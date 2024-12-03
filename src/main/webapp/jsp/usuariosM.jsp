<%@include file="conexion.jsp"%>
<%
    String listar = request.getParameter("listar");

    if ("verificar_duplicado".equals(listar)) {
        // Validación de duplicados
        String usuario = request.getParameter("usuario");
        String idusuarios = request.getParameter("idusuarios"); // Opcional para excluir el usuario actual

        try {
            String query = "SELECT COUNT(*) FROM usuarios WHERE usuario ILIKE ?";
            if (idusuarios != null && !idusuarios.isEmpty()) {
                query += " AND idusuarios != ?"; // Excluir el usuario actual
            }

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, usuario);
            if (idusuarios != null && !idusuarios.isEmpty()) {
                pstmt.setInt(2, Integer.parseInt(idusuarios));
            }

            ResultSet rs = pstmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                out.print("duplicado");
            } else {
                out.print("no_duplicado");
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al verificar duplicado: " + e.getMessage() + "</div>");
        }

    } else if ("listar".equals(listar)) {
        // Listar usuarios
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT u.idusuarios, u.usuario, u.usu_clave, r.idroles, r.rol " +
                                           "FROM usuarios u INNER JOIN roles r ON u.idroles = r.idroles " +
                                           "ORDER BY u.idusuarios ASC");

            while (rs.next()) { %>
<tr>
    <td><%= rs.getString("idusuarios") %></td>
    <td><%= rs.getString("usuario") %></td>
    <td><%= rs.getString("usu_clave") %></td>
    <td><%= rs.getString("rol") %></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square"
           onclick="rellenaredit('<%= rs.getString("idusuarios") %>', '<%= rs.getString("usuario") %>', '<%= rs.getString("usu_clave") %>', '<%= rs.getString("idroles") %>')"></i>
        <i title="eliminar" class="bi bi-trash"
           onclick="$('#idusuarios_e').val('<%= rs.getString("idusuarios") %>')" 
           data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<% 
            }

        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar usuarios: " + e.getMessage() + "</div>");
        }

    } else if ("cargar".equals(listar)) {
        // Guardar un nuevo usuario
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");

        if (usuario.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Campo vacío: usuario</div>");
        } else if (clave.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Campo vacío: clave</div>");
        } else if (rol.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Campo vacío: rol</div>");
        } else {
            try {
                Statement st = conn.createStatement();
                st.executeUpdate("INSERT INTO usuarios (usuario, usu_clave, idroles) VALUES ('" + usuario + "', '" + clave + "', '" + rol + "')");
                out.print("<div class='alert alert-success' role='alert'>Guardado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar usuario: " + e.getMessage() + "</div>");
            }
        }

    } else if ("modificar".equals(listar)) {
        // Modificar un usuario existente
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");
        String pk = request.getParameter("idusuarios");

        if (usuario.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Campo vacío: usuario</div>");
        } else {
            try {
                Statement st = conn.createStatement();
                st.executeUpdate("UPDATE usuarios SET usuario = '" + usuario + "', usu_clave = '" + clave + "', idroles = '" + rol + "' WHERE idusuarios = '" + pk + "'");
                out.print("<div class='alert alert-success' role='alert'>Modificado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al modificar usuario: " + e.getMessage() + "</div>");
            }
        }

    } else if ("eliminar".equals(listar)) {
        // Eliminar un usuario
        String pk = request.getParameter("idusuarios_e");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM usuarios WHERE idusuarios = '" + pk + "'");
            out.print("<div class='alert alert-success' role='alert'>Usuario eliminado</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al eliminar usuario: " + e.getMessage() + "</div>");
        }
    }
%>
