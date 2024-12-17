<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">

        <div class="container-fluid mt-5">
            <!-- Card Container -->
            <div class="card shadow-sm">
                <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
                    <h4>Informe de Pagos</h4>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <p>Seleccione un rango de fechas para generar el informe de pagos.</p>
                    </div>

                    <form action="informe_pagosdetallados.jsp" target="_blank" method="get" class="user">
                        <div class="row">
                            <!-- Campo Fecha Inicio -->
                            <div class="col-md-6 mb-3">
                                <label for="fechainicio" class="form-label">Fecha Inicio:</label>
                                <input type="date" class="form-control form-control-user" name="fechainicio" id="fechainicio" autocomplete="off" required>
                            </div>

                            <!-- Campo Fecha Final -->
                            <div class="col-md-6 mb-3">
                                <label for="fechafinal" class="form-label">Fecha Final:</label>
                                <input type="date" class="form-control form-control-user" name="fechafinal" id="fechafinal" autocomplete="off" required>
                            </div>
                        </div>

                        <!-- Campo ID Cliente (Oculto) -->
                      <div class="col-md-6 mb-3">
                        <label for="idcliente" class="control-label">Cliente</label>
                        <select class="form_control" name="idcliente" id="idcliente">
                        </select>
                    </div>

                        <!-- Botón para Generar Informe -->
                        <div class="d-flex justify-content-center mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-file-pdf"></i> Generar Informe
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>


    </section>
</div>

<script>
    $(document).ready(function () {
        buscadorCliente();
        // Llamada para llenar el select de clientes
    // Llamada para llenar el select de clientes
    function buscadorCliente() {
        $.ajax({
            data: { listar: "buscadorCliente" }, // Parámetro para activar el bloque en buscar.jsp
            url: "jsp/buscar.jsp", // Ruta correcta del archivo JSP
            type: "POST",
            success: function (response) {
                $("#idcliente").html(response); // Rellena el select con los clientes
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar clientes: ", error); // Muestra el error en la consola
            }
        });
    }


        $("#acptar").click(function () {
            // Obtener valores de los campos
            fecha_ini = $("#fechainicio").val();
            fecha_fin = $("#fechafinal").val();
            idcliente = $("#idcliente").val(); // Nuevo campo para ID Cliente

            // Enviar solicitud AJAX
            $.ajax({
                data: {
                    listar: 'informe',
                    fecha_ini: fecha_ini,
                    fecha_fin: fecha_fin,
                    idcliente: idcliente // Agregar idcliente como parámetro
                },
                url: 'jsp/pagosM.jsp',
                type: 'post',
                beforeSend: function () {
                    // Opcional: puedes agregar un mensaje de procesamiento
                    // $("#resultado").html("Procesando, espere por favor...");
                },
                success: function (response) {
                    // Acción a realizar en caso de éxito
                    llenadocompras();
                }
            });
        });
    });

        // Llamada para llenar el select de clientes con buscadorCliente

    


</script>
<%@ include file="footer.jsp" %>
