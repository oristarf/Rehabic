<%@include file="header.jsp"%>

<div class="container-fluid mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
            <h4>Listado de Evaluaciones ACL</h4>
        </div>
        <div class="card-body">
            <!-- Formulario de Filtros -->
            <form id="filtroEvaluaciones" class="mb-4">
    <div class="row">
        <div class="col-md-4">
            <label for="clienteId" class="form-label">Paciente:</label>
            <select id="clienteId" name="clienteId" class="form-select">
                <option value="">Seleccione un paciente</option>
                <!-- Opciones dinámicas cargadas desde la base de datos -->
            </select>
        </div>
        <div class="col-md-4">
            <label for="fechaInicio" class="form-label">Desde:</label>
            <input type="date" id="fechaInicio" name="fechaInicio" class="form-control">
        </div>
        <div class="col-md-4">
            <label for="fechaFin" class="form-label">Hasta:</label>
            <input type="date" id="fechaFin" name="fechaFin" class="form-control">
        </div>
    </div>
    <div class="mt-3 text-end">
        <button type="button" class="btn btn-primary" id="filtrar">Filtrar</button>
    </div>
</form>


            <!-- Tabla de Resultados -->
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Paciente</th>
                            <th>Fase</th>
                            <th>Medida</th>
                            <th>Objetivo</th>
                            <th>Cumplidos</th>
                        </tr>
                    </thead>
                    <tbody id="resultadosEvaluaciones">
                        <!-- Las filas se cargan desde la consulta -->
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp"%>

<script>
    $(document).ready(function () {
        cargarEvaluaciones(); // Cargar evaluaciones al cargar la página

        // Filtrar evaluaciones al hacer clic en el botón
        $("#btnFiltrar").on("click", function () {
            cargarEvaluaciones();
        });
    });

    function cargarEvaluaciones() {
        const filtros = {
            listar: 'listar',
            cliente: $("#cliente").val(),
            fecha_inicio: $("#fecha_inicio").val(),
            fecha_fin: $("#fecha_fin").val()
        };

        $.ajax({
            url: 'jsp/acl_evaluacionesM.jsp', // Apunta al mismo JSP donde se maneja el backend
            type: 'POST',
            data: filtros,
            success: function (response) {
                $("#tablaEvaluaciones tbody").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar las evaluaciones:", error);
                $("#tablaEvaluaciones tbody").html("<tr><td colspan='6' class='text-center text-danger'>Error al cargar las evaluaciones</td></tr>");
            }
        });
    }
    $("#filtrar").on("click", function () {
    const datos = $("#filtroEvaluaciones").serialize() + "&listar=evaluaciones";
    $.ajax({
        url: "acl_evaluacionesM.jsp",
        type: "POST",
        data: datos,
        success: function (response) {
            $("#resultadosEvaluaciones").html(response);
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar evaluaciones:", error);
        }
    });
});


</script>
