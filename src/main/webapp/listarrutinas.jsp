<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<div class="content-wrapper">
    <section class="content">
        <h1>Lista de Rutinas</h1>
        <button type="button" class="btn btn-primary" onclick="location.href = 'rutinas.jsp'">Nueva Rutina</button>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">Ref.</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Fisioterapeuta</th>
                    <th scope="col">Acción</th>
                </tr>
            </thead>
            <tbody id="resultadorutinas">

            </tbody>
        </table>
    </section>
</div>

</div>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Rutina</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro de querer eliminar la rutina?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anulrutina">Sí</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        llenadorutinas();
    });
    
    // Cargar la lista de rutinas
    function llenadorutinas() {
        $.ajax({
            data: {listar: 'listarrutinas'},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadorutinas").html(response);
            }
        });
    }

    // Anular una rutina
    $("#anulrutina").click(function () {
        idpkrutina = $("#pkanul").val(); // ID de la rutina a anular
        $.ajax({
            data: {listar: 'anularrutinas', idpkrutina: idpkrutina},
            url: 'jsp/rutinasM.jsp',
            type: 'post',
            success: function (response) {
                llenadorutinas(); // Recargar la lista después de anular
            }
        });
    });
</script>
<%@include file="footer.jsp" %>
