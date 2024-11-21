<%@ include file="header.jsp" %>

<div class="content-wrapper">
    <section class="content">
        <div class="panel panel-border panel-warning widget-s-1">
            <div class="panel-heading">
                <h4>Listado de Pagos</h4>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered dt-responsive nowrap" id="listarPagos">
                        <thead>
                            <tr>
                                <th>ID Pago</th>
                                <th>Cliente</th>
                                <th>Fecha</th>
                                <th>Total</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="resultadosPagos"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<%@ include file="footer.jsp" %>


<script>
    $(document).ready(function () {
        listarPagos(); // Llamar a la función al cargar la página
    });

    // Función para listar pagos
    function listarPagos() {
        $.ajax({
            url: 'jsp/pagosM.jsp',
            type: 'POST',
            data: { listar: 'listar_pagos' },
            success: function (response) {
                $("#resultadosPagos").html(response); // Cargar la respuesta en el cuerpo de la tabla
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar los pagos: ", xhr.responseText); // Más detalles para depuración
                alert("Hubo un error al cargar los pagos. Por favor, inténtelo de nuevo.");
            }
        });
    }

    // Evento para eliminar un pago
    $(document).on("click", ".eliminar-pago", function () {
        const idPago = $(this).data("id");
        if (confirm("¿Está seguro de querer eliminar el pago?")) {
            $.ajax({
                url: 'jsp/pagosM.jsp',
                type: 'POST',
                data: { listar: 'cancelar_pago', idcab_pago: idPago },
                success: function (response) {
                    alert(response); // Mostrar el mensaje del servidor
                    listarPagos();   // Refrescar la tabla de pagos
                },
                error: function (xhr, status, error) {
                    console.error("Error al eliminar el pago: ", xhr.responseText);
                    alert("Hubo un error al intentar eliminar el pago. Por favor, inténtelo de nuevo.");
                }
            });
        }
    });

    // Evento para anular un pago
    $(document).on("click", ".anular-pago", function () {
        const idPago = $(this).data("id"); // Obtener el ID del pago
        if (confirm("¿Está seguro de querer anular este pago?")) {
            $.ajax({
                url: 'jsp/pagosM.jsp',
                type: 'POST',
                data: { listar: 'anular_pago', idcab_pago: idPago },
                success: function (response) {
                    alert(response); // Mostrar el mensaje del servidor
                    listarPagos();   // Refrescar la tabla de pagos
                },
                error: function (xhr, status, error) {
                    console.error("Error al anular el pago: ", xhr.responseText);
                    alert("Hubo un error al intentar anular el pago. Por favor, inténtelo de nuevo.");
                }
            });
        }
    });
</script>
