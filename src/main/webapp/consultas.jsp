<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <!-- Card Container -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Registro de Consultas</h4>
        </div>
        <div class="card-body">
            <div class="text-center mb-4">
            </div>

            <form class="user" id="formConsulta" method="post">
                <input type="hidden" id="listar" name="listar" value="cargar">
                <input type="hidden" id="idconsulta" name="idconsulta">

                <!-- Selección de Cliente -->
                <div class="form-group mb-3">
                    <label for="buscarCliente" class="form-label">Buscar Cliente:</label>
                    <input type="text" id="buscarCliente" class="form-control" placeholder="Escriba el nombre o apellido del cliente">
                    <input type="hidden" id="idcliente" name="idcliente">
                    <div id="resultadosClientes" class="list-group mt-2"></div>
                </div>

                <!-- Información de la consulta -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="fecha_consulta" class="form-label">Fecha de Consulta</label>
                        <input type="date" class="form-control" id="fecha_consulta" name="fecha_consulta" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="medico_tratante" class="form-label">Médico Tratante</label>
                        <input type="text" class="form-control" id="medico_tratante" name="medico_tratante" placeholder="Nombre del médico">
                    </div>
                </div>

                <!-- More Fields in Row for Better Spacing -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="medico_tel" class="form-label">Teléfono del Médico</label>
                        <input type="text" class="form-control" id="medico_tel" name="medico_tel" placeholder="Teléfono del médico">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="motivo_consulta" class="form-label">Motivo de Consulta</label>
                        <input type="text" class="form-control" id="motivo_consulta" name="motivo_consulta" placeholder="Motivo de la consulta">
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label for="aea" class="form-label">AEA</label>
                    <textarea id="aea" name="aea" rows="3" class="form-control"></textarea>
                </div>

                <div class="form-group mb-3">
                    <label for="estudios_complementarios" class="form-label">Estudios Complementarios</label>
                    <textarea id="estudios_complementarios" name="estudios_complementarios" rows="3" class="form-control"></textarea>
                </div>

                <!-- Remaining Fields -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="evaluacion_goniometria" class="form-label">Evaluación Goniometría</label>
                        <textarea id="evaluacion_goniometria" name="evaluacion_goniometria" rows="3" class="form-control"></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="pruebas_musculares" class="form-label">Pruebas Musculares</label>
                        <textarea id="pruebas_musculares" name="pruebas_musculares" rows="3" class="form-control"></textarea>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="pruebas_especificas" class="form-label">Pruebas Específicas</label>
                        <textarea id="pruebas_especificas" name="pruebas_especificas" rows="3" class="form-control"></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="impresion_diagnostica" class="form-label">Impresión Diagnóstica</label>
                        <textarea id="impresion_diagnostica" name="impresion_diagnostica" rows="3" class="form-control"></textarea>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label for="plan_tratamiento" class="form-label">Plan de Tratamiento</label>
                    <textarea id="plan_tratamiento" name="plan_tratamiento" rows="3" class="form-control"></textarea>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-primary" id="guardarConsulta">Guardar</button>
                    <button type="reset" class="btn btn-secondary">Cancelar</button>
                </div>

                <div id="mensaje" class="mt-3 text-center"></div>
            </form>

            <hr>

            <!-- Tabla de consultas -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="resultado" width="100%" cellspacing="0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Cliente</th>
                            <th>Fecha de Consulta</th>
                            <th>Médico Tratante</th>
                            <th>Teléfono del Médico</th>
                            <th>Motivo de Consulta</th>
                            <th>AEA</th>
                            <th>Estudios Complementarios</th>
                            <th>Evaluación Goniometría</th>
                            <th>Pruebas Musculares</th>
                            <th>Pruebas Específicas</th>
                            <th>Impresión Diagnóstica</th>
                            <th>Plan de Tratamiento</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="modalEditarConsulta" tabindex="-1" aria-labelledby="editarConsultaLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editarConsultaLabel">Editar Consulta</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formEditarConsulta">
                    <input type="hidden" id="idconsulta_m" name="idconsulta">
                    <input type="hidden" id="idcliente_m" name="idcliente">

                    <div class="form-group mb-3">
                        <label for="buscarCliente_m" class="form-label">Cliente:</label>
                        <input type="text" id="buscarCliente_m" class="form-control" placeholder="Escriba el nombre o apellido del cliente">
                        <div id="resultadosClientes_m" class="list-group mt-2"></div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="fecha_consulta_m" class="form-label">Fecha de Consulta</label>
                            <input type="date" class="form-control" id="fecha_consulta_m" name="fecha_consulta">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="medico_tratante_m" class="form-label">Médico Tratante</label>
                            <input type="text" class="form-control" id="medico_tratante_m" name="medico_tratante">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="medico_tel_m" class="form-label">Teléfono del Médico</label>
                            <input type="text" class="form-control" id="medico_tel_m" name="medico_tel">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="motivo_consulta_m" class="form-label">Motivo de Consulta</label>
                            <input type="text" class="form-control" id="motivo_consulta_m" name="motivo_consulta">
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="aea_m" class="form-label">AEA</label>
                        <textarea id="aea_m" name="aea" rows="3" class="form-control"></textarea>
                    </div>

                    <div class="form-group mb-3">
                        <label for="estudios_complementarios_m" class="form-label">Estudios Complementarios</label>
                        <textarea id="estudios_complementarios_m" name="estudios_complementarios" rows="3" class="form-control"></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="evaluacion_goniometria_m" class="form-label">Evaluación Goniometría</label>
                            <textarea id="evaluacion_goniometria_m" name="evaluacion_goniometria" rows="3" class="form-control"></textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="pruebas_musculares_m" class="form-label">Pruebas Musculares</label>
                            <textarea id="pruebas_musculares_m" name="pruebas_musculares" rows="3" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="pruebas_especificas_m" class="form-label">Pruebas Específicas</label>
                            <textarea id="pruebas_especificas_m" name="pruebas_especificas" rows="3" class="form-control"></textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="impresion_diagnostica_m" class="form-label">Impresión Diagnóstica</label>
                            <textarea id="impresion_diagnostica_m" name="impresion_diagnostica" rows="3" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="plan_tratamiento_m" class="form-label">Plan de Tratamiento</label>
                        <textarea id="plan_tratamiento_m" name="plan_tratamiento" rows="3" class="form-control"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <div id="mensaje_modal" class="mt-3 text-center"></div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="guardar-editar-consulta">Guardar</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalEliminarConsulta" tabindex="-1" aria-labelledby="eliminarConsultaLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarConsultaLabel">Confirmar Eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="idconsulta_e">
                <p>¿Está seguro de que desea eliminar esta consulta?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger" id="eliminarConsulta">Eliminar</button>
            </div>
        </div>
    </div>
