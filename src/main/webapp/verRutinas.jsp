<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">
        <h1>Mis Rutinas</h1>
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
                    <th scope="col">Acci�n</th>
                </tr>
            </thead>
            <tbody id="resultadoRutinas">
                <!-- Aqu� se cargar�n las rutinas -->
            </tbody>
        </table>
    </section>
</div>

<!-- Modal para retroalimentaci�n -->
<div class="modal fade" id="modalFeedback" tabindex="-1" role="dialog" aria-labelledby="modalFeedbackLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalFeedbackLabel">Agregar Retroalimentaci�n</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <textarea class="form-control" id="feedbackText" rows="4" placeholder="Escribe tu retroalimentaci�n..."></textarea>
                <input type="hidden" id="idRutinaFeedback" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" id="guardarFeedback">Guardar</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        cargarRutinas(); // Cargar rutinas del d�a
    });

    function cargarRutinas() {
        const idUsuario = '<%= sesion.getAttribute("idusuarios") %>';
        $.ajax({
            data: { listar: 'rutinasCliente', idusuario: idUsuario },
            url: 'jsp/verRutinasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoRutinas").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar rutinas:", error);
            }
        });
    }

    function marcarCompletado(idRutina) {
    console.log("Par�metros enviados para marcar como completado:", { idRutina: idRutina }); // Log de par�metros enviados

    $.ajax({
        data: { listar: 'marcarCompletado', idRutina: idRutina },
        url: 'jsp/verRutinasM.jsp',
        type: 'post',
        success: function (response) {
            console.log("Respuesta recibida al marcar como completado:", response); // Log de respuesta recibida
            cargarRutinas(); // Recargar rutinas
        },
        error: function (xhr, status, error) {
            console.error("Error al marcar como completado:", error); // Log detallado del error
            console.log("Error Response:", xhr.responseText); // Respuesta de error
        }
    });
}


    function mostrarFeedbackModal(idRutina) {
    console.log("Abrir Modal de Feedback para idRutina:", idRutina);
    $("#idRutinaFeedback").val(idRutina); // Asignar el ID de la rutina al campo oculto
    $("#feedbackText").val(""); // Limpiar el campo de texto del modal
    $("#modalFeedback").modal("show");
}

$("#guardarFeedback").click(function () {
    const idRutina = $("#idRutinaFeedback").val();
    const feedback = $("#feedbackText").val().trim();

    if (!feedback) {
        alert("Por favor, escribe tu retroalimentaci�n.");
        return;
    }

    console.log("Guardar Feedback - Par�metros Enviados:", { idRutina, feedback });

    $.ajax({
        data: { listar: 'guardarFeedback', idRutina, feedback },
        url: 'jsp/verRutinasM.jsp',
        type: 'post',
        success: function (response) {
            console.log("Feedback guardado con �xito:", response);
            $("#modalFeedback").modal("hide");
            cargarRutinas(); // Recargar las rutinas despu�s de guardar la retroalimentaci�n
        },
        error: function (xhr, status, error) {
            console.error("Error al guardar retroalimentaci�n:", error);
            alert("Ocurri� un error al guardar la retroalimentaci�n.");
        }
    });
});

</script>
<%@ include file="footer.jsp" %>
