<%@include file="conexion.jsp"%>
<%    String listar = request.getParameter("listar");

    // Listar clientes
    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            String query = "SELECT c.idcliente, c.cli_nombres, c.cli_apellidos, c.cli_cedula, c.cli_fechanacimiento, "
                    + "c.cli_telefono, c.cli_telurgencia, u.usuario AS usuario_asociado, u.idusuarios "
                    + "FROM clientes c "
                    + "LEFT JOIN usuarios u ON c.idusuarios = u.idusuarios "
                    + "ORDER BY c.idcliente ASC";
            ResultSet rs = st.executeQuery(query);
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
    <td><%= rs.getString("usuario_asociado") != null ? rs.getString("usuario_asociado") : "No asignado"%></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" 
           onclick="rellenaredit(
                           '<%= rs.getInt("idcliente")%>',
                           '<%= rs.getString("cli_nombres")%>',
                           '<%= rs.getString("cli_apellidos")%>',
                           '<%= rs.getDate("cli_fechanacimiento")%>',
                           '<%= rs.getString("cli_cedula")%>',
                           '<%= rs.getString("cli_telefono")%>',
                           '<%= rs.getString("cli_telurgencia")%>',
                           '<%= rs.getInt("idusuarios") != 0 ? rs.getInt("idusuarios") : ""%>'
                           )"></i>
        <i title="eliminar" class="bi bi-trash"
           onclick="$('#idcliente_e').val('<%= rs.getInt("idcliente")%>')"
           data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar: " + e.getMessage() + "</div>");
        }
    } else if ("usuarios_disponibles".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idusuarios, usuario FROM usuarios WHERE usu_estado = 'Activo'");
            while (rs.next()) {
                out.print("<option value='" + rs.getInt("idusuarios") + "'>" + rs.getString("usuario") + "</option>");
            }
        } catch (Exception e) {
            out.print("<option>Error al cargar usuarios</option>");
        }
    } // Verificar si la cédula ya existe
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
        String idusuarios = request.getParameter("idusuarios");

        // Agregar logs para depuración
        System.out.println("----- DATOS RECIBIDOS -----");
        System.out.println("Nombre: " + nombre);
        System.out.println("Apellido: " + apellido);
        System.out.println("Cédula: " + cedula);
        System.out.println("Fecha de Nacimiento: " + nacimiento);
        System.out.println("Teléfono: " + telefono);
        System.out.println("Teléfono de Urgencia: " + telurgencia);
        System.out.println("ID Usuario Asociado: " + idusuarios);
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
                String query;
                if (idusuarios == null || idusuarios.isEmpty()) {
                    query = "INSERT INTO clientes (cli_nombres, cli_apellidos, cli_fechanacimiento, cli_cedula, cli_telefono, cli_telurgencia) VALUES ('"
                            + nombre + "', '" + apellido + "', '" + nacimiento + "', '" + cedula + "', '" + telefono + "', '" + telurgencia + "')";
                } else {
                    query = "INSERT INTO clientes (cli_nombres, cli_apellidos, cli_fechanacimiento, cli_cedula, cli_telefono, cli_telurgencia, idusuarios) VALUES ('"
                            + nombre + "', '" + apellido + "', '" + nacimiento + "', '" + cedula + "', '" + telefono + "', '" + telurgencia + "', " + idusuarios + ")";
                }
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
    String idusuarios = request.getParameter("idusuario"); // Revisar parámetro aquí

    // Imprimir valores recibidos para depuración
    System.out.println("----- DATOS RECIBIDOS -----");
    System.out.println("ID Cliente: " + id);
    System.out.println("Nombre: " + nombre);
    System.out.println("Apellido: " + apellido);
    System.out.println("Cédula: " + cedula);
    System.out.println("Fecha de Nacimiento: " + nacimiento);
    System.out.println("Teléfono: " + telefono);
    System.out.println("Teléfono de Urgencia: " + telurgencia);
    System.out.println("ID Usuario: " + idusuarios);

    try {
        Statement st = conn.createStatement();
        String query = "UPDATE clientes SET cli_nombres = '" + nombre + "', "
                + "cli_apellidos = '" + apellido + "', "
                + "cli_fechanacimiento = '" + nacimiento + "', "
                + "cli_cedula = '" + cedula + "', "
                + "cli_telefono = '" + telefono + "', "
                + "cli_telurgencia = '" + telurgencia + "', "
                + "idusuarios = " + (idusuarios != null && !idusuarios.isEmpty() ? idusuarios : "NULL") + " " // Manejo de valores nulos
                + "WHERE idcliente = " + id;

        System.out.println("Ejecutando consulta: " + query); // Depuración
        st.executeUpdate(query);
        out.print("<div class='alert alert-success'>Cliente modificado exitosamente.</div>");
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al modificar: " + e.getMessage() + "</div>");
        System.err.println("Error al modificar cliente: " + e.getMessage());
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
