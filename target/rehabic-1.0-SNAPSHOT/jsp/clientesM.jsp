<%@include file="conexion.jsp"%>
<%    String listar = request.getParameter("listar");

    // Listar clientes
    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idcliente, cli_nombres, cli_apellidos, cli_cedula, cli_fechanacimiento, cli_telefono, cli_telurgencia FROM clientes ORDER BY idcliente ASC");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idcliente")%></td>
    <td><%= rs.getString("cli_nombres")%></td>
    <td><%= rs.getString("cli_apellidos")%></td>
    <td><%= rs.getDate("cli_fechanacimiento")%></td>
    <td><%= rs.getString("cli_cedula")%></td>
    <td><%= rs.getString("cli_telefono")%></td>
    <td><%= rs.getString("cli_telurgencia")%></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" onclick="rellenaredit('<%= rs.getInt("idcliente")%>', '<%= rs.getString("cli_nombres")%>', '<%= rs.getString("cli_apellidos")%>', '<%= rs.getDate("cli_fechanacimiento")%>', '<%= rs.getString("cli_cedula")%>', '<%= rs.getString("cli_telefono")%>', '<%= rs.getString("cli_telurgencia")%>')"></i>
        <i title="eliminar" class="bi bi-trash" onclick="$('#idcliente_e').val('<%= rs.getInt("idcliente")%>')" data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar: " + e.getMessage() + "</div>");
        }
    }// Verificar si la cédula ya existe
    else if ("verificar_cedula".equals(listar)) {
        String cedula = request.getParameter("cli_cedula");
        String idCliente = request.getParameter("idcliente");

        try {
            Statement st = conn.createStatement();
            String query = "SELECT idcliente FROM clientes WHERE cli_cedula = '" + cedula + "'";
            ResultSet rs = st.executeQuery(query);

            if (rs.next()) {
                int idExistente = rs.getInt("idcliente");

                // Si la cédula existe pero pertenece al cliente actual, es válida
                if (idCliente != null && Integer.parseInt(idCliente) == idExistente) {
                    out.print("disponible");
                } else {
                    out.print("duplicado");
                }
            } else {
                out.print("disponible");
            }
        } catch (Exception e) {
            out.print("error");
        }
    } // Guardar nuevo cliente
    else if ("cargar".equals(listar)) {
        String nombre = request.getParameter("cli_nombres");
        String apellido = request.getParameter("cli_apellidos");
        String cedula = request.getParameter("cli_cedula");
        String nacimiento = request.getParameter("cli_fechanacimiento");
        String telefono = request.getParameter("cli_telefono");
        String telurgencia = request.getParameter("cli_telurgencia");

        // Validación: Verificar que todos los campos estén completos
        if (nombre == null || nombre.trim().isEmpty()
                || apellido == null || apellido.trim().isEmpty()
                || cedula == null || cedula.trim().isEmpty()
                || nacimiento == null || nacimiento.trim().isEmpty()
                || telefono == null || telefono.trim().isEmpty()
                || telurgencia == null || telurgencia.trim().isEmpty()) {

            out.print("<div class='alert alert-danger'>Todos los campos son obligatorios. Por favor, complete el formulario.</div>");
        } else {
            try {
                Statement st = conn.createStatement();
                String query = "INSERT INTO clientes (cli_nombres, cli_apellidos, cli_fechanacimiento, cli_cedula, cli_telefono, cli_telurgencia) VALUES ('"
                        + nombre + "', '" + apellido + "', '" + nacimiento + "', '" + cedula + "', '" + telefono + "', '" + telurgencia + "')";
                st.executeUpdate(query);
                out.print("<div class='alert alert-success'>Cliente guardado exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
            }
        }
    } // Modificar cliente
    else if ("modificar".equals(listar)) {
        String id = request.getParameter("idcliente");
        String nombre = request.getParameter("cli_nombres");
        String apellido = request.getParameter("cli_apellidos");
        String cedula = request.getParameter("cli_cedula");
        String nacimiento = request.getParameter("cli_fechanacimiento");
        String telefono = request.getParameter("cli_telefono");
        String telurgencia = request.getParameter("cli_telurgencia");

        // Imprimir valores recibidos para depuración
        System.out.println("----- DATOS RECIBIDOS -----");
        System.out.println("ID Cliente: " + id);
        System.out.println("Nombre: " + nombre);
        System.out.println("Apellido: " + apellido);
        System.out.println("Cédula: " + cedula);
        System.out.println("Fecha de Nacimiento: " + nacimiento);
        System.out.println("Teléfono: " + telefono);
        System.out.println("Teléfono de Urgencia: " + telurgencia);

        try {
            Statement st = conn.createStatement();
            String query = "UPDATE clientes SET cli_nombres = '" + nombre + "', "
                    + "cli_apellidos = '" + apellido + "', "
                    + "cli_fechanacimiento = '" + nacimiento + "', "
                    + "cli_cedula = '" + cedula + "', "
                    + "cli_telefono = '" + telefono + "', "
                    + "cli_telurgencia = '" + telurgencia + "' "
                    + "WHERE idcliente = " + id;
            System.out.println("Ejecutando consulta: " + query); // Depuración
            st.executeUpdate(query);
            out.print("<div class='alert alert-success'>Cliente modificado exitosamente.</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al modificar: " + e.getMessage() + "</div>");
            System.err.println("Error al modificar cliente: " + e.getMessage());
        }
    } // Eliminar cliente
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
