<%@include file="conexion.jsp"%>

<%    String listar = request.getParameter("listar");
    HttpSession sesion = request.getSession();

    // 1. Filtrar Pacientes
    if ("buscar_paciente".equals(listar)) {
        String query = request.getParameter("query");
        if (query != null && !query.trim().isEmpty()) {
            try {
                Statement st = conn.createStatement();
                String sql = "SELECT idcliente, cli_nombres, cli_apellidos FROM clientes "
                        + "WHERE cli_nombres ILIKE '%" + query + "%' OR cli_apellidos ILIKE '%" + query + "%' "
                        + "ORDER BY cli_nombres";
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()) {
%>
<a href="#" class="list-group-item list-group-item-action paciente-item" data-id="<%= rs.getInt("idcliente")%>">
    <%= rs.getString("cli_nombres")%> <%= rs.getString("cli_apellidos")%>
</a>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error en la búsqueda: " + e.getMessage() + "</div>");
        }
    }

    // 2. Cargar Plan de Tratamiento del Paciente Seleccionado
} else if ("plan_tratamiento".equals(listar)) {
    String pacienteId = request.getParameter("pacienteId");
    if (pacienteId != null && !pacienteId.isEmpty()) {
        try {
            Statement st = conn.createStatement();
            String sql = "SELECT idconsulta, plan_tratamiento FROM consultas WHERE idcliente = " + pacienteId + " ORDER BY fecha_consulta DESC";
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
%>
<option value="<%= rs.getInt("idconsulta")%>"><%= rs.getString("plan_tratamiento")%></option>
<%
            }
        } catch (Exception e) {
            out.print("<option>Error: " + e.getMessage() + "</option>");
        }
    }

    // 3. Mostrar Tabla de Fase Seleccionada
} else if ("mostrar_fase".equals(listar)) {
    String faseId = request.getParameter("fase");
    if (faseId != null && !faseId.isEmpty()) {
        try {
            Statement st = conn.createStatement();
            String sql = "SELECT idacl_fase, acl_medida, acl_objetivo FROM acl_fases WHERE acl_fase = " + faseId + " ORDER BY idacl_fase";
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("acl_medida")%></td>
    <td><%= rs.getString("acl_objetivo")%></td>
    <td><input type="checkbox" name="cumplido_<%= rs.getInt("idacl_fase")%>value="<%= rs.getInt("idacl_fase")%>"></td>
</tr>
<%
                }
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al cargar la fase: " + e.getMessage() + "</div>");
            }
        }

        // 4. Guardar Evaluación de ACL
    } else if ("cargar_acl".equals(listar)) {
        String pacienteId = request.getParameter("pacienteId");
        String consultaId = request.getParameter("plan_tratamiento");
        String fecha = request.getParameter("fecha");
        String observaciones = request.getParameter("observaciones");

        // Obtener idusuarios de la sesión
// Obtener idusuarios de la sesión
        Integer usuarioId = null;
        if (sesion.getAttribute("idusuarios") != null) {
            usuarioId = Integer.parseInt(sesion.getAttribute("idusuarios").toString());
        }

        if (pacienteId == null || consultaId == null || fecha == null || usuarioId == null) {
            out.print("<div class='alert alert-danger'>Debe completar todos los campos, incluyendo usuario.</div>");
            return;
        } else {
            try {
                // Insertar en acl_cabecera para crear una nueva evaluación de ACL
                Statement st = conn.createStatement();
                String queryCabecera = "INSERT INTO acl_cabecera (acl_fecha, idcliente, idusuarios, acl_observaciones) VALUES ('"
                        + fecha + "', '" + pacienteId + "', '" + usuarioId + "', '" + observaciones + "')";
                st.executeUpdate(queryCabecera);

                // Obtener el idacl_cab generado para esta evaluación de ACL
                ResultSet rs = st.executeQuery("SELECT currval('acl_cabecera_idacl_cab_seq') as idacl_cab");
                int idacl_cab = 0;
                if (rs.next()) {
                    idacl_cab = rs.getInt("idacl_cab");
                }

                // Insertar en acl_detalle los ítems de la fase seleccionada
                for (int i = 1; request.getParameter("cumplido_" + i) != null; i++) {
                    String idacl_fase = request.getParameter("cumplido_" + i);
                    if (idacl_fase != null) {
                        String queryDetalle = "INSERT INTO acl_detalle (idacl_cab, idacl_fase) VALUES (" + idacl_cab + ", " + idacl_fase + ")";
                        st.executeUpdate(queryDetalle);
                    }
                }

                out.print("<div class='alert alert-success'>Evaluación de ACL guardada exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
            }
        }

    }
%>