</div>



<%@include file="footer.jsp"%>


<script>
    $(document).ready(function () {
        rellenardatos();
    });

    // Filtrar clientes en tiempo real
    $("#buscarCliente").on("keyup", function () {
        const query = $(this).val();
        $("#idcliente").val("");
        $("#resultadosClientes").html("");

        if (query.length > 0) {
            $.ajax({
                url: "jsp/consultasM.jsp",
                type: "POST",
                data: {listar: "buscar_cliente", query: query},
                success: function (response) {
                    $("#resultadosClientes").html(response);
                }
            });
        }
    });

    // Seleccionar cliente
    $(document).on("click", ".cliente-item", function () {
        const clienteId = $(this).data("id");
        const clienteNombre = $(this).text().trim();

        $("#buscarCliente").val(clienteNombre);
        $("#idcliente").val(clienteId);
        $("#resultadosClientes").html("");
    });

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/consultasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    }

    // Obtener el nombre del cliente por ID
    function obtenerNombreCliente(clienteId) {
        return $.ajax({
            url: 'jsp/obtenerNombreCliente.jsp',
            type: 'POST',
            data: {idcliente: clienteId},
            dataType: 'text'
        });
    }

    $("#guardarConsulta").on("click", function () {
        let datos = $("#formConsulta").serialize();
        $.ajax({
            data: datos,
            url: 'jsp/consultasM.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                rellenardatos();
                setTimeout(function () {
                    $("#mensaje").html("");
                    $("#formConsulta")[0].reset();
                    $("#buscarCliente").focus("");
                    $("#listar").val("cargar");
                }, 2000);
            }
        });
    });


    // Rellenar el formulario para editar la consulta
    function rellenaredit(
            id, clienteId, fechaConsulta, medicoTratante, medicoTel, motivoConsulta,
            aea, estudiosComplementarios, evaluacionGoniometria, pruebasMusculares,
            pruebasEspecificas, impresionDiagnostica, planTratamiento
            ) {
        console.log("Datos recibidos para editar:");
        console.log("ID de la Consulta:", id);
        console.log("ID del Cliente:", clienteId);
        console.log("Fecha de Consulta:", fechaConsulta);
        console.log("Médico Tratante:", medicoTratante);
        console.log("Teléfono del Médico:", medicoTel);
        console.log("Motivo de Consulta:", motivoConsulta);
        console.log("AEA:", aea);
        console.log("Estudios Complementarios:", estudiosComplementarios);
        console.log("Evaluación Goniometría:", evaluacionGoniometria);
        console.log("Pruebas Musculares:", pruebasMusculares);
        console.log("Pruebas Específicas:", pruebasEspecificas);
        console.log("Impresión Diagnóstica:", impresionDiagnostica);
        console.log("Plan de Tratamiento:", planTratamiento);

        // Asignar valores a los campos ocultos y principales
        $("#idconsulta_m").val(id);
        $("#idcliente_m").val(clienteId);

        // Llenar los campos del formulario del modal
        $("#fecha_consulta_m").val(fechaConsulta || "");
        $("#medico_tratante_m").val(medicoTratante || "");
        $("#medico_tel_m").val(medicoTel || "");
        $("#motivo_consulta_m").val(motivoConsulta || "");
        $("#aea_m").val(aea || "");
        $("#estudios_complementarios_m").val(estudiosComplementarios || "");
        $("#evaluacion_goniometria_m").val(evaluacionGoniometria || "");
        $("#pruebas_musculares_m").val(pruebasMusculares || "");
        $("#pruebas_especificas_m").val(pruebasEspecificas || "");
        $("#impresion_diagnostica_m").val(impresionDiagnostica || "");
        $("#plan_tratamiento_m").val(planTratamiento || "");

        // Obtener el nombre del cliente y asignarlo al campo correspondiente
        if (clienteId) {
            $.ajax({
                url: 'jsp/obtenerNombreCliente.jsp',
                type: 'POST',
                data: {idcliente: clienteId},
                dataType: 'text',
                success: function (response) {
                    const nombreCliente = response.trim();
                    console.log("Nombre del cliente obtenido:", nombreCliente);
                    $("#buscarCliente_m").val(nombreCliente); // Asignar el nombre al campo
                },
                error: function (xhr, status, error) {
                    console.error("Error al obtener el nombre del cliente:", error);
                    $("#buscarCliente_m").val(""); // Limpiar el campo en caso de error
                }
            });
        } else {
            console.warn("El ID del cliente es nulo o indefinido.");
            $("#buscarCliente_m").val(""); // Limpiar el campo si no hay cliente asociado
        }

        // Mostrar el modal
        $("#modalEditarConsulta").modal("show");
    }

