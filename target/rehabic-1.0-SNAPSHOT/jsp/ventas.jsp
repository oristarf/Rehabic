

<%@ include file="conexion.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%   
    HttpSession sesion=request.getSession();
    
    String listar = request.getParameter("listar");
    if ("cargar".equals(listar)) {
        /* DATOS PARA LA CABECERA */
        String idclientes = request.getParameter("idclientes");
        String tra_fecha = request.getParameter("tra_fecha");
        String estado = request.getParameter("estado");
        /* DATOS PARA EL DETALLE */
        //String id_detalle = request.getParameter("id_detalle");
        String idtratamientos = request.getParameter("idtratamientos");
        String det_fecha = request.getParameter("det_fecha");
        String descripcion = request.getParameter("descripcion");

        try {
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            // Verificar si existe una cabecera de venta pendiente
            pstmt = conn.prepareStatement("SELECT idtratamientos FROM tratamientos WHERE estado='Pendiente';");
            rs = pstmt.executeQuery();
            if (rs.next()) {
    // Insertar detalle de venta
    pstmt = conn.prepareStatement("INSERT INTO detalle_tratamientos (idtratamientos, det_fecha, descripcion) VALUES (?,?,?)");
    pstmt.setInt(1, rs.getInt(1)); // idtratamientos
    pstmt.setDate(2, java.sql.Date.valueOf(det_fecha));
    pstmt.setString(3, descripcion); // descripcion
    pstmt.executeUpdate();
} else {
    // Insertar cabecera de venta
    pstmt = conn.prepareStatement("INSERT INTO tratamientos (idclientes, tra_fecha, estado) VALUES (?, TO_DATE(?, 'DD-MM-YYYY'),'Pendiente')");
    pstmt.setInt(1, Integer.parseInt(idclientes));
    pstmt.setString(2, tra_fecha);
    pstmt.executeUpdate();

    // Obtener el ID de la cabecera de venta recien insertada
    pstmt = conn.prepareStatement("SELECT idtratamientos FROM tratamientos WHERE estado = 'Pendiente'");
    rs = pstmt.executeQuery();
    rs.next();
    int newIdTratamientos = rs.getInt(1);

    // Insertar detalle de ventas
    pstmt = conn.prepareStatement("INSERT INTO detalle_tratamientos (idtratamientos, det_fecha, descripcion) VALUES (?,TO_DATE(?, 'DD-MM-YYYY'),?)");
    pstmt.setInt(1, newIdTratamientos);
    pstmt.setString(2, det_fecha);
    pstmt.setString(3, descripcion);
    pstmt.executeUpdate();
}

        } catch (Exception e) {
            out.println("Error cr: " + e.getMessage());
        }
    } else if ("listar".equals(request.getParameter("listar"))) {
    try {
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Obtener el ID de la cabecera de venta pendiente
        pstmt = conn.prepareStatement("SELECT idtratamientos FROM tratamientos WHERE estado='Pendiente';");
        rs = pstmt.executeQuery();
        rs.next();
        int idtratamientos = rs.getInt(1);

        // Consultar detalle de Venta
        pstmt = conn.prepareStatement("SELECT id_detalle, det_fecha, descripcion FROM detalle_tratamientos WHERE idtratamientos=?");
        pstmt.setInt(1, idtratamientos);
        rs = pstmt.executeQuery();  
        while (rs.next()) {
%>
<tr>
    <td><i class="fa fa-trash" style="font-size:30px;color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i></td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3)%></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }

    } else if (request.getParameter("listar").equals("listarsuma")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        // Obtener el ID de la cabecera de venta pendiente
        rs = st.executeQuery("SELECT idtratamientos FROM tratamientos WHERE estado='Pendiente';");

        int totalSuma = 0;

        while (rs.next()) {
            int id_venta = rs.getInt(1);

            // Consultar detalle de Venta para cada venta pendiente
            PreparedStatement pstmt = conn.prepareStatement("SELECT descripcion FROM detalle_tratamientos WHERE idtratamientos = ?");
            pstmt.setInt(1, id_venta);
            ResultSet rsDetalle = pstmt.executeQuery();

            int sumador = 0;
            while (rsDetalle.next()) {
                // No parece que tengas cantidad y precio, por lo que se omite esta parte
                // int cantidad = rsDetalle.getInt(1);
                // double precio = rsDetalle.getDouble(2);
                // sumador += cantidad * precio;
            }
            totalSuma += sumador;
        }
        out.println(totalSuma); // Devolver el total de todas las ventas pendientes
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }

}

else if (request.getParameter("listar").equals("elimregventa")) {
    String pk = request.getParameter("pkd");

    try {
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM detalle_tratamientos WHERE id_detalle = ?");
        pstmt.setInt(1, Integer.parseInt(pk));
        pstmt.executeUpdate();

        out.println("<div class='alert alert-danger' role='alert'>Datos eliminados con exito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }

    } else if (request.getParameter("listar").equals("cancelventa")) {

        try {
            Statement st = null;
            ResultSet pk = null;
            st = conn.createStatement();
            pk = st.executeQuery("SELECT idtratamientos FROM ventas WHERE estado='Pendiente';");

            pk.next();
            st.executeUpdate("update tratamientos set estado = 'Cancelado' where idtratamientos =" + pk.getString(1) + "");

        } catch (SQLException e) {
            out.println("Error PSQL: " + e);
        }
    }else if ("finalventa".equals(listar)) {
        // Finalizar venta y actualizar el total
        try {
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            pstmt = conn.prepareStatement("SELECT idtratamientos FROM tratamientos WHERE estado='Pendiente';");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int idtratamientos = rs.getInt(1);
                
                pstmt = conn.prepareStatement("UPDATE tratamientos SET estado = 'Finalizado' WHERE idtratamientos = ?");
                
                pstmt.setInt(1, idtratamientos);
                pstmt.executeUpdate();
                out.println("<div class='alert alert-success' role='alert'>?Venta finalizada con exito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }  else if (request.getParameter("listar").equals("listarventas")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        rs = st.executeQuery("SELECT v.idtratamientos,TO_CHAR(v.tra_fecha, 'dd-mm-YYYY') fechatratamiento,UPPER(c.cli_nombre) cliente,TO_CHAR(dv.det_fecha, 'dd-mm-YYYY') fecharutina,dv.descripcion FROM tratamientos v INNER JOIN clientes c ON v.idclientes = c.idclientes INNER JOIN detalle_tratamientos dv ON v.idtratamientos = dv.idtratamientos  WHERE v.estado = 'Finalizado' ORDER BY 1 DESC;");

        while (rs.next()) {

%>
<tr>
    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><%out.print(rs.getString(5));%></td>
    <td><i class="fa fa-trash" style="font-size:30px;color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i></td>
</tr>
<%

            }
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("anularventa")) {
        
        try {
            Statement st = null;
            ResultSet pk = null;
            st = conn.createStatement();
            
            st.executeUpdate("update tratamientos set estado = 'Anulado' where idtratamientos =" + request.getParameter("idpkventa") + "");

        } catch (SQLException e) {
            out.println("Error PSQL: " + e);
        }
    }

%>