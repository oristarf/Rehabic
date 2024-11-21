<%@ include file="conexion.jsp" %>

<%
    String listar = request.getParameter("listar");
    HttpSession sesion = request.getSession();

    try {
        if ("buscar_cliente".equals(listar)) {
            String query = request.getParameter("query");
            if (query != null && !query.trim().isEmpty()) {
                try {
                    Statement st = conn.createStatement();
                    String sql = "SELECT idcliente, cli_nombres, cli_apellidos, cli_cedula FROM clientes " +
                                 "WHERE cli_nombres ILIKE '%" + query + "%' OR cli_apellidos ILIKE '%" + query + "%' " +
                                 "ORDER BY cli_nombres";
                    ResultSet rs = st.executeQuery(sql);

                    if (!rs.isBeforeFirst()) {
                        out.print("<div class='alert alert-warning'>No se encontraron clientes que coincidan con la búsqueda.</div>");
                    } else {
                        while (rs.next()) {
%>
                            <a href="#" class="list-group-item list-group-item-action cliente-item" 
                               data-id="<%= rs.getInt("idcliente") %>" 
                               data-ci="<%= rs.getString("cli_cedula") %>">
                                <%= rs.getString("cli_nombres") %> <%= rs.getString("cli_apellidos") %>
                            </a>
<%
                        }
                    }
                    rs.close();
                    st.close();
                } catch (Exception e) {
                    out.print("<div class='alert alert-danger'>Error en la búsqueda de clientes: " + e.getMessage() + "</div>");
                }
            } else {
                out.print("<div class='alert alert-warning'>El campo de búsqueda está vacío.</div>");
            }

        } else if ("buscar_servicio".equals(listar)) {
            String query = request.getParameter("query");
            if (query != null && !query.trim().isEmpty()) {
                try {
                    Statement st = conn.createStatement();
                    String sql = "SELECT idservicio, ser_nombre AS nombre, ser_precio AS precio FROM servicios WHERE ser_nombre ILIKE '%" + query + "%' ORDER BY ser_nombre";
                    ResultSet rs = st.executeQuery(sql);

                    if (!rs.isBeforeFirst()) {
                        out.print("<div class='alert alert-warning'>No se encontraron servicios que coincidan con la búsqueda.</div>");
                    } else {
                        while (rs.next()) {
%>
                            <a href="#" class="list-group-item list-group-item-action servicio-item" 
                               data-id="<%= rs.getInt("idservicio") %>" 
                               data-precio="<%= rs.getDouble("precio") %>">
                                <%= rs.getString("nombre") %> - Gs <%= rs.getDouble("precio") %>
                            </a>
<%
                        }
                    }
                    rs.close();
                    st.close();
                } catch (Exception e) {
                    out.print("<div class='alert alert-danger'>Error en la búsqueda de servicios: " + e.getMessage() + "</div>");
                }
            } else {
                out.print("<div class='alert alert-warning'>El campo de búsqueda de servicio está vacío.</div>");
            }

        } else if ("agregar_detalle".equals(listar)) {
            String servicioId = request.getParameter("servicio_id");
            String precio = request.getParameter("precio");
            String cantidad = request.getParameter("cantidad");
            String usuarioIdStr = String.valueOf(sesion.getAttribute("idusuarios"));
            String clienteIdStr = request.getParameter("id_cliente");

            Integer usuarioId = null;
            Integer clienteId = null;
            try {
                usuarioId = Integer.parseInt(usuarioIdStr);
                clienteId = Integer.parseInt(clienteIdStr);
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"Error al convertir usuarioId o clienteId a Integer.\"}");
                return;
            }

            if (servicioId == null || precio == null || cantidad == null || usuarioId == null || clienteId == null) {
                out.print("{\"success\": false, \"message\": \"Debe completar todos los campos del detalle.\"}");
            } else {
                try {
                    Statement st = conn.createStatement();
                    int cabeceraId;
                    ResultSet rs = st.executeQuery("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente' AND idusuario=" + usuarioId + " AND idcliente=" + clienteId);

                    if (rs.next()) {
                        cabeceraId = rs.getInt("idcab_pago");
                    } else {
                        // Si no existe, crea una nueva cabecera
                        String queryCabecera = "INSERT INTO cab_pago (idcliente, fecha, estado, idusuario, total, saldo_pendiente) VALUES (" + clienteId + ", CURRENT_DATE, 'Pendiente', " + usuarioId + ", 0, 0) RETURNING idcab_pago";
                        ResultSet cabeceraRs = st.executeQuery(queryCabecera);
                        cabeceraRs.next();
                        cabeceraId = cabeceraRs.getInt("idcab_pago");
                        cabeceraRs.close();
                    }

                    int cantidadInt = Integer.parseInt(cantidad);
                    double precioDouble = Double.parseDouble(precio);
                    double totalDetalle = cantidadInt * precioDouble;

                    String queryDetalle = "INSERT INTO det_pago (idcab_pago, idservicio, det_precio, det_cantidad, det_total) VALUES (" + cabeceraId + ", " + servicioId + ", " + precioDouble + ", " + cantidadInt + ", " + totalDetalle + ")";
                    st.executeUpdate(queryDetalle);

                    String updateTotal = "UPDATE cab_pago SET total = total + " + totalDetalle + ", saldo_pendiente = saldo_pendiente + " + totalDetalle + " WHERE idcab_pago = " + cabeceraId;
                    st.executeUpdate(updateTotal);

                    String html = "<tr><td><i class='fa fa-trash' style='font-size:30px;color:red'></i></td><td>Servicio ID " + servicioId + "</td><td>" + cantidadInt + "</td><td>Gs " + precioDouble + "</td><td>Gs " + totalDetalle + "</td></tr>";
                    out.print("{\"success\": true, \"idCabecera\": " + cabeceraId + ", \"html\": \"" + html + "\"}");

                    rs.close();
                    st.close();
                } catch (Exception e) {
                    out.print("{\"success\": false, \"message\": \"Error al agregar detalle: " + e.getMessage() + "\"}");
                }
            }

        } else if ("finalpago".equals(listar)) { // Aquí insertamos la lógica del profesor
            // Lógica para finalizar el pago
            try {
                Statement st = conn.createStatement();
                ResultSet pk = st.executeQuery("SELECT idcab_pago FROM cab_pago WHERE estado='Pendiente';"); 
                
                if (pk.next()) {
                    // Actualiza el estado y total de la cabecera a 'Finalizado'
                    String cabeceraId = pk.getString("idcab_pago");
                    String total = request.getParameter("total");
                    st.executeUpdate("UPDATE cab_pago SET estado='Finalizado', total=" + total + " WHERE idcab_pago=" + cabeceraId);
                    out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito.</div>");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>No se encontró ninguna cabecera en estado 'Pendiente'.</div>");
                }
                
                pk.close();
                st.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error en la base de datos: " + e + "</div>");
            }

        } else if ("listarsuma".equals(listar)) { // Este bloque ya estaba en tu código original
            try {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT SUM(det_total) FROM det_pago dp JOIN cab_pago cp ON dp.idcab_pago = cp.idcab_pago WHERE cp.estado = 'Pendiente'");
                if (rs.next()) {
                    double totalSuma = rs.getDouble(1);
                    out.print(totalSuma);
                } else {
                    out.print("0.00");
                }
                rs.close();
                st.close();
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error al calcular la suma total: " + e.getMessage() + "</div>");
            }

        } else if ("cancelar_pago".equals(listar)) {
    try {
        String usuarioId = String.valueOf(sesion.getAttribute("idusuarios"));
        Statement st = conn.createStatement();
        String updateCancel = "UPDATE cab_pago SET estado = 'Cancelado' WHERE estado = 'Pendiente' AND idusuario = " + usuarioId;
        st.executeUpdate(updateCancel);
        out.print("<div class='alert alert-info'>Pago cancelado exitosamente.</div>");
        st.close();
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al cancelar el pago: " + e.getMessage() + "</div>");
    }
} else if ("listar_pagos".equals(listar)) { // Bloque actualizado para listar pagos
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT cp.idcab_pago, CONCAT(c.cli_nombres, ' ', c.cli_apellidos) AS cliente, " +
            "TO_CHAR(cp.fecha, 'DD-MM-YYYY') AS fecha, cp.total, cp.estado " +
            "FROM cab_pago cp " +
            "JOIN clientes c ON cp.idcliente = c.idcliente " +
            "WHERE cp.estado != 'Cancelado' " +
            "ORDER BY cp.fecha DESC"
        );

        if (!rs.isBeforeFirst()) { // Verificar si el ResultSet está vacío
            out.print("<tr><td colspan='6' class='text-center'>No se encontraron pagos.</td></tr>");
        } else {
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("idcab_pago") %></td>
    <td><%= rs.getString("cliente") %></td>
    <td><%= rs.getString("fecha") %></td>
    <td>Gs <%= rs.getDouble("total") %></td>
    <td><%= rs.getString("estado") %></td>
    <td>
        <!-- Botón para anular el pago -->
        <button class="btn btn-warning anular-pago" data-id="<%= rs.getInt("idcab_pago") %>">
            Anular
        </button>
    </td>
</tr>
<%
            }
        }
        rs.close();
        st.close();
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al listar pagos: " + e.getMessage() + "</div>");
    }
} else {
    out.print("<div class='alert alert-warning'>Acción desconocida en el parámetro 'listar': " + listar + "</div>");
}
} catch (Exception e) {
    out.print("<div class='alert alert-danger'>Error general: " + e.getMessage() + "</div>");
}
%>
