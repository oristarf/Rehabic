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

<%@include file="footer.jsp"%>


<script>
    $(document).ready(function () {
        rellenardatos();
    });

    // Filtrar clientes en tiempo real
    $("#buscarCliente").on("keyup", function() {
        const query = $(this).val();
        $("#idcliente").val("");
        $("#resultadosClientes").html("");

        if (query.length > 0) {
            $.ajax({
                url: "jsp/consultasM.jsp",
                type: "POST",
                data: { listar: "buscar_cliente", query: query },
                success: function(response) {
                    $("#resultadosClientes").html(response);
                }
            });
        }
    });

    // Seleccionar cliente
    $(document).on("click", ".cliente-item", function() {
        const clienteId = $(this).data("id");
        const clienteNombre = $(this).text();
        
        $("#buscarCliente").val(clienteNombre);
        $("#idcliente").val(clienteId);
        $("#resultadosClientes").html("");
    });

    function rellenardatos() {
        $.ajax({
            data: { listar: 'listar' },
            url: 'jsp/consultasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
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
    function rellenaredit(id, clienteId, fechaConsulta, medicoTratante, medicoTel, motivoConsulta, aea, estudiosComplementarios, evaluacionGoniometria, pruebasMusculares, pruebasEspecificas, impresionDiagnostica, planTratamiento) {
    console.log("ID de la Consulta:", id);  // Verificación del ID de la consulta
    console.log("ID del Cliente:", clienteId);  // Verificación del ID del cliente

    // Asignar valores a los campos de la consulta
    $("#idconsulta").val(id);
    $("#idcliente").val(clienteId);

    // Cargar el nombre del cliente en el campo de búsqueda
    $.ajax({
        url: 'jsp/obtenerNombreCliente.jsp', // Página JSP para obtener el nombre del cliente
        type: 'post',
        data: { idcliente: clienteId },
        success: function(response) {
            console.log("Nombre del cliente obtenido:", response); // Verificar la respuesta del servidor
            $("#buscarCliente").val(response); // Mostrar el nombre en el campo de búsqueda
        },
        error: function(xhr, status, error) {
            console.log("Error en la solicitud AJAX:", error); // Si ocurre algún error
        }
    });

    // Asignar valores a los otros campos
    $("#fecha_consulta").val(fechaConsulta);
    $("#medico_tratante").val(medicoTratante);
    $("#medico_tel").val(medicoTel);
    $("#motivo_consulta").val(motivoConsulta);
    $("#aea").val(aea);
    $("#estudios_complementarios").val(estudiosComplementarios);
    $("#evaluacion_goniometria").val(evaluacionGoniometria);
    $("#pruebas_musculares").val(pruebasMusculares);
    $("#pruebas_especificas").val(pruebasEspecificas);
    $("#impresion_diagnostica").val(impresionDiagnostica);
    $("#plan_tratamiento").val(planTratamiento);
    $("#listar").val("modificar");
}


    // Confirmar eliminación de la consulta
    $("#eliminarConsulta").on("click", function () {
    const idconsulta = $("#idconsulta_e").val();
    $.ajax({
        data: { listar: "eliminar", idconsulta_e: idconsulta },
        url: 'jsp/consultasM.jsp',
        type: 'post',
        success: function (response) {
            // Cerrar el modal automáticamente
            $("#eliminarC").modal("hide");

            // Mostrar el mensaje después de cerrar el modal
            setTimeout(function() {
                $("#mensaje").html(response); // Mostrar el mensaje en el elemento con id="mensaje"
            }, 500); // Esperar 500ms para asegurarse de que el modal se haya cerrado completamente

            // Recargar los datos en la tabla para reflejar el cambio
            rellenardatos();
        }
    });
});
</script>
