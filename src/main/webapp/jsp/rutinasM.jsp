                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               <%@ include file="conexion.jsp" %>

<%//el campo cargar sirve para saber lo que estoy recibiendo cuando se envie el formulario, se encuentra en rutinas.jsp <input type="hidden" id="listar" name="listar" value="cargar"/>, se envia el formulario id=form cuando le demos click en <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary">Agregar</button>    
if (request.getParameter("listar").equals("cargar")) {
/*DATOS PARA LA CABECERA*/
//idcliente
//fecha


/*DATOS PARA EL DETALLE*/
//idcab_pago
//idservicio
//det_precio
//det_cantidad
    String codcliente = request.getParameter("codcliente"); //codcliente es por el name del input "<input type="hidden" id="codcliente" name="codcliente">" de rutinas.jsp
    String fecharegistro = request.getParameter("fecharegistro");//fecharegistro es por el name del input "<input class="form-control" type="text" name="fecharegistro" id="fecharegistro" ...)> de rutinas.jsp
    String codservicio = request.getParameter("codservicio");//codservicio es por el name del input "<input type="hidden" id="codservicio" name="codservicio">" de rutinas.jsp
    String precio = request.getParameter("precio");//precio es por el name del input "<input type="text" class="form-control" id="precio" name="precio" placeholder="Precio" readonly="readonly" required>" de rutinas.jsp
    String cantidad = request.getParameter("cantidad");//cantidad es por el name del input "<input class="form-control number" value="1" type="text" name="cantidad" id="cantidad"...>" de rutinas.jsp
    String codusuario = request.getParameter("codusuario");
    //out.println(codcliente+','+ fecharegistro+','+ codservicio+','+ precio+','+ cantidad);
    try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet idcab = null; //se agrega la variable pk para consultar cual es el idcab_pago pendiente (el id pendiente)
            st= conn.createStatement();
            rs = st.executeQuery("select idcab_pago from cab_pago where estado='Pendiente';"); //estira el id de la cabecera pendiente si es que existe
            // Si existe una cabecera con estado pendiente, imprime un mensaje
            if (rs.next()) {
            //out.println("Existe cabecera");
            st.executeUpdate("INSERT INTO det_pago (idcab_pago, idservicio, det_precio, det_cantidad) VALUES ('" + rs.getString(1) + "', '" + codservicio + "','" + precio + "','" + cantidad + "')");
        } else {
           // out.println("No existe cabecera");
           
           //solamente insertamos idcliente y fecha porque los demas ya establecimos sus datos por defecto
           st.executeUpdate("INSERT INTO cab_pago (idcliente, fecha, idusuario) VALUES ('" + codcliente + "', '" + fecharegistro + "', '" + codusuario + "')"); //aqui insertamos la cabecera
            idcab = st.executeQuery("select idcab_pago from cab_pago where estado='Pendiente';"); //una vez que ya exista un valor insertado en la cabecera se vuelve a consultar por la cabecera pendiente
            idcab.next();//aqui se almacena el idcab_pago pendiente que se insert�
            st.executeUpdate("INSERT INTO det_pago (idcab_pago, idservicio, det_precio, det_cantidad) VALUES ('" + idcab.getString(1) + "', '" + codservicio + "','" + precio + "','" + cantidad + "')");//y aqui insertamos el detalle, como el idcab_pago pendiente se almacena en idcab.next(); aqui lo llamamos mediante idcab.getString(1)
        }

   } catch (Exception e) {
    // Manejo de errores
    out.println("Error PSQL: " + e);
}
    }
    if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet idcab = null;
        st = conn.createStatement();
        idcab = st.executeQuery("select idcab_pago from cab_pago where estado='Pendiente';"); 
        idcab.next();
        rs = st.executeQuery("select dt.iddet_pago, s.ser_nombre, dt.det_precio, dt.det_cantidad from det_pago dt, servicios s where dt.idservicio=s.idservicio and dt.idcab_pago='"+idcab.getString(1)+"'");

        while (rs.next()) {
        String precio = rs.getString(3);
        String cantidad = rs.getString(4);
        Integer precio1=Integer.parseInt(precio);
        Integer cantidad1=Integer.parseInt(cantidad);
        int calcular = precio1*cantidad1;
%>
<tr>
    <td>  
        <i class="fa fa-trash" data-target="#exampleModal"></i>
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
    }

%>