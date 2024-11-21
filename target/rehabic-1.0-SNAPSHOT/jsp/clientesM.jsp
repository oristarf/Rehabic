<%@include file="conexion.jsp"%>
<%
    String listar = request.getParameter("listar");

    // Listar clientes
    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idcliente, cli_nombres, cli_apellidos, cli_cedula, cli_fechanacimiento, cli_telefono, cli_telurgencia FROM clientes ORDER BY idcliente ASC");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idcliente") %></td>
    <td><%= rs.getString("cli_nombres") %></td>
    <td><%= rs.getString("cli_apellidos") %></td>
    <td><%= rs.getDate("cli_fechanacimiento") %></td>
    <td><%= rs.getString("cli_cedula") %></td>
    <td><%= rs.getString("cli_telefono") %></td>
    <td><%= rs.getString("cli_telurgencia") %></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" onclick="rellenaredit('<%= rs.getInt("idcliente") %>','<%= rs.getString("cli_nombres") %>','<%= rs.getString("cli_apellidos") %>','<%= rs.getDate("cli_fechanacimiento") %>','<%= rs.getString("cli_cedula") %>','<%= rs.getString("cli_telefono") %>','<%= rs.getString("cli_telurgencia") %>')"></i>
        <i title="eliminar" class="bi bi-trash" onclick="$('#idcliente_e').val('<%= rs.getInt("idcliente") %>')" data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar: " + e.getMessage() + "</div>");
        }
    }
    // Guardar nuevo cliente
    else if ("cargar".equals(listar)) {
        String nombre = request.getParameter("cli_nombres");
        String apellido = request.getParameter("cli_apellidos");
        String cedula = request.getParameter("cli_cedula");
        String nacimiento = request.getParameter("cli_fechanacimiento");
        String telefono = request.getParameter("cli_telefono");
        String telurgencia = request.getParameter("cli_telurgencia");

        if (nombre == null || apellido == null || cedula == null || nacimiento == null) {
            out.print("<div class='alert alert-danger'>Todos los campos son obligatorios.</div>");
        } else {
            try {
                Statement st = conn.createStatement();
                String query = "INSERT INTO clientes (cli_nombres, cli_apellidos, cli_fechanacimiento, cli_cedula, cli_telefono, cli_telurgencia) VALUES ('" + nombre + "', '" + apellido + "', '" + nacimiento + "', '" + cedula + "', '" + telefono + "', '" + telurgencia + "')";
                st.executeUpdate(query);
                out.print("<div class='alert alert-success'>Cliente guardado exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
            }
        }
    }
    // Modificar cliente
    else if ("modificar".equals(listar)) {
        String id = request.getParameter("idcliente");
        String nombre = request.getParameter("cli_nombres");
        String apellido = request.getParameter("cli_apellidos");
        String cedula = request.getParameter("cli_cedula");
        String nacimiento = request.getParameter("cli_fechanacimiento");
        String telefono = request.getParameter("cli_telefono");
        String telurgencia = request.getParameter("cli_telurgencia");

        try {
            Statement st = conn.createStatement();
            String query = "UPDATE clientes SET cli_nombres = '" + nombre + "', cli_apellidos = '" + apellido + "', cli_fechanacimiento = '" + nacimiento + "', cli_cedula = '" + cedula + "', cli_telefono = '" + telefono + "', cli_telurgencia = '" + telurgencia + "' WHERE idcliente = " + id;
            st.executeUpdate(query);
            out.print("<div class='alert alert-success'>Cliente modificado exitosamente.</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al modificar: " + e.getMessage() + "</div>");
        }
    }
    // Eliminar cliente
    else if ("eliminar".equals(listar)) {
        String id = request.getParameter("idcliente_e");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM clientes WHERE idcliente = " + id);
            out.print("<div class='alert alert-success'>Cliente eliminado exitosamente.</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
        }
    }
%>
