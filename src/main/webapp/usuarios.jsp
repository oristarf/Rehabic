

<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Usuarios</h4>
        </div>
        <div class="card-body">
            <div class="text-center mb-4">
            </div>

            <!-- Formulario de Usuario -->
            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idusuarios" name="idusuarios">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="usuario" class="form-label">Usuario</label>
                        <input type="text" class="form-control form-control-user" id="usuario" name="usuario" placeholder="Escriba el usuario">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="clave" class="form-label">Clave</label>
                        <input type="password" class="form-control form-control-user" id="clave" name="clave" placeholder="Clave">
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label for="rol" class="form-label">Rol</label>
                    <select class="form-control" id="rol" name="rol">
                        <option value="">Seleccionar rol</option>
                        <!-- Opciones de rol -->
                    </select>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton-cancelar">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Tabla de Usuarios -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Usuario</th>
                            <th>Clave</th>
                            <th>Rol</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Datos de usuarios -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- Modal para Editar Usuario -->
<div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-labelledby="editarUsuarioLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editarUsuarioLabel">Editar Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarUsuario">
                    <input type="hidden" id="idusuarios_m" name="idusuarios">

                    <div class="mb-3">
                        <label for="usuario_m" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="usuario_m" name="usuario" placeholder="Escriba el usuario">
                    </div>
                    <div class="mb-3">
                        <label for="clave_m" class="form-label">Clave</label>
                        <input type="password" class="form-control" id="clave_m" name="clave" placeholder="Clave">
                    </div>
                    <div class="mb-3">
                        <label for="rol_m" class="form-label">Rol</label>
                        <select class="form-control" id="rol_m" name="rol">
                            <option value="">Seleccionar rol</option>
                            <!-- Opciones de rol -->
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardarEditarUsuario">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Confirmación de Eliminación -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="exampleModalLabel">Confirmar Eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="listar_eliminar" name="listar_eliminar" value="eliminar">
                <input type="hidden" class="form-control" id="idusuarios_e" name="idusuarios_e">
                <p>¿Está seguro de que desea eliminar este usuario?</p>
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
        rellenarrol();

    });
    function rellenarrol() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/roles.jsp',
            type: 'post',
            success: function (response) {
                // Actualizar los select de roles
                $("#rol").html('<option value="">Seleccionar rol</option>' + response);
                $("#rol_m").html('<option value="">Seleccionar rol</option>' + response);
            }
        });
    }

    function rellenardatos() {

        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/usuariosM.jsp',
            type: 'post',

            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });

    }

    $("#boton-aceptar").on("click", function () {
        const usuario = $("#usuario").val().trim();
        if (usuario === "") {
            $("#mensaje").html("<div class='alert alert-danger'>El nombre del usuario no puede estar vacío.</div>");
            return;
        }

        // Comprobar duplicado
        $.ajax({
            url: 'jsp/usuariosM.jsp',
            type: 'post',
            data: {listar: 'verificar_duplicado', usuario: usuario},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje").html("<div class='alert alert-danger'>El usuario ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    let datos = $("#form").serialize();
                    $.ajax({
                        data: datos,
                        url: 'jsp/usuariosM.jsp',
                        type: 'post',
                        success: function (response) {
                            $("#mensaje").html(response);
                            rellenardatos();
                            setTimeout(function () {
                                // Limpiar los campos
                                $("#mensaje").html("");
                                $("#usuario").val("");
                                $("#clave").val("");
                                $("#rol").val(""); // Limpia el select de roles
                                $("#usuario").focus("");
                                $("#listar").val("cargar");
                            }, 2000);
                        }
                    });
                }
            }
        });
    });

    $("#eliminaregistro").on("click", function () {
        var listar = $("#listar_eliminar").val();
        var pk = $("#idusuarios_e").val();

        $.ajax({
            data: {listar: listar, idusuarios_e: pk},
            url: 'jsp/usuariosM.jsp',
            type: 'post',
            success: function (response) {
                // Mostrar el mensaje en la página principal
                $("#mensaje").html(response);

                // Recargar la tabla de usuarios
                rellenardatos();

                // Cerrar el modal de confirmación de eliminación
                $("#exampleModal").modal("hide");

                // Limpiar el mensaje tras un tiempo
                setTimeout(function () {
                    $("#mensaje").html("");
                }, 2000);
            },
            error: function () {
                // Manejar el error si ocurre
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el usuario.</div>");
            }
        });
    });

    function rellenaredit(id, usuario, clave, rol) {
        // Asignar valores al modal
        $("#idusuarios_m").val(id);
        $("#usuario_m").val(usuario);
        $("#clave_m").val(clave);
        $("#rol_m").val(rol); // Seleccionar el rol actual
        $("#modalEditarUsuario").modal("show");
    }


    $("#guardarEditarUsuario").on("click", function () {
        const usuario = $("#usuario_m").val().trim();
        const idusuarios = $("#idusuarios_m").val(); // ID del usuario actual

        // Verificar campos obligatorios
        if (!usuario || !$("#clave_m").val().trim() || !$("#rol_m").val().trim()) {
            $("#mensaje_modal").html("<div class='alert alert-danger'>Todos los campos obligatorios deben ser completados.</div>");
            return;
        }

        // Comprobar duplicado (excluyendo el usuario actual)
        $.ajax({
            url: 'jsp/usuariosM.jsp',
            type: 'POST',
            data: {listar: 'verificar_duplicado', usuario: usuario, idusuarios: idusuarios},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje_modal").html("<div class='alert alert-danger'>El usuario ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    // Proceder a guardar los cambios
                    const datos = $("#formEditarUsuario").serialize();
                    $.ajax({
                        url: 'jsp/usuariosM.jsp',
                        type: 'POST',
                        data: datos + '&listar=modificar',
                        success: function (response) {
                            $("#mensaje").html(response); // Mostrar mensaje en la página principal
                            rellenardatos(); // Actualizar la tabla
                            $("#modalEditarUsuario").modal("hide"); // Cerrar el modal
                        },
                        error: function () {
                            $("#mensaje_modal").html("<div class='alert alert-danger'>Error al guardar los cambios.</div>");
                        }
                    });
                }
            },
            error: function () {
                $("#mensaje_modal").html("<div class='alert alert-danger'>Error al verificar el usuario.</div>");
            }
        });
    });


</script>