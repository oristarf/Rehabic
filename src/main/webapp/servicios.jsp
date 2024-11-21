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
                    <label for="descripcion" class="form-label">Descripción</label>
                    <input type="text" class="form-control form-control-user" id="ser_descripcion" name="ser_descripcion" placeholder="Descripción del Servicio">
                </div>
                <div class="form-group mb-3">
                    <label for="costo" class="form-label">Costo</label>
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
                            <th>Descripción</th>
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
        if (ser_nombre === "") {
            $("#mensaje").html("<div class='alert alert-danger'>El nombre del servicio no puede estar vacío.</div>");
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
                                $("#ser_descripcion").val("");
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
    function setModificar(id, ser_nombre, ser_descripcion, ser_precio) {
        $('#idservicio').val(id);
        $('#ser_nombre').val(ser_nombre);
        $('#ser_descripcion').val(ser_descripcion);
        $('#ser_precio').val(ser_precio);
        $('#listar').val('modificar');
    }

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
                $("#mensaje").html(response);
                rellenardatos(); // Refresca la tabla para mostrar los cambios
                setTimeout(function () {
                    $("#mensaje").html("");
                    $("#modalEliminar").modal('hide'); // Cierra el modal de eliminación
                }, 2000);
            }
        });
    });
</script>
