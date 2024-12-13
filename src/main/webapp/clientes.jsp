<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Pacientes</h4>
        </div>
        <div class="card-body">
            <div class="text-center mb-4">
            </div>

            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idcliente" name="idcliente">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cli_nombres" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="cli_nombres" name="cli_nombres" placeholder="Nombre" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cli_apellidos" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="cli_apellidos" name="cli_apellidos" placeholder="Apellido">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cli_cedula" class="form-label">Cédula</label>
                        <input type="text" class="form-control" id="cli_cedula" name="cli_cedula" placeholder="Cédula">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cli_fechanacimiento" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" class="form-control" id="cli_fechanacimiento" name="cli_fechanacimiento">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cli_telefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="cli_telefono" name="cli_telefono" placeholder="Teléfono">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cli_telurgencia" class="form-label">Teléfono de Urgencia</label>
                        <input type="text" class="form-control" id="cli_telurgencia" name="cli_telurgencia" placeholder="Teléfono de Urgencia">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="usuario_asociado" class="form-label">Usuario Asociado</label>
                        <select class="form-control" id="usuario_asociado" name="idusuarios">
                            <option value="">Sin usuario asociado</option>
                            <!-- Opciones de usuario se cargarán dinámicamente -->
                        </select>
                    </div>
                </div>


                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton-cancelar">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Enlace para descargar el PDF de clientes -->
            <div class="text-end">
                <a href="ListaClienteJR.jsp" class="btn btn-info btn-sm mb-3" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generar PDF de Clientes
                </a>
                <a href="consultas.jsp" class="btn btn-info btn-sm mb-3">
                    <i class="fas fa-note"></i> Nueva consulta
                </a>
            </div>
         

            <!-- Tabla de clientes -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>Fecha de Nacimiento</th>
                            <th>Cédula</th>
                            <th>Teléfono</th>
                            <th>Teléfono de Urgencia</th>
                            <th>Usuario</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- Modal para editar cliente -->
