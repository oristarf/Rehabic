<%@ include file="header.jsp" %>

<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <h3>Registro de Pagos</h3>
            <!-- Datos del Cliente -->
            <div class="panel panel-border panel-warning widget-s-1">
                <h5>Datos del Cliente</h5>
                <div class="client-box">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="id_cliente" class="control-label">Cliente</label>
                                <input type="text" id="buscarCliente" class="form-control" placeholder="Escriba el nombre o apellido del cliente">
                                <input type="hidden" id="id_cliente" name="id_cliente">
                                <div id="resultadosClientes" class="list-group mt-2"></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="ci" class="control-label">CI / RUC</label>
                                <input type="text" class="form-control" id="ci" name="ci" placeholder="Cédula" readonly>
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
                <div class="panel-heading">
                    <h4>Detalle del Pago</h4>
                </div>
                <div class="panel-body">
                    <div id="error"></div>
                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="servicio_id" class="control-label">Búsqueda de Servicio:</label>
                                <input type="text" id="buscarServicio" class="form-control" placeholder="Escriba el nombre del servicio">
                                <input type="hidden" id="servicio_id" name="servicio_id">
                                <div id="resultadosServicios" class="list-group mt-2"></div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="precio" class="control-label">Precio del Servicio:</label>
                                <input class="form-control" type="text" name="precio" id="precio" autocomplete="off" placeholder="precio" required readonly>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="cantidad" class="control-label">Cantidad:</label>
                                <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" autocomplete="off" placeholder="Cantidad">
                            </div>
                        </div>
                    </div>

                    <div align="right">
                        <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary">Agregar</button>
                        <div id="respuesta"></div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                    <thead>
                                        <tr>
                                            <th>Acción</th>
                                            <th>Servicio</th>
                                            <th>Cantidad</th>
                                            <th>Precio</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody id="resultados"></tbody>
                                </table>

                                <table id="carritototal">
                                    <tr>
                                        <td>Total:</td>
                                        <td>
                                            <div align="right">
                                                <label id="lbltotal"></label>
                                                <input type="hidden" name="txtTotal" id="txtTotal" value="0.00"/>
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

<%@ include file="footer.jsp" %>

<script>
    $(document).ready(function () {
        verificarCabeceraActiva();
        buscarCliente();
        buscarServicio();
        actualizarSumaTotal();

        setInterval(actualizarSumaTotal, 3000);
    });

    function verificarCabeceraActiva() {
        $.ajax({
            url: 'jsp/pagosM.jsp',
            type: 'POST',
            data: {listar: 'verificar_cabecera'},
            success: function (response) {
                if (response === '1') {
                    cargardetalle();
                    actualizarSumaTotal();
                }
            }
        });
    }

    function buscarCliente() {
        $("#buscarCliente").on("keyup", function () {
            const query = $(this).val().trim();
            if (query.length > 0) {
                $.ajax({
                    url: "jsp/pagosM.jsp",
                    type: "POST",
                    data: {listar: "buscar_cliente", query: query},
                    success: function (response) {
                        $("#resultadosClientes").html(response);
                    }
                });
            } else {
                $("#resultadosClientes").html("");
            }
        });
    }

    $(document).on("click", ".cliente-item", function () {
        const clienteId = $(this).data("id");
        const clienteNombre = $(this).text().trim();
        const clienteCi = $(this).data("ci");

        $("#buscarCliente").val(clienteNombre);
        $("#id_cliente").val(clienteId);
        $("#ci").val(clienteCi);
        $("#resultadosClientes").html("");
    });

    function buscarServicio() {
        $("#buscarServicio").on("keyup", function () {
            const query = $(this).val().trim();
            if (query.length > 1) {
                $.ajax({
                    url: "jsp/pagosM.jsp",
                    type: "POST",
                    data: {listar: "buscar_servicio", query: query},
                    success: function (response) {
                        $("#resultadosServicios").html(response);
                    }
                });
            } else {
                $("#resultadosServicios").html("");
            }
        });
    }

    $(document).on("click", ".servicio-item", function () {
        const servicioId = $(this).data("id");
        const servicioNombre = $(this).text().trim();
        const precio = $(this).data("precio");

        $("#buscarServicio").val(servicioNombre);
        $("#servicio_id").val(servicioId);
        $("#precio").val(precio);
        $("#resultadosServicios").html("");
    });

    $("#AgregaServicioPago").click(function () {
    $("#listar").val("agregar_detalle");
    $("#txtTotal").val(parseFloat($("#lbltotal").text().replace("Gs", "").trim()) || 0);

    let datosform = $("#form").serialize();
    console.log("Datos enviados:", datosform);

    $.ajax({
        data: datosform,
        url: 'jsp/pagosM.jsp',
        type: 'post',
        dataType: 'json',
        success: function (response) {
            if (response.success) {
                $("#resultados").append(response.html); // Agrega la fila del detalle
                actualizarSumaTotal();

                // Guarda el id de la cabecera en un campo oculto si es la primera vez que se crea
                if (!$("#idCabecera").val()) {
                    $("#idCabecera").val(response.idCabecera);
                }
            } else {
                alert("Error al agregar detalle: " + response.message);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error en el servidor:", error);
            alert("Hubo un error al agregar el detalle. Verifica los datos e intenta nuevamente.");
        }
    });
});


    function cargardetalle() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/pagosM.jsp',
            type: 'post',
            success: function (response) {
                console.log("Cargar detalle respuesta:", response);
                $("#resultados").html(response);
            }
        });
    }

    function actualizarSumaTotal() {
        $.ajax({
            data: {listar: 'listarsuma'},
            url: 'jsp/pagosM.jsp',
            type: 'post',
            success: function (response) {
                $("#lbltotal").html(response);
                $("#txtTotal").val(response);
            }
        });
    }

    $("#cancelar-pago").click(function () {
        $.ajax({
            data: {listar: 'cancelar_pago'},
            url: 'jsp/pagosM.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'jsp/listarpagos.jsp';
            }
        });
    });

  $("#final-pago").click(function () { 
    const total = $("#txtTotal").val();
    $.ajax({
        data: {listar: 'finalpago', total: total},
        url: 'jsp/pagosM.jsp', // Asegúrate de que apunte al archivo JSP correcto
        type: 'post',
        beforeSend: function () {
            // Puede agregar un mensaje de carga si deseas informar al usuario que el proceso está en curso
            // $("#resultado").html("Procesando, espere por favor...");
        },
        success: function (response) {
            location.href = 'listarpagos.jsp'; // Redirige a la lista de pagos después de finalizar el pago
        },
        error: function (xhr, status, error) {
            console.error("Error en el servidor:", error);
            alert("Hubo un error al finalizar el pago. Intente nuevamente.");
        }
    });
});



    $("#guardarAbono").click(function () {
        const montoAbono = parseFloat($("#montoAbono").val()) || 0;
        const saldoPendiente = parseFloat($("#saldoPendiente").val()) || 0;

        if (montoAbono > saldoPendiente) {
            alert("El monto del abono no puede ser mayor al saldo pendiente.");
            return;
        }

        const datosForm = $("#abonoForm").serialize() + "&listar=guardar_abono";

        $.ajax({
            data: datosForm,
            url: 'jsp/pagosM.jsp',
            type: 'post',
            success: function (response) {
                alert(response);
                $("#abonoModal").modal('hide');
                verificarCabeceraActiva();
            }
        });
    });
</script>
