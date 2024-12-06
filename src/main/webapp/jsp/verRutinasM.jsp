<%@ include file="conexion.jsp" %>
<%
    String action = request.getParameter("listar");

    if ("rutinasCliente".equals(action)) {
        String idUsuario = request.getParameter("idusuario");
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT dr.iddet_rutina, to_char(dr.fecha, 'DD-MM-YYYY') AS fecha, " +
                "e.eje_nombre AS ejercicio, dr.series, dr.repeticiones, dr.peso, dr.minutos, dr.estado, dr.retroalimentacion " +
                "FROM det_rutinas dr " +
                "JOIN cab_rutinas cr ON dr.idcab_rutina = cr.idcab_rutina " +
                "JOIN ejercicios e ON dr.idejercicio = e.idejercicio " +
                "WHERE cr.idcliente = (SELECT idcliente FROM clientes WHERE idusuarios = " + idUsuario + ") " +
                "AND cr.estado = 'Finalizado' " + // Solo mostrar rutinas con cabeceras finalizadas
                "ORDER BY dr.fecha DESC"
            );

            if (!rs.isBeforeFirst()) {
                out.println("<tr><td colspan='8'>No tienes rutinas asignadas para hoy.</td></tr>");
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
    <td>
        <% if ("Pendiente".equals(rs.getString("estado"))) { %>
        <button class="btn btn-success btn-sm" onclick="marcarCompletado('<%= rs.getString("iddet_rutina") %>')">Completado</button>
        <% } %>
        <button 
            class="btn btn-info btn-sm" 
            onclick="mostrarFeedbackModal('<%= rs.getString("iddet_rutina") %>')"
            <%= rs.getString("retroalimentacion") != null && !rs.getString("retroalimentacion").isEmpty() ? "disabled" : "" %>>
            Feedback
        </button>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='8'>Error al cargar las rutinas: " + e.getMessage() + "</td></tr>");
        }
    }

    // Marcar Completado
    if ("marcarCompletado".equals(action)) {
        String idRutina = request.getParameter("idRutina");
        try {
            if (idRutina != null && !idRutina.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE det_rutinas SET estado = 'Completado' WHERE iddet_rutina = ?"
                );
                ps.setInt(1, Integer.parseInt(idRutina));
                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    out.println("Rutina marcada como completada con éxito.");
                } else {
                    out.println("Error: no se encontró la rutina con ID " + idRutina);
                }
            } else {
                out.println("Error: ID de rutina no proporcionado o inválido.");
            }
        } catch (Exception e) {
            out.println("Error al marcar rutina como completada: " + e.getMessage());
        }
    }

    // Guardar Feedback
    else if ("guardarFeedback".equals(action)) {
        String idRutina = request.getParameter("idRutina");
        String feedback = request.getParameter("feedback");

        try {
            if (idRutina != null && !idRutina.isEmpty() && feedback != null) {
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE det_rutinas SET retroalimentacion = ? WHERE iddet_rutina = ?"
                );
                ps.setString(1, feedback);
                ps.setInt(2, Integer.parseInt(idRutina));
                ps.executeUpdate();
                out.println("{\"success\": \"Retroalimentación guardada exitosamente\"}");
            } else {
                out.println("{\"error\": \"Datos incompletos para guardar retroalimentación.\"}");
            }
        } catch (Exception e) {
            out.println("{\"error\": \"Error al guardar retroalimentación: " + e.getMessage() + "\"}");
        }
    }

%>