<div class="modal fade" id="modalEditarCliente" tabindex="-1" aria-labelledby="editarClienteLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editarClienteLabel">Editar Cliente</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarCliente">
                    <input type="hidden" id="idcliente_m" name="idcliente">
                    <div class="mb-3">
                        <label for="cli_nombres_m" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="cli_nombres_m" name="cli_nombres">
                    </div>
                    <div class="mb-3">
                        <label for="cli_apellidos_m" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="cli_apellidos_m" name="cli_apellidos">
                    </div>
                    <div class="mb-3">
                        <label for="cli_cedula_m" class="form-label">Cédula</label>
                        <input type="text" class="form-control" id="cli_cedula_m" name="cli_cedula">
                    </div>
                    <div class="mb-3">
                        <label for="cli_fechanacimiento_m" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" class="form-control" id="cli_fechanacimiento_m" name="cli_fechanacimiento">
                    </div>
                    <div class="mb-3">
                        <label for="cli_telefono_m" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="cli_telefono_m" name="cli_telefono">
                    </div>
                    <div class="mb-3">
                        <label for="cli_telurgencia_m" class="form-label">Teléfono de Urgencia</label>
                        <input type="text" class="form-control" id="cli_telurgencia_m" name="cli_telurgencia">
                    </div>
                    <div class="mb-3">
                        <label for="usuario_asociado_m" class="form-label">Usuario Asociado</label>
                        <select class="form-control" id="usuario_asociado_m" name="idusuario">
                            <option value="">Sin usuario asociado</option>
                            <!-- Opciones de usuario se cargarán dinámicamente -->
                        </select>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardar-editar-cliente">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmación de eliminación -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="exampleModalLabel">Confirmar eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="listar_eliminar" name="listar_eliminar" value="eliminar">
                <input type="hidden" class="form-control" id="idcliente_e" name="idcliente_e">
                <p>¿Está seguro de que desea eliminar este cliente?</p>
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
        cargarUsuariosDisponibles();
    });

    // Función para cargar los datos en la tabla
    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al cargar los datos.</div>");
            }
        });
    }

    // Cargar usuarios disponibles en el select
    function cargarUsuariosDisponibles() {
        $.ajax({
            data: {listar: 'usuarios_disponibles'},
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#usuario_asociado").html('<option value="">Sin usuario asociado</option>' + response);
                $("#usuario_asociado_m").html('<option value="">Sin usuario asociado</option>' + response);
            },
            error: function () {
                console.error("Error al cargar usuarios disponibles.");
            }
        });
    }

    // Evento para guardar un nuevo cliente
    $("#boton-aceptar").on("click", function () {
        const cedula = $("#cli_cedula").val().trim();
        const nombre = $("#cli_nombres").val().trim();
        const apellido = $("#cli_apellidos").val().trim();
        const nacimiento = $("#cli_fechanacimiento").val().trim();
        const telefono = $("#cli_telefono").val().trim();
        const idusuarios = $("#usuario_asociado").val(); //capturamos el usuario asociado

        console.log("Datos enviados:", {
            cedula, nombre, apellido, nacimiento, telefono, idusuarios
        });
        // Validar campos obligatorios
        if (!cedula || !nombre || !apellido || !nacimiento || !telefono) {
            $("#mensaje").html("<div class='alert alert-danger'>Todos los campos marcados son obligatorios.</div>");
            return;
        }

        // Verificar duplicado de cédula
        $.ajax({
            url: 'jsp/clientesM.jsp',
            type: 'post',
            data: {listar: 'verificar_cedula', cli_cedula: cedula},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje").html("<div class='alert alert-danger'>La cédula ya está registrada. Use una diferente.</div>");
                } else if (response.trim() === "disponible") {
                    // Proceder a guardar
                    const datos = $("#form").serialize() + `&usuario_asociado=${usuarioAsociado}`; // Incluimos el usuario
                    $.ajax({
                        url: 'jsp/clientesM.jsp',
                        type: 'post',
                        data: datos,
                        success: function (response) {
                            $("#mensaje").html(response);
                            rellenardatos();
                            setTimeout(function () {
                                $("#mensaje").html("");
                                $("#form")[0].reset();
                                $("#cli_nombres").focus();
                                $("#listar").val("cargar");
                            }, 2000);
                        },
                        error: function () {
                            $("#mensaje").html("<div class='alert alert-danger'>Error al guardar el cliente.</div>");
                        }
                    });
                } else {
                    $("#mensaje").html("<div class='alert alert-danger'>Error al verificar la cédula. Inténtelo nuevamente.</div>");
                }
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al verificar la cédula. Inténtelo nuevamente.</div>");
            }
        });
    });

    // Evento para eliminar un cliente
    $("#eliminaregistro").on("click", function () {
        var listar = $("#listar_eliminar").val();
        var pk = $("#idcliente_e").val();
        $.ajax({
            data: {listar: listar, idcliente_e: pk},
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                rellenardatos();
                $("#exampleModal").modal("hide"); // Cerrar el modal automáticamente
                setTimeout(function () {
                    $("#mensaje").html("");
                }, 2000);
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el cliente.</div>");
            }
        });
    });

    // Función para cargar datos en el modal de edición
    function rellenaredit(id, nombre, apellido, nacimiento, cedula, telefono, telurgencia, usuario_asociado) {
        console.log("Datos recibidos para edición:", {id, nombre, apellido, nacimiento, cedula, telefono, telurgencia, usuario_asociado});

        // Asignar valores a los campos del modal
        $("#idcliente_m").val(id);
        $("#cli_nombres_m").val(nombre);
        $("#cli_apellidos_m").val(apellido);
        $("#cli_fechanacimiento_m").val(nacimiento);
        $("#cli_cedula_m").val(cedula);
        $("#cli_telefono_m").val(telefono);
        $("#cli_telurgencia_m").val(telurgencia);

        // Cargar usuarios disponibles y asignar el valor del usuario asociado
        $.ajax({
            data: {listar: 'usuarios_disponibles'},
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#usuario_asociado_m").html('<option value="">Sin usuario asociado</option>' + response);
                if (usuario_asociado && usuario_asociado !== "") {
                    $("#usuario_asociado_m").val(usuario_asociado); // Seleccionar el usuario asociado
                } else {
                    $("#usuario_asociado_m").val(""); // Sin usuario asociado por defecto
                }
            },
            error: function () {
                console.error("Error al cargar usuarios disponibles.");
            }
        });

        // Mostrar el modal
        $("#modalEditarCliente").modal("show");
    }



