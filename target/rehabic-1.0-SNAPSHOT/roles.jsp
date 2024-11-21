<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Roles</h4>
        </div>
        <div class="card-body">
            <div class="text-center mb-4">
            </div>

            <!-- Formulario de Rol -->
            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idroles" name="idroles">

                <div class="form-group mb-3">
                    <label for="rol" class="form-label">Nombre del Rol</label>
                    <input type="text" class="form-control form-control-user" id="rol" name="rol" placeholder="Nombre del Rol">
                    <div id="error-rol" class="text-danger mt-2"></div>
                </div>
                <!-- Selección de Permisos -->
                <div class="form-group mb-3">
                    <label class="form-label">Asignar Permisos</label>
                    <div id="permisos-list" class="form-check">
                        <!-- Aquí se cargarán los permisos disponibles desde rolesM.jsp -->
                    </div>
                </div>
                <!-- Botones -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Tabla de Roles -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Rol</th>
                            <th>Permisos</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Datos de roles -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Modificar Rol -->
<div class="modal fade" id="modalModificar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="exampleModalLabel">Modificar Rol</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="listar_modificar" name="listar_modificar" value="modificar">
                <input type="hidden" class="form-control" id="idroles_m" name="idroles_m">
                
                <!-- Campo para modificar nombre del rol -->
                <label for="rol" class="form-label">Nombre de Rol</label>
                <input type="text" class="form-control" id="rol_m" name="rol">
                <div id="error-rol" class="text-danger mt-2"></div>
                
                <!-- Campo para seleccionar permisos -->
                <div class="form-group mb-3 mt-4">
                    <label class="form-label">Modificar Permisos</label>
                    <div id="permisos-list-modificar" class="form-check">
                        <!-- Aquí se cargarán los permisos disponibles y seleccionados del rol -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="modificar-guardar">Guardar Cambios</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Confirmación de Eliminación -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Rol</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="listar_eliminar" name="listar_eliminar" value="eliminar">
                <input type="hidden" class="form-control" id="idroles_e" name="idroles_e">
                <p>¿Está seguro de que desea eliminar este rol?</p>
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
        cargarPermisos();
    });

    function rellenardatos() {
        $.ajax({
            data: { listar: 'listar' },
            url: 'jsp/rolesM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            },
            error: function () {
                alert("Error al cargar los datos de los roles. Por favor, intente nuevamente.");
            }
        });
    }

    function cargarPermisos() {
        $.ajax({
            data: { listar: 'listar_permisos' },
            url: 'jsp/rolesM.jsp',
            type: 'post',
            success: function (response) {
                $("#permisos-list").html(response); // Inserta permisos para el registro
            },
            error: function () {
                alert("Error al cargar los permisos. Por favor, intente nuevamente.");
            }
        });
    }

    $("#boton-aceptar").on("click", function () {
        var rol = $("#rol").val().trim();
        var permisosSeleccionados = [];

        $("input[name='permisos']:checked").each(function () {
            permisosSeleccionados.push($(this).val());
        });

        if ($("#error-rol").text() === "") {
            var datos = $("#form").serialize() + "&permisos=" + permisosSeleccionados.join(",");
            $.ajax({
                data: datos,
                url: 'jsp/rolesM.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    rellenardatos();
                    $("#rol").val("");
                    cargarPermisos();
                },
                error: function () {
                    alert("Error al guardar el rol. Por favor, intente nuevamente.");
                }
            });
        }
    });

    $("#eliminaregistro").on("click", function () {
        var idroles = $("#idroles_e").val();
        $.ajax({
            data: { listar: "eliminar", idroles_e: idroles },
            url: 'jsp/rolesM.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                rellenardatos();
            },
            error: function () {
                alert("Error al eliminar el rol. Por favor, intente nuevamente.");
            }
        });
    });

    $("#modificar-guardar").on("click", function () {
        var idroles = $("#idroles_m").val();
        var rol = $("#rol_m").val().trim();
        var permisosSeleccionados = [];

        $("input[name='permisos']:checked").each(function () {
            permisosSeleccionados.push($(this).val());
        });

        if (rol !== "") {
            $.ajax({
                data: { listar: "modificar", idroles_m: idroles, rol: rol, permisos: permisosSeleccionados.join(",") },
                url: 'jsp/rolesM.jsp',
                type: 'post',
                success: function (response) {
                    alert(response);
                    rellenardatos();
                    $("#modalModificar").modal('hide');
                },
                error: function () {
                    alert("Error al modificar el rol. Por favor, intente nuevamente.");
                }
            });
        } else {
            alert("El nombre del rol no puede estar vacío.");
        }
    });

    function setModificar(id, rol) {
        $('#idroles_m').val(id);
        $('#rol_m').val(rol);

        // Cargar permisos para el rol seleccionado
        $.ajax({
            data: { listar: "listar_permisos", idroles: id },
            url: 'jsp/rolesM.jsp',
            type: 'post',
            success: function (response) {
                $("#permisos-list-modificar").html(response);
            },
            error: function () {
                alert("Error al cargar permisos para modificar.");
            }
        });
    }
</script>
