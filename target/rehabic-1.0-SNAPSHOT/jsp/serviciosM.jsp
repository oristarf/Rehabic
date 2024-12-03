<%@include file="conexion.jsp"%>
<%    if ("verificar_duplicado".equals(request.getParameter("listar"))) {
        String ser_nombre = request.getParameter("ser_nombre");
        String idservicio = request.getParameter("idservicio"); // ID del servicio actual (opcional)

        try {
            String query = "SELECT COUNT(*) FROM servicios WHERE ser_nombre ILIKE ?";
            if (idservicio != null && !idservicio.isEmpty()) {
                query += " AND idservicio != ?"; // Excluir el servicio actual
            }

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, ser_nombre);
            if (idservicio != null && !idservicio.isEmpty()) {
                pstmt.setInt(2, Integer.parseInt(idservicio));
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
    } else if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM servicios ORDER BY idservicio");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idservicio")%></td>
    <td><%= rs.getString("ser_nombre")%></td>
    <td><%= rs.getString("ser_tipo")%></td> <!-- Mostrar tipo de servicio -->
    <td>Gs <%= rs.getInt("ser_precio")%></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square"
           onclick="setModificar('<%= rs.getInt("idservicio")%>', '<%= rs.getString("ser_nombre")%>', '<%= rs.getString("ser_tipo")%>', '<%= rs.getInt("ser_precio")%>')" 
           data-bs-toggle="modal" data-bs-target="#modalModificar"></i>
        <i title="eliminar" class="bi bi-trash" onclick="setEliminar('<%= rs.getInt("idservicio")%>')" data-bs-toggle="modal" data-bs-target="#modalEliminar"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar servicios: " + e.getMessage() + "</div>");
        }
    } else if ("cargar".equals(request.getParameter("listar"))) {
        String ser_nombre = request.getParameter("ser_nombre");
        String ser_tipo = request.getParameter("ser_tipo"); // Nuevo campo
        String ser_precioStr = request.getParameter("ser_precio");

        if (ser_nombre == null || ser_nombre.isEmpty() || ser_precioStr == null || ser_precioStr.isEmpty() || ser_tipo == null || ser_tipo.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Debe completar todos los campos.</div>");
        } else {
            try {
                int ser_precio = Integer.parseInt(ser_precioStr);
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO servicios (ser_nombre, ser_tipo, ser_precio) VALUES (?, ?, ?)");
                pstmt.setString(1, ser_nombre);
                pstmt.setString(2, ser_tipo); // Guardar tipo
                pstmt.setInt(3, ser_precio);
                pstmt.executeUpdate();
                out.print("<div class='alert alert-success' role='alert'>Servicio guardado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar servicio: " + e.getMessage() + "</div>");
            }
        }
    } else if ("modificar".equals(request.getParameter("listar"))) {
        String id = request.getParameter("idservicio");
        String ser_nombre = request.getParameter("ser_nombre");
        String ser_tipo = request.getParameter("ser_tipo"); // Nuevo campo
        String ser_precioStr = request.getParameter("ser_precio");

        if (ser_nombre == null || ser_nombre.isEmpty() || ser_precioStr == null || ser_precioStr.isEmpty() || ser_tipo == null || ser_tipo.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Debe completar todos los campos.</div>");
        } else {
            try {
                int ser_precio = Integer.parseInt(ser_precioStr);
                PreparedStatement pstmt = conn.prepareStatement("UPDATE servicios SET ser_nombre = ?, ser_tipo = ?, ser_precio = ? WHERE idservicio = ?");
                pstmt.setString(1, ser_nombre);
                pstmt.setString(2, ser_tipo); // Actualizar tipo
                pstmt.setInt(3, ser_precio);
                pstmt.setInt(4, Integer.parseInt(id));
                pstmt.executeUpdate();
                out.print("<div class='alert alert-success' role='alert'>Servicio modificado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al modificar servicio: " + e.getMessage() + "</div>");
            }
        }
    } else if ("eliminar".equals(request.getParameter("listar"))) {
        String id = request.getParameter("idservicio_e");
        try {
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM servicios WHERE idservicio = ?");
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
            out.print("<div class='alert alert-success' role='alert'>Servicio eliminado correctamente</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al eliminar servicio: " + e.getMessage() + "</div>");
        }
    }

%>
