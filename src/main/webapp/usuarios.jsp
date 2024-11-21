

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
                <input type="hidden" class="form-control" id="idpersonal" name="idpersonal">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="usuario" class="form-label">Usuario</label>
                        <input type="text" class="form-control form-control-user" id="usuario" name="usuario" placeholder="Escriba el usuario">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="clave" class="form-label">Clave</label>
                        <input type="text" class="form-control form-control-user" id="clave" name="clave" placeholder="Clave">
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
                <input type="hidden" class="form-control" id="idpersonal_e" name="idpersonal_e">
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
                $("#rol").html('<option value="">Seleccionar rol</option>' + response);
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

    $("#boton-aceptar").on("click", function (){
    const usuario = $("#usuario").val().trim();
            if (usuario === "") {
    $("#mensaje").html("<div class='alert alert-danger'>El nombre del usuario no puede estar vacío.</div>");
            return;
    }

    //comprobar duplicado
    $.ajax({
    url: 'jsp/usuariosM.jsp',
            type: 'post',
            data: {listar: 'verificar_duplicado', usuario: usuario},
            success: function (response) {
            if (response.trim() === "duplicado") {
            $("#mensaje").html("<div class='alert alert-danger'>El usuario ya existe. Ingrese un nombre diferente.</div>");
            } else {

            dato = $("#form").serialize();
                    $.ajax({
                    data: dato,
                            url: 'jsp/usuariosM.jsp',
                            type: 'post',
                            success: function (response) {
                            $("#mensaje").html(response);
                                    rellenardatos();
                                    setTimeout(function () {

                                    $("#mensaje").html("");
                                            $("#usuario").val("");
                                            $("#clave").val("");
                                            $("#rolselect").val("");
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
            var pk = $("#idpersonal_e").val();
            $.ajax({
            data: {listar: listar, idpersonal_e: pk},
                    url: 'jsp/usuariosM.jsp',
                    type: 'post',
                    success: function (response) {
                    $("#mensaje").html(response);
                            rellenardatos();
                            setTimeout(function () {
                            $("#mensaje").html("");
                                    $("#usuario").val("");
                                    $("#clave").val("");
                                    $("#listar").val("cargar");
                            }, 2000);
                    }
            });
    });
            function rellenaredit(a, b, c, r) {
            $("#idpersonal").val(a);
                    $("#usuario").val(b);
                    $("#clave").val(c);
                    $("#rol").val(r);
                    $("#listar").val("modificar");
            }

</script>