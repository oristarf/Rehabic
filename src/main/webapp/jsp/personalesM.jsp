<%@include file="conexion.jsp"%>
<%    String listar = request.getParameter("listar");

    // Listar personales
    if ("listar".equals(listar)) {
        try {
            Statement st = conn.createStatement();
            String query = "SELECT p.idpersonal, p.per_nombres, p.per_apellidos, p.per_cedula, p.per_email, "
                    + "p.per_telefono, p.per_direccion, u.usuario AS usuario_asociado, u.idusuarios "
                    + "FROM personales p "
                    + "LEFT JOIN usuarios u ON p.idusuarios = u.idusuarios "
                    + "ORDER BY p.idpersonal ASC";
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idpersonal")%></td>
    <td><%= rs.getString("per_nombres")%></td>
    <td><%= rs.getString("per_apellidos")%></td>
    <td><%= rs.getString("per_cedula")%></td>
    <td><%= rs.getString("per_email")%></td>
    <td><%= rs.getString("per_telefono")%></td>
    <td><%= rs.getString("per_direccion") != null ? rs.getString("per_direccion") : "Sin dirección"%></td>
    <td><%= rs.getString("usuario_asociado") != null ? rs.getString("usuario_asociado") : "No asignado"%></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" 
           onclick="rellenaredit(
                           '<%= rs.getInt("idpersonal")%>',
                           '<%= rs.getString("per_nombres")%>',
                           '<%= rs.getString("per_apellidos")%>',
                           '<%= rs.getString("per_cedula")%>',
                           '<%= rs.getString("per_email")%>',
                           '<%= rs.getString("per_telefono")%>',
                           '<%= rs.getString("per_direccion") != null ? rs.getString("per_direccion") : ""%>',
                           '<%= rs.getInt("idusuarios") != 0 ? rs.getInt("idusuarios") : ""%>'
                           )"></i>
        <i title="eliminar" class="bi bi-trash"
           onclick="$('#idpersonal_e').val('<%= rs.getInt("idpersonal")%>')"
           data-bs-toggle="modal" data-bs-target="#modalEliminarPersonal"></i>
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
    } else if ("verificar_cedula".equals(listar)) {
        String cedula = request.getParameter("per_cedula");
        String idPersonal = request.getParameter("idpersonal");

        try {
            Statement st = conn.createStatement();
            String query = "SELECT idpersonal FROM personales WHERE per_cedula = '" + cedula + "'";
            ResultSet rs = st.executeQuery(query);

            if (rs.next()) {
                int idExistente = rs.getInt("idpersonal");

                // Si la cédula existe pero pertenece al personal actual, es válida
                if (idPersonal != null && Integer.parseInt(idPersonal) == idExistente) {
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
    }// Guardar nuevo personal
    else if ("cargar".equals(listar)) {
        String nombre = request.getParameter("per_nombres");
        String apellido = request.getParameter("per_apellidos");
        String cedula = request.getParameter("per_cedula");
        String email = request.getParameter("per_email");
        String telefono = request.getParameter("per_telefono");
        String direccion = request.getParameter("per_direccion");
        String idusuarios = request.getParameter("idusuarios");
        String fechaContratacion = request.getParameter("fecha_contratacion");

        // Logs para depuración
        System.out.println("----- DATOS RECIBIDOS -----");
        System.out.println("Nombre: " + nombre);
        System.out.println("Apellido: " + apellido);
        System.out.println("Cédula: " + cedula);
        System.out.println("Email: " + email);
        System.out.println("Teléfono: " + telefono);
        System.out.println("Dirección: " + direccion);
        System.out.println("Fecha de Contratación: " + fechaContratacion);
        System.out.println("ID Usuario Asociado: " + idusuarios);

        // Validación
        if (nombre == null || nombre.trim().isEmpty()
                || apellido == null || apellido.trim().isEmpty()
                || cedula == null || cedula.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || telefono == null || telefono.trim().isEmpty()) {

            out.print("<div class='alert alert-danger'>Todos los campos obligatorios deben completarse.</div>");
        } else if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            out.print("<div class='alert alert-danger'>El correo ingresado no es válido.</div>");
            return;
        } else {
            try {
                Statement st = conn.createStatement();
                String query = "INSERT INTO personales (per_nombres, per_apellidos, per_cedula, per_email, per_telefono, per_direccion, fecha_contratacion, idusuarios) VALUES ('"
                        + nombre + "', '" + apellido + "', '" + cedula + "', '" + email + "', '" + telefono + "', '" + direccion + "', "
                        + (fechaContratacion != null && !fechaContratacion.isEmpty() ? "'" + fechaContratacion + "'" : "NULL") + ", "
                        + (idusuarios != null && !idusuarios.isEmpty() ? idusuarios : "NULL") + ")";
                System.out.println("Ejecutando consulta: " + query);
                st.executeUpdate(query);
                out.print("<div class='alert alert-success'>Personal guardado exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar: " + e.getMessage() + "</div>");
            }
        }
    } // Modificar personal
    else if ("modificar".equals(listar)) {
        String id = request.getParameter("idpersonal");
        String nombre = request.getParameter("per_nombres");
        String apellido = request.getParameter("per_apellidos");
        String cedula = request.getParameter("per_cedula");
        String email = request.getParameter("per_email");
        String telefono = request.getParameter("per_telefono");
        String direccion = request.getParameter("per_direccion");
        String idusuarios = request.getParameter("idusuarios");
        String fechaContratacion = request.getParameter("fecha_contratacion");

        // Logs para depuración
        System.out.println("----- DATOS RECIBIDOS -----");
        System.out.println("ID Personal: " + id);
        System.out.println("Nombre: " + nombre);
        System.out.println("Apellido: " + apellido);
        System.out.println("Cédula: " + cedula);
        System.out.println("Email: " + email);
        System.out.println("Teléfono: " + telefono);
        System.out.println("Dirección: " + direccion);
        System.out.println("Fecha de Contratación: " + fechaContratacion);
        System.out.println("ID Usuario: " + idusuarios);
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            out.print("<div class='alert alert-danger'>El correo ingresado no es válido.</div>");
            return;
        } else {
            try {
                Statement st = conn.createStatement();
                String query = "UPDATE personales SET per_nombres = '" + nombre + "', "
                        + "per_apellidos = '" + apellido + "', "
                        + "per_cedula = '" + cedula + "', "
                        + "per_email = '" + email + "', "
                        + "per_telefono = '" + telefono + "', "
                        + "per_direccion = '" + direccion + "', "
                        + "fecha_contratacion = " + (fechaContratacion != null && !fechaContratacion.isEmpty() ? "'" + fechaContratacion + "'" : "NULL") + ", "
                        + "idusuarios = " + (idusuarios != null && !idusuarios.isEmpty() ? idusuarios : "NULL") + " "
                        + "WHERE idpersonal = " + id;
                System.out.println("Ejecutando consulta: " + query);
                st.executeUpdate(query);
                out.print("<div class='alert alert-success'>Personal modificado exitosamente.</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al modificar: " + e.getMessage() + "</div>");
            }
        }

    } // Eliminar personal
    else if ("eliminar".equals(listar)) {
        String id = request.getParameter("idpersonal_e");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM personales WHERE idpersonal = " + id);
            out.print("<div class='alert alert-success'>Personal eliminado exitosamente.</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
        }
    }
%>



