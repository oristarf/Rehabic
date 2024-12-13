<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>

<%
    HttpSession sesion = request.getSession();
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    String logueado = (String) sesion.getAttribute("logueado");

    if (logueado == null || !logueado.equals("1")) {
%>
<script>alert('Ingrese sus credenciales para acceder.'); location.href = 'index.jsp';</script>
<%
    }

    // Obtiene la lista de permisos de la sesión
    ArrayList<String> permisos = (ArrayList<String>) sesion.getAttribute("permisos");

    String uri = request.getRequestURI(); // Ejemplo: /rehabic/roles.jsp

    // Asociar permisos a las URLs
    String permisoRequerido = null;

    if (uri.contains("roles.jsp")) {
        permisoRequerido = "Roles";
    } else if (uri.contains("usuarios.jsp")) {
        permisoRequerido = "Usuarios";
    } else if (uri.contains("clientes.jsp")) {
        permisoRequerido = "Clientes";
    } else if (uri.contains("consultas.jsp")) {
        permisoRequerido = "Consultas";
    } else if (uri.contains("historial.jsp")) {
        permisoRequerido = "Historial";
    } else if (uri.contains("asistencias.jsp")) {
        permisoRequerido = "Asistencia";
    } else if (uri.contains("servicios.jsp")) {
        permisoRequerido = "Servicios";
    } else if (uri.contains("ejercicios.jsp")) {
        permisoRequerido = "Ejercicios";
    } else if (uri.contains("pagos.jsp")) {
        permisoRequerido = "Pagos";
    } else if (uri.contains("listarpagos.jsp")) {
        permisoRequerido = "Listar_Pagos";
    } else if (uri.contains("evaluaciones.jsp")) {
        permisoRequerido = "Evaluaciones_Generales";
    } else if (uri.contains("acl_evaluaciones.jsp")) {
        permisoRequerido = "Evaluaciones_ACL";
    } else if (uri.contains("rutinas.jsp")) {
        permisoRequerido = "Rutinas";
    } else if (uri.contains("listarrutinas.jsp")) {
        permisoRequerido = "Listar_Rutinas";
    } else if (uri.contains("personales.jsp")) {
        permisoRequerido = "Personales";
    } else if (uri.contains("verRutinas.jsp")) {
        permisoRequerido = "Ver_Rutinas";
    } else if (uri.contains("controlRutinas.jsp")) {
        permisoRequerido = "Control_Rutinas";
    }else if (uri.contains("informepago_vista.jsp")) {
        permisoRequerido = "Informe Pagos General";
    }else if (uri.contains("informepagodetallado_vista.jsp")) {
        permisoRequerido = "Informe Pago Cliente";
    }else if (uri.contains("informerutinadetallada_vista.jsp")) {
        permisoRequerido = "Informe Rutina Cliente";
    }else if (uri.contains("informe_acl_detvista.jsp")) {
        permisoRequerido = "Informe ACL Cliente";
    }else if (uri.contains("informe_eva_detvista.jsp")) {
        permisoRequerido = "Informe Evaluacion Cliente";
    }
    // Validar acceso basado en los permisos de la sesión
    if (permisoRequerido != null && (permisos == null || !permisos.contains(permisoRequerido))) {
%>
<script>alert('No tiene permisos para acceder a esta página.'); location.href = 'container.jsp';</script>
<%
    }
%>

<script src="js/jquery.js"></script>
<script src="js/sb-admin-2.js"></script>
<script src="js/sb-admin-2.min.js"></script>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Rehabic</title>

        <!-- Sweetalert2 -->
        <link rel="stylesheet" href="css/sweetalert2.min.css">
        <script src="js/sweetalert2.min.js"></script>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


        <!-- Custom fonts and styles -->
        <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="css/sb-admin-2.min.css" rel="stylesheet">
        <link href="css/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">



        <style>
    .sidebar {
        background: linear-gradient(135deg, #10243c 30%, #17a2b8 90%);
    }

    .sidebar-brand {
        font-size: 1.5rem;
        font-weight: 600;
        color: #ffffff;
    }

    .sidebar .nav-item .nav-link {
        color: #e9ecef;
    }

    .sidebar .nav-item .nav-link:hover {
        color: #17a2b8;
        background-color: rgba(255, 255, 255, 0.2);
        border-radius: 5px;
    }

    #content-wrapper {
        background-color: #f8f9fa;
    }

    .card-header {
        background-color: #17a2b8;
        color: white;
        font-size: 1.3rem;
        font-weight: bold;
    }

    .btn-primary {
        background-color: #17a2b8;
        border: none;
    }

    .btn-primary:hover {
        background-color: #138496;
    }

    .navbar .nav-link {
        color: #495057 !important;
    }

    .container-fluid {
        max-width: 1200px;
    }

    .sidebar-divider {
        border-top: 1px solid rgba(255, 255, 255, 0.2);
    }

    .dropdown-item i {
        color: #17a2b8;
    }

    /* Custom style for dropdown items */
    .collapse-item {
        color: #e9ecef;
        padding: 10px 20px;
        font-size: 0.9rem;
        display: block;
    }

    .collapse-item:hover {
        color: #17a2b8;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 4px;
    }

    /* Arrow indicator for collapsed nav-link */
    .nav-link.collapsed::after {
        content: '\f078';
        font-family: "FontAwesome";
        float: right;
    }

    .checkbox-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); /* Ajusta el tamaño de las columnas */
        gap: 10px; /* Espaciado entre elementos */
    }

    .checkbox-grid label {
        display: flex;
        align-items: center;
    }

    /* Fondo destacado para elementos desplegados en pantallas pequeñas */
    .collapse.show {
     background : linear-gradient(135deg, #10243c 30%, #17a2b8 90%);
    color: #000000; /* Texto negro */
    border: 1px solid rgba(0, 0, 0, 0.1); /* Borde sutil */
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2); /* Sombra más marcada */
    border-radius: 4px; /* Bordes redondeados */
    z-index: 9999; /* Prioridad sobre otros elementos */
}

