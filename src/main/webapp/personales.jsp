<%@include file="header.jsp"%>
<div class="container-fluid mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Personales</h4>
        </div>
        <div class="card-body">
            <div class="text-center mb-4"></div>

            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idpersonal" name="idpersonal">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="per_nombres" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="per_nombres" name="per_nombres" placeholder="Nombre" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="per_apellidos" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="per_apellidos" name="per_apellidos" placeholder="Apellido">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="per_cedula" class="form-label">Cédula</label>
                        <input type="text" class="form-control" id="per_cedula" name="per_cedula" placeholder="Cédula">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="per_email" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="per_email" name="per_email" placeholder="Correo Electrónico">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="per_telefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="per_telefono" name="per_telefono" placeholder="Teléfono">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="per_direccion" class="form-label">Dirección</label>
                        <input type="text" class="form-control" id="per_direccion" name="per_direccion" placeholder="Dirección">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="fecha_contratacion" class="form-label">Fecha de Contratación</label>
                        <input type="date" class="form-control" id="fecha_contratacion" name="fecha_contratacion" placeholder="Fecha de Contratación">
                    </div>
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

            <!-- Tabla de Personales -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>Cédula</th>
                            <th>Correo Electrónico</th>
                            <th>Teléfono</th>
                            <th>Dirección</th>
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

<!-- Modal para editar personal -->
<div class="modal fade" id="modalEditarPersonal" tabindex="-1" aria-labelledby="editarPersonalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editarPersonalLabel">Editar Personal</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarPersonal">
                    
                    <input type="hidden" id="idpersonal_m" name="idpersonal">
                    <div class="mb-3">
                        <label for="per_nombres_m" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="per_nombres_m" name="per_nombres">
                    </div>
                    <div class="mb-3">
                        <label for="per_apellidos_m" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="per_apellidos_m" name="per_apellidos">
                    </div>
                    <div class="mb-3">
                        <label for="per_cedula_m" class="form-label">Cédula</label>
                        <input type="text" class="form-control" id="per_cedula_m" name="per_cedula">
                    </div>
                    <div class="mb-3">
                        <label for="per_email_m" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="per_email_m" name="per_email">
                    </div>
                    <div class="mb-3">
                        <label for="per_telefono_m" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="per_telefono_m" name="per_telefono">
                    </div>
                    <div class="mb-3">
                        <label for="per_direccion_m" class="form-label">Dirección</label>
                        <input type="text" class="form-control" id="per_direccion_m" name="per_direccion">
                    </div>
                    <div class="mb-3">
                        <label for="fecha_contratacion_m" class="form-label">Fecha de Contratación</label>
                        <input type="date" class="form-control" id="fecha_contratacion_m" name="fecha_contratacion">
                    </div>

                    <div class="mb-3">
                        <label for="usuario_asociado_m" class="form-label">Usuario Asociado</label>
                        <select class="form-control" id="usuario_asociado_m" name="idusuarios">
                            <option value="">Sin usuario asociado</option>
                            <!-- Opciones de usuario se cargarán dinámicamente -->
                        </select>
                    </div>
                    <div id="mensaje-modal" class="mb-3 text-center"></div> <!-- Contenedor para mensajes -->
                </form>
            </div>
            <div class="modal-footer">
                
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardar-editar-personal">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmación de eliminación -->
<div class="modal fade" id="modalEliminarPersonal" tabindex="-1" aria-labelledby="eliminarPersonalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarPersonalLabel">Confirmar eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="listar_eliminar" name="listar_eliminar" value="eliminar">
                <input type="hidden" class="form-control" id="idpersonal_e" name="idpersonal_e">
                <p>¿Está seguro de que desea eliminar este personal?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                <button type="button" class="btn btn-danger" id="eliminarPersonal">Sí, eliminar</button>
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
            url: 'jsp/personalesM.jsp',
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
            url: 'jsp/personalesM.jsp',
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

