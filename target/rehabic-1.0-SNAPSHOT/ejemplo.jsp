<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/> <!-- para cuando envie el formulario y ver que es lo que estoy recibiendo -->
            <input type="hidden" id="codusuario" name="codusuario" value="<%= sesion.getAttribute("idusuarios")%>">
            <h3 class="text-center mb-4">Pagos por servicios</h3>

            <div class="row">
                <!-- Datos del Paciente -->
                <div class="col-lg-3">
                    <div class="border rounded p-3">
                        <h5 class="mb-3 font-weight-bold">Datos del Paciente</h5>
                        <div class="form-group">
                            <label for="idcliente" class="control-label">Paciente</label>
                            <select class="form-control" name="idcliente" id="idcliente" onchange="dividircliente(this.value)">
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="cli_cedula" class="control-label">Cédula</label>
                            <input type="hidden" id="codcliente" name="codcliente">
                            <input type="text" class="form-control" id="cli_cedula" name="cli_cedula" placeholder="Cédula" readonly required>
                        </div>
                        <div class="form-group">
                            <label for="fecharegistro" class="control-label">Fecha del Pago</label>
                            <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly>
                        </div>
                    </div>
                </div>

                <!-- Detalle de Pagos -->
                <div class="col-lg-9">
                    <div class="border rounded p-3">
                        <h5 class="mb-3 font-weight-bold">Detalle del Pago</h5>
                        <div id="error" class="alert alert-danger d-none"></div>
                        <div class="row">
                            <div class="col-md-5">
                                <div class="form-group">
                                    <label for="idservicio" class="control-label">Buscar servicio:</label>
                                    <select class="form-control" name="idservicio" id="idservicio" onchange="dividirservicio(this.value)">
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label for="precio" class="control-label">Precio:</label>
                                    <input class="form-control" type="text" name="precio" id="precio" placeholder="Precio" readonly required>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label for="cantidad" class="control-label">Cantidad:</label>
                                    <input class="form-control" type="text" name="cantidad" id="cantidad" value="1" placeholder="Cantidad">
                                </div>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="button" name="agregar" value="agregar" id="AgregaServicioPago" class="btn btn-primary w-100">
                                    <i class="fa fa-shopping"></i> Agregar
                                </button>
                            </div>
                        </div>

                        <div class="table-responsive mt-4">
                            <table class="table table-bordered table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th class="text-center">Acción</th>
                                        <th class="text-center">Servicio</th>
                                        <th class="text-center">Precio</th>
                                        <th class="text-center">Cantidad</th>
                                        <th class="text-center">Total</th>
                                    </tr>
                                </thead>
                                <tbody id="resultados">
                                </tbody>
                            </table>
                        </div>

                        <div class="text-right mt-3">
                            <table class="table table-borderless">
                                <tr>
                                    <td class="text-right">
                                        <strong>Total:</strong>
                                    </td>
                                    <td class="text-right">
                                        <div>
                                            <label id="lbltotal" name="lbltotal" class="font-weight-bold text-danger"></label>
                                            <input type="hidden" name="txtTotal" id="txtTotal" value="0.00">
                                            <input type="text" class="form-control d-inline w-auto" name="txtTotalPago" id="txtTotalPago" value="">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="mt-3 text-right">
                            <button class="btn btn-danger" type="reset" id="cancelar-pago"><i class="fa fa-times"></i> Cancelar</button>
                            <button type="button" name="btn-submit" id="final-pago" class="btn btn-success"><i class="fa fa-save"></i> Registrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </section>
</div>

<!-- MODAL ELIMINAR -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-light border-bottom-0">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar registro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro de querer eliminar el registro?
                <input type="hidden" name="pkdel" id="pkdel"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal" id="eliminardet">Sí</button>
            </div>
        </div>
    </div>
</div>
