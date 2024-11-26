<%@page import="java.util.ArrayList"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@ include file="conexion.jsp" %>

<%
    Statement st = null;
    ResultSet rs = null;

    // Tomamos los par�metros del formulario de inicio de sesi�n
    String user = request.getParameter("usuario");
    String password = request.getParameter("usu_clave");

    // Creamos la sesi�n para almacenar datos si el inicio de sesi�n es exitoso
    HttpSession sesion = request.getSession();

    try {
        // Consulta segura utilizando PreparedStatement
        String query = "SELECT u.usuario, u.idusuarios, u.idroles, r.rol " +
                       "FROM usuarios u " +
                       "INNER JOIN roles r ON u.idroles = r.idroles " +
                       "WHERE u.usuario = ? AND u.usu_clave = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setString(1, user);  // Sustituye el primer par�metro por el usuario ingresado
        pst.setString(2, password); // Sustituye el segundo par�metro por la contrase�a ingresada

        rs = pst.executeQuery();

        if (rs.next()) {
            String rol = rs.getString("rol");
            int roleId = rs.getInt("idroles");

            // Guardamos los datos del usuario en sesi�n
            sesion.setAttribute("logueado", "1");
            sesion.setAttribute("user", rs.getString("usuario"));
            sesion.setAttribute("idusuarios", rs.getString("idusuarios"));
            sesion.setAttribute("rol", rol);
            sesion.setAttribute("role_id", roleId);

            // Cargamos los permisos del rol en la sesi�n
            ArrayList<String> permisos = new ArrayList<>();
            String permisosQuery = "SELECT per_nombre FROM permisos p " +
                                   "JOIN roles_permisos rp ON p.idpermisos = rp.idpermisos " +
                                   "WHERE rp.idroles = ?";
            PreparedStatement permisoStmt = conn.prepareStatement(permisosQuery);
            permisoStmt.setInt(1, roleId);
            ResultSet permisosRs = permisoStmt.executeQuery();
            while (permisosRs.next()) {
                permisos.add(permisosRs.getString("per_nombre"));
            }
            permisosRs.close();
            permisoStmt.close();

            // Guardar la lista de permisos en la sesi�n
            sesion.setAttribute("permisos", permisos);

%>
<script>location.href = 'container.jsp';</script>
<%
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Usuario o contrase�a inv�lido.</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
