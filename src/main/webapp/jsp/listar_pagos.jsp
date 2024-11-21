<%@ include file="conexion.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%   
    HttpSession sesion = request.getSession();
    
    String listar = request.getParameter("listar");
    if ("cargar".equals(listar)) {
        /* DATOS PARA LA CABECERA */
        String codcliente = request.getParameter("id_cliente");
        String fecharegistro = request.getParameter("fecharegistro");
        
        try {
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            // Verificar si existe una cabecera de pago pendiente
            pstmt = conn.prepareStatement("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente' AND idcliente = ?");
            pstmt.setInt(1, Integer.parseInt(codcliente));
            rs = pstmt.executeQuery();
            if (!rs.next()) {
                // Insertar cabecera de pago
                pstmt = conn.prepareStatement("INSERT INTO cab_pago (idcliente, fecha, estado, idusuario, total) VALUES (?, TO_DATE(?, 'YYYY-MM-DD'), 'Pendiente', ?, 0)");
                pstmt.setInt(1, Integer.parseInt(codcliente));
                pstmt.setString(2, fecharegistro);
                pstmt.setInt(3, (Integer) sesion.getAttribute("idusuarios"));
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            out.println("Error al cargar la cabecera: " + e.getMessage());
        }
    } else if ("listar".equals(request.getParameter("listar"))) {
        try {
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            // Obtener el ID de la cabecera de pago pendiente
            pstmt = conn.prepareStatement("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente'");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int idcab_pago = rs.getInt(1);

                // Consultar detalle del Pago
                pstmt = conn.prepareStatement("SELECT dp.iddet_pago, upper(s.ser_nombre), dp.det_cantidad, dp.precio FROM det_pago dp, servicio s WHERE dp.idservicio=s.idservicio AND dp.idcab_pago=?");
                pstmt.setInt(1, idcab_pago);
                rs = pstmt.executeQuery();  
                while (rs.next()) {
                    String cantidad = rs.getString(3);
                    String precio = rs.getString(4);

                    // Validar que cantidad y precio no estén vacíos antes de convertir
                    if (!cantidad.isEmpty() && !precio.isEmpty()) {
                        int cantidadInt = Integer.parseInt(cantidad.trim());
                        double precioDouble = Double.parseDouble(precio.trim());
                        double calcular = cantidadInt * precioDouble;
%>
<tr>
    <td><i class="fa fa-trash" style="font-size:30px;color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i></td>
    <td><%= rs.getString(2)%></td>
    <td><%= cantidadInt%></td>
    <td><%= precioDouble%></td>
    <td><%= calcular%></td>
</tr>
<%
                    }
                }
            }
        } catch (Exception e) {
            out.println("Error al listar el detalle: " + e.getMessage());
        }
    } else if ("listarsuma".equals(request.getParameter("listar"))) {
        try {
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            // Obtener el ID de la cabecera de pago pendiente
            pstmt = conn.prepareStatement("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente'");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int idcab_pago = rs.getInt(1);

                // Consultar detalle del Pago para calcular la suma total
                pstmt = conn.prepareStatement("SELECT dp.det_cantidad, dp.precio FROM det_pago dp WHERE dp.idcab_pago = ?");
                pstmt.setInt(1, idcab_pago);
                rs = pstmt.executeQuery();

                double total = 0;
                while (rs.next()) {
                    int cantidad = rs.getInt(1);
                    double precio = rs.getDouble(2);
                    total += cantidad * precio;
                }
                out.println(total);
            }
        } catch (Exception e) {
            out.println("Error al listar la suma: " + e.getMessage());
        }
    } else if ("cancelar_pago".equals(request.getParameter("listar"))) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("UPDATE cab_pago SET estado='Cancelado' WHERE estado='Pendiente'");
            pstmt.executeUpdate();
            out.println("<div class='alert alert-danger'>Pago cancelado con éxito.</div>");
        } catch (Exception e) {
            out.println("Error al cancelar el pago: " + e.getMessage());
        }
    } else if ("final_pago".equals(request.getParameter("listar"))) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("UPDATE cab_pago SET estado='Finalizado' WHERE estado='Pendiente'");
            pstmt.executeUpdate();
            out.println("<div class='alert alert-success'>Pago registrado con éxito.</div>");
        } catch (Exception e) {
            out.println("Error al finalizar el pago: " + e.getMessage());
        }
    }
%>
