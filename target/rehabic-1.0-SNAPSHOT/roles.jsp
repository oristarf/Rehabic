<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Gestión de Roles</h4>
        </div>
        <div class="card-body">
            <!-- Formulario para agregar o modificar roles -->
            <div class="text-center mb-4">
                <h5>Nuevo Rol</h5>
            </div>

            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idroles" name="idroles">

                <!-- Campo de entrada para el nombre del rol -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="rol" class="form-label">Nombre del Rol</label>
                        <input type="text" class="form-control" id="rol" name="rol" placeholder="Escriba el nombre del rol">
                    </div>
                </div>

                <!-- Lista de permisos -->
                <div class="mb-3">
                    <label for="permissions-container" class="form-label">Permisos</label>
                    <div id="permissions-container">
                        <!-- Los permisos se cargarán dinámicamente aquí -->
                    </div>
                </div>

                <!-- Botones del formulario -->
                <div class="d-flex justify-content-between">
                    <button class="btn btn-danger" type="reset" id="cancelar-rol"><span class="fa fa-times"></span> Cancelar</button>
                    <button type="button" name="btn-submit" id="guardar-rol" class="btn btn-primary"><span class="fa fa-save"></span> Guardar</button>
                </div>
            </form>

            <div id="mensaje" class="mt-3 text-center"></div>

            <hr>

            <!-- Tabla para listar los roles -->
            <div class="table-responsive mt-4">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Rol</th>
                            <th>Permisos</th> <!-- Nueva columna -->
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal para modificar roles -->
<div class="modal fade" id="modalModificar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="exampleModalLabel">Modificar Rol</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Campo oculto para el ID del rol -->
                <input type="hidden" id="idrol_m" name="idrol_m">

                <!-- Campo para el nombre del rol -->
                <label for="rol_edit" class="form-label">Nombre del Rol</label>
                <input type="text" class="form-control" id="rol_edit" name="rol" placeholder="Nombre del rol">

                <!-- Contenedor de permisos -->
                <label class="form-label mt-3">Permisos</label>
                <div id="permissions-container-edit">
                    <!-- Los permisos asociados se cargarán dinámicamente aquí -->
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-danger" type="button" data-bs-dismiss="modal" id="cancelar-modificar"><span class="fa fa-times"></span> Cancelar</button>
                <button class="btn btn-primary" type="button" id="guardar-modificar"><span class="fa fa-save"></span> Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal para eliminar roles -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="exampleModalLabel">Confirmar Eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro de que desea eliminar este rol?</p>
                <input type="hidden" name="idrol_e" id="idrol_e" />
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
        rellenardatos(); // Cargar la tabla de roles al iniciar
        cargarPermisos(); // Cargar permisos disponibles para nuevos roles
    });

    // Función para cargar la tabla de roles
    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/rolesM.jsp',
            type: 'POST',
            success: function (response) {
                $("#resultado tbody").html(response); // Actualiza la tabla
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar datos:", error);
            }
        });
    }

    // Función para cargar los permisos disponibles al crear un rol
    function cargarPermisos() {
        $.ajax({
            url: 'jsp/buscar_permisos.jsp',
            type: 'POST',
            data: {action: 'listar'},
            success: function (response) {
                $("#permissions-container").html(response); // Permisos para nuevos roles
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar permisos:", error);
            }
        });
    }

    // Evento para el botón "Guardar" (Registrar un nuevo rol)
    $("#guardar-rol").on("click", function () {
        var datos = $("#form").serialize(); // Serializa los datos del formulario
        $.ajax({
            url: 'jsp/rolesM.jsp',
            type: 'POST',
            data: datos,
            success: function (response) {
                console.log("Respuesta del servidor (Guardar):", response);
                $("#mensaje").html(response); // Mostrar mensaje en la interfaz
                rellenardatos(); // Recargar la tabla de roles
                $("#form")[0].reset(); // Resetea el formulario
            },
            error: function (xhr, status, error) {
                console.error("Error al guardar el rol:", error);
                $("#mensaje").html("<div class='alert alert-danger'>Error al guardar el rol.</div>");
            }
        });
    });

    // Evento para el botón "Guardar" en el modal de modificación
    $("#guardar-modificar").on("click", function () {
        var datos = {
            listar: "modificar",
            idrol_m: $("#idrol_m").val(),
            rol: $("#rol_edit").val(),
            permisos: $("input[name='permisos']:checked").map(function () {
                return $(this).val();
            }).get()
        };

        if (!datos.rol.trim()) {
            $("#mensaje").html("<div class='alert alert-danger'>El nombre del rol no puede estar vacío.</div>");
            return;
        }

        $.ajax({
            url: 'jsp/rolesM.jsp',
            type: 'POST',
            data: datos,
            traditional: true, // Permite enviar arrays
            success: function (response) {
                console.log("Respuesta del servidor (Modificar):", response);
                $("#mensaje").html(response);
                rellenardatos();
                $("#modalModificar").modal("hide");
            },
            error: function (xhr, status, error) {
                console.error("Error al modificar el rol:", error);
                $("#mensaje").html("<div class='alert alert-danger'>Error al modificar el rol.</div>");
            }
        });
    });


    // Evento para eliminar un rol con confirmación
    $("#eliminaregistro").on("click", function () {
        var idRol = $("#idrol_e").val(); // Obtiene el ID del rol
        if (confirm("¿Está seguro de que desea eliminar este rol? Esto también eliminará sus permisos asociados.")) {
            $.ajax({
                data: {listar: "eliminar", idrol_e: idRol},
                url: 'jsp/rolesM.jsp',
                type: 'POST',
                success: function (response) {
                    console.log("Respuesta del servidor (Eliminar):", response);
                    $("#mensaje").html(response); // Muestra el mensaje del servidor
                    rellenardatos(); // Recarga la tabla de roles
                    $("#exampleModal").modal("hide"); // Cierra el modal
                },
                error: function (xhr, status, error) {
                    console.error("Error al eliminar el rol:", error);
                    $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el rol.</div>");
                }
            });
        } else {
            console.log("Eliminación cancelada.");
        }
    });



// Función para asignar ID de rol al modal de eliminación
    function setEliminar(id) {
        console.log("Rol seleccionado para eliminar:", id); // Verificar el ID que se pasa al modal
        $("#idrol_e").val(id); // Asigna el ID al campo oculto
        $("#exampleModal").modal("show"); // Abre el modal
    }


    // Función para abrir el modal y modificar un rol existente
    function setModificar(id, rol) {
        console.log("ID del rol recibido en setModificar:", id);
        console.log("Nombre del rol recibido en setModificar:", rol);

        // Asignar valores al formulario
        $("#idrol_m").val(id); // Asigna el ID al campo oculto
        $("#rol_edit").val(rol); // Asigna el nombre al campo de texto
        $("#listar").val("modificar"); // Define la acción como "modificar"

        // Cargar los permisos asociados al rol
        $.ajax({
            url: 'jsp/buscar_permisos.jsp',
            type: 'POST',
            data: {action: 'listar', idroles: id},
            success: function (response) {
                console.log("Permisos cargados:", response);
                $("#permissions-container-edit").html(response); // Cargar permisos en el modal
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar permisos:", error);
            }
        });

        $("#modalModificar").modal("show"); // Abre el modal
    }
</script>



