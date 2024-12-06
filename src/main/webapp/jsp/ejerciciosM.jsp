<%@include file="conexion.jsp"%>
<%    if ("verificar_duplicado".equals(request.getParameter("listar"))) {
        String eje_nombre = request.getParameter("eje_nombre");
        String idejercicio = request.getParameter("idejercicio"); 

        try {
            String query = "SELECT COUNT(*) FROM ejercicios WHERE eje_nombre ILIKE ?";
            if (idejercicio != null && !idejercicio.isEmpty()) {
                query += " AND idejercicio != ?"; 
            }

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, eje_nombre);
            if (idejercicio != null && !idejercicio.isEmpty()) {
                pstmt.setInt(2, Integer.parseInt(idejercicio));
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
            ResultSet rs = st.executeQuery("SELECT * FROM ejercicios ORDER BY idejercicio");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idejercicio")%></td>
    <td><%= rs.getString("eje_nombre")%></td>
    <td><%= rs.getString("eje_descripcion")%></td>
    <td><%= rs.getString("eje_categoria")%></td>
    <td>
        <i title="modificar" class="bi bi-pencil-square"
           onclick="setModificar('<%= rs.getInt("idejercicio")%>', '<%= rs.getString("eje_nombre")%>', '<%= rs.getString("eje_descripcion")%>', '<%= rs.getString("eje_categoria")%>')" 
           data-bs-toggle="modal" data-bs-target="#modalModificar"></i>
        <i title="eliminar" class="bi bi-trash" onclick="setEliminar('<%= rs.getInt("idejercicio")%>')" data-bs-toggle="modal" data-bs-target="#modalEliminar"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al listar ejercicios: " + e.getMessage() + "</div>");
        }
    } else if ("cargar".equals(request.getParameter("listar"))) {
        String eje_nombre = request.getParameter("eje_nombre");
        String eje_descripcion = request.getParameter("eje_descripcion");
        String eje_categoria = request.getParameter("eje_categoria");

        if (eje_nombre == null || eje_nombre.isEmpty() ) {
            out.print("<div class='alert alert-danger' role='alert'>Debe completar todos los campos.</div>");
        } else {
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO ejercicios (eje_nombre, eje_descripcion, eje_categoria) VALUES (?, ?, ?)");
                pstmt.setString(1, eje_nombre);
                pstmt.setString(2, eje_descripcion); 
                pstmt.setString(3, eje_categoria);
                pstmt.executeUpdate();
                out.print("<div class='alert alert-success' role='alert'>ejercicio guardado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al guardar ejercicio: " + e.getMessage() + "</div>");
            }
        }
    } else if ("modificar".equals(request.getParameter("listar"))) {
        String id = request.getParameter("idejercicio");
        String eje_nombre = request.getParameter("eje_nombre");
        String eje_descripcion = request.getParameter("eje_descripcion"); 
        String eje_categoria = request.getParameter("eje_categoria");

        if (eje_nombre == null || eje_nombre.isEmpty()) {
            out.print("<div class='alert alert-danger' role='alert'>Debe completar todos los campos.</div>");
        } else {
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE ejercicios SET eje_nombre = ?, eje_descripcion = ?, eje_categoria = ? WHERE idejercicio = ?");
                pstmt.setString(1, eje_nombre);
                pstmt.setString(2, eje_descripcion); 
                pstmt.setString(3, eje_categoria);
                pstmt.setInt(4, Integer.parseInt(id));
                pstmt.executeUpdate();
                out.print("<div class='alert alert-success' role='alert'>ejercicio modificado correctamente</div>");
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al modificar ejercicio: " + e.getMessage() + "</div>");
            }
        }
    } else if ("eliminar".equals(request.getParameter("listar"))) {
        String id = request.getParameter("idejercicio_e");
        try {
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM ejercicios WHERE idejercicio = ?");
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
            out.print("<div class='alert alert-success' role='alert'>ejercicio eliminado correctamente</div>");
        } catch (Exception e) {
            out.print("<div class='alert alert-danger'>Error al eliminar ejercicio: " + e.getMessage() + "</div>");
        }
    }

%>
