
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
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text font-weight-bold text-warning text-uppercase mb-1">Pagos Pendientes</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">10</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Fila de Gráficos -->
    <div class="row">
        <!-- Gráfico de Tratamientos -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between" style="background: linear-gradient(135deg, #6c757d 10%, #17a2b8 90%); color: white;">
                    <h6 class="m-0 font-weight-bold">Tratamientos por Estado</h6>
                </div>
                <div class="card-body">
                    <div class="chart-pie pt-4 pb-2">
                        <canvas id="treatmentPieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráfico de Asistencias -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between" style="background: linear-gradient(135deg, #28a745 10%, #218838 90%); color: white;">
                    <h6 class="m-0 font-weight-bold">Asistencias Mensuales</h6>
                </div>
                <div class="card-body">
                    <div class="chart-bar pt-4 pb-2">
                        <canvas id="attendanceBarChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp"%>

<!-- Scripts para Gráficos -->
<script src="vendor/chart.js/Chart.min.js"></script>
<script>
    // Gráfico de Tratamientos
    var ctxPie = document.getElementById("treatmentPieChart");
    var treatmentPieChart = new Chart(ctxPie, {
        type: 'pie',
        data: {
            labels: ["En progreso", "Completados", "Pendientes"],
            datasets: [{
                data: [30, 40, 20],
                backgroundColor: ['#17a2b8', '#28a745', '#ffc107'],
            }],
        },
    });

    // Gráfico de Asistencias
    var ctxBar = document.getElementById("attendanceBarChart");
    var attendanceBarChart = new Chart(ctxBar, {
        type: 'bar',
        data: {
            labels: ["Semana 1", "Semana 2", "Semana 3", "Semana 4"],
            datasets: [{
                label: "Asistencias",
                backgroundColor: "#17a2b8",
                data: [50, 60, 70, 80],
            }],
        },
        options: {
            scales: {
                x: { display: true, title: { display: true, text: 'Semanas' }},
                y: { beginAtZero: true, title: { display: true, text: 'Asistencias' }},
            },
        }
    });
</script>
