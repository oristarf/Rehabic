                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
<%@ include file="conexion.jsp" %>

<%    if (request.getParameter("listar").equals("cargar")) {
        // Datos para la cabecera y detalle
        String codcliente = request.getParameter("codcliente");
        String fecharegistro = request.getParameter("fecharegistro");
        String idejercicio = request.getParameter("idejercicio");
        String fecha_detalle = request.getParameter("fecha_detalle");
        String series = request.getParameter("series");
        String repeticiones = request.getParameter("repeticiones");
        String peso = request.getParameter("peso");
        String minutos = request.getParameter("minutos");
        String codusuario = request.getParameter("codusuario");
        // Validaciones para campos obligatorios
    if (codcliente == null || codcliente.trim().isEmpty()) {
        out.println("<div class='alert alert-danger'>Error: El cliente es obligatorio.</div>");
        return;
    }
    if (fecharegistro == null || fecharegistro.trim().isEmpty()) {
        out.println("<div class='alert alert-danger'>Error: La fecha de registro es obligatoria.</div>");
        return;
    }
    if (idejercicio == null || idejercicio.trim().isEmpty()) {
        out.println("<div class='alert alert-danger'>Error: El ejercicio es obligatorio.</div>");
        return;
    }
    if (fecha_detalle == null || fecha_detalle.trim().isEmpty()) {
        out.println("<div class='alert alert-danger'>Error: La fecha del detalle es obligatoria.</div>");
        return;
    }
    if (series == null || series.trim().isEmpty()) {
        series = "0"; // Valor predeterminado si no se ingresa
    }
    if (repeticiones == null || repeticiones.trim().isEmpty()) {
        repeticiones = "0"; // Valor predeterminado si no se ingresa
    }
    if (peso == null || peso.trim().isEmpty()) {
        peso = "0"; // Valor predeterminado si no se ingresa
    }
    if (minutos == null || minutos.trim().isEmpty()) {
        minutos = "0"; // Valor predeterminado si no se ingresa
    }
        try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet idcab = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT idcab_rutina FROM cab_rutinas WHERE estado='Pendiente';");
            if (rs.next()) {
                // Insertar detalle en la cabecera existente
                st.executeUpdate("INSERT INTO det_rutinas (idcab_rutina, idejercicio, fecha, series, repeticiones, peso, minutos) "
                        + "VALUES (" + rs.getString(1) + ", " + idejercicio + ", '" + fecha_detalle + "', "
                        + series + ", "
                        + repeticiones + ", "
                        + peso + ", "
                        + minutos + ")");

            } else {
                // Crear nueva cabecera y luego agregar el detalle
                st.executeUpdate("INSERT INTO cab_rutinas (idcliente, fecha, idusuario) "
                        + "VALUES ('" + codcliente + "', '" + fecharegistro + "', '" + codusuario + "')");
                idcab = st.executeQuery("SELECT idcab_rutina FROM cab_rutinas WHERE estado='Pendiente';");
                idcab.next();
                st.executeUpdate("INSERT INTO det_rutinas (idcab_rutina, idejercicio, fecha, series, repeticiones, peso, minutos) "
                        + "VALUES (" + idcab.getString(1) + ", " + idejercicio + ", '" + fecha_detalle + "', "
                        + series + ", "
                        + repeticiones + ", "
                        + peso + ", "
                        + minutos + ")");

            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    } // Listar detalles de rutinas
    else if (request.getParameter("listar").equals("listar")) {

        try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet idcab = null;
            st = conn.createStatement();
            idcab = st.executeQuery("SELECT idcab_rutina FROM cab_rutinas WHERE estado='Pendiente';");
            idcab.next();
            rs = st.executeQuery(
                    "SELECT dr.iddet_rutina, e.eje_nombre, dr.fecha, dr.series, dr.repeticiones, dr.peso, dr.minutos "
                    + "FROM det_rutinas dr ,"
                    + "ejercicios e where dr.idejercicio = e.idejercicio "
                    + "and dr.idcab_rutina = '" + idcab.getString(1) + "';"
            );
            while (rs.next()) {
%>
<tr>
    <td>
        <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val('<%= rs.getString(1)%>')"></i>
    </td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3)%></td>
    <td><%= rs.getString(4)%></td>
    <td><%= rs.getString(5)%></td>
    <td><%= rs.getString(6)%></td>
    <td><%= rs.getString(7)%></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='6'>Error PSQL: " + e.getMessage() + "</td></tr>");
    }
} // Eliminar detalle de rutina
else if (request.getParameter("listar").equals("elimregrutina")) {
    String pk = request.getParameter("pkd");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM det_rutinas WHERE iddet_rutina = " + pk);
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
} // Cancelar rutina pendiente
else if (request.getParameter("listar").equals("cancelrutina")) {
    try {
        Statement st = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("SELECT idcab_rutina FROM cab_rutinas WHERE estado='Pendiente';");
        idcab.next();
        st.executeUpdate("UPDATE cab_rutinas SET estado='Cancelado' WHERE idcab_rutina = " + idcab.getString(1));
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
} // Finalizar rutina pendiente
else if (request.getParameter("listar").equals("finalrutina")) {
    try {
        Statement st = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("SELECT idcab_rutina FROM cab_rutinas WHERE estado='Pendiente';");
        if (idcab.next()) {
            st.executeUpdate("UPDATE cab_rutinas SET estado='Finalizado' WHERE idcab_rutina = " + idcab.getString(1));
        } else {
            out.println("Error: No se encontró una cabecera pendiente.");
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("listarrutinas")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        // Consulta para listar las rutinas finalizadas
        rs = st.executeQuery("SELECT r.idcab_rutina, to_char(r.fecha, 'DD-MM-YYYY'), "
                + "c.cli_nombres || ' ' || c.cli_apellidos AS Paciente, "
                + "u.usuario AS Fisioterapeuta "
                + "FROM cab_rutinas r "
                + "JOIN clientes c ON r.idcliente = c.idcliente "
                + "JOIN usuarios u ON r.idusuario = u.idusuarios "
                + "WHERE r.estado = 'Finalizado'");

        while (rs.next()) {
%>
<tr>
    <td><%out.print(rs.getString(1));%></td> <!-- ID de la rutina -->
    <td><%out.print(rs.getString(2));%></td> <!-- Fecha -->
    <td><%out.print(rs.getString(3));%></td> <!-- Cliente -->
    <td><%out.print(rs.getString(4));%></td> <!-- Estado -->
    <td>
        <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" 
           onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i>
        <a href="Reporte_Rutinas.jsp?idcab_rutina=<%= rs.getString(1)%>" target="_blank" class="btn btn-info btn-sm">
            <i class="fas fa-file-pdf"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("anularrutinas")) {
        try {
            Statement st = null;

            st = conn.createStatement();

            // Consulta para anular una rutina por ID
            st.executeUpdate("UPDATE cab_rutinas SET estado='Anulado' WHERE idcab_rutina=" + request.getParameter("idpkrutina") + "");
            // Opcional: Puedes incluir un mensaje de confirmación para el usuario
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    }


%>
