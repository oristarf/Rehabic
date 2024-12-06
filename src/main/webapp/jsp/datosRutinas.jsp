<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>

<%@include file="conexion.jsp"%>
 
<% 
// Buscar clientes para el select en rutinas.jsp
if (request.getParameter("listar").equals("buscarcliente")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM clientes ORDER BY idcliente DESC;");
%>

<option value="">Seleccionar cliente</option>
<%
        while (rs.next()) { %>
<!-- El value contiene el idcliente y cli_cedula separados por coma -->
<option value="<%out.print(rs.getString(1));%>,<%out.print(rs.getString(4));%>">
    <%out.print(rs.getString(2));%> <%out.print(rs.getString(3));%> | <%out.print(rs.getString(4));%>
</option>
<%    }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}

// Buscar ejercicios para el select en rutinas.jsp
else if (request.getParameter("listar").equals("buscarejercicio")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM ejercicios ORDER BY idejercicio DESC;");
%> 
<option value="">Seleccionar ejercicio</option>
<%
        while (rs.next()) { %>
<!-- Cambiamos el value para que contenga únicamente el idejercicio -->
<option value="<%out.print(rs.getString(1));%>">
    <%out.print(rs.getString(2));%> | <%out.print(rs.getString(4));%>
</option>
<%    }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>
