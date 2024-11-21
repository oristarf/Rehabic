<%@include file="conexion.jsp"%>
<%
    String listar = request.getParameter("listar");

    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idcliente, cli_nombres || ' ' || cli_apellidos AS cliente_nombre FROM clientes ORDER BY cli_nombres");
            while (rs.next()) {
%>
<option value="<%= rs.getInt("idcliente") %>"><%= rs.getString("cliente_nombre") %></option>
<%
            }
        } catch (Exception e) {
            out.print("<option>Error: " + e.getMessage() + "</option>");
        }
    }
%>
