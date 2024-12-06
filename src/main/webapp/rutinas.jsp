<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/> <!-- Parámetro para determinar la acción -->
            <input type="hidden" id="codusuario" name="codusuario" value="<%= sesion.getAttribute("idusuarios")%>"> <!-- Usuario que crea la rutina -->
            <h3><i></i>Gestión de Rutinas</h3><br>

            <div class="row">
                <div class="col-lg-3 ds">
                    <h5>Datos del Paciente</h5>

                    <!-- Selección del Paciente -->
                    <div class="form-group">
                        <label for="idcliente" class="control-label">Paciente</label>
                        <select class="form_control" name="idcliente" id="idcliente" onchange="dividirCliente(this.value)">
                        </select>
                    </div>

                    <!-- Campo de Cédula -->
                    <div class="form-group">
                        <label for="cli_cedula" class="control-label">Cédula</label>
                        <input type="hidden" id="codcliente" name="codcliente">
                        <input type="text" class="form-control" id="cli_cedula" name="cli_cedula" placeholder="Cédula" readonly="readonly" required>
                    </div>

                    <!-- Fecha de Registro -->
                    <div class="form-group">
                        <label for="fecharegistro" class="control-label">Fecha de Registro</label>
                        <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" value="<%= fechaFormateada%>" readonly>
                    </div>

                    <hr><br>
                </div>

                <div class="col-lg-9">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-border panel-warning widget-s-1">
                                <div class="panel-heading">
                                    <h4 class="mb"><i class="fa fa-dumbbell"></i> <strong>Detalle de la Rutina</strong></h4>
                                </div>
                                <div class="panel-body">
                                    <div id="error"></div>
                                    <div class="row">
                                        <!-- Selección del Ejercicio -->
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="idejercicio" class="control-label">Ejercicio:</label>
                                                <select class="form_control" name="idejercicio" id="idejercicio">
                                                </select>
                                            </div>
                                        </div>

                                        <!-- Fecha del Ejercicio -->
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="fecha_detalle" class="control-label">Fecha del Ejercicio:</label>
                                                <input class="form-control" type="date" name="fecha_detalle" id="fecha_detalle" value="<%= new java.sql.Date(System.currentTimeMillis())%>">
                                            </div>
                                        </div>

                                        <!-- Series -->
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label for="series" class="control-label">Series:</label>
                                                <input class="form-control number" value="0" type="number" name="series" id="series" placeholder="Series">
                                            </div>
                                        </div>

                                        <!-- Repeticiones -->
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label for="repeticiones" class="control-label">Repeticiones:</label>
                                                <input class="form-control number" value="0"  type="number" name="repeticiones" id="repeticiones" placeholder="Repeticiones">
                                            </div>
                                        </div>

                                        <!-- Peso -->
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label for="peso" class="control-label">Peso (Kg):</label>
                                                <input class="form-control number" value="0" type="number" name="peso" id="peso" placeholder="Peso">
                                            </div>
                                        </div>

                                        <!-- Minutos -->
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label for="minutos" class="control-label">Minutos:</label>
                                                <input class="form-control number" value="0" type="number" name="minutos" id="minutos" placeholder="Minutos">
                                            </div>
                                        </div>
                                    </div>

                                    <div align="right">
                                        <button type="button" name="agregar" value="agregar" id="AgregarRutina" class="btn btn-primary"><span class="fa fa-plus"></span> Agregar</button>
                                        <div id="respuesta"></div>
                                    </div>
                                    <hr>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                                    <thead>
                                                        <tr>
                                                            <th>Acción</th>
                                                            <th>Ejercicio</th>
                                                            <th>Fecha</th>
                                                            <th>Series</th>
                                                            <th>Repeticiones</th>
                                                            <th>Peso</th>
                                                            <th>Minutos</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="resultados"></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button class="btn btn-danger" type="reset" id="cancelar-rutina"><span class="fa fa-times"></span> Cancelar</button>
                                        <button type="button" id="final-rutina" class="btn btn-primary"><span class="fa fa-save"></span> Registrar</button>
                                    </div>
                                </div>
                            </div>
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
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Registro</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                ¿Está seguro de querer eliminar el registro?
                <input type="hidden" name="pkdel" id="pkdel"/> <!-- ID del detalle a eliminar -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal" id="eliminardet">Sí</button>
            </div>
        </div>
    </div>
</div>
<%@ include file="footer.jsp" %>
<script>
    // Inicializar funciones al cargar la página
    $(document).ready(function () {
        buscarCliente(); // Carga los clientes en el select
        buscarEjercicio(); // Carga los ejercicios en el select
        cargardetalle(); // Carga los detalles si hay cabeceras pendientes
    });

    // Buscar clientes y llenar el select
    function buscarCliente() {
        $.ajax({
            data: {listar: 'buscarcliente'},
            url: 'jsp/datosRutinas.jsp',
            type: 'post',
            success: function (response) {
                $("#idcliente").html(response);
            }
        });
    }

    // Buscar ejercicios y llenar el select
    function buscarEjercicio() {
        $.ajax({
            data: {listar: 'buscarejercicio'},
            url: 'jsp/datosRutinas.jsp',
            type: 'post',
            success: function (response) {
                $("#idejercicio").html(response);
            }
        });
    }

    // Dividir los datos del cliente seleccionado
    function dividirCliente(a) {
        let datos = a.split(',');
        $("#codcliente").val(datos[0]); // ID del cliente
        $("#cli_cedula").val(datos[1]); // Cédula del cliente
    }

// Agregar detalle de rutina al presionar el botón "Agregar"
    $("#AgregarRutina").click(function () {
        datosform = $("form").serialize();
        $.ajax({
            data: datosform,
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                console.log(datosform);
                $("#respuesta").html(response); // Mostrar respuesta del servidor
                cargardetalle();
                limpiarCampos();// Recargar detalles
            }
        });
    });

    function limpiarCampos() {
    $("#idejercicio").val(""); // Limpia el select de ejercicios
    $("#series").val(""); // Limpia el campo de series
    $("#repeticiones").val(""); // Limpia el campo de repeticiones
    $("#peso").val(""); // Limpia el campo de peso
    $("#minutos").val(""); // Limpia el campo de minutos
    $("#fecha_detalle").val(""); // Limpia la fecha
}
    // Cargar los detalles de la cabecera de rutina
    function cargardetalle() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response); // Llenar el tbody con los detalles
            }
        });
    }

    // Eliminar un detalle de la rutina
    $("#eliminardet").click(function () {
        pkd = $("#pkdel").val(); // Obtener el ID del detalle a eliminar
        $.ajax({
            data: {listar: 'elimregrutina', pkd: pkd},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                cargardetalle(); // Recargar los detalles
            }
        });
    });

    // Cancelar toda la cabecera de rutina
    $("#cancelar-rutina").click(function () {
        $.ajax({
            data: {listar: 'cancelrutina'},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'listarrutinas.jsp'; // Redirigir al listado de rutinas
            }
        });
    });

    // Finalizar la cabecera de rutina
    $("#final-rutina").click(function () {
        $.ajax({
            data: {listar: 'finalrutina'},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'listarrutinas.jsp'; // Redirigir al listado de rutinas
            }
        });
    });
</script>