// Evento para guardar cambios desde el modal de edición
    $("#guardar-editar-cliente").on("click", function () {
        const cedula = $("#cli_cedula_m").val().trim();
        const idCliente = $("#idcliente_m").val();
        const nombre = $("#cli_nombres_m").val().trim();
        const apellido = $("#cli_apellidos_m").val().trim();
        const nacimiento = $("#cli_fechanacimiento_m").val().trim();
        const telefono = $("#cli_telefono_m").val().trim();
        const idusuario = $("#usuario_asociado_m").val(); // Capturar el usuario asociado desde el select

        // Validar campos obligatorios
        if (!cedula || !nombre || !apellido || !nacimiento || !telefono) {
            let mensaje = "<div class='alert alert-danger'>Faltan los siguientes campos obligatorios:<ul>";
            if (!nombre)
                mensaje += "<li>Nombre</li>";
            if (!apellido)
                mensaje += "<li>Apellido</li>";
            if (!cedula)
                mensaje += "<li>Cédula</li>";
            if (!nacimiento)
                mensaje += "<li>Fecha de Nacimiento</li>";
            if (!telefono)
                mensaje += "<li>Teléfono</li>";
            mensaje += "</ul></div>";
            $("#mensaje").html(mensaje);
            return;
        }

        console.log("Datos para verificar duplicado de cédula:", {cedula, idCliente});

        // Verificar duplicado de cédula, excluyendo el cliente actual
        $.ajax({
            url: 'jsp/clientesM.jsp',
            type: 'post',
            data: {listar: 'verificar_cedula', cli_cedula: cedula, idcliente: idCliente},
            success: function (response) {
                console.log("Respuesta de la verificación de cédula:", response.trim());
                if (response.trim() === "duplicado") {
                    $("#mensaje").html("<div class='alert alert-danger'>La cédula ya está registrada. Use una diferente.</div>");
                } else if (response.trim() === "disponible") {
                    // Proceder con la actualización
                    const datos = $("#formEditarCliente").serialize(); // Serializa todo el formulario
                    console.log("Datos enviados para modificar cliente:", datos);
                    $.ajax({
                        url: 'jsp/clientesM.jsp',
                        type: 'POST',
                        data: datos + '&listar=modificar',
                        success: function (response) {
                            console.log("Respuesta del servidor (Modificar):", response);
                            $("#mensaje").html(response);
                            rellenardatos(); // Recargar la tabla
                            $("#modalEditarCliente").modal("hide"); // Cerrar modal
                            setTimeout(() => $("#mensaje").html(""), 3000); // Limpiar mensajes después de 3 segundos
                        },
                        error: function () {
                            $("#mensaje").html("<div class='alert alert-danger'>Error al guardar los cambios.</div>");
                        }
                    });
                } else {
                    $("#mensaje").html("<div class='alert alert-danger'>Error al verificar la cédula. Inténtelo nuevamente.</div>");
                }
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al verificar la cédula. Inténtelo nuevamente.</div>");
            }
        });
    });

// Limpiar mensajes al cerrar el modal
    $('#modalEditarCliente').on('hidden.bs.modal', function () {
        $("#mensaje").html("");
    });


</script>