// Guardar cambios en la consulta
    $("#guardar-editar-consulta").on("click", function () {
        // Validar campos obligatorios en el formulario del modal
        if (
                !$("#fecha_consulta_m").val().trim() ||
                !$("#motivo_consulta_m").val().trim() ||
                !$("#plan_tratamiento_m").val().trim()
                ) {
            $("#mensaje_modal").html(
                    "<div class='alert alert-danger'>Todos los campos obligatorios deben ser completados.</div>"
                    );
            return;
        }

        const datos = $("#formEditarConsulta").serialize();
        $.ajax({
            url: 'jsp/consultasM.jsp',
            type: 'POST',
            data: datos + '&listar=modificar',
            success: function (response) {
                $("#mensaje_modal").html(
                        "<div class='alert alert-success'>Consulta modificada exitosamente.</div>"
                        );
                rellenardatos(); // Recargar la tabla
                setTimeout(function () {
                    $("#modalEditarConsulta").modal("hide");
                    $("#mensaje_modal").html(""); // Limpiar mensajes
                }, 2000);
            },
            error: function () {
                $("#mensaje_modal").html(
                        "<div class='alert alert-danger'>Error al guardar los cambios.</div>"
                        );
            }
        });
    });

    function abrirModalEliminar(id) {
        $("#idconsulta_e").val(id); // Asigna el ID al campo oculto
    }

    // Confirmar eliminación de la consulta
    $("#eliminarConsulta").on("click", function () {
        const idconsulta = $("#idconsulta_e").val(); // Recuperar el ID del campo oculto

        $.ajax({
            url: 'jsp/consultasM.jsp',
            type: 'POST',
            data: {listar: 'eliminar', idconsulta_e: idconsulta},
            success: function (response) {
                $("#mensaje").html(response); // Muestra el mensaje de éxito/error
                $("#modalEliminarConsulta").modal("hide"); // Cierra el modal
                rellenardatos(); // Recarga la tabla para reflejar los cambios
            },
            error: function () {
                $("#mensaje").html("<div class='alert alert-danger'>Error al eliminar la consulta.</div>");
            }
        });
    });

</script>
