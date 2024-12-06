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
        <h1>Lista de pagos</h1>
        <button type="button" class="btn btn-primary" onclick="location.href = 'pagos.jsp'">Nuevo pago</button>
        <button type="button" id="verVencimientos" class="btn btn-warning">Ver vencimientos</button>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">Ref.</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Total</th>
                    <th scope="col">Accion</th>
                </tr>
            </thead>
            <tbody id="resultadopago">

            </tbody>
        </table>
    </section>
</div>

<h3 class="mt-4">Vencimientos</h3>
<table class="table">
    <thead>
        <tr>
            <th scope="col">Cliente</th>
            <th scope="col">Fecha de Vencimiento</th>
            <th scope="col">Estado</th>
        </tr>
    </thead>
    <tbody id="resultadovencimientos">
        <!-- Los vencimientos se cargarán aquí -->
    </tbody>
</table>


<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar pago</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Esta seguro de querer eliminar el pago?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anulpago">Si</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        llenadopagos();
    });
    function llenadopagos() {
        $.ajax({
            data: {listar: 'listarpagos'},
            url: 'jsp/pagosM.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#resultadopago").html(response);
                //sumador();

            }
        });
    }

    $("#anulpago").click(function () {
        idpkpago = $("#pkanul").val();
        $.ajax({
            data: {listar: 'anularpagos', idpkpago: idpkpago},
            url: 'jsp/pagosM.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                llenadopagos();
                //sumador();

            }
        });
    });
  $("#verVencimientos").click(function () {
    const idUsuario = '<%= sesion.getAttribute("idusuarios") %>'; // Obtener ID del usuario desde la sesión

    $.ajax({
        data: { listar: 'listarVencimientos', idusuario: idUsuario },
        url: 'jsp/pagosM.jsp',
        type: 'post',
        success: function (response) {
            console.log("Respuesta de vencimientos:", response); // Log para depuración
            $("#resultadovencimientos").html(response); // Mostrar vencimientos en la tabla correspondiente
        },
        error: function () {
            alert("Error al cargar los vencimientos.");
        }
    });
});


</script>

<%@include file="footer.jsp" %>