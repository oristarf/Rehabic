<%@include file="conexion.jsp"%>
<%
    String idcliente = request.getParameter("idcliente");
    String nombreCompleto = "";

    try {
        String query = "SELECT cli_nombres || ' ' || cli_apellidos AS nombre_completo FROM clientes WHERE idcliente = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        
        // Convertir idcliente a Integer, ya que es un número en la base de datos
        ps.setInt(1, Integer.parseInt(idcliente));

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            nombreCompleto = rs.getString("nombre_completo");
        }

        out.print(nombreCompleto); // Enviar el nombre completo como respuesta
    } catch (Exception e) {
        out.print("Error al obtener el nombre del cliente: " + e.getMessage());
    }
%>
