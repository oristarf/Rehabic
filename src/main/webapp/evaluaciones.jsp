<%@include file="header.jsp"%>
<div class="container-fluid mt-5">
    <!-- Tarjeta para la Evaluación -->
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Evaluación de Avance del Paciente</h4>
        </div>
        <div class="card-body">
            <form id="formEvaluacion" method="post">
                <!-- Búsqueda de Cliente -->
                <div class="form-group mb-3">
                    <label for="buscarCliente" class="form-label">Buscar Cliente:</label>
                    <input type="text" id="buscarCliente" class="form-control" placeholder="Escriba el nombre o apellido del cliente">
                    <input type="hidden" id="cliente" name="cliente">
                    <div id="resultadosClientes" class="list-group mt-2"></div> <!-- Contenedor para mostrar resultados de búsqueda -->
                </div>

                <!-- Diagnóstico del Cliente (Plan de Tratamiento) -->
                <div class="form-group mb-3">
                    <label for="plan_tratamiento" class="form-label">Plan tratamiento:</label>
                    <select id="plan_tratamiento" name="plan_tratamiento" class="form-select">
                        <option value="">Seleccione un plan</option>
                        <!-- Las opciones se cargarán vía AJAX desde evaluacionesM.jsp -->
                    </select>
                </div>

                <!-- Fecha de Evaluación -->
                <div class="form-group mb-3">
                    <label for="fecha" class="form-label">Fecha:</label>
                    <input type="date" id="fecha" name="fecha" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis())%>" readonly>
                </div>

                <!-- Detalle de Evaluación -->
                <fieldset class="border p-3 mt-4">
                    <legend class="w-auto">Detalle de Evaluación</legend>

                    <div class="form-group mb-3">
                        <label for="avance" class="form-label">Progreso Observado:</label>
                        <textarea id="avance" name="avance" rows="3" class="form-control" required></textarea>
                    </div>

                    <div class="form-group mb-3">
                        <label for="nivelDolor" class="form-label">Nivel de Dolor (0-10):</label>
                        <input type="number" id="nivelDolor" name="nivelDolor" min="0" max="10" class="form-control" required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="movilidad" class="form-label">Movilidad:</label>
                        <select id="movilidad" name="movilidad" class="form-select">
                            <option value="limitada">Limitada</option>
                            <option value="moderada">Moderada</option>
                            <option value="completa">Completa</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="comentarios" class="form-label">Comentarios Adicionales:</label>
                        <textarea id="comentarios" name="comentarios" rows="3" class="form-control"></textarea>
                    </div>
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-primary" id="guardarEvaluacion">Guardar Evaluación</button>
                        <button type="reset" class="btn btn-secondary" id="boton-cancelar" name="boton-cancelar">Cancelar</button>
                    </div>
                    
                </fieldset>
            </form>
        </div>
        <div id="mensaje" class="text-center mt-3"></div>
    </div>
</div>
<%@include file="footer.jsp"%>

<script>
    // Evento de búsqueda de cliente
    $("#buscarCliente").on("keyup", function() {
        const query = $(this).val();

        // Limpia el campo oculto de cliente seleccionado si cambia el texto en el campo de búsqueda
        $("#cliente").val(""); 
        $("#plan_tratamiento").html('<option value="">Seleccione un plan</option>'); // Resetear el campo de plan de tratamiento

        if (query.length > 1) { // Realiza la búsqueda si el término tiene más de 1 carácter
            $.ajax({
                url: "jsp/evaluacionesM.jsp",
                type: "POST",
                data: { listar: "buscar_cliente", query: query },
                success: function(response) {
                    $("#resultadosClientes").html(response);
                }
            });
        } else {
            $("#resultadosClientes").html(""); // Limpiar resultados si el término es muy corto
        }
    });

    // Selección de cliente de los resultados
    $(document).on("click", ".cliente-item", function() {
        const clienteId = $(this).data("id");
        const clienteNombre = $(this).text().trim();
        
        $("#buscarCliente").val(clienteNombre);
        $("#cliente").val(clienteId); // Establecer el ID del cliente en el campo oculto
        $("#resultadosClientes").html(""); // Limpiar los resultados de búsqueda
        
        // Cargar plan de tratamiento para el cliente seleccionado
        cargarPlan(clienteId);
    });

    function cargarPlan(clienteId) {
        $.ajax({
            url: "jsp/evaluacionesM.jsp",
            type: "POST",
            data: { listar: "plan_tratamiento", clienteId: clienteId },
            success: function(response) {
                $("#plan_tratamiento").html(response);
            }
        });
    }

    // Evento para guardar la evaluación
    $("#guardarEvaluacion").on("click", function () {
        const boton = $(this);
        boton.prop("disabled", true).text("Guardando...");
        const datos = $("#formEvaluacion").serialize() + "&listar=cargar";

        $.ajax({
            url: "jsp/evaluacionesM.jsp",
            type: "POST",
            data: datos,
            success: function (response) {
                $("#mensaje").html(response);

                // Limpiar todos los campos del formulario
                $("#formEvaluacion")[0].reset();       // Limpia el formulario
                $("#cliente").val("");                 // Limpia el campo oculto de cliente
                $("#buscarCliente").val("");           // Limpia el campo de búsqueda de cliente
                $("#plan_tratamiento").html('<option value="">Seleccione un plan</option>'); // Resetea el plan de tratamiento

                boton.prop("disabled", false).text("Guardar Evaluación"); // Restaurar botón
            },
            error: function () {
                boton.prop("disabled", false).text("Guardar Evaluación");
            }
        });
    });
</script>

