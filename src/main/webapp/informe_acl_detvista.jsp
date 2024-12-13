<%@ include file="header.jsp" %>
<div class="content-wrapper">
    <section class="content">

        <div class="container-fluid mt-5">
            <!-- Card Container -->
            <div class="card shadow-sm">
                <div class="card-header text-white text-center" style="background: linear-gradient(135deg, #10243c 5%, #17a2b8 90%);">
                    <h4>Informe de Evaluaciones ACL</h4>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <p>Seleccione un rango de fechas para generar el informe de evaluaciones ACL.</p>
                    </div>

                    <form action="informe_acl_detallado.jsp" target="_blank" method="get" class="user">
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

                        <!-- Campo ID Cliente -->
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="idcliente" class="form-label">ID Cliente:</label>
                                <input type="text" class="form-control form-control-user" name="idcliente" id="idcliente" autocomplete="off" placeholder="Ingrese el ID del cliente (opcional)">
                            </div>
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
            <br>
            <h1>Lista de evaluaciones</h1>
        <button type="button" class="btn btn-primary" onclick="location.href = 'acl_evaluaciones.jsp'">Nueva evaluación</button>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">Ref.</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Observaciones</th>
                    <th scope="col">Accion</th>
                </tr>
            </thead>
            <tbody id="resultadoeva">

            </tbody>
        </table>
        </div>


    </section>
</div>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar evaluación</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Esta seguro de querer eliminar la evaluación?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anuleva">Si</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
         llenadoeva();
        });
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

function llenadoeva() {
        $.ajax({
            data: {listar: 'listareva'},
            url: 'jsp/acl_evaluacionesM.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#resultadoeva").html(response);
                //sumador();

            }
        });
    }

    $("#anuleva").click(function () {
    const idpkeva = $("#pkanul").val(); // Obtener el ID de la cabecera a eliminar
    $.ajax({
        data: { listar: 'anuleva', idpkeva: idpkeva },
        url: 'jsp/acl_evaluacionesM.jsp',
        type: 'post',
        beforeSend: function () {
            // Opcional: Mostrar un mensaje de cargando
            console.log("Procesando eliminación...");
        },
        success: function (response) {
            console.log("Eliminación completada:", response);
            llenadoeva(); // Refrescar la vista después de la eliminación
        },
        error: function (xhr, status, error) {
            console.error("Error en la eliminación:", error);
        }
    });
});

</script>
<%@ include file="footer.jsp" %>
