<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Servicios</h4>
        </div>
        <div class="card-body">
            <!-- Formulario de Servicio -->
            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idservicio" name="idservicio">

                <div class="form-group mb-3">
                    <label for="nombre" class="form-label">Nombre del Servicio</label>
                    <input type="text" class="form-control form-control-user" id="ser_nombre" name="ser_nombre" placeholder="Nombre del Servicio">
                </div>
                <div class="form-group mb-3">
                    <label for="ser_tipo" class="form-label">Tipo de Servicio</label>
                    <select class="form-control" id="ser_tipo" name="ser_tipo">
                        <option value="">Seleccionar tipo</option>
                        <option value="Mensual">Mensual</option>
                        <option value="Diario">Diario</option>
                    </select>
                </div>

                <div class="form-group mb-3">
                    <label for="costo" class="form-label">Precio</label>
                    <input type="number" class="form-control form-control-user" id="ser_precio" name="ser_precio" placeholder="Precio del Servicio">
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Tabla de Servicios -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Servicio</th>
                            <th>Tipo</th> <!-- Nueva columna para el tipo de servicio -->
                            <th>Precio</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Datos de servicios se cargan aquí -->
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>
<!-- Modal de Edición de Servicio -->
<div class="modal fade" id="modalModificar" tabindex="-1" aria-labelledby="modalModificarLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalModificarLabel">Editar Servicio</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarServicio">
                    <input type="hidden" id="idservicio_m" name="idservicio">
                    <div class="form-group mb-3">
                        <label for="ser_nombre_m" class="form-label">Nombre del Servicio</label>
                        <input type="text" class="form-control" id="ser_nombre_m" name="ser_nombre" placeholder="Nombre del Servicio">
                    </div>
                    <div class="form-group mb-3">
                        <label for="ser_tipo_m" class="form-label">Tipo de Servicio</label>
                        <select class="form-control" id="ser_tipo_m" name="ser_tipo">
                            <option value="">Seleccionar tipo</option>
                            <option value="Mensual">Mensual</option>
                            <option value="Diario">Diario</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="ser_precio_m" class="form-label">Precio</label>
                        <input type="number" class="form-control" id="ser_precio_m" name="ser_precio" placeholder="Precio del Servicio">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <div id="mensaje_modal" class="mt-3 text-center"></div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardarEditarServicio">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Confirmación de Eliminación -->
<div class="modal fade" id="modalEliminar" tabindex="-1" aria-labelledby="modalEliminarLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="modalEliminarLabel">Eliminar Servicio</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="idservicio_e" name="idservicio_e">
                <p>¿Está seguro de que desea eliminar este servicio?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                <button type="button" class="btn btn-danger" id="eliminaregistro">Sí, eliminar</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp"%>

<script>
    $(document).ready(function () {
        rellenardatos();
    });

    // Cargar los datos de los servicios en la tabla
    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/serviciosM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    // Verificar duplicados antes de guardar
    $("#boton-aceptar").on("click", function () {
        const ser_nombre = $("#ser_nombre").val().trim();
        const ser_tipo = $("#ser_tipo").val().trim(); // Nuevo campo tipo de servicio

        // Validar campos obligatorios
        if (!ser_nombre || !$("#ser_precio").val().trim() || !ser_tipo) {
            $("#mensaje").html("<div class='alert alert-danger'>Debe completar todos los campos obligatorios, incluido el tipo de servicio.</div>");
            return;
        }

        // Comprobación de duplicado en el campo "servicio" por AJAX
        $.ajax({
            url: 'jsp/serviciosM.jsp',
            type: 'post',
            data: {listar: 'verificar_duplicado', ser_nombre: ser_nombre},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje").html("<div class='alert alert-danger'>El servicio ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    // Proceder a guardar si no hay duplicado en "servicio"
                    let datos = $("#form").serialize();
                    $.ajax({
                        data: datos,
                        url: 'jsp/serviciosM.jsp',
                        type: 'post',
                        success: function (response) {
                            $("#mensaje").html(response);
                            rellenardatos();

                            setTimeout(function () {
                                $("#mensaje").html("");
                                $("#ser_nombre").val("");
                                $("#ser_tipo").val(""); // Limpiar el tipo de servicio
                                $("#ser_precio").val("");
                                $("#listar").val("cargar");
                            }, 2000);
                        }
                    });
                }
            }
        });
    });

    // Configurar los datos en el modal de modificación
    function setModificar(id, ser_nombre, ser_tipo, ser_precio) {
        $('#idservicio_m').val(id);
        $('#ser_nombre_m').val(ser_nombre);
        $('#ser_tipo_m').val(ser_tipo); // Nuevo campo tipo de servicio
        $('#ser_precio_m').val(ser_precio);
        $('#modalModificar').modal('show');
    }

    // Guardar cambios en el servicio
    $("#guardarEditarServicio").on("click", function () {
        const ser_nombre = $("#ser_nombre_m").val().trim();
        const ser_tipo = $("#ser_tipo_m").val().trim(); // Validar el campo tipo de servicio
        const idservicio = $("#idservicio_m").val();

        // Validar campos obligatorios
        if (!ser_nombre || !$("#ser_precio_m").val().trim() || !ser_tipo) {
            $("#mensaje_modal").html("<div class='alert alert-danger'>Debe completar todos los campos obligatorios, incluido el tipo de servicio.</div>");
            return;
        }

        // Comprobar duplicados excluyendo el idservicio actual
        $.ajax({
            url: 'jsp/serviciosM.jsp',
            type: 'POST',
            data: {listar: 'verificar_duplicado', ser_nombre: ser_nombre, idservicio: idservicio},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje_modal").html("<div class='alert alert-danger'>El nombre del servicio ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    // Proceder a guardar los cambios
                    const datos = $("#formEditarServicio").serialize();
                    $.ajax({
                        url: 'jsp/serviciosM.jsp',
                        type: 'POST',
                        data: datos + '&listar=modificar',
                        success: function (response) {
                            $("#mensaje").html(response); // Mostrar mensaje en la página principal
                            rellenardatos(); // Actualizar la tabla
                            $("#modalModificar").modal("hide"); // Cerrar el modal
                        },
                        error: function () {
                            $("#mensaje_modal").html("<div class='alert alert-danger'>Error al guardar los cambios.</div>");
                        }
                    });
                }
            },
            error: function () {
                $("#mensaje_modal").html("<div class='alert alert-danger'>Error al verificar duplicados.</div>");
            }
        });
    });

    // Configurar el ID del servicio a eliminar en el modal de confirmación
    function setEliminar(id) {
        $('#idservicio_e').val(id);
    }

    // Ejecutar la eliminación al confirmar en el modal
    $("#eliminaregistro").on("click", function () {
        const idservicio = $("#idservicio_e").val(); // Toma el ID del servicio a eliminar
        $.ajax({
            data: {listar: 'eliminar', idservicio_e: idservicio},
            url: 'jsp/serviciosM.jsp',
            type: 'post',
            success: function (response) {
                // Mostrar el mensaje en el contenedor principal
                $("#mensaje").html(response);

                // Cerrar el modal más rápido
                $("#modalEliminar").modal('hide');

                // Actualizar la tabla después de un pequeño retraso
                setTimeout(function () {
                    $("#mensaje").html(""); // Limpiar el mensaje
                    rellenardatos(); // Refresca la tabla
                }, 2000);
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el servicio.</div>");
                $("#modalEliminar").modal('hide');

                setTimeout(function () {
                    $("#mensaje").html(""); // Limpiar el mensaje
                }, 2000);
            }
        });
    });
</script>

