<%@include file="conexion.jsp"%>
<%
    String listar = request.getParameter("listar");

    // Búsqueda de clientes según el término ingresado
    if ("buscar_cliente".equals(listar)) {
        String query = request.getParameter("query");
        if (query != null && !query.trim().isEmpty()) {
            try {
                Statement st = conn.createStatement();
                String sql = "SELECT idcliente, cli_nombres, cli_apellidos FROM clientes " +
                             "WHERE cli_nombres ILIKE '%" + query + "%' OR cli_apellidos ILIKE '%" + query + "%' " +
                             "ORDER BY cli_nombres";
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()) {
%>
                    <a href="#" class="list-group-item list-group-item-action cliente-item" data-id="<%= rs.getInt("idcliente") %>">
                        <%= rs.getString("cli_nombres") %> <%= rs.getString("cli_apellidos") %>
                    </a>
<%
                }
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error en la búsqueda: " + e.getMessage() + "</div>");
            }
        }

    // Cargar planes de tratamiento del cliente seleccionado
    } else if ("plan_tratamiento".equals(listar)) {
        String clienteId = request.getParameter("clienteId");
        if (clienteId != null && !clienteId.isEmpty()) {
            try {
                Statement st = conn.createStatement();
                String sql = "SELECT idconsulta, plan_tratamiento FROM consultas WHERE idcliente = '" + clienteId + "' ORDER BY fecha_consulta";
                ResultSet rs = st.executeQuery(sql);
                while (rs.next()) {
%>
                    <option value="<%= rs.getInt("idconsulta") %>"><%= rs.getString("plan_tratamiento") %></option>
<%
                }
            } catch (Exception e) {
                out.print("<option>Error: " + e.getMessage() + "</option>");
            }
        }

    // Guardar evaluación en cabecera_evaluaciones y detalle_evaluaciones
    } else if ("cargar".equals(listar)) {
        String clienteId = request.getParameter("cliente");
        String consultaId = request.getParameter("plan_tratamiento");
        String fecha = request.getParameter("fecha");
        String avance = request.getParameter("avance");
        String nivelDolor = request.getParameter("nivelDolor");
        String movilidad = request.getParameter("movilidad");
        String comentarios = request.getParameter("comentarios");

        if (clienteId == null || consultaId == null || fecha == null || avance == null || nivelDolor == null || movilidad == null) {
            out.print("<div class='alert alert-danger'>Todos los campos son obligatorios.</div>");
        } else {
            try {
                // Insertar en cabecera_evaluaciones
                Statement st = conn.createStatement();
                String queryCabecera = "INSERT INTO cabecera_evaluaciones (idcliente, idconsulta, fecha_evaluacion) VALUES ('"
                    + clienteId + "', '" + consultaId + "', '" + fecha + "')";
                st.executeUpdate(queryCabecera);

                // Obtener el idevaluacion generado
                ResultSet rs = st.executeQuery("SELECT currval('cabecera_evaluaciones_idevaluacion_seq') as idevaluacion");
                int idevaluacion = 0;
                if (rs.next()) {
                    idevaluacion = rs.getInt("idevaluacion");
                }

                // Insertar en detalle_evaluaciones usando idevaluacion
                String queryDetalle = "INSERT INTO detalle_evaluaciones (idevaluacion, progreso_observado, nivel_dolor, movilidad, comentarios) VALUES ("
                    + idevaluacion + ", '" + avance + "', " + nivelDolor + ", '" + movilidad + "', '" + comentarios + "')";
                st.executeUpdate(queryDetalle);

                out.print("<div class='alert alert-success'>Evaluación guardada exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
            }
        }
    }else if (request.getParameter("listar").equals("listareva")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        rs = st.executeQuery("SELECT ce.idevaluacion, "
                            + "TO_CHAR(ce.fecha_evaluacion, 'DD-MM-YYYY') AS fecha_evaluacion, "
                            + "c.cli_nombres || ' ' || c.cli_apellidos AS paciente, "
                            + "ce.idconsulta "
                            + "FROM cabecera_evaluaciones ce "
                            + "JOIN clientes c ON ce.idcliente = c.idcliente "
                            + "ORDER BY ce.idevaluacion ASC");

        while (rs.next()) {

%>
<tr>

    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i>
    <a href="Reporte_Evaluacion.jsp?idevaluacion=<%= rs.getString(1) %>" target="_blank" class="btn btn-info btn-sm">
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
        st.executeUpdate("DELETE FROM cabecera_evaluaciones WHERE idevaluacion=" + idpkeva);

        // Mensaje opcional de éxito
        out.println("<div class='alert alert-success'>Cabecera y detalles eliminados con éxito.</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
    }
}
%>