
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>

<%@include file="conexion.jsp"%>
 
<% //este buscador de clientes es para que en rutinas.jsp en el <select class="form_control" name="idcliente" id="idcliente" onchange="dividircliente(this.value)"></select> de clientes se puedan ver los clientes existentes
if (request.getParameter("listar").equals("buscarcliente")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT * FROM clientes ORDER BY idcliente DESC;");
%>

<option value="">Seleccionar cliente</option>
<%
                while (rs.next()) {%>
<!-- el value va a contener el primary key idcliente(1) y la cedula cli_cedula(4) y en las opciones se muestran los nombres cli_nombres (2),apellidos cli_apellidos (3) separados por un espacio y concatenados con la cedula cli_cedula (4) -->
<option value="<%out.print(rs.getString(1));%>, <%out.print(rs.getString(4));%>"><%out.print(rs.getString(2));%> <%out.print(rs.getString(3));%>|<%out.print(rs.getString(4));%></option>


<%    }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}// este buscador de servicios es para que en rutinas.jsp en el <select class="form_control" name="idservicio" id="idservicio" onchange="dividirservicio(this.value)"></select> de clientes se puedan ver los servicios existentes
else if (request.getParameter("listar").equals("buscarservicio")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("select * from servicios order by idservicio desc;");
%> 
<option value="">Seleccionar servicio</option>
<%
    while (rs.next()) {%>
<option value="<%out.print(rs.getString(1));%>, <%out.print(rs.getString(4));%>"><%out.print(rs.getString(2));%>|<%out.print(rs.getString(4));%></option>
//trae los valores de los ejercicios que es 1 (idejercicios) el 4 la descripocion  en en select se concatena la descripcion del producto con el precio 

<%    }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    }
else
if (request.getParameter("listar").equals("buscadorCliente")) {
    try {
        Statement st = conn.createStatement(); // Asegúrate de inicializar el Statement
        ResultSet rs = st.executeQuery("SELECT idcliente, cli_nombres, cli_apellidos FROM clientes ORDER BY idcliente DESC;"); // Consulta SQL correcta

%>
<option value="">Seleccionar cliente</option>
<%
        while (rs.next()) { 
%>
<option value="<%= rs.getInt("idcliente") %>">
    <%= rs.getString("cli_nombres") %> <%= rs.getString("cli_apellidos") %>
</option>
<%
        }
        rs.close(); // Cerrar ResultSet
        st.close(); // Cerrar Statement
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }
}
%>
           



