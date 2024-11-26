<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">
        <h3>Registrar Abono</h3>
        <form id="form-abono" method="POST">
            <input type="hidden" id="idcab_pago" name="idcab_pago" value="<%= request.getParameter("idcab_pago") %>">
            <input type="hidden" id="codusuario" name="codusuario" value="<%= sesion.getAttribute("idusuarios")%>">
            <div class="form-group">
                <label>Saldo Pendiente:</label>
                <input type="text" id="saldo_pendiente" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label>Monto a Abonar:</label>
                <input type="number" id="ab_monto" name="ab_monto" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Método de Pago:</label>
                <select id="ab_metodo" name="ab_metodo" class="form-control" required>
                    <option value="Efectivo">Efectivo</option>
                    <option value="Transferencia">Transferencia</option>
                </select>
            </div>
            <button type="button" id="registrar-abono" class="btn btn-primary">Registrar</button>
        </form>
        <hr>
        <h4>Historial de Abonos</h4>
        <table class="table">
            <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Monto</th>
                    <th>Método</th>
                </tr>
            </thead>
            <tbody id="historial-abonos">
                <!-- Se llenará con AJAX -->
            </tbody>
        </table>
    </section>
</div>
<script>
    $(document).ready(function () {
    const idCabPago = $("#idcab_pago").val();

    // Cargar datos iniciales del pago
    $.post('abonosM.jsp', {action: 'loadPago', idcab_pago: idCabPago}, function (response) {
        const data = JSON.parse(response);
        $("#saldo_pendiente").val(data.saldo_pendiente);
        cargarHistorial();
    });

    // Registrar abono
    $("#registrar-abono").click(function () {
        const abMonto = parseFloat($("#ab_monto").val());
        const saldoPendiente = parseFloat($("#saldo_pendiente").val());

        // Validaciones antes de enviar
        if (!abMonto || abMonto <= 0) {
            alert("El monto a abonar debe ser mayor a cero.");
            return;
        }

        if (abMonto > saldoPendiente) {
            alert("El monto a abonar no puede ser mayor que el saldo pendiente.");
            return;
        }

        if (!$("#ab_metodo").val()) {
            alert("Debe seleccionar un método de pago.");
            return;
        }

        // Si las validaciones pasan, enviar los datos al backend
        const datos = $("#form-abono").serialize();
        $.post('abonosM.jsp', {action: 'registrarAbono', ...datos}, function (response) {
            alert(response);
            location.reload();
        }).fail(function (xhr) {
            alert("Ocurrió un error al registrar el abono: " + xhr.responseText);
        });
    });

    // Cargar historial de abonos
    function cargarHistorial() {
        $.post('abonosM.jsp', {action: 'loadAbonos', idcab_pago: idCabPago}, function (response) {
            $("#historial-abonos").html(response);
        }).fail(function (xhr) {
            alert("Ocurrió un error al cargar el historial de abonos: " + xhr.responseText);
        });
    }
});

</script>
<%@ include file="footer.jsp" %>
