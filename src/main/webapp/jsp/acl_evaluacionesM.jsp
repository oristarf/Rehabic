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
    <td>
        <input type="checkbox" name="cumplido_<%= rs.getInt("idacl_fase")%>" value="true">
        <input type="hidden" name="idacl_fase_<%= rs.getInt("idacl_fase")%>" value="<%= rs.getInt("idacl_fase")%>">
    </td>
</tr>

<%
                }
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al cargar la fase: " + e.getMessage() + "</div>");
            }
        }

        // 4. Guardar Evaluación de ACL
    }  else if ("cargar_acl".equals(listar)) {
    String pacienteId = request.getParameter("pacienteId");
    String consultaId = request.getParameter("plan_tratamiento");
    String fecha = request.getParameter("fecha");
    String observaciones = request.getParameter("observaciones");

    Integer usuarioId = null;
    if (sesion.getAttribute("idusuarios") != null) {
        usuarioId = Integer.parseInt(sesion.getAttribute("idusuarios").toString());
    }

    if (pacienteId == null || consultaId == null || fecha == null || usuarioId == null) {
        out.print("<div class='alert alert-danger'>Debe completar todos los campos, incluyendo usuario.</div>");
        return;
    }

    try {
        // Insertar en acl_cabecera
        Statement st = conn.createStatement();
        String queryCabecera = "INSERT INTO acl_cabecera (acl_fecha, idcliente, idusuarios, acl_observaciones) VALUES ('"
                + fecha + "', '" + pacienteId + "', '" + usuarioId + "', '" + observaciones + "')";
        st.executeUpdate(queryCabecera);

        // Obtener el idacl_cab generado
        ResultSet rs = st.executeQuery("SELECT currval('acl_cabecera_idacl_cab_seq') as idacl_cab");
        int idacl_cab = 0;
        if (rs.next()) {
            idacl_cab = rs.getInt("idacl_cab");
        }

        // Procesar los checkboxes
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            if (paramName.startsWith("idacl_fase_")) {
                String idaclFase = request.getParameter(paramName);
                boolean cumplido = "true".equals(request.getParameter("cumplido_" + idaclFase));

                // Insertar en acl_detalle
                String queryDetalle = "INSERT INTO acl_detalle (idacl_cab, idacl_fase, cumplido) VALUES (" +
                        idacl_cab + ", " + idaclFase + ", " + cumplido + ")";
                st.executeUpdate(queryDetalle);
            }
        }

        out.print("<div class='alert alert-success'>Evaluación de ACL guardada exitosamente.</div>");
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
    }
} else if ("listar".equals(listar)) {
        String cliente = request.getParameter("cliente");
        String fechaInicio = request.getParameter("fecha_inicio");
        String fechaFin = request.getParameter("fecha_fin");

        try {
            String sql = "SELECT ac.acl_fecha AS fecha, "
           + "c.cli_nombres || ' ' || c.cli_apellidos AS paciente, "
           + "CASE af.acl_fase "
           + "  WHEN 0 THEN 'Fase Preoperatoria' "
           + "  WHEN 1 THEN 'Fase 1: Recuperación de la Cirugía' "
           + "  WHEN 2 THEN 'Fase 2: Fuerza y Control Neuromuscular' "
           + "  WHEN 3 THEN 'Fase 3: Carrera, Agilidad y Aterrizajes' "
           + "END AS fase, "
           + "af.acl_medida AS medida, "
           + "af.acl_objetivo AS objetivo, "
           + "CASE WHEN ad.idacl_det IS NOT NULL THEN 'Cumplido' ELSE 'No Cumplido' END AS cumplidos "
           + "FROM acl_cabecera ac "
           + "JOIN clientes c ON ac.idcliente = c.idcliente "
           + "LEFT JOIN acl_detalle ad ON ac.idacl_cab = ad.idacl_cab "
           + "LEFT JOIN acl_fases af ON ad.idacl_fase = af.idacl_fase "
           + "WHERE 1=1 ";

if (request.getParameter("clienteId") != null && !request.getParameter("clienteId").trim().isEmpty()) {
    sql += " AND ac.idcliente = " + request.getParameter("clienteId");
}

if (request.getParameter("fechaInicio") != null && !request.getParameter("fechaInicio").trim().isEmpty()) {
    sql += " AND ac.acl_fecha >= '" + request.getParameter("fechaInicio") + "'";
}

if (request.getParameter("fechaFin") != null && !request.getParameter("fechaFin").trim().isEmpty()) {
    sql += " AND ac.acl_fecha <= '" + request.getParameter("fechaFin") + "'";
}

sql += " ORDER BY ac.acl_fecha DESC";

try {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery(sql);
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("fecha") %></td>
    <td><%= rs.getString("paciente") %></td>
    <td><%= rs.getString("fase") %></td>
    <td><%= rs.getString("medida") %></td>
    <td><%= rs.getString("objetivo") %></td>
    <td><%= rs.getString("cumplidos") %></td>
</tr>
<%
     } // Cierre del while
        } catch (Exception e) { // Bloque catch correspondiente al segundo try
            out.print("<div class='alert alert-danger'>Error al cargar las evaluaciones: " + e.getMessage() + "</div>");
        } // Cierre del segundo try-catch
    } catch (Exception e) { // Bloque catch correspondiente al primer try
        out.print("<div class='alert alert-danger'>Error al generar el query: " + e.getMessage() + "</div>");
    } // Cierre del primer try-catch
} // Cierre del else if para listar
else if (request.getParameter("listar").equals("listareva")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        rs = st.executeQuery("SELECT ac.idacl_cab, to_char(ac.acl_fecha, 'DD-MM-YYYY'), c.cli_nombres ||' '|| c.cli_apellidos as Paciente, ac.acl_observaciones FROM acl_cabecera ac, clientes c where ac.idcliente = c.idcliente order by idacl_cab asc");

        while (rs.next()) {

%>
<tr>

    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i>
    <a href="Reporte_ACL.jsp?idacl_cab=<%= rs.getString(1) %>" target="_blank" class="btn btn-info btn-sm">
            <i class="fas fa-file-pdf"></i>
        </a></td>
    
    
</tr>
<%

        }
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("anuleva")) {
    try {
        Statement st = null;
        st = conn.createStatement();

        // Eliminar la cabecera, los detalles se eliminan automáticamente debido a ON DELETE CASCADE
        String idpkeva = request.getParameter("idpkeva");
        st.executeUpdate("DELETE FROM acl_cabecera WHERE idacl_cab=" + idpkeva);

        // Mensaje opcional de éxito
        out.println("<div class='alert alert-success'>Cabecera y detalles eliminados con éxito.</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
    }
}


%>
