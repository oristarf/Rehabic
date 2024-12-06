<%@include file="header.jsp"%>

<div class="container-fluid">

    <!-- Encabezado del Dashboard -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800"></h1>
        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                class="fas fa-download fa-sm text-white-50"></i> </a>
    </div>

    <!-- Fila de Tarjetas Informativas -->
    <div class="row">

        <!-- Tarjeta Clientes -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text font-weight-bold text-primary text-uppercase mb-1">Clientes Activos</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">50</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-user fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tarjeta Tratamientos -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text font-weight-bold text-success text-uppercase mb-1">Tratamientos en Progreso</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">30</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tarjeta Asistencias -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text font-weight-bold text-info text-uppercase mb-1">Asistencias del Mes</div>
                            <div class="row no-gutters align-items-center">
                                <div class="col-auto">
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">75%</div>
                                </div>
                                <div class="col">
                                    <div class="progress progress-sm mr-2">
                                        <div class="progress-bar bg-info" role="progressbar"
                                             style="width: 75%" aria-valuenow="75" aria-valuemin="0"
                                             aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tarjeta Pagos Pendientes -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div id="tarjetaPagosPendientes" class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text font-weight-bold text-warning text-uppercase mb-1">Mensualidades</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                Por vencer: <span id="proximosPagos">0</span>
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-danger">
                                Vencidos: <span id="pagosVencidos">0</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<%@include file="footer.jsp"%>

<script>
    $(document).ready(function () {
        cargarNotificacionesVencimientos(); // Cargar notificaciones al abrir la página
    });

   function cargarNotificacionesVencimientos() {
    const idUsuario = '<%= sesion.getAttribute("idusuarios") %>'; // Obtener ID del usuario desde la sesión

    $.ajax({
        data: { listar: 'notificacionesVencimientos', idusuario: idUsuario },
        url: 'jsp/pagosM.jsp',
        type: 'post',
        success: function (response) {
            console.log("Respuesta del servidor:", response);

            if (response.trim() !== "") {
                let datos = response.trim().split("|");

                // Limpieza de valores antes de convertir
                let proximosRaw = datos[0].trim().replace(/[^0-9]/g, ""); 
                let vencidosRaw = datos[1].trim().replace(/[^0-9]/g, ""); 

                let proximos = parseInt(proximosRaw, 10) || 0;
                let vencidos = parseInt(vencidosRaw, 10) || 0;

                console.log("Próximos vencimientos procesados:", proximos);
                console.log("Pagos vencidos procesados:", vencidos);

                // Actualizar la interfaz
                $("#proximosPagos").text(proximos);
                $("#pagosVencidos").text(vencidos);

                // Alertas con SweetAlert2
                if (vencidos > 0) {
                    Swal.fire({
                        title: '¡Pagos vencidos!',
                        text: `Tienes ${vencidos} pago(s) vencido(s).`,
                        icon: 'error',
                        timer: 1500,
                        timerProgressBar: true,
                        showConfirmButton: false
                    });
                } else if (proximos > 0) {
                    Swal.fire({
                        title: '¡Pagos próximos a vencer!',
                        text: `Tienes ${proximos} pago(s) próximo(s) a vencer.`,
                        icon: 'warning',
                        timer: 1500,
                        timerProgressBar: true,
                        showConfirmButton: false
                    });
                }
            } else {
                console.error("Respuesta vacía del servidor.");
            }
        },
        error: function (xhr, status, error) {
            console.error("Error AJAX:", error);
        }
    });
}


</script>

