<%@ include file="header.jsp" %>

<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/> <!-- para cuando envie el formulario y ver que es lo que estoy recibiendo -->
            <input type="hidden" id="codusuario" name="codusuario" value="<%= sesion.getAttribute("idusuarios")%>">
            <h3>Pagos por servicios</h3>
            <!-- Datos del Cliente -->
            <div class="panel panel-border panel-warning widget-s-1">
                <h5>Datos del Paciente</h5>
                <div class="client-box">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="idcliente" class="control-label">Paciente</label>
                                <select class="form_control" name="idcliente" id="idcliente" onchange="dividircliente(this.value)">

                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="cli_cedula" class="control-label">Cedula</label>
                                <input type="hidden" id="codcliente" name="codcliente"> <!-- no lo llamo idcliente porque ese id ya se referencia en el select de pacientes -->
                                <input type="text" class="form-control" id="cli_cedula" name="cli_cedula" placeholder="Cédula" readonly="readonly" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="fecharegistro" class="control-label">Fecha del Pago</label>
                                <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" value="<%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date())%>" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detalle de Pagos -->
            <div class="panel panel-border panel-warning widget-s-1">
                <h5>Detalles del pago</h5>
                <div class="client-box">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="idservicio" class="control-label">Servicio</label>
                                <input type="hidden" id="codservicio" name="codservicio">
                                <!-- dividirservicio(this.value) sirve para que segun el servicio seleccionado, el dato registrado en campo de precio dentro de la base de datos aparezca automaticamente en el  <input type="text" class="form-control" id="precio" name="precio" placeholder="Precio" readonly="readonly" required> con la funcion  function dividirservicio(a) dentro del script-->
                                <select class="form_control" name="idservicio" id="idservicio" onchange="dividirservicio(this.value)"></select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="precio" class="control-label">Precio</label>
                                <input type="text" class="form-control" id="precio" name="precio" placeholder="Precio" readonly="readonly" required>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="cantidad" class="control-label">Cantidad:</label>
                            <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" autocomplete="off" placeholder="Cantidad">
                        </div>
                    </div>    
                </div>

                <div align="right">
                    <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary">Agregar</button>
                    <div id="respuesta"></div> <!-- para verificar si muestra los parametros que pasamos en el rutinasM.jsp String codcliente = request.getParameter("codcliente");String fecharegistro = request.getParameter("fecharegistro"); etc abajo del boton agregar luego de darle click -->
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                <thead>
                                    <tr>
                                        <th>
                                            <div align="center">Acción</div>
                                        </th>
                                        <th>
                                            <div align="center">Servicio</div>
                                        </th>
                                        <th>
                                            <div align="center">Precio</div>
                                        </th>
                                        <th>
                                            <div align="center">Cantidad</div>
                                        </th>
                                        <th>
                                            <div align="center">Total</div>
                                        </th>

                                    </tr>
                                </thead>
                                <tbody id="resultados">


                                </tbody>
                            </table>

                            <table width="302" id="carritototal">

                                                    <tr>
                                                        <td><span class="Estilo9"><label>Total:</label></span></td>
                                                        <td>
                                                            <div align="right" class="Estilo9"><label id="lbltotal" name="lbltotal"></label><input type="hidden" name="txtTotal" id="txtTotal" value="0.00" />
                                                                <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>

                            <div class="modal-footer">
                                <button class="btn btn-danger" type="reset" id="cancelar-pago">Cancelar</button>
                                <button type="button" name="btn-submit" id="final-pago" class="btn btn-primary">Registrar Pago</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </form>
    </section>
</div>

