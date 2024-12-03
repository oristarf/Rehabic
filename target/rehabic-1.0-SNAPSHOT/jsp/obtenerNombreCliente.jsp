<%@ include file="conexion.jsp" %>
<%
    String idcliente = request.getParameter("idcliente");
    String nombreCompleto = "";

    try {
        if (idcliente == null || idcliente.trim().isEmpty()) {
            out.print("Error: ID del cliente no proporcionado.");
            return;
        }

        // Verificar si el idcliente es un número válido
        int idClienteInt;
        try {
            idClienteInt = Integer.parseInt(idcliente);
        } catch (NumberFormatException e) {
            out.print("Error: ID del cliente no es un número válido.");
            return;
        }

        // Consulta SQL para obtener el nombre completo
        String query = "SELECT cli_nombres || ' ' || cli_apellidos AS nombre_completo FROM clientes WHERE idcliente = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, idClienteInt);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            nombreCompleto = rs.getString("nombre_completo");
        }

        if (nombreCompleto.isEmpty()) {
            out.print("Cliente no encontrado.");
        } else {
            out.print(nombreCompleto); // Enviar el nombre completo como respuesta
        }

    } catch (Exception e) {
        out.print("Error al obtener el nombre del cliente: " + e.getMessage());
    }
%>
