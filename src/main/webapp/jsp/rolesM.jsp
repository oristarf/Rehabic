<%@include file="conexion.jsp"%>
<%
    
if(request.getParameter("listar").equals("listar")){

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        // Query para obtener roles junto con sus permisos concatenados
        rs = st.executeQuery(
            "SELECT r.idroles, r.rol, STRING_AGG(p.per_nombre, ', ') AS permisos " +
            "FROM roles r " +
            "LEFT JOIN roles_permisos rp ON r.idroles = rp.idroles " +
            "LEFT JOIN permisos p ON rp.idpermisos = p.idpermisos " +
            "GROUP BY r.idroles, r.rol " +
            "ORDER BY r.idroles ASC"
        );

        while(rs.next()) {
%>
<tr>
    <td><%= rs.getString("idroles") %></td>
    <td><%= rs.getString("rol") %></td>
    <td><%= rs.getString("permisos") != null ? rs.getString("permisos") : "Sin permisos" %></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" onclick="setModificar('<%= rs.getString("idroles") %>', '<%= rs.getString("rol") %>');" data-bs-toggle="modal" data-bs-target="#modalModificar"></i>
        <i title="eliminar" class="bi bi-trash" onclick="$('#idroles_e').val('<%= rs.getString("idroles") %>')" data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
        }
    } catch(Exception e) {
        out.print("Error al listar roles y permisos: " + e.getMessage());
    }

} else if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT r.idroles, r.rol, " +
            "COALESCE(GROUP_CONCAT(p.per_nombre SEPARATOR ', '), 'Sin permisos') AS permisos " +
            "FROM roles r " +
            "LEFT JOIN roles_permisos rp ON r.idroles = rp.idroles " +
            "LEFT JOIN permisos p ON rp.idpermisos = p.idpermisos " +
            "GROUP BY r.idroles, r.rol " +
            "ORDER BY r.idroles ASC"
        );

        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idroles") %></td>
    <td><%= rs.getString("rol") %></td>
    <td><%= rs.getString("permisos") %></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square" 
           onclick="setModificar('<%= rs.getString("idroles") %>', '<%= rs.getString("rol") %>');" 
           data-bs-toggle="modal" data-bs-target="#modalModificar"></i>
        <i title="eliminar" class="bi bi-trash" 
           onclick="$('#idroles_e').val('<%= rs.getString("idroles") %>');" 
           data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.print("Error al listar roles y permisos: " + e.getMessage());
    }
}
 else if(request.getParameter("listar").equals("cargar")) {

    String rol = request.getParameter("rol");
    String[] permisos = request.getParameterValues("permisos");

    if (rol == null || rol.trim().isEmpty()) {
        out.print("<div class='alert alert-danger' role='alert'>Campo vacío rol</div>");
    } else {
        try {
            Statement st = conn.createStatement();
            // Insertar el rol
            st.executeUpdate("INSERT INTO roles(rol) VALUES (upper('" + rol + "'))", Statement.RETURN_GENERATED_KEYS);
            ResultSet generatedKeys = st.getGeneratedKeys();
            int rolId = 0;
            if (generatedKeys.next()) {
                rolId = generatedKeys.getInt(1);  // Obtenemos el ID generado del rol
            }

            // Insertar los permisos asociados en roles_permisos
            if (permisos != null && rolId > 0) {
                for (String permisoId : permisos) {
                    st.executeUpdate("INSERT INTO roles_permisos (idroles, idpermisos) VALUES (" + rolId + ", " + permisoId + ")");
                }
            }

            out.print("<div class='alert alert-success' role='alert'>Rol y permisos guardados correctamente</div>");
        } catch (Exception e) {
            out.print("Error al guardar rol y permisos: " + e.getMessage());
        }
    }

} else if (request.getParameter("listar").equals("modificar")) {

    String pk = request.getParameter("idroles_m");
    String rol = request.getParameter("rol");
    String[] permisos = request.getParameterValues("permisos");

    if (rol == null || rol.trim().isEmpty()) {
        out.print("<div class='alert alert-danger' role='alert'>Campo vacío rol</div>");
    } else {
        try {
            Statement st = conn.createStatement();
            // Actualizar el nombre del rol
            st.executeUpdate("UPDATE roles SET rol= upper('" + rol + "') WHERE idroles='" + pk + "'");

            // Actualizar permisos asociados
            st.executeUpdate("DELETE FROM roles_permisos WHERE idroles = " + pk);  // Eliminamos permisos antiguos
            if (permisos != null) {
                for (String permisoId : permisos) {
                    st.executeUpdate("INSERT INTO roles_permisos (idroles, idpermisos) VALUES (" + pk + ", " + permisoId + ")");
                }
            }

            out.print("<div class='alert alert-success' role='alert'>Rol y permisos modificados correctamente</div>");
        } catch (Exception e) {
            out.print("Error al modificar rol y permisos: " + e.getMessage());
        }
    }

} else if (request.getParameter("listar").equals("eliminar")) {

    String pk = request.getParameter("idroles_e");

    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM roles_permisos WHERE idroles='" + pk + "'");  // Eliminar permisos asociados
        st.executeUpdate("DELETE FROM roles WHERE idroles='" + pk + "'");  // Eliminar el rol

        out.print("<div class='alert alert-success' role='alert'>Rol y permisos eliminados correctamente</div>");
    } catch (Exception e) {
        out.print("Error al eliminar rol y permisos: " + e.getMessage());
    }
}
%>
