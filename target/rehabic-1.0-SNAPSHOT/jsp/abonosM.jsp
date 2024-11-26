<%@ include file="conexion.jsp" %>
<%
    String action = request.getParameter("action");

    if ("loadPago".equals(action)) {
        String idCabPago = request.getParameter("idcab_pago");
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT saldo_pendiente FROM cab_pago WHERE idcab_pago = " + idCabPago);
            if (rs.next()) {
                out.print("{\"saldo_pendiente\": \"" + rs.getInt("saldo_pendiente") + "\"}");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else if ("registrarAbono".equals(action)) {
        String idCabPago = request.getParameter("idcab_pago");
        String abMonto = request.getParameter("ab_monto");
        String abMetodo = request.getParameter("ab_metodo");
        try {
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO abono (idcab_pago, ab_monto, ab_metodo) VALUES (" + idCabPago + ", " + abMonto + ", '" + abMetodo + "')");
            st.executeUpdate("UPDATE cab_pago SET saldo_pendiente = saldo_pendiente - " + abMonto + ", total_abonado = total_abonado + " + abMonto + " WHERE idcab_pago = " + idCabPago);
            ResultSet rs = st.executeQuery("SELECT saldo_pendiente FROM cab_pago WHERE idcab_pago = " + idCabPago);
            if (rs.next() && rs.getInt("saldo_pendiente") == 0) {
                st.executeUpdate("UPDATE cab_pago SET estado = 'Cancelado' WHERE idcab_pago = " + idCabPago);
            }
            out.println("Abono registrado con éxito.");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else if ("loadAbonos".equals(action)) {
        String idCabPago = request.getParameter("idcab_pago");
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT to_char(fecha_abono, 'DD-MM-YYYY'), ab_monto, ab_metodo FROM abono WHERE idcab_pago = " + idCabPago);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getInt(2) %></td>
    <td><%= rs.getString(3) %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>
