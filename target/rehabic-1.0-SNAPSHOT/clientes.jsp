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
                        <input type="text" class="form-control" id="cli_nombres" name="cli_nombres" placeholder="Nombre">
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

                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton-cancelar">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Enlace para descargar el PDF de clientes -->
            <div class="text-end">
                <a href="Rclientes.jsp" class="btn btn-info btn-sm mb-3" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generar PDF de Clientes
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
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
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
    });

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    $("#boton-aceptar").on("click", function () {
        let dato = $("#form").serialize();
        $.ajax({
            data: dato,
            url: 'jsp/clientesM.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                rellenardatos();
                setTimeout(function () {
                    $("#mensaje").html("");
                    $("#form")[0].reset();
                    $("#cli_nombres").focus("");
                    $("#listar").val("cargar");
                }, 2000);
            }
        });
    });

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
                setTimeout(function () {
                    $("#mensaje").html("");
                }, 2000);
            }
        });
    });

    function rellenaredit(id, nombre, apellido, nacimiento, cedula, telefono, telurgencia) {
        $("#idcliente").val(id);
        $("#cli_nombres").val(nombre);
        $("#cli_apellidos").val(apellido);
        $("#cli_fechanacimiento").val(nacimiento);
        $("#cli_cedula").val(cedula);
        $("#cli_telefono").val(telefono);
        $("#cli_telurgencia").val(telurgencia);
        $("#listar").val("modificar");
    }
</script>
