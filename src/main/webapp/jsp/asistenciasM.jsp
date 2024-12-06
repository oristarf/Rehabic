<%@ include file="conexion.jsp" %>
<%
    String accion = request.getParameter("listar");

    // Listar clientes
    if ("listarClientes".equals(accion)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idcliente, cli_nombres || ' ' || cli_apellidos AS cliente FROM clientes");
            while (rs.next()) {
                out.println("<option value='" + rs.getString("idcliente") + "'>" + rs.getString("cliente") + "</option>");
            }
        } catch (Exception e) {
            out.println("<option>Error al cargar clientes</option>");
        }
    }

    // Registrar asistencia
    else if ("registrarAsistencia".equals(accion)) {
    String idCliente = request.getParameter("idCliente");
    String fecha = request.getParameter("fecha");

    try {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO asistencias (idcliente, fecha, estado, idusuario) VALUES (?, ?, 'Presente', ?)"
        );

        ps.setInt(1, Integer.parseInt(idCliente)); // Convert idCliente to Integer
        ps.setDate(2, java.sql.Date.valueOf(fecha)); // Convert fecha to java.sql.Date

        // Retrieve idusuario as Integer directly and set it
        Integer idUsuario = (Integer) session.getAttribute("idusuarios");
        ps.setInt(3, idUsuario);

        ps.executeUpdate();
        out.println("Asistencia registrada correctamente.");
    } catch (Exception e) {
        out.println("Error al registrar la asistencia: " + e.getMessage());
    }
}


    // Listar asistencias
    else if ("listarAsistencias".equals(accion)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT a.idasistencia, c.cli_nombres || ' ' || c.cli_apellidos AS cliente, " +
                "to_char(a.fecha, 'YYYY-MM-DD') AS fecha " +
                "FROM asistencias a " +
                "JOIN clientes c ON a.idcliente = c.idcliente " +
                "ORDER BY a.fecha DESC"
            );

            if (!rs.isBeforeFirst()) {
                out.println("<tr><td colspan='3'>No hay asistencias registradas.</td></tr>");
            } else {
                while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("cliente") %></td>
    <td><%= rs.getString("fecha") %></td>
    <td>
        <button class="btn btn-danger btn-sm" onclick="eliminarAsistencia('<%= rs.getInt("idasistencia") %>')">Eliminar</button>
    </td>
</tr>
<%
                }
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='3'>Error al cargar las asistencias: " + e.getMessage() + "</td></tr>");
        }
    }

    // Eliminar asistencia
    else if ("eliminarAsistencia".equals(accion)) {
        String idAsistencia = request.getParameter("idAsistencia");
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM asistencias WHERE idasistencia = ?");
            ps.setInt(1, Integer.parseInt(idAsistencia));
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.println("Asistencia eliminada correctamente.");
            } else {
                out.println("Error: no se encontró la asistencia.");
            }
        } catch (Exception e) {
            out.println("Error al eliminar la asistencia: " + e.getMessage());
        }
    }
%>
