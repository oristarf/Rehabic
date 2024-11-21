<%@include file="conexion.jsp"%>
<%
    try {
        Statement st = conn.createStatement();
        ResultSet rsClientes = st.executeQuery("SELECT idcliente, cli_nombres, cli_apellidos FROM clientes ORDER BY cli_nombres");

        while (rsClientes.next()) {
        String nombreCompleto = rsClientes.getString("cli_nombres") + " " + rsClientes.getString("cli_apellidos");
%>
            <option value="<%= rsClientes.getInt("idcliente") %>"><%= nombreCompleto %></option>
<%
        }
    } catch (Exception e) {
        out.print("<option>Error: " + e.getMessage() + "</option>");
    }
%>

