<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");

    if ("rutinasFisioterapeuta".equals(action)) {
        String nombre = request.getParameter("nombre");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");

        try {
            Statement st = conn.createStatement();
            StringBuilder query = new StringBuilder(
                "SELECT dr.iddet_rutina, to_char(dr.fecha, 'DD-MM-YYYY') AS fecha, " +
                "e.eje_nombre AS ejercicio, dr.series, dr.repeticiones, dr.peso, dr.minutos, dr.estado, dr.retroalimentacion, " +
                "u.usuario AS cliente_usuario, c.cli_nombres || ' ' || c.cli_apellidos AS cliente " +
                "FROM det_rutinas dr " +
                "JOIN cab_rutinas cr ON dr.idcab_rutina = cr.idcab_rutina " +
                "JOIN ejercicios e ON dr.idejercicio = e.idejercicio " +
                "JOIN clientes c ON cr.idcliente = c.idcliente " +
                "JOIN usuarios u ON c.idusuarios = u.idusuarios " +
                "WHERE cr.estado = 'Finalizado' " // Filtrar solo cabeceras finalizadas
            );

            // Filtrar por nombre/apellido
            if (nombre != null && !nombre.isEmpty()) {
                query.append("AND LOWER(c.cli_nombres || ' ' || c.cli_apellidos) LIKE LOWER('%").append(nombre).append("%') ");
            }

            // Filtrar por rango de fechas
            if (fechaInicio != null && !fechaInicio.isEmpty() && fechaFin != null && !fechaFin.isEmpty()) {
                query.append("AND dr.fecha BETWEEN '").append(fechaInicio).append("' AND '").append(fechaFin).append("' ");
            }

            query.append("ORDER BY dr.fecha DESC");

            out.println("Query ejecutado: " + query); // Log para depuración
            ResultSet rs = st.executeQuery(query.toString());

            if (!rs.isBeforeFirst()) { // No hay resultados
                out.println("<tr><td colspan='9'>No se encontraron rutinas para los criterios ingresados.</td></tr>");
            }

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("fecha") %></td>
    <td><%= rs.getString("ejercicio") %></td>
    <td><%= rs.getString("series") != null ? rs.getString("series") : "N/A" %></td>
    <td><%= rs.getString("repeticiones") != null ? rs.getString("repeticiones") : "N/A" %></td>
    <td><%= rs.getString("peso") != null ? rs.getString("peso") : "N/A" %></td>
    <td><%= rs.getString("minutos") != null ? rs.getString("minutos") : "N/A" %></td>
    <td><%= rs.getString("estado") %></td>
    <td><%= rs.getString("retroalimentacion") != null ? rs.getString("retroalimentacion") : "Sin feedback" %></td>
    <td><%= rs.getString("cliente_usuario") %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='9'>Error al cargar rutinas: " + e.getMessage() + "</td></tr>");
        }
    }
%>
