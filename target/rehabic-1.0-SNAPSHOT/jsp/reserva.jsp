<%-- 
    Document   : reserva
    Created on : 25 jun. 2024, 19:52:01
    Author     : david
--%>

<%@include file="conexion.jsp"%>
<% 
if (request.getParameter("listar").equals("cargar")) {

    // Parámetros de la solicitud
    String idpersona = request.getParameter("idpersona");
      String idusuario = request.getParameter("idusuario");
    String fechareserva = request.getParameter("fechareserva");
    String idlibro = request.getParameter("idlibro");
    String cantidad_reserva = request.getParameter("cantidad_reserva");
    String fechafinreserva = request.getParameter("fechafinreserva");

    
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        st = conn.createStatement();

        // Verificar si hay reservas pendientes
        rs = st.executeQuery("SELECT idreserva FROM reservas WHERE estado='Pendiente';");
        if (rs.next()) {
            // Si existe una cabecera pendiente, agregar detalle de reserva
            st.executeUpdate("INSERT INTO detalle_reserva_de_libros (idreserva, idlibro, cantidad_reserva,fechafinreserva) VALUES ('" + rs.getString(1) + "','" + idlibro + "','" + cantidad_reserva + "','" + fechafinreserva + "')");
        } else {
            // Si no existe una cabecera pendiente, crear una nueva reserva y agregar detalle
            st.executeUpdate("INSERT INTO reservas (idpersona, idusuario, fechareserva) VALUES ('" + idpersona + "','" + idusuario + "','" + fechareserva + "')");
            pk = st.executeQuery("SELECT idreserva FROM reservas WHERE estado='Pendiente';");
            pk.next();
            st.executeUpdate("INSERT INTO detalle_reserva_de_libros (idreserva, idlibro, cantidad_reserva,fechafinreserva) VALUES ('" + pk.getString(1) + "','" + idlibro + "','" + cantidad_reserva + "','" + fechafinreserva + "')");
        }

    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} 
// Para listar el detalle
 else if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        st = conn.createStatement();
       //si ahi un estado pendiente que lo seleccione 
        pk = st.executeQuery("SELECT idreserva FROM reservas WHERE estado='Pendiente';");
        pk.next();
        
        rs = st.executeQuery("SELECT dtr.iddetallereserva, l.titulo_libro, dtr.cantidad_reserva, dtr.fechafinreserva FROM detalle_reserva_de_libros dtr, libros l WHERE dtr.idlibro=l.idlibro AND dtr.idreserva='" + pk.getString(1) + "'");
   // sin el while no funciona no toque     
        while (rs.next()) {
            
            
%>
<tr>
    <td><% out.print(rs.getString(1)); %></td>
    <td><% out.print(rs.getString(2)); %></td>
    <td><% out.print(rs.getString(3)); %></td>
    <td><% out.print(rs.getString(4)); %></td>
    <td><i class="bi bi-trash" data-toggle="modal" data-target="#basicModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i>
    </td>
</tr>
<%   }
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("elimregreserva")) {

    String pk = request.getParameter("pkd");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM detalle_reserva_de_libros WHERE iddetallereserva=" + pk);
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("cancelreserva")) {

    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idreserva FROM reservas WHERE estado='Pendiente';");
        pk.next();
        st.executeUpdate("UPDATE reservas SET estado='Cancelado' WHERE idreserva=" + pk.getString(1));
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("finalreserva")) {

    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idreserva FROM reservas WHERE estado='Pendiente';");
        pk.next();
        st.executeUpdate("UPDATE reservas SET estado='Finalizado' WHERE idreserva=" + pk.getString(1));
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
}else if (request.getParameter("listar").equals("listarre")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        
        st = conn.createStatement();
       //si ahi un estado pendiente que lo seleccione 
        
        
        rs = st.executeQuery("SELECT r.idreserva, TO_CHAR(r.fechareserva,'dd-mm-YYYY'), p.nombre_persona, r.estado FROM reservas r, personas p WHERE r.idpersona = p.idpersona AND r.estado='Finalizado'");
   // sin el while no funciona no toque     
        while (rs.next()) {
            
            
%>
<tr>

    <td><% out.print(rs.getString(1)); %></td>
    <td><% out.print(rs.getString(2)); %></td>
    <td><% out.print(rs.getString(3)); %></td>
    <td><% out.print(rs.getString(4)); %></td>
    <td><i class="bi bi-trash" data-toggle="modal" data-target="#basicModal" onclick="$('#pkanul').val(<% out.print(rs.getString(1)); %>)"></i>
    <a target="blank_" href="datoreserva.jsp?cab=<%= rs.getString("idreserva") %>" >
            <i class="bi bi-eye icono-negro"></i>
        </a> </td>
</tr>
<%

        }
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("anularreserva")) {
    
    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        st.executeUpdate("UPDATE reservas SET estado='Anulado' WHERE idreserva=" + request.getParameter("idpkreserva"));
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
}
%>