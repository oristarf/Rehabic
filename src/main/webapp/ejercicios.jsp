<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Ejercicios</h4>
        </div>
        <div class="card-body">
            <!-- Formulario de Ejercicio -->
            <form class="user" id="form" method="post">
                <input type="hidden" class="form-control" id="listar" name="listar" value="cargar">
                <input type="hidden" class="form-control" id="idejercicio" name="idejercicio">

                <div class="form-group mb-3">
                    <label for="nombre" class="form-label">Nombre del ejercicio</label>
                    <input type="text" class="form-control form-control-user" id="eje_nombre" name="eje_nombre" placeholder="Nombre del Ejercicio">
                </div>
                
                <div class="form-group mb-3">
                    <label for="nombre" class="form-label">Descripción</label>
                    <input type="text" class="form-control form-control-user" id="eje_descripcion" name="eje_descripcion" placeholder="Nombre del Ejercicio">
                </div>
                

                <div class="form-group mb-3">
                    <label for="categoria" class="form-label">Categoria</label>
                    <input type="text" class="form-control form-control-user" id="eje_categoria" name="eje_categoria" placeholder="Categoria del ejercicio">
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="boton-aceptar" name="boton-aceptar">Guardar</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>
<div class="text-end">
                <a href="ListaEjercicioJR.jsp" class="btn btn-info btn-sm mb-3" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generar PDF de Ejercicios
                </a>
            </div>
            <hr>

            <!-- Tabla de Ejercicios -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Ejercicio</th>
                            <th>Descripcion</th>
                            <th>Categoria</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Datos de ejercicios se cargan aquí -->
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>
<!-- Modal de Edición de Ejercicio -->
<div class="modal fade" id="modalModificar" tabindex="-1" aria-labelledby="modalModificarLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalModificarLabel">Editar Ejercicio</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarEjercicio">
                    <input type="hidden" id="idejercicio_m" name="idejercicio">
                    <div class="form-group mb-3">
                        <label for="eje_ejercicio_m" class="form-label">Nombre del Ejercicio</label>
                        <input type="text" class="form-control" id="eje_nombre_m" name="eje_nombre" placeholder="Nombre del Ejercicio">
                    </div>
                       <div class="form-group mb-3">
                        <label for="eje_descripcion_m" class="form-label">Descripcion</label>
                        <input type="text" class="form-control" id="eje_descripcion_m" name="eje_descripcion" placeholder="Nombre del Ejercicio">
                    </div>
                    <div class="form-group mb-3">
                        <label for="eje_categoria_m" class="form-label">Categoria</label>
                        <input type="text" class="form-control" id="eje_categoria_m" name="eje_categoria" placeholder="Categoria del Ejercicio">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <div id="mensaje_modal" class="mt-3 text-center"></div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardarEditarEjercicio">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Confirmación de Eliminación -->
<div class="modal fade" id="modalEliminar" tabindex="-1" aria-labelledby="modalEliminarLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="modalEliminarLabel">Eliminar Ejercicio</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" id="idejercicio_e" name="idejercicio_e">
                <p>¿Está seguro de que desea eliminar este ejercicio?</p>
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

    // Cargar los datos de los ejercicios en la tabla
    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/ejerciciosM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    // Verificar duplicados antes de guardar
    $("#boton-aceptar").on("click", function () {
        const eje_nombre = $("#eje_nombre").val().trim();
        

        // Validar campos obligatorios
        if (!eje_nombre) {
            $("#mensaje").html("<div class='alert alert-danger'>Debe completar el nombre del ejercicio.</div>");
            return;
        }

        // Comprobación de duplicado en el campo "ejercicio" por AJAX
        $.ajax({
            url: 'jsp/ejerciciosM.jsp',
            type: 'post',
            data: {listar: 'verificar_duplicado', eje_nombre: eje_nombre},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje").html("<div class='alert alert-danger'>El ejercicio ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    // Proceder a guardar si no hay duplicado en "ejercicio"
                    let datos = $("#form").serialize();
                    $.ajax({
                        data: datos,
                        url: 'jsp/ejerciciosM.jsp',
                        type: 'post',
                        success: function (response) {
                            $("#mensaje").html(response);
                            rellenardatos();

                            setTimeout(function () {
                                $("#mensaje").html("");
                                $("#eje_nombre").val("");
                                $("#eje_descripcion").val(""); 
                                $("#eje_categoria").val("");
                                $("#listar").val("cargar");
                            }, 2000);
                        }
                    });
                }
            }
        });
    });

    // Configurar los datos en el modal de modificación
    function setModificar(id, eje_nombre, eje_descripcion, eje_categoria) {
        $('#idejercicio_m').val(id);
        $('#eje_nombre_m').val(eje_nombre);
        $('#eje_descripcion_m').val(eje_descripcion); 
        $('#eje_categoria_m').val(eje_categoria);
        $('#modalModificar').modal('show');
    }

    // Guardar cambios en el ejercicio
    $("#guardarEditarEjercicio").on("click", function () {
        const eje_nombre = $("#eje_nombre_m").val().trim();
        const eje_descripcion = $("#eje_descripcion_m").val().trim();
        const idejercicio = $("#idejercicio_m").val();

        // Validar campos obligatorios
        if (!eje_nombre) {
            $("#mensaje_modal").html("<div class='alert alert-danger'>Debe completar el nombre del ejercicio.</div>");
            return;
        }

        // Comprobar duplicados excluyendo el idejercicio actual
        $.ajax({
            url: 'jsp/ejerciciosM.jsp',
            type: 'POST',
            data: {listar: 'verificar_duplicado', eje_nombre: eje_nombre, idejercicio: idejercicio},
            success: function (response) {
                if (response.trim() === "duplicado") {
                    $("#mensaje_modal").html("<div class='alert alert-danger'>El nombre del ejercicio ya existe. Ingrese un nombre diferente.</div>");
                } else {
                    // Proceder a guardar los cambios
                    const datos = $("#formEditarEjercicio").serialize();
                    $.ajax({
                        url: 'jsp/ejerciciosM.jsp',
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

    // Configurar el ID del ejercicio a eliminar en el modal de confirmación
    function setEliminar(id) {
        $('#idejercicio_e').val(id);
    }

    // Ejecutar la eliminación al confirmar en el modal
    $("#eliminaregistro").on("click", function () {
        const idejercicio = $("#idejercicio_e").val(); // Toma el ID del ejercicio a eliminar
        $.ajax({
            data: {listar: 'eliminar', idejercicio_e: idejercicio},
            url: 'jsp/ejerciciosM.jsp',
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
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar el ejercicio.</div>");
                $("#modalEliminar").modal('hide');

                setTimeout(function () {
                    $("#mensaje").html(""); // Limpiar el mensaje
                }, 2000);
            }
        });
    });
</script>

