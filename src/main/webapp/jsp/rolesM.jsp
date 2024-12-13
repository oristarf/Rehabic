
<%@include file="conexion.jsp"%>
<% String idRol = request.getParameter("idroles"); // Obtener el ID del rol a editar
    System.out.println("ID del rol recibido: " + idRol);

    if ("listar".equals(request.getParameter("action"))) {
        try {
            Statement st = conn.createStatement();

            // Consulta principal para listar todos los permisos
            String queryPermisos = "SELECT idpermisos, per_nombre FROM permisos ORDER BY idpermisos";
            System.out.println("Consulta principal: " + queryPermisos);

            // Si hay un rol seleccionado, cargar permisos asociados
            Set<Integer> permisosAsociados = new HashSet<>();
            if (idRol != null && !idRol.trim().isEmpty()) {
                String queryAsociados = "SELECT idpermisos FROM roles_permisos WHERE idroles = " + idRol;
                ResultSet rsAsociados = st.executeQuery(queryAsociados);
                System.out.println("Consulta permisos asociados: " + queryAsociados);

                // Agregar permisos asociados al Set
                while (rsAsociados.next()) {
                    int permisoAsociado = rsAsociados.getInt("idpermisos");
                    System.out.println("Permiso asociado encontrado: " + permisoAsociado);
                    permisosAsociados.add(permisoAsociado);
                }
            }

            // Generar la lista de permisos con checkboxes
            ResultSet rsPermisos = st.executeQuery(queryPermisos);
            while (rsPermisos.next()) {
                int idPermiso = rsPermisos.getInt("idpermisos");
                String nombrePermiso = rsPermisos.getString("per_nombre");
%>
<div>
    <input type="checkbox" name="permisos" value="<%= idPermiso%>" 
           <% if (permisosAsociados.contains(idPermiso)) { %>checked<% }%> >
    <%= nombrePermiso%>
</div>
<%
        }
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al cargar permisos: " + e.getMessage() + "</div>");
        System.err.println("Error al cargar permisos: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT r.idroles, r.rol, COALESCE(STRING_AGG(p.per_nombre, ', '), 'Sin permisos') AS permisos " +
            "FROM roles r " +
            "LEFT JOIN roles_permisos rp ON r.idroles = rp.idroles " +
            "LEFT JOIN permisos p ON rp.idpermisos = p.idpermisos " +
            "GROUP BY r.idroles, r.rol " +
            "ORDER BY r.idroles"
        );
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idroles") %></td>
    <td><%= rs.getString("rol") %></td>
    <td><%= rs.getString("permisos") %></td> <!-- Nueva columna con los permisos -->
    <td>
        <i title="modificar" class="bi bi-pencil-square" onclick="setModificar('<%= rs.getInt("idroles") %>', '<%= rs.getString("rol") %>');" data-bs-toggle="modal" data-bs-target="#modalModificar"></i>
        <i title="eliminar" class="bi bi-trash" onclick="setEliminar('<%= rs.getInt("idroles") %>');" data-bs-toggle="modal" data-bs-target="#exampleModal"></i>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.print("Error al listar roles: " + e.getMessage());
    }
} 
// Bloque dentro de listar equals cargar
else if (request.getParameter("listar").equals("cargar")) {
    String rol = request.getParameter("rol");
    String[] permisos = request.getParameterValues("permisos");

    if (rol == null || rol.trim().isEmpty()) {
        out.print("<div class='alert alert-danger'>El nombre del rol no puede estar vacío.</div>");
        return;
    }

    try {
        conn.setAutoCommit(false); // Inicia la transacción

        // Verifica si el rol ya existe
        PreparedStatement checkStmt = conn.prepareStatement("SELECT 1 FROM roles WHERE rol ILIKE ?");
        checkStmt.setString(1, rol);
        ResultSet rs = checkStmt.executeQuery();
        if (rs.next()) {
            out.print("<div class='alert alert-danger'>El rol ya existe.</div>");
            return;
        }

        // Inserta el rol y recupera el ID generado
        PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO roles (rol) VALUES (?) RETURNING idroles");
        insertStmt.setString(1, rol);
        rs = insertStmt.executeQuery();

        int idRolGenerado = 0;
        if (rs.next()) {
            idRolGenerado = rs.getInt("idroles");
        }

        // Asigna permisos al rol si se seleccionaron
        if (permisos != null) {
            PreparedStatement permisoStmt = conn.prepareStatement("INSERT INTO roles_permisos (idroles, idpermisos) VALUES (?, ?)");
            for (String permiso : permisos) {
                permisoStmt.setInt(1, idRolGenerado);
                permisoStmt.setInt(2, Integer.parseInt(permiso)); // Asegúrate de que el permiso es un número
                permisoStmt.executeUpdate();
            }
        }

        conn.commit(); // Confirma la transacción
        out.print("<div class='alert alert-success'>Rol y permisos guardados correctamente.</div>");
    } catch (Exception e) {
        conn.rollback(); // Revertir la transacción en caso de error
        out.print("<div class='alert alert-danger'>Error al guardar el rol: " + e.getMessage() + "</div>");
    } finally {
        conn.setAutoCommit(true); // Restablecer el modo de autocommit
    }
}

 else if ("modificar".equals(request.getParameter("listar"))) {
        String idRolEditar = request.getParameter("idrol_m"); // ID del rol
        String rol = request.getParameter("rol"); // Nombre del rol
        String[] permisos = request.getParameterValues("permisos"); // Permisos seleccionados

        // Verificar los datos recibidos
        System.out.println("----- DATOS RECIBIDOS -----");
        System.out.println("ID del rol a modificar: " + idRolEditar);
        System.out.println("Nuevo nombre del rol: " + rol);
        System.out.println("Permisos seleccionados: " + Arrays.toString(permisos));

        // Validación: nombre del rol no puede estar vacío
        if (rol == null || rol.trim().isEmpty()) {
            out.print("<div class='alert alert-danger'>El nombre del rol no puede estar vacío.</div>");
            System.err.println("Error: El nombre del rol está vacío.");
            return;
        }

        // Validación: ID del rol debe ser numérico
        try {
            Integer.parseInt(idRolEditar);
        } catch (NumberFormatException e) {
            out.print("<div class='alert alert-danger'>ID del rol inválido.</div>");
            System.err.println("Error: ID del rol no es válido.");
            return;
        }

        // Proceder con la transacción
        try {
            conn.setAutoCommit(false); // Inicia la transacción
            Statement st = conn.createStatement();

            // Actualizar el nombre del rol
            String updateRolQuery = "UPDATE roles SET rol = '" + rol + "' WHERE idroles = " + idRolEditar;
            System.out.println("Ejecutando consulta: " + updateRolQuery);
            st.executeUpdate(updateRolQuery);

            // Eliminar permisos antiguos del rol
            String deletePermisosQuery = "DELETE FROM roles_permisos WHERE idroles = " + idRolEditar;
            System.out.println("Ejecutando consulta: " + deletePermisosQuery);
            st.executeUpdate(deletePermisosQuery);

            // Insertar los nuevos permisos seleccionados
            if (permisos != null) {
                for (String permiso : permisos) {
                    try {
                        int permisoId = Integer.parseInt(permiso); // Validar permiso como numérico
                        String insertPermisosQuery = "INSERT INTO roles_permisos (idroles, idpermisos) VALUES (" + idRolEditar + ", " + permisoId + ")";
                        System.out.println("Ejecutando consulta: " + insertPermisosQuery);
                        st.executeUpdate(insertPermisosQuery);
                    } catch (NumberFormatException e) {
                        System.err.println("Error: ID de permiso inválido (" + permiso + ").");
                    }
                }
            }

            conn.commit(); // Confirma la transacción
            out.print("<div class='alert alert-success'>Rol actualizado correctamente.</div>");
            System.out.println("Rol actualizado correctamente.");
        } catch (Exception e) {
            try {
                conn.rollback(); // Revertir la transacción en caso de error
            } catch (Exception rollbackEx) {
                System.err.println("Error al revertir la transacción: " + rollbackEx.getMessage());
            }
            out.print("<div class='alert alert-danger'>Error al modificar el rol: " + e.getMessage() + "</div>");
            System.err.println("Error en rolesM.jsp: " + e.getMessage());
        }
    } else if (request.getParameter("listar").equals("eliminar")) {
        String pk = request.getParameter("idrol_e");

        System.out.println("Intentando eliminar rol con ID: " + pk);

        try {
            conn.setAutoCommit(false); // Iniciar la transacción
            Statement st = conn.createStatement();

            // Eliminar las relaciones en roles_permisos
            String deletePermisosQuery = "DELETE FROM roles_permisos WHERE idroles = " + pk;
            System.out.println("Ejecutando consulta para eliminar permisos asociados: " + deletePermisosQuery);
            st.executeUpdate(deletePermisosQuery);

            // Eliminar el rol
            String deleteRolQuery = "DELETE FROM roles WHERE idroles = " + pk;
            System.out.println("Ejecutando consulta para eliminar el rol: " + deleteRolQuery);
            st.executeUpdate(deleteRolQuery);

            conn.commit(); // Confirmar la transacción
            out.print("<div class='alert alert-success'>Rol y sus permisos asociados eliminados correctamente.</div>");
            System.out.println("Rol eliminado correctamente.");
        } catch (Exception e) {
            try {
                conn.rollback(); // Revertir la transacción en caso de error
            } catch (Exception rollbackEx) {
                System.err.println("Error al revertir la transacción: " + rollbackEx.getMessage());
            }
            out.print("<div class='alert alert-danger'>Error al eliminar el rol: " + e.getMessage() + "</div>");
            System.err.println("Error al eliminar el rol: " + e.getMessage());
        }
    }


%>