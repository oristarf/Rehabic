                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               <%@ include file="conexion.jsp" %>

<%//el campo cargar sirve para saber lo que estoy recibiendo cuando se envie el formulario, se encuentra en rutinas.jsp <input type="hidden" id="listar" name="listar" value="cargar"/>, se envia el formulario id=form cuando le demos click en <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary">Agregar</button>    
  if (request.getParameter("listar").equals("cargar")) {
    /* DATOS PARA LA CABECERA */
    String codcliente = request.getParameter("codcliente"); // ID del cliente
    String fecharegistro = request.getParameter("fecharegistro"); // Fecha de registro
    String codservicio = request.getParameter("codservicio"); // ID del servicio
    String precio = request.getParameter("precio"); // Precio del servicio
    String cantidad = request.getParameter("cantidad"); // Cantidad del servicio
    String codusuario = request.getParameter("codusuario"); // Usuario que registra

    try (Statement st = conn.createStatement()) {
        ResultSet idcab = st.executeQuery("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente';");

        if (!idcab.next()) {
            // Crear nueva cabecera si no existe
            st.executeUpdate("INSERT INTO cab_pago (idcliente, fecha, idusuario) VALUES ('" + codcliente + "', '" + fecharegistro + "', '" + codusuario + "')");
            idcab = st.executeQuery("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente';");
            idcab.next();
        }

        // Obtener el tipo del servicio que se intenta agregar
        String tipoServicio = null;
        ResultSet rsTipo = st.executeQuery("SELECT ser_tipo FROM servicios WHERE idservicio = " + codservicio);
        if (rsTipo.next()) {
            tipoServicio = rsTipo.getString("ser_tipo");
        }

        // Verificar si ya hay un servicio mensual en la cabecera
        ResultSet rsMensual = st.executeQuery("SELECT COUNT(*) FROM det_pago dp INNER JOIN servicios s ON dp.idservicio = s.idservicio WHERE dp.idcab_pago = " + idcab.getString(1) + " AND s.ser_tipo = 'Mensual';");
        rsMensual.next();

        if ("Mensual".equals(tipoServicio) && rsMensual.getInt(1) > 0) {
            // Bloquear si ya existe un servicio mensual y se intenta agregar otro mensual
            out.println("<div class='alert alert-danger'>Solo se permite un servicio mensual por pago. Elimine el existente para agregar otro.</div>");
        } else {
            // Calcular la fecha de vencimiento si el servicio es mensual
            String fechaVencimiento = null;
            if ("Mensual".equals(tipoServicio)) {
                try (PreparedStatement pstmtFecha = conn.prepareStatement(
                        "SELECT TO_CHAR(DATE(?::DATE + (? * INTERVAL '1 month')), 'YYYY-MM-DD') AS fecha_vencimiento")) {
                    pstmtFecha.setString(1, fecharegistro); // Fecha base
                    pstmtFecha.setInt(2, Integer.parseInt(cantidad)); // Intervalo mensual basado en cantidad
                    ResultSet rsFecha = pstmtFecha.executeQuery();
                    if (rsFecha.next()) {
                        fechaVencimiento = rsFecha.getString("fecha_vencimiento");
                    }
                }

                // Actualizar la fecha de vencimiento en la cabecera
                st.executeUpdate("UPDATE cab_pago SET fecha_vencimiento = '" + fechaVencimiento + "' WHERE idcab_pago = " + idcab.getString(1));
            }

            // Insertar el detalle
            st.executeUpdate("INSERT INTO det_pago (idcab_pago, idservicio, det_precio, det_cantidad) VALUES (" +
                    idcab.getString(1) + ", " + codservicio + ", " + precio + ", " + cantidad + ")");
            out.println("<div class='alert alert-success'>Servicio agregado correctamente.</div>");
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error PSQL: " + e + "</div>");
    }
}

 else if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet idcab = null;
            st = conn.createStatement();
            idcab = st.executeQuery("select idcab_pago from cab_pago where estado='Pendiente';");
            idcab.next();
            rs = st.executeQuery("select dt.iddet_pago, s.ser_nombre, dt.det_precio, dt.det_cantidad from det_pago dt, servicios s where dt.idservicio=s.idservicio and dt.idcab_pago='" + idcab.getString(1) + "'");

            while (rs.next()) {
                String precio = rs.getString(3);
                String cantidad = rs.getString(4);
                Integer precio1 = Integer.parseInt(precio);
                Integer cantidad1 = Integer.parseInt(cantidad);
                int calcular = precio1 * cantidad1;
%>
<tr>
    <td>  
        <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i> <!-- eliminar el id del detalle gregado con el icono trash-->
    </td>

    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><%out.print(calcular);%></td>
</tr>
<%    }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("listarsuma")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("SELECT idcab_pago FROM cab_pago where estado='Pendiente';");
        idcab.next();
        rs = st.executeQuery("select dt.iddet_pago,s.ser_nombre, dt.det_precio, dt.det_cantidad from det_pago dt, servicios s where dt.idservicio=s.idservicio and dt.idcab_pago='" + idcab.getString(1) + "'");
        int sumador = 0;
        while (rs.next()) {
            String precio = rs.getString(3);
            String cantidad = rs.getString(4);
            Integer precio1 = Integer.parseInt(precio);
            Integer cantidad1 = Integer.parseInt(cantidad);
            int calcular = precio1 * cantidad1;
            sumador += calcular;
        }
        out.println(sumador);
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("elimregpago")) {
    String pk = request.getParameter("pkd"); // ID del detalle a eliminar

    try {
        Statement st = conn.createStatement();

        // Obtener la cabecera asociada al detalle
        ResultSet rsCab = st.executeQuery("SELECT idcab_pago, idservicio FROM det_pago WHERE iddet_pago = " + pk);
        if (rsCab.next()) {
            String idcab = rsCab.getString("idcab_pago");
            String idservicio = rsCab.getString("idservicio");

            // Eliminar el detalle
            st.executeUpdate("DELETE FROM det_pago WHERE iddet_pago = " + pk);

            // Verificar si el detalle eliminado es un servicio mensual
            ResultSet rsTipo = st.executeQuery("SELECT ser_tipo FROM servicios WHERE idservicio = " + idservicio);
            if (rsTipo.next() && "Mensual".equals(rsTipo.getString("ser_tipo"))) {
                // Eliminar la fecha de vencimiento si no hay m�s servicios mensuales
                ResultSet rsMensual = st.executeQuery("SELECT COUNT(*) FROM det_pago dp INNER JOIN servicios s ON dp.idservicio = s.idservicio WHERE dp.idcab_pago = " + idcab + " AND s.ser_tipo = 'Mensual';");
                rsMensual.next();
                if (rsMensual.getInt(1) == 0) {
                    st.executeUpdate("UPDATE cab_pago SET fecha_vencimiento = NULL WHERE idcab_pago = " + idcab);
                }
            }
        }

        out.println("<div class='alert alert-success'>Detalle eliminado correctamente.</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error PSQL: " + e + "</div>");
    }
} else if (request.getParameter("listar").equals("cancelpago")) {

    try {
        //no definimos ningun string ni int antes porque no recibimos ningun parametro en ninguna variable
        Statement st = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("SELECT idcab_pago FROM cab_pago where estado='Pendiente';");
        idcab.next();
        st.executeUpdate("update cab_pago set estado='Cancelado' where idcab_pago=" + idcab.getString(1) + ""); //sub 1 porque sobamente estoy seleccionando el id de la cabecera
        //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
}else if (request.getParameter("listar").equals("finalpago")) {
    try {
        Statement st = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("SELECT idcab_pago FROM cab_pago where estado='Pendiente';");
        if (idcab.next()) {  // Validar si hay resultados
            String totalStr = request.getParameter("total");
            try {
                double total = Double.parseDouble(totalStr); // Asegura que sea un n�mero v�lido
                st.executeUpdate("UPDATE cab_pago SET estado='Finalizado', total=" + total + " WHERE idcab_pago=" + idcab.getString(1));
            } catch (NumberFormatException e) {
                out.println("Error: Total no es un n�mero v�lido.");
            }
        } else {
            out.println("Error: No se encontr� una cabecera pendiente.");
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("listarpagos")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        rs = st.executeQuery("SELECT p.idcab_pago, to_char(p.fecha, 'DD-MM-YYYY'), c.cli_nombres ||' '|| c.cli_apellidos as Paciente, p.total FROM cab_pago p, clientes c where p.idcliente = c.idcliente and p.estado='Finalizado' order by idcab_pago asc");

        while (rs.next()) {

%>
<tr>

    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i>
    <a href="Reporte_Pagos.jsp?idcab_pago=<%= rs.getString(1) %>" target="_blank" class="btn btn-info btn-sm">
            <i class="fas fa-file-pdf"></i>
        </a></td>
    
    
</tr>
<%

        }
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("anularpagos")) {

    try {
        Statement st = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        st.executeUpdate("update cab_pago set estado='Anulado' where idcab_pago=" + request.getParameter("idpkpago") + "");
        //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("listarVencimientos")) {
    String idUsuario = request.getParameter("idusuario"); // ID del usuario actual

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        // Buscar pagos pr�ximos a vencer y vencidos para el usuario actual
        rs = st.executeQuery(
                "SELECT c.cli_nombres || ' ' || c.cli_apellidos AS cliente, " +
                "p.fecha_vencimiento, " +
                "CASE " +
                "WHEN p.fecha_vencimiento < CURRENT_DATE THEN 'Vencido' " +
                "WHEN p.fecha_vencimiento BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '5 days' THEN 'Pr�ximo a vencer' " +
                "END AS estado " +
                "FROM cab_pago p " +
                "INNER JOIN clientes c ON p.idcliente = c.idcliente " +
                "WHERE p.estado = 'Finalizado' " +
                "AND p.fecha_vencimiento IS NOT NULL " +
                "AND (p.fecha_vencimiento < CURRENT_DATE OR p.fecha_vencimiento BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '5 days') " +
                "AND p.idusuario = " + idUsuario // Filtrar por el usuario actual
        );

        // Generar la salida de la tabla
        while (rs.next()) {
%>
<tr>
    <td><%out.print(rs.getString("cliente"));%></td>
    <td><%out.print(rs.getString("fecha_vencimiento"));%></td>
    <td><%out.print(rs.getString("estado"));%></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
}
else if (request.getParameter("listar").equals("notificacionesVencimientos")) {
    String idUsuario = request.getParameter("idusuario"); // ID del usuario actual

    try {
        Statement st = conn.createStatement();

        // Pr�ximos vencimientos para el usuario actual
        ResultSet rsProximos = st.executeQuery(
            "SELECT COUNT(*) AS proximos " +
            "FROM cab_pago " +
            "WHERE estado = 'Finalizado' " +
            "AND fecha_vencimiento >= CURRENT_DATE " +
            "AND fecha_vencimiento <= CURRENT_DATE + INTERVAL '5 days' " +
            "AND idusuario = " + idUsuario);
        int proximos = 0;
        if (rsProximos.next()) {
            proximos = rsProximos.getInt("proximos");
        }

        // Vencimientos vencidos para el usuario actual
        ResultSet rsVencidos = st.executeQuery(
            "SELECT COUNT(*) AS vencidos " +
            "FROM cab_pago " +
            "WHERE estado = 'Finalizado' " +
            "AND fecha_vencimiento < CURRENT_DATE " +
            "AND idusuario = " + idUsuario);
        int vencidos = 0;
        if (rsVencidos.next()) {
            vencidos = rsVencidos.getInt("vencidos");
        }

        // Enviar respuesta al frontend
        out.print(proximos + "|" + vencidos);

    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
}


%>