
<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Date fechaActual = new Date();
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<div class="content-wrapper">
    <section class="content">

        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <h3><i></i>Tratamientos y rutinas</h3>

            <div class="provider-details panel panel-border panel-warning widget-s-1">
                <h5>Datos del cliente</h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="idproveedor" class="control-label">Cliente</label>
                            <select class="form-control" name="idproveedor" id="idproveedor" onchange="dividirproveedor(this.value)"></select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="ruc" class="control-label">RUC</label>
                            <input type="hidden" id="codproveedor" name="codproveedor">
                            <input class="form-control" type="text" value="" name="ruc" id="ruc" autocomplete="off" placeholder="Cédula" readonly="readonly" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="fecharegistro" class="control-label">Fecha de Venta</label>
                            <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" value="<%= fechaFormateada%>" readonly>
                        </div>
                    </div>
                </div>
                <hr>
            </div>

            <div class="purchase-details panel panel-border panel-warning widget-s-1">
                <div class="panel-heading">
                    <h4 class="mb"><i class="fa fa-archive"></i> <strong> Detalle de la Compra</strong></h4>
                </div>
                <div class="panel-body">
                    <div id="error"></div>
                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="field-5" class="control-label">Búsqueda de Artículo: <span class="symbol required"></span></label>
                                <input type="hidden" id="codproducto" name="codproducto">
                                <select class="form-control" name="prod_id" id="prod_id" onchange="dividirproducto(this.value)"></select>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="field-3" class="control-label">Precio Venta: <span class="symbol required"></span></label>
                                <input class="form-control" type="text" name="precio" id="precio" autocomplete="off" placeholder="precio" required readonly="readonly">
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="field-2" class="control-label">Cantidad: <span class="symbol required"></span></label>
                                <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" autocomplete="off" placeholder="Cantidad">
                            </div>
                        </div>
                    </div>

                    <div align="right">
                        <button type="button" name="agregar" value="agregar" id="AgregaProductoCompra" class="btn btn-primary"><span class="fa fa-shopping"></span> Agregar</button>
                        <div id="respuesta"></div>
                    </div>
                    <hr>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                    <thead>
                                        <tr>
                                            <th><div align="center">Acción</div></th>
                                            <th><div align="center">Artículo</div></th>
                                            <th><div align="center">Cantidad</div></th>
                                            <th><div align="center">Precio</div></th>
                                            <th><div align="center">Total</div></th>
                                        </tr>
                                    </thead>
                                    <tbody id="resultados"></tbody>
                                </table>

                                <table id="carritototal" style="width: 302px;">
                                    <tr>
                                        <td><span style="font-size: 40px;" class="Estilo9"><label for="txtTotalCompra">Total:</label></span></td>
                                        <td>
                                            <div align="right" class="Estilo9">
                                                <label id="lbltotal"></label>
                                                <input type="hidden" name="txtTotal" id="txtTotal" value="0.00" />
                                                <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-danger" type="reset" onclick="#" id="cancelar-compra"><span class="fa fa-times"></span> Cancelar</button>
                        <button type="button" name="btn-submit" id="final-compra" class="btn btn-primary" onclick="#"><span class="fa fa-save"></span> Registrar</button>
                    </div>
                </div>
            </div>
        </form>
    </section>
</div>

<!-- Modal -->
<div class="modal" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Registro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Esta seguro de querer eliminar el registro?
                <input type="text" name="pkdel" id="pkdel"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="delcompra">SI</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>

<script>
                            $(document).ready(function () {
                                buscarproveedor();
                                buscararticulo();
                                cargardetalle(); // Agregar esta línea para cargar el detalle al cargar la página
                                actualizarSumaTotal(); // Llama a la función para actualizar la suma total

                                // Configurar un intervalo para actualizar la suma total cada 5 segundos (5000 ms)
                                setInterval(actualizarSumaTotal, 3000);
                            });

                            function buscarproveedor() {
                                $.ajax({
                                    data: {listar: 'buscarproveedor'},
                                    url: 'jsp/buscar.jsp',
                                    type: 'post',
                                    beforeSend: function () {},
                                    success: function (response) {
                                        $("#idproveedor").html(response);
                                    }
                                });
                            }

                            function buscararticulo() {
                                $.ajax({
                                    data: {listar: 'buscararticulo'},
                                    url: 'jsp/buscar.jsp',
                                    type: 'post',
                                    beforeSend: function () {},
                                    success: function (response) {
                                        $("#prod_id").html(response);
                                    }
                                });
                            }

                            function dividirproveedor(a) {
                                let datos = a.split(',');
                                $("#codproveedor").val(datos[0]);
                                $("#ruc").val(datos[1]);
                            }

                            function dividirproducto(a) {
                                let datos = a.split(',');
                                $("#codproducto").val(datos[0]);
                                $("#precio").val(datos[1]);
                            }

                            $("#AgregaProductoCompra").click(function () {
                                let datosform = $("#form").serialize();
                                $.ajax({
                                    data: datosform,
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    beforeSend: function () {},
                                    success: function (response) {
                                        $("#respuesta").html(response);
                                        cargardetalle();
                                        actualizarSumaTotal(); // Llama a la función para actualizar la suma total
                                    }
                                });
                            });

                            function cargardetalle() {
                                $.ajax({
                                    data: {listar: 'listar'},
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    beforeSend: function () {},
                                    success: function (response) {
                                        $("#resultados").html(response);
                                    }
                                });
                            }

                            function actualizarSumaTotal() {
                                $.ajax({
                                    data: {listar: 'listarsuma'},
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    success: function (response) {
                                        $("#lbltotal").html(response);
                                        $("#txtTotalCompra").val(response);
                                    }
                                });
                            }

                            $("#delcompra").click(function () {
                                pkd = $("#pkdel").val();
                                $.ajax({
                                    data: {listar: 'elimregcompra', pkd: pkd},
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    beforeSend: function () {
                                        //$("#resultado").html("Procesando, espere por favor...");
                                    },
                                    success: function (response) {
                                        cargardetalle();
                                        actualizarSumaTotal(); // Llama a la función para actualizar la suma total

                                    }
                                });
                            });

                            $("#cancelar-compra").click(function () {
                                $.ajax({
                                    data: {listar: 'cancelcompra'},
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    beforeSend: function () {
                                        //$("#resultado").html("Procesando, espere por favor...");
                                    },
                                    success: function (response) {
                                        location.href = 'listarcompras.jsp';

                                    }
                                });
                            });

                            $("#final-compra").click(function () {
                                total = $("#txtTotalCompra").val();
                                $.ajax({
                                    data: {listar: 'finalcompra', total: total},
                                    url: 'jsp/compras.jsp',
                                    type: 'post',
                                    success: function (response) {
                                        alert(response);
                                        location.href = 'listarcompras.jsp';
                                    }
                                });
                            });


</script>