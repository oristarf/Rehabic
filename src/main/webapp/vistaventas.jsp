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
            <h3><i></i>TRATAMIENTOS Y RUTINAS</h3>
            <!--datos del cliente -->
            <div class="provider-details panel panel-border panel-warning widget-s-1">
                <h5><i class="fa fa-archive"></i> Datos del cliente</h5>
                <div class="client-box">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="id_cliente" class="control-label">Cliente</label>
                                <select class="form-control" name="id_cliente" id="id_cliente" onchange="dividircliente(this.value)"></select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="ci" class="control-label">Diagnostico</label>
                                <input type="hidden" id="idclientes" name="idclientes">
                                <input class="form-control" type="text" value="" name="ci" id="ci" autocomplete="off" placeholder="Diagnostico" readonly required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="fecharegistro" class="control-label">Fecha de creacion</label>
                                <input class="form-control" type="text" name="tra_fecha" id="tra_fecha" value="<%= fechaFormateada%>" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--detalle ventas -->
            <hr>
            <div class="purchase-details panel panel-border panel-warning widget-s-1">
                <div class="panel-heading">
                    <h4 class="mb"><i class="fa fa-archive"></i> <strong> Detalle del tratamiento</strong></h4>
                </div>
                <div class="panel-body">
                    <div id="error"></div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="det_fecha" class="control-label">Fecha: <span class="symbol required"></span></label>
                                <input class="form-control" type="date" name="det_fecha" id="det_fecha">
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="form-group">
                                <label for="descripcion" class="control-label">Descripcion de rutina: <span class="symbol required"></span></label>
                                <input class="form-control" type="text" name="descripcion" id="descripcion" placeholder="Describir el tratamiento a ser aplicado en esta fecha, ya sea masaje, ejercicio, etc" autocomplete="off" required>
                            </div>
                        </div>
                    </div>
                    <div align="right">
                        <button type="button" name="agregar" value="agregar" id="AgregaProductoVenta" class="btn btn-primary"><span class="fa fa-shopping"></span> Agregar</button>
                        <div id="respuesta"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered dt-responsive nowrap" id="tratamiento">
                                    <thead>
                                        <tr>
                                            <th><div align="center">Accion</div></th>
                                            <th><div align="center">ID Tratamiento</div></th>
                                            <th><div align="center">Fecha</div></th>
                                            <th><div align="center">Estado</div></th>
                                        </tr>
                                    </thead>
                                    <tbody id="resultados"></tbody>
                                </table>
                                <div class="modal-footer">
                                    <button class="btn btn-danger" type="reset" id="cancelar-venta"><span class="fa fa-times"></span> Cancelar</button>
                                    <button type="button" name="btn-submit" id="final-venta" class="btn btn-primary"><span class="fa fa-save"></span> Registrar Venta</button>
                                </div>
                            </div>
                        </div>
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
                ¿Eliminar registro?
                <input type="hidden" name="pkdel" id="pkdel"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="delventa">SI</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="js/jquery-3.7.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>

<script>
                                    $(document).ready(function () {
                                        buscarcliente();
                                        cargardetalle(); // Cargar el detalle al cargar la p?gina

                                        // Configurar un intervalo para actualizar la suma total cada 3 segundos (3000 ms)
                                        setInterval(actualizarSumaTotal, 3000);
                                    });

                                    function buscarcliente() {
                                        $.ajax({
                                            data: {listar: 'buscarcliente'},
                                            url: 'jsp/buscar.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                $("#id_cliente").html(response);
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al buscar clientes: " + error);
                                            }
                                        });
                                    }

                                    function dividircliente(value) {
                                        let datos = value.split(',');
                                        $("#idclientes").val(datos[0]);
                                        $("#ci").val(datos[1]);
                                    }

                                    $("#AgregaProductoVenta").click(function () {
                                        let datosform = $("#form").serialize();
                                        $.ajax({
                                            data: datosform,
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                $("#respuesta").html(response);
                                                cargardetalle();
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al agregar producto: " + error);
                                            }
                                        });
                                    });

                                    function cargardetalle() {
                                        $.ajax({
                                            data: {listar: 'listar'},
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                $("#resultados").html(response);
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al cargar detalle: " + error);
                                            }
                                        });
                                    }

                                    function actualizarSumaTotal() {
                                        $.ajax({
                                            data: {listar: 'listarsuma'},
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                $("#lbltotal").html(response);
                                                $("#txtTotalVenta").val(response);
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al actualizar suma total: " + error);
                                            }
                                        });
                                    }

                                    $("#delventa").click(function () {
                                        let pkd = $("#pkdel").val();
                                        $.ajax({
                                            data: {listar: 'elimregventa', pkd: pkd},
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                cargardetalle();
                                                actualizarSumaTotal();
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al eliminar venta: " + error);
                                            }
                                        });
                                    });

                                    $("#cancelar-venta").click(function () {
                                        $.ajax({
                                            data: {listar: 'cancelventa'},
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                location.href = 'listarventas.jsp';
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al cancelar venta: " + error);
                                            }
                                        });
                                    });

                                    $("#final-venta").click(function () {
                                        let total = $("#txtTotalVenta").val();
                                        $.ajax({
                                            data: {listar: 'finalventa', total: total},
                                            url: 'jsp/ventas.jsp',
                                            type: 'post',
                                            success: function (response) {
                                                alert(response);
                                                location.href = 'listarventas.jsp';
                                            },
                                            error: function (xhr, status, error) {
                                                $("#error").html("Error al finalizar venta: " + error);
                                            }
                                        });
                                    });
</script>
