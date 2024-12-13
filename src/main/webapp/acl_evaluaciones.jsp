<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Evaluación ACL</h4>
        </div>
        <div class="card-body">
            <form id="formAclEvaluacion" method="post">
                <!-- Búsqueda de Paciente -->
                <div class="form-group mb-3">
                    <label for="buscarPaciente" class="form-label">Buscar Paciente:</label>
                    <input type="text" id="buscarPaciente" class="form-control" placeholder="Escriba el nombre o apellido del paciente">
                    <input type="hidden" id="pacienteId" name="pacienteId">
                    <div id="resultadosPacientes" class="list-group mt-2"></div>
                </div>

                <!-- Selección del Plan de Tratamiento del Cliente -->
                <div class="form-group mb-3">
                    <label for="plan_tratamiento" class="form-label">Plan de Tratamiento:</label>
                    <select id="plan_tratamiento" name="plan_tratamiento" class="form-select">
                        <option value="">Seleccione el plan de tratamiento</option>
                    </select>
                </div>

                <!-- Fecha de Evaluación -->
                <div class="form-group mb-3">
                    <label for="fecha" class="form-label">Fecha de Evaluación:</label>
                    <input type="date" id="fecha" name="fecha" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" readonly>
                </div>

                <!-- Selección de Fase de Rehabilitación ACL -->
                <div class="form-group mb-3">
                    <label for="faseAcl" class="form-label">Fase de Rehabilitación ACL:</label>
                    <select id="faseAcl" name="faseAcl" class="form-select" onchange="mostrarTablaFase()">
                        <option value="">Seleccione una fase</option>
                        <option value="0">Fase Preoperatoria</option>
                        <option value="1">Fase 1: Recuperación de la Cirugía</option>
                        <option value="2">Fase 2: Fuerza y Control Neuromuscular</option>
                        <option value="3">Fase 3: Carrera, Agilidad y Aterrizajes</option>
                        <option value="4">Fase 4: Vuelta al Deporte</option>
                        <option value="5">Fase 5: Prevención de Nuevas Lesiones</option>
                    </select>
                </div>

                <!-- Tabla dinámica para Fase -->
                <div id="tablaFase" class="form-group">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Medida de Resultado</th>
                                <th>Objetivo</th>
                                <th>Cumplido</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Filas dinámicas se cargarán aquí según la fase seleccionada -->
                        </tbody>
                    </table>
                </div>

                <!-- Notas de Observación -->
                <div class="form-group mb-3">
                    <label for="observaciones" class="form-label">Notas de Observación:</label>
                    <textarea id="observaciones" name="observaciones" rows="3" class="form-control"></textarea>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-info" id="guardarAclEvaluacion">Guardar Evaluación ACL</button>
                    <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton-cancelar">Cancelar</button>
                </div>
                
            </form>
        </div>
        <div id="mensajeAcl" class="text-center mt-3"></div>
    </div>
</div>

<%@include file="footer.jsp"%>

<script>
    // Filtrar pacientes en tiempo real
    $("#buscarPaciente").on("keyup", function() {
        const query = $(this).val();
        $("#pacienteId").val(""); 
        $("#plan_tratamiento").html('<option value="">Seleccione el plan de tratamiento</option>');
        $("#tablaFase tbody").html("");

        if (query.length > 1) {
            $.ajax({
                url: "jsp/acl_evaluacionesM.jsp",
                type: "POST",
                data: { listar: "buscar_paciente", query: query },
                success: function(response) {
                    $("#resultadosPacientes").html(response);
                }
            });
        } else {
            $("#resultadosPacientes").html("");
        }
    });

    // Seleccionar paciente y cargar su plan de tratamiento
    $(document).on("click", ".paciente-item", function() {
        const pacienteId = $(this).data("id");
        const pacienteNombre = $(this).text();
        
        $("#buscarPaciente").val(pacienteNombre);
        $("#pacienteId").val(pacienteId);
        $("#resultadosPacientes").html("");

        cargarPlanTratamiento(pacienteId);
    });

    function cargarPlanTratamiento(pacienteId) {
        $.ajax({
            url: "jsp/acl_evaluacionesM.jsp",
            type: "POST",
            data: { listar: "plan_tratamiento", pacienteId: pacienteId },
            success: function(response) {
                $("#plan_tratamiento").html(response);
            }
        });
    }

    // Mostrar la tabla de la fase seleccionada
    function mostrarTablaFase() {
        const faseId = $("#faseAcl").val();
        if (faseId) {
            $.ajax({
                url: "jsp/acl_evaluacionesM.jsp",
                type: "POST",
                data: { listar: "mostrar_fase", fase: faseId },
                success: function(response) {
                    $("#tablaFase tbody").html(response);
                }
            });
        } else {
            $("#tablaFase tbody").html("");
        }
    }

    // Guardar evaluación ACL
    $("#guardarAclEvaluacion").on("click", function() {
        const datos = $("#formAclEvaluacion").serialize() + "&listar=cargar_acl";
        $.ajax({
            url: "jsp/acl_evaluacionesM.jsp",
            type: "POST",
            data: datos,
            success: function(response) {
                $("#mensajeAcl").html(response);
                setTimeout(() => {
                limpiarFormulario(); // Limpiar el formulario
            }, 3000);
                
            }
        });
    });
    
    function limpiarFormulario() {
    // Resetear el formulario
    $("#formAclEvaluacion")[0].reset();

    // Limpiar campos dinámicos adicionales
    $("#resultadosPacientes").html(""); // Limpiar resultados de búsqueda de pacientes
    $("#plan_tratamiento").html('<option value="">Seleccione el plan de tratamiento</option>'); // Limpiar el dropdown
    $("#tablaFase tbody").html(""); // Limpiar la tabla de fases
    $("#mensajeAcl").html(""); // Limpiar mensajes anteriores
}
</script>