.collapse-item {
    color: #333333; /* Texto gris oscuro para mejor contraste */
    padding: 10px 15px;
    text-decoration: none;
    display: block;
    border-radius: 4px;
}

.collapse-item:hover {
    background-color: rgba(0, 0, 0, 0.2); /* Fondo gris más oscuro */
    color: #0056b3; /* Texto azul más oscuro */
}
</style>

    </head>

    <body id="page-top" style="background-color: white;"

        <!-- Page Wrapper -->
        <div id="wrapper" style="background-color: white;">
            <!-- Sidebar -->
            <!-- Sidebar -->
            <ul class="navbar-nav sidebar sidebar-dark accordion" id="accordionSidebar">
                <!-- Sidebar - Brand -->
                <a class="sidebar-brand d-flex align-items-center justify-content-center" href="container.jsp">
                    <i class="fas fa-spa fa-lg"></i>
                    <div class="sidebar-brand-text mx-3">Rehabic</div>
                </a>

                <!-- Divider -->
                <hr class="sidebar-divider my-0">

                <!-- Dashboard -->
                <li class="nav-item active">
                    <a class="nav-link" href="container.jsp">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>

                <!-- Divider -->


                <!-- Mantenimineto Section -->
                <%
                    boolean tienePermisoMantenimiento
                            = permisos != null && (permisos.contains("Clientes")
                            || permisos.contains("Personales")
                            || permisos.contains("Roles")
                            || permisos.contains("Usuarios")
                            || permisos.contains("Servicios")
                            || permisos.contains("Ejercicios"));
                %>

                <% if (tienePermisoMantenimiento) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseMantenimiento"
                       aria-expanded="true" aria-controls="collapseMantenimiento">
                        <i class="fas fa-address-book"></i>
                        <span>Mantenimiento</span>
                    </a>
                    <div id="collapseMantenimiento" class="collapse" aria-labelledby="headingMantenimiento" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Clientes")) { %>
                            <li><a class="nav-link collapse-item" href="clientes.jsp">Clientes</a></li>
                                <% } %>
                                <% if (permisos.contains("Personales")) { %>
                            <li><a class="nav-link collapse-item" href="personales.jsp">Personales</a></li>
                                <% } %>
                                <% if (permisos.contains("Roles")) { %>
                            <li><a class="nav-link collapse-item" href="roles.jsp">Roles</a></li>
                                <% } %>
                                <% if (permisos.contains("Usuarios")) { %>
                            <li><a class="nav-link collapse-item" href="usuarios.jsp">Usuarios</a></li>
                                <% } %>
                                <% if (permisos.contains("Servicios")) { %>
                            <li><a class="nav-link collapse-item" href="servicios.jsp">Servicios</a></li>
                                <% } %>
                                <% if (permisos.contains("Ejercicios")) { %>
                            <li><a class="nav-link collapse-item" href="ejercicios.jsp">Ejercicios</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->

                <!-- Pagos Section -->
                <%
                    boolean tienePermisoPagos
                            = permisos != null && (permisos.contains("Pagos")
                            || permisos.contains("Listar_Pagos"));
                %>

                <% if (tienePermisoPagos) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapsePagos"
                       aria-expanded="true" aria-controls="collapsePagos">
                        <i class="fas fa-notes-medical"></i>
                        <span>Pagos</span>
                    </a>
                    <div id="collapsePagos" class="collapse" aria-labelledby="headingPagos" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Pagos")) { %>
                            <li><a class="nav-link collapse-item" href="pagos.jsp">Nuevo pago</a></li>
                                <% } %>
                                <% if (permisos.contains("Listar_Pagos")) { %>
                            <li><a class="nav-link collapse-item" href="listarpagos.jsp">Lista de pagos</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->

                <!-- Tratamiento Section -->
                <%
                    boolean tienePermisoTratamiento
                            = permisos != null && (permisos.contains("Rutinas")
                            || permisos.contains("Listar_Rutinas")
                            || permisos.contains("Ver_Rutinas")
                            || permisos.contains("Control_Rutinas")
                            || permisos.contains("Asisntencia"));
                %>

                <% if (tienePermisoTratamiento) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTratamiento"
                       aria-expanded="true" aria-controls="collapseTratamiento">
                        <i class="fas fa-running"></i>
                        <span>Tratamiento</span>
                    </a>
                    <div id="collapseTratamiento" class="collapse" aria-labelledby="headingTratamiento" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Rutinas")) { %>
                            <li><a class="nav-link collapse-item" href="rutinas.jsp">Nueva rutina</a></li>
                                <% } %>
                                <% if (permisos.contains("Listar_Rutinas")) { %>
                            <li><a class="nav-link collapse-item" href="listarrutinas.jsp">Lista de rutinas</a></li>
                                <% } %>
                                <% if (permisos.contains("Ver_Rutinas")) { %>
                            <li><a class="nav-link collapse-item" href="verRutinas.jsp">Ver rutinas</a></li>
                                <% } %>
                                <% if (permisos.contains("Control_Rutinas")) { %>
                            <li><a class="nav-link collapse-item" href="controlRutinas.jsp">Seguimiento rutinas</a></li>
                                <% } %>
                                    <% if (permisos.contains("Asistencia")) { %>
                            <li><a class="nav-link collapse-item" href="asistencias.jsp">Asistencias</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->
                
                <!-- Historial Section -->
                <%
                    boolean tienePermisoHistorial
                            = permisos != null && (permisos.contains("Consultas")
                            || permisos.contains("Evaluaciones_Generales")
                            || permisos.contains("Evaluaciones_ACL"));
                %>

                <% if (tienePermisoHistorial) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseHistorial"
                       aria-expanded="true" aria-controls="collapseHistorial">
                        <i class="fas fa-cogs"></i>
                        <span>Historial</span>
                    </a>
                    <div id="collapseHistorial" class="collapse" aria-labelledby="headingHistorial" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Consultas")) { %>
                            <li><a class="nav-link collapse-item" href="consultas.jsp">Consultas</a></li>
                                <% } %>
                                <% if (permisos.contains("Evaluaciones_Generales")) { %>
                            <li><a class="nav-link collapse-item" href="evaluaciones.jsp">Evaluaciones Generales</a></li>
                                <% } %>
                                <% if (permisos.contains("Evaluaciones_ACL")) { %>
                            <li><a class="nav-link collapse-item" href="acl_evaluaciones.jsp">Evaluaciones ACL</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->



                
                <!-- Informes Section -->
                <%
                    boolean tienePermisoInformes
                            = permisos != null && (permisos.contains("Informe Pagos General")
                            || permisos.contains("Informe Pago Cliente")
                            || permisos.contains("Informe Rutina Cliente")
                            || permisos.contains("Informe ACL Cliente")
                            || permisos.contains("Informe Evaluacion Cliente"));
                %>

                <% if (tienePermisoInformes) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseInformes"
                       aria-expanded="true" aria-controls="collapseInformes">
                        <i class="fas fa-diagnoses"></i>
                        <span>Informes</span>
                    </a>
                    <div id="collapseInformes" class="collapse" aria-labelledby="headingInformes" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Informe Pagos General")) { %>
                            <li><a class="nav-link collapse-item" href="informepago_vista.jsp">Informe pagos fecha</a></li>
                                <% } %>
                                <% if (permisos.contains("Informe Pago Cliente")) { %>
                            <li><a class="nav-link collapse-item" href="informepagodetallado_vista.jsp">Informe pagos fecha-cliente</a></li>
                                <% } %>
                            <% if (permisos.contains("Informe Rutina Cliente")) { %>
                            <li><a class="nav-link collapse-item" href="informerutinadetallada_vista.jsp">Informe rutinas fecha-cliente</a></li>
                                <% } %>
                            <% if (permisos.contains("Informe ACL Cliente")) { %>
                            <li><a class="nav-link collapse-item" href="informe_acl_detvista.jsp">Informe acl fecha-cliente</a></li>
                                <% } %>
                            <% if (permisos.contains("Informe Evaluacion Cliente")) { %>
                            <li><a class="nav-link collapse-item" href="informe_eva_detvista.jsp">Informe evaluaciones fecha-cliente</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% }%>

            </ul>
            <!-- End of Sidebar -->

            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column" style="background-color: white;">
                <!-- Main Content -->
                <div id="content" style="background-color: white;">
                    <!-- Topbar -->
                    <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                            <i class="fa fa-bars"></i>
                        </button>

                        <!-- Topbar Navbar -->
                        <ul class="navbar-nav ml-auto">
                            <!-- User Information -->
                            <li class="nav-item dropdown no-arrow">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="mr-2 d-none d-lg-inline text-gray-600 small"><%= sesion.getAttribute("user")%></span>
                                    <img class="img-profile rounded-circle" src="img/undraw_profile.svg">
                                </a>
                                <!-- Dropdown - User Information -->
                                <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                     aria-labelledby="userDropdown">
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i> Profile
                                    </a>
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i> Settings
                                    </a>
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i> Activity Log
                                    </a>
                                    <div class="dropdown-divider"></div>
                                    <a href="jsp/logout.jsp" class="dropdown-item">
                                        <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i> Logout
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </nav>
                    <!-- End of Topbar -->
                    <script>
    
                    </script>
