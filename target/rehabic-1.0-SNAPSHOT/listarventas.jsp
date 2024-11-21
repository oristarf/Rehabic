

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
        <h1>Lista de tratamientos</h1>
        <button type="button" class="btn btn-primary" onclick="location.href = 'vistaventas.jsp'">Nuevo</button>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">Ref.</th>
                    <th scope="col">Fecha de creación</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Fecha de rutina</th>
                    <th scope="col">Descripcion</th>
                    <th scope="col">Acción</th>
                </tr>
            </thead>
            <tbody id="resultadoventa">

            </tbody>
        </table>
    </section>
</div>

<!-- Modal -->
<div class="modal" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Venta</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Esta seguro de querer eliminar la Venta?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anulventa">SI</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>

<script>
    $(document).ready(function () {
        llenadoventas();
    });
    function llenadoventas() {
        $.ajax({
            data: {listar: 'listarventas'},
            url: 'jsp/ventas.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#resultadoventa").html(response);
                //sumador();

            }
        });
    }

    $("#anulventa").click(function () {
        idpkventa = $("#pkanul").val();
        $.ajax({
            data: {listar: 'anularventa',idpkventa:idpkventa},
            url: 'jsp/ventas.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                llenadoventas();
                //sumador();

            }
        });
    });
</script>