<!-- Modal de Abono -->
<div class="modal fade" id="abonoModal" tabindex="-1" role="dialog" aria-labelledby="abonoModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="abonoModalLabel">Registrar Abono</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="abonoForm">
                    <div class="form-group">
                        <label for="montoAbono">Monto del Abono</label>
                        <input type="number" class="form-control" id="montoAbono" name="montoAbono" required>
                        <input type="hidden" id="idCabecera" name="idCabecera">
                    </div>
                    <div class="form-group">
                        <label for="saldoPendiente">Saldo Pendiente</label>
                        <input type="text" class="form-control" id="saldoPendiente" readonly>
                    </div>
                    <div class="form-group">
                        <label for="abonoMetodo">Método de Pago</label>
                        <select class="form-control" id="abonoMetodo" name="abonoMetodo">
                            <option value="efectivo">Efectivo</option>
                            <option value="transferencia">Transferencia</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" id="guardarAbono">Guardar Abono</button>
            </div>
        </div>
    </div>
</div>

<script>
    //PARA VERIFICAR SI LLAMA AL JQUERY
    /*$(document).ready(function(){
     alert('a')
     });*/
    $(document).ready(function () {
        buscarcliente();//funcion que va a llamar a otra funcion llamada buscarcliente mas abajo
        buscarservicio();
    });
    function buscarcliente() {
        //ajax
        $.ajax({
            data: {listar: 'buscarcliente'}, //cuando nosotros emitimos de rutinas debemos de pasar la variable listar y el dato que va a tener
            url: 'jsp/buscar.jsp',
            type: 'post',
            beforeSend: function () {
                //$("resultado").html("Procesando, espere por favor...");
                //todos los datos se deben cargar en el select de clientes
            },
            success: function (response) {
                $("#idcliente").html(response); //busca todas las opciones en buscar.jsp en buscarcliente y retorna dentro de idcliente
            }
        });
    }
    function buscarservicio() {
        //ajax
        $.ajax({
            data: {listar: 'buscarservicio'}, //cuando nosotros emitimos de rutinas debemos de pasar la variable listar y el dato que va a tener
            url: 'jsp/buscar.jsp',
            type: 'post',
            beforeSend: function () {
                //$("resultado").html("Procesando, espere por favor...");
                //todos los datos se deben cargar en el select de clientes
            },
            success: function (response) {
                $("#idservicio").html(response); //busca todas las opciones en buscar.jsp en buscarcliente y retorna dentro de idcliente
            }
        });
    }
    //al seleccionar un de los que se muestran en el select, la funcion dividircliente particiona los datos id y cedula con la variable datos
    function dividircliente(a) {
        //alert(a)
        let datos = a.split(',');
        //alert(datos[0]);
        //alert(datos[1]);
        $("#codcliente").val(datos[0]); //0 es el idcliente
        $("#cli_cedula").val(datos[1]); //1 es la cedula cliente, tienen ese orden 0 y 1 porque los dos datos que se particionan al seleccionar un cliente son esos dos 
        /*de esta manera al seleccionar un cliente su id se completa automaticamente en el 
         <input type="" id="codcliente" name="codcliente"> y la cedula se completa automaticamente 
         en <input type="text" class="form-control" id="cli_cedula" name="cli_cedula" placeholder="Cédula" readonly onKeyUp="this.value">*/
    }
    function dividirservicio(a) {
        //alert(a)
        let datos = a.split(',');
        //alert(datos[0]);
        //alert(datos[1]);
        $("#codservicio").val(datos[0]);
        $("#precio").val(datos[1]);
    }

    //al darle click al boton <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary">Agregar</button> se ejecuta la funcion para enviar el formulario
    $("#AgregaServicioPago").click(function () {
        datosform = $("form").serialize(); //aqui se toma todos los datos del formulario
        $.ajax({
            data: datosform, //de datos form serialize se pasan los datos a esta linea
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            beforeSend: function () {
                //$("resultado").html("Procesando, espere por favor...");
                //todos los datos se deben cargar en el select de clientes
            },
            success: function (response) {
                $("#respuesta").html(response);
                cargardetalle();
            }
        });
    });
    function cargardetalle() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#resultados").html(response);//lista en el tbody los detalles agregados con el boton agregar 
                //sumador();

            }
        });
    }
</script>

<%@ include file="footer.jsp" %>



