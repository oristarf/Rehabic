<%@include file="conexion.jsp"%>
<%
String idRol = request.getParameter("idroles"); // Captura el ID del rol
System.out.println("ID del rol recibido en buscar_permisos.jsp: " + idRol); // Depuración

if ("listar".equals(request.getParameter("action"))) {
    try {
        Statement st = conn.createStatement();

        // Consulta para obtener los permisos asociados al rol
        Set<Integer> permisosAsociados = new HashSet<>();
        if (idRol != null && !idRol.trim().isEmpty()) {
            String queryAsociados = "SELECT idpermisos FROM roles_permisos WHERE idroles = " + idRol;
            ResultSet rsAsociados = st.executeQuery(queryAsociados);

            while (rsAsociados.next()) {
                int permisoAsociado = rsAsociados.getInt("idpermisos");
                System.out.println("Permiso asociado encontrado: " + permisoAsociado); // Depuración
                permisosAsociados.add(permisoAsociado);
            }
        }

        // Consulta principal para listar todos los permisos
        String queryPermisos = "SELECT idpermisos, per_nombre FROM permisos ORDER BY idpermisos";
        ResultSet rsPermisos = st.executeQuery(queryPermisos);

        // Generar la lista de permisos con checkboxes
        while (rsPermisos.next()) {
            int idPermiso = rsPermisos.getInt("idpermisos");
            String nombrePermiso = rsPermisos.getString("per_nombre");
%>
        <div>
            <input type="checkbox" name="permisos" value="<%= idPermiso %>" 
                   <% if (permisosAsociados.contains(idPermiso)) { %>checked<% } %> >
            <%= nombrePermiso %>
        </div>
<%
        }
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al cargar permisos: " + e.getMessage() + "</div>");
        System.err.println("Error en buscar_permisos.jsp: " + e.getMessage()); // Depuración
    }
}
%>
