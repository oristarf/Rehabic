<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">
        <h1>Control de Rutinas</h1>

        <!-- Filtro para buscar rutinas -->
        <div class="form-group" id="filtroBusqueda">
            <label for="buscarNombre">Buscar por Nombre/Apellido del Cliente</label>
            <input type="text" id="buscarNombre" class="form-control" placeholder="Ingrese Nombre o Apellido del cliente">

            <label for="fechaInicio">Fecha Inicio</label>
            <input type="date" id="fechaInicio" class="form-control">

            <label for="fechaFin">Fecha Fin</label>
            <input type="date" id="fechaFin" class="form-control">

            <button class="btn btn-primary mt-2" onclick="buscarRutinas()">Buscar</button>
        </div>



        <!-- Tabla de resultados -->
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">Fecha</th>
                    <th scope="col">Ejercicio</th>
                    <th scope="col">Series</th>
                    <th scope="col">Repeticiones</th>
                    <th scope="col">Peso (Kg)</th>
                    <th scope="col">Minutos</th>
                    <th scope="col">Estado</th>
                    <th scope="col">Feedback</th>
                    <th scope="col">Usuario</th>
                </tr>
            </thead>
            <tbody id="resultadoRutinas">
                <!-- Aquí se cargarán las rutinas -->
            </tbody>
        </table>
    </section>
    
</div>

<script>
    function buscarRutinas() {
        const nombre = $("#buscarNombre").val().trim();
        const fechaInicio = $("#fechaInicio").val();
        const fechaFin = $("#fechaFin").val();

        if (!nombre && !fechaInicio && !fechaFin) {
            alert("Ingrese al menos un criterio de búsqueda.");
            return;
        }

        console.log("Buscar Rutinas - Parámetros Enviados:", {nombre, fechaInicio, fechaFin});

        $.ajax({
            data: {listar: 'rutinasFisioterapeuta', nombre, fechaInicio, fechaFin},
            url: 'jsp/controlRutinasM.jsp',
            type: 'post',
            success: function (response) {
                console.log("Buscar Rutinas - Respuesta Recibida:", response);
                if (response.trim() === "") {
                    $("#resultadoRutinas").html("<tr><td colspan='8'>No se encontraron rutinas para los criterios ingresados.</td></tr>");
                } else {
                    $("#resultadoRutinas").html(response);
                }
            },
            error: function (xhr, status, error) {
                console.error("Error al buscar rutinas:", error);
                $("#resultadoRutinas").html("<tr><td colspan='8'>Error al buscar rutinas. Intente nuevamente.</td></tr>");
            }
        });
    }


</script>

<%@ include file="footer.jsp" %>
