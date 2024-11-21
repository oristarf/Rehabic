<%@page import="java.util.ArrayList"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@ include file="conexion.jsp" %>

<%  
    Statement st = null;
    ResultSet rs = null;

    // Tomamos los parámetros del formulario de inicio de sesión
    String user = request.getParameter("usuario");
    String password = request.getParameter("usu_clave");

    // Creamos la sesión para almacenar datos si el inicio de sesión es exitoso
    HttpSession sesion = request.getSession();

    try {
        // Consultamos el rol y los datos del usuario en la base de datos
        st = conn.createStatement();
        rs = st.executeQuery("SELECT u.usuario, u.idusuarios, u.idroles, r.rol FROM usuarios u INNER JOIN roles r ON u.idroles = r.idroles WHERE u.usuario='" + user + "' AND u.usu_clave='" + password + "';");

        if (rs.next()) {
            String rol = rs.getString("rol");
            int roleId = rs.getInt("idroles");

            // Guardamos los datos del usuario en sesión
            sesion.setAttribute("logueado", "1");
            sesion.setAttribute("user", rs.getString("usuario"));
            sesion.setAttribute("idusuarios", rs.getString("idusuarios"));
            sesion.setAttribute("rol", rol);
            sesion.setAttribute("role_id", roleId);

            // Cargamos los permisos del rol en la sesión
            ArrayList<String> permisos = new ArrayList<>();
            PreparedStatement permisoStmt = conn.prepareStatement(
                "SELECT per_nombre FROM permisos p " +
                "JOIN roles_permisos rp ON p.idpermisos = rp.idpermisos " +
                "WHERE rp.idroles = ?"
            );
            permisoStmt.setInt(1, roleId);
            ResultSet permisosRs = permisoStmt.executeQuery();
            while (permisosRs.next()) {
                permisos.add(permisosRs.getString("per_nombre"));
            }
            permisosRs.close();
            permisoStmt.close();

            // Guardar la lista de permisos en la sesión
            sesion.setAttribute("permisos", permisos);

%>
<script>location.href = 'container.jsp';</script>
<%
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Usuario o contraseña inválido.</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