// Evento para guardar un nuevo personal
  $("#boton-aceptar").on("click", function () {
    const cedula = $("#per_cedula").val().trim();
    const nombre = $("#per_nombres").val().trim();
    const apellido = $("#per_apellidos").val().trim();
    const email = $("#per_email").val().trim();
    const telefono = $("#per_telefono").val().trim();
    const direccion = $("#per_direccion").val().trim();
    const idusuarios = $("#usuario_asociado").val(); // Puede ser vacío

    console.log("Datos enviados:", { cedula, nombre, apellido, email, telefono, direccion, idusuarios });

    // Validar campos obligatorios
    let camposFaltantes = [];
    if (!cedula) camposFaltantes.push("Cédula");
    if (!nombre) camposFaltantes.push("Nombre");
    if (!apellido) camposFaltantes.push("Apellido");
    if (!email) camposFaltantes.push("Correo electrónico");
    if (!telefono) camposFaltantes.push("Teléfono");

    // Validar formato del correo electrónico
    const correoRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (email && !correoRegex.test(email)) {
        $("#mensaje").html("<div class='alert alert-danger'>El correo ingresado no es válido.</div>");
        return;
    }

    if (camposFaltantes.length > 0) {
        const mensaje = `<div class='alert alert-danger'>Faltan los siguientes campos obligatorios:<ul><li>${camposFaltantes.join(
            "</li><li>"
        )}</li></ul></div>`;
        $("#mensaje").html(mensaje);
        return;
    }

    // Verificar duplicado de cédula
    $.ajax({
        url: 'jsp/personalesM.jsp',
        type: 'post',
        data: { listar: 'verificar_cedula', per_cedula: cedula },
        success: function (response) {
            if (response.trim() === "duplicado") {
                $("#mensaje").html("<div class='alert alert-danger'>La cédula ya está registrada. Use una diferente.</div>");
            } else if (response.trim() === "disponible") {
                // Proceder a guardar
                const datos = $("#form").serialize();
                $.ajax({
                    url: 'jsp/personalesM.jsp',
                    type: 'post',
                    data: datos + `&idusuarios=${idusuarios || ''}&listar=cargar`, // Incluimos idusuarios si está disponible
                    success: function (response) {
                        $("#mensaje").html(response);
                        rellenardatos(); // Actualizamos la tabla
                        setTimeout(function () {
                            $("#mensaje").html("");
                            $("#form")[0].reset(); // Limpiamos el formulario
                            $("#per_nombres").focus(); // Colocamos el cursor en el campo de nombre
                        }, 2000);
                    },
                    error: function () {
                        $("#mensaje").html("<div class='alert alert-danger'>Error al guardar el personal.</div>");
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



    // Evento para eliminar un personal
    $("#eliminarPersonal").on("click", function () {
        var listar = $("#listar_eliminar").val();
        var pk = $("#idpersonal_e").val();
        $.ajax({
            data: {listar: listar, idpersonal_e: pk},
            url: 'jsp/personalesM.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                rellenardatos();
                $("#modalEliminarPersonal").modal("hide");
                setTimeout(function () {
                    $("#mensaje").html("");
                }, 2000);
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el personal.</div>");
            }
        });
    });

    // Función para cargar datos en el modal de edición
    function rellenaredit(id, nombre, apellido, cedula, email, telefono, direccion, usuario_asociado) {
        console.log("Datos recibidos para edición:", {id, nombre, apellido, cedula, email, telefono, direccion, usuario_asociado});

        // Asignar valores a los campos del modal
        $("#idpersonal_m").val(id);
        $("#per_nombres_m").val(nombre);
        $("#per_apellidos_m").val(apellido);
        $("#per_cedula_m").val(cedula);
        $("#per_email_m").val(email);
        $("#per_telefono_m").val(telefono);
        $("#per_direccion_m").val(direccion);

        // Cargar usuarios disponibles y asignar el valor del usuario asociado
        $.ajax({
            data: {listar: 'usuarios_disponibles'},
            url: 'jsp/personalesM.jsp',
            type: 'post',
            success: function (response) {
                $("#usuario_asociado_m").html('<option value="">Sin usuario asociado</option>' + response);
                if (usuario_asociado && usuario_asociado !== "") {
                    $("#usuario_asociado_m").val(usuario_asociado);
                } else {
                    $("#usuario_asociado_m").val("");
                }
            },
            error: function () {
                console.error("Error al cargar usuarios disponibles.");
            }
        });

        $("#modalEditarPersonal").modal("show");
    }

// Evento para guardar cambios desde el modal de edición
   $("#guardar-editar-personal").on("click", function () {
    const cedula = $("#per_cedula_m").val().trim();
    const idPersonal = $("#idpersonal_m").val();
    const nombre = $("#per_nombres_m").val().trim();
    const apellido = $("#per_apellidos_m").val().trim();
    const email = $("#per_email_m").val().trim();
    const telefono = $("#per_telefono_m").val().trim();
    const direccion = $("#per_direccion_m").val().trim();
    const idusuario = $("#usuario_asociado_m").val();

    if (!cedula || !nombre || !apellido || !email || !telefono) {
        let mensaje = "<div class='alert alert-danger'>Faltan los siguientes campos obligatorios:<ul>";
        if (!nombre) mensaje += "<li>Nombre</li>";
        if (!apellido) mensaje += "<li>Apellido</li>";
        if (!cedula) mensaje += "<li>Cédula</li>";
        if (!email) mensaje += "<li>Correo Electrónico</li>";
        if (!telefono) mensaje += "<li>Teléfono</li>";
        mensaje += "</ul></div>";
        $("#mensaje-modal").html(mensaje); // Mostrar mensaje en el modal
        return;
    }

    // Enviar datos para modificación
    $.ajax({
        url: 'jsp/personalesM.jsp',
        type: 'post',
        data: {
            listar: 'modificar',
            idpersonal: idPersonal,
            per_cedula: cedula,
            per_nombres: nombre,
            per_apellidos: apellido,
            per_email: email,
            per_telefono: telefono,
            per_direccion: direccion,
            idusuarios: idusuario,
        },
        success: function (response) {
            if (response.includes("alert-danger")) {
                // Si hay error, mostrar mensaje en el modal
                $("#mensaje-modal").html(response);
            } else {
                // Si es exitoso, cerrar el modal y recargar la tabla
                $("#mensaje-modal").html("");
                $("#mensaje").html(response);
                rellenardatos();
                $("#modalEditarPersonal").modal("hide");
                setTimeout(() => $("#mensaje").html(""), 3000);
            }
        },
        error: function () {
            $("#mensaje-modal").html("<div class='alert alert-danger'>Error al guardar los cambios.</div>");
        },
    });
});

</script>
