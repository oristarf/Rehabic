<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">
        <h1>Registro de Asistencias</h1>

        <!-- Formulario para registrar asistencias -->
        <div class="row mb-3">
            <div class="col-md-4">
                <label for="idCliente">Cliente</label>
                <select id="idCliente" class="form-control">
                    <!-- Opciones cargadas din�micamente -->
                </select>
            </div>
            <div class="col-md-4">
                <label for="fechaAsistencia">Fecha</label>
                <input type="date" id="fechaAsistencia" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis()) %>">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button class="btn btn-success" onclick="registrarAsistencia()">Registrar Presente</button>
            </div>
        </div>

        <!-- Tabla para listar asistencias registradas -->
        <<table class="table">
    <thead>
        <tr>
            <th>Cliente</th>
            <th>Fecha</th>
            <th>Acci�n</th>
        </tr>
    </thead>
    <tbody id="resultadosAsistencias">
        <!-- Aqu� se listar�n las asistencias -->
    </tbody>
</table>

    </section>
</div>

<script>
    $(document).ready(function () {
        cargarClientes(); // Cargar clientes en el select
        listarAsistencias(); // Listar las asistencias al cargar la p�gina
    });

    // Cargar lista de clientes
    function cargarClientes() {
        $.ajax({
            data: { listar: 'listarClientes' },
            url: 'jsp/asistenciasM.jsp',
            type: 'post',
            success: function (response) {
                $("#idCliente").html(response); // Llenar el select con las opciones de clientes
            },
            error: function () {
                alert("Error al cargar los clientes.");
            }
        });
    }

    // Registrar asistencia
    function registrarAsistencia() {
        const idCliente = $("#idCliente").val();
        const fecha = $("#fechaAsistencia").val();

        if (!idCliente || !fecha) {
            alert("Por favor, selecciona un cliente y una fecha.");
            return;
        }

        $.ajax({
            data: { listar: 'registrarAsistencia', idCliente, fecha },
            url: 'jsp/asistenciasM.jsp',
            type: 'post',
            success: function (response) {
                alert(response.trim());
                listarAsistencias(); // Actualizar la lista de asistencias
            },
            error: function () {
                alert("Error al registrar la asistencia.");
            }
        });
    }

    // Listar asistencias
   function listarAsistencias() {
        $.ajax({
            data: { listar: 'listarAsistencias' },
            url: 'jsp/asistenciasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadosAsistencias").html(response);
            },
            error: function () {
                alert("Error al cargar las asistencias.");
            }
        });
    }

    // Funci�n para eliminar una asistencia
    function eliminarAsistencia(idAsistencia) {
        if (!confirm("�Est�s seguro de eliminar esta asistencia?")) return;

        $.ajax({
            data: { listar: 'eliminarAsistencia', idAsistencia: idAsistencia },
            url: 'jsp/asistenciasM.jsp',
            type: 'post',
            success: function (response) {
                alert(response.trim()); // Mostrar mensaje del servidor
                listarAsistencias(); // Recargar la lista de asistencias
            },
            error: function () {
                alert("Error al eliminar la asistencia.");
            }
        });
    }

</script>
<%@ include file="footer.jsp" %>
