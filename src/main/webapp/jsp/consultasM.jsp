<%@include file="conexion.jsp"%>

<%
    String listar = request.getParameter("listar");

    // Listar consultas
    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT c.idconsulta, c.idcliente, cl.cli_nombres || ' ' || cl.cli_apellidos AS cliente, " +  // Asegúrate de incluir c.idcliente aquí
                "c.fecha_consulta, c.medico_tratante, c.medico_tel, c.motivo_consulta, " +
                "c.aea, c.estudios_complementarios, c.evaluacion_goniometria, " +
                "c.pruebas_musculares, c.pruebas_especificas, c.impresion_diagnostica, " +
                "c.plan_tratamiento " +
                "FROM consultas c INNER JOIN clientes cl ON c.idcliente = cl.idcliente " +
                "ORDER BY c.idconsulta ASC"
            );

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idconsulta") %></td>
    <td><%= rs.getString("cliente") %></td>
    <td><%= rs.getDate("fecha_consulta") %></td>
    <td><%= rs.getString("medico_tratante") %></td>
    <td><%= rs.getString("medico_tel") %></td>
    <td><%= rs.getString("motivo_consulta") %></td>
    <td><%= rs.getString("aea") %></td>
    <td><%= rs.getString("estudios_complementarios") %></td>
    <td><%= rs.getString("evaluacion_goniometria") %></td>
    <td><%= rs.getString("pruebas_musculares") %></td>
    <td><%= rs.getString("pruebas_especificas") %></td>
    <td><%= rs.getString("impresion_diagnostica") %></td>
    <td><%= rs.getString("plan_tratamiento") %></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" onclick="rellenaredit('<%= rs.getInt("idconsulta") %>', '<%= rs.getInt("idcliente") %>', '<%= rs.getDate("fecha_consulta") %>', '<%= rs.getString("medico_tratante") %>', '<%= rs.getString("medico_tel") %>', '<%= rs.getString("motivo_consulta") %>', '<%= rs.getString("aea") %>', '<%= rs.getString("estudios_complementarios") %>', '<%= rs.getString("evaluacion_goniometria") %>', '<%= rs.getString("pruebas_musculares") %>', '<%= rs.getString("pruebas_especificas") %>', '<%= rs.getString("impresion_diagnostica") %>', '<%= rs.getString("plan_tratamiento") %>')"></i>
        <i title="eliminar" class="bi bi-trash" onclick="$('#idconsulta_e').val('<%= rs.getInt("idconsulta") %>')" data-bs-toggle="modal" data-bs-target="#eliminarC"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar: " + e.getMessage() + "</div>");
        }
} // Guardar nueva consulta
else if ("cargar".equals(listar)) {
    String idcliente = request.getParameter("idcliente");
    String fechaConsulta = request.getParameter("fecha_consulta");
    String medicoTratante = request.getParameter("medico_tratante");
    String medicoTel = request.getParameter("medico_tel");
    String motivoConsulta = request.getParameter("motivo_consulta");
    String aea = request.getParameter("aea");
    String estudiosComplementarios = request.getParameter("estudios_complementarios");
    String evaluacionGoniometria = request.getParameter("evaluacion_goniometria");
    String pruebasMusculares = request.getParameter("pruebas_musculares");
    String pruebasEspecificas = request.getParameter("pruebas_especificas");
    String impresionDiagnostica = request.getParameter("impresion_diagnostica");
    String planTratamiento = request.getParameter("plan_tratamiento");

    if (idcliente == null || fechaConsulta == null || motivoConsulta == null) {
        out.print("<div class='alert alert-danger'>Todos los campos obligatorios deben completarse.</div>");
    } else {
        try {
            Statement st = conn.createStatement();
            String query = "INSERT INTO consultas (idcliente, fecha_consulta, medico_tratante, medico_tel, motivo_consulta, "
                    + "aea, estudios_complementarios, evaluacion_goniometria, pruebas_musculares, pruebas_especificas, "
                    + "impresion_diagnostica, plan_tratamiento) VALUES (" + idcliente + ", '" + fechaConsulta + "', '"
                    + medicoTratante + "', '" + medicoTel + "', '" + motivoConsulta + "', '" + aea + "', '"
                    + estudiosComplementarios + "', '" + evaluacionGoniometria + "', '" + pruebasMusculares + "', '"
                    + pruebasEspecificas + "', '" + impresionDiagnostica + "', '" + planTratamiento + "')";
            st.executeUpdate(query);
            out.print("<div class='alert alert-success'>Consulta guardada exitosamente.</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
        }
    }
} // Modificar consulta
else if ("modificar".equals(listar)) {
    String idconsulta = request.getParameter("idconsulta");
    String idcliente = request.getParameter("idcliente");
    String fechaConsulta = request.getParameter("fecha_consulta");
    String medicoTratante = request.getParameter("medico_tratante").replace("'", "''");
    String medicoTel = request.getParameter("medico_tel").replace("'", "''");
    String motivoConsulta = request.getParameter("motivo_consulta").replace("'", "''");
    String aea = request.getParameter("aea").replace("'", "''");
    String estudiosComplementarios = request.getParameter("estudios_complementarios").replace("'", "''");
    String evaluacionGoniometria = request.getParameter("evaluacion_goniometria").replace("'", "''");
    String pruebasMusculares = request.getParameter("pruebas_musculares").replace("'", "''");
    String pruebasEspecificas = request.getParameter("pruebas_especificas").replace("'", "''");
    String impresionDiagnostica = request.getParameter("impresion_diagnostica").replace("'", "''");
    String planTratamiento = request.getParameter("plan_tratamiento").replace("'", "''");

    try {
        Statement st = conn.createStatement();
        String query = "UPDATE consultas SET idcliente = " + idcliente + ", fecha_consulta = '" + fechaConsulta + "', "
                + "medico_tratante = '" + medicoTratante + "', medico_tel = '" + medicoTel + "', "
                + "motivo_consulta = '" + motivoConsulta + "', aea = '" + aea + "', "
                + "estudios_complementarios = '" + estudiosComplementarios + "', evaluacion_goniometria = '" + evaluacionGoniometria + "', "
                + "pruebas_musculares = '" + pruebasMusculares + "', pruebas_especificas = '" + pruebasEspecificas + "', "
                + "impresion_diagnostica = '" + impresionDiagnostica + "', plan_tratamiento = '" + planTratamiento + "' "
                + "WHERE idconsulta = " + idconsulta;
        st.executeUpdate(query);
        out.print("<div class='alert alert-success'>Consulta modificada exitosamente.</div>");
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al modificar: " + e.getMessage() + "</div>");
    }
} // Eliminar consulta
else if ("eliminar".equals(listar)) {
    String idconsulta = request.getParameter("idconsulta_e");

    try {
        // Verificar si la consulta tiene evaluaciones asociadas en cabecera_evaluaciones
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM cabecera_evaluaciones WHERE idconsulta = " + idconsulta);

        if (rs.next() && rs.getInt("count") > 0) {
            // Si existen evaluaciones asociadas, mostrar advertencia y no eliminar
            out.print("<div class='alert alert-warning'>No se puede eliminar esta consulta porque tiene evaluaciones asociadas.</div>");
        } else {
            // Si no hay evaluaciones asociadas, proceder con la eliminación
            st.executeUpdate("DELETE FROM consultas WHERE idconsulta = " + idconsulta);
            out.print("<div class='alert alert-success'>Consulta eliminada exitosamente.</div>");
        }
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
    }
} // Buscar clientes para la lista de selección
else if ("buscar_cliente".equals(listar)) {
    String query = request.getParameter("query");
    if (query != null && !query.trim().isEmpty()) {
        try {
            Statement st = conn.createStatement();
            String sql = "SELECT idcliente, cli_nombres || ' ' || cli_apellidos AS cliente_nombre FROM clientes "
                    + "WHERE cli_nombres ILIKE '%" + query + "%' OR cli_apellidos ILIKE '%" + query + "%' "
                    + "ORDER BY cli_nombres";
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
%>
<a href="#" class="list-group-item list-group-item-action cliente-item" data-id="<%= rs.getInt("idcliente")%>">
    <%= rs.getString("cliente_nombre")%>
</a>
<%
                }
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error en la búsqueda: " + e.getMessage() + "</div>");
            }
        }
    }
%>
