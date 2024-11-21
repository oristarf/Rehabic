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
    } else if (uri.contains("asistencia.jsp")) {
        permisoRequerido = "Asistencia";
    } else if (uri.contains("servicios.jsp")) {
        permisoRequerido = "Servicios";
    } else if (uri.contains("ejercicios.jsp")) {
        permisoRequerido = "Ejercicios";
    } else if (uri.contains("pagos.jsp")) {
        permisoRequerido = "Pagos";
    } else if (uri.contains("mensualidades.jsp")) {
        permisoRequerido = "Mensualidades";
    } else if (uri.contains("listarpagos.jsp")) {
        permisoRequerido = "Listar_Pagos";
    } else if (uri.contains("evaluaciones.jsp")) {
        permisoRequerido = "Evaluaciones_Generales";
    } else if (uri.contains("acl_evaluaciones.jsp")) {
        permisoRequerido = "Evaluaciones_ACL";
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

        <!-- Custom fonts and styles -->
        <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="css/sb-admin-2.min.css" rel="stylesheet">
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

            .nav-item:hover .collapse {
                display: block !important;
            }

            .nav-link.collapsed::after {
                content: '\f078';
                font-family: "FontAwesome";
                float: right;
            }
        </style>
    </head>

    <body id="page-top">

        <!-- Page Wrapper -->
        <div id="wrapper">
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


                <!-- Gestionar Pacientes Section -->
                <%
                    boolean tienePermisoPacientes
                            = permisos != null && (permisos.contains("Clientes")
                            || permisos.contains("Consultas")
                            || permisos.contains("Historial")
                            || permisos.contains("Asistencia"));
                %>

                <% if (tienePermisoPacientes) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapsePacientes"
                       aria-expanded="true" aria-controls="collapsePacientes">
                        <i class="fas fa-address-book"></i>
                        <span>Gestionar Pacientes</span>
                    </a>
                    <div id="collapsePacientes" class="collapse" aria-labelledby="headingPacientes" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Clientes")) { %>
                            <li><a class="nav-link collapse-item" href="clientes.jsp">Pacientes</a></li>
                                <% } %>
                                <% if (permisos.contains("Consultas")) { %>
                            <li><a class="nav-link collapse-item" href="consultas.jsp">Consultas</a></li>
                                <% } %>
                                <% if (permisos.contains("Historial")) { %>
                            <li><a class="nav-link collapse-item" href="historial.jsp">Historial</a></li>
                                <% } %>
                                <% if (permisos.contains("Asistencia")) { %>
                            <li><a class="nav-link collapse-item" href="asistencia.jsp">Asistencia</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->


                <!-- Administrar Section -->
                <%
                    boolean tienePermisoAdministrar
                            = permisos != null && (permisos.contains("Roles")
                            || permisos.contains("Usuarios")
                            || permisos.contains("Servicios")
                            || permisos.contains("Ejercicios"));
                %>

                <% if (tienePermisoAdministrar) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdministrar"
                       aria-expanded="true" aria-controls="collapseAdministrar">
                        <i class="fas fa-cogs"></i>
                        <span>Administrar</span>
                    </a>
                    <div id="collapseAdministrar" class="collapse" aria-labelledby="headingAdministrar" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
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
                            || permisos.contains("Mensualidades")
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
                                <% if (permisos.contains("Mensualidades")) { %>
                            <li><a class="nav-link collapse-item" href="mensualidades.jsp">Mensualidades</a></li>
                                <% } %>
                                <% if (permisos.contains("Listar_Pagos")) { %>
                            <li><a class="nav-link collapse-item" href="listarpagos.jsp">Lista de pagos</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% } %>

                <!-- Divider -->


                <!-- Evaluaciones Section -->
                <%
                    boolean tienePermisoEvaluaciones
                            = permisos != null && (permisos.contains("Evaluaciones_Generales")
                            || permisos.contains("Evaluaciones_ACL"));
                %>

                <% if (tienePermisoEvaluaciones) { %>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseEvaluaciones"
                       aria-expanded="true" aria-controls="collapseEvaluaciones">
                        <i class="fas fa-diagnoses"></i>
                        <span>Evaluaciones</span>
                    </a>
                    <div id="collapseEvaluaciones" class="collapse" aria-labelledby="headingEvaluaciones" data-parent="#accordionSidebar">
                        <ul class="navbar-nav">
                            <% if (permisos.contains("Evaluaciones_Generales")) { %>
                            <li><a class="nav-link collapse-item" href="evaluaciones.jsp">Evaluaciones Generales</a></li>
                                <% } %>
                                <% if (permisos.contains("Evaluaciones_ACL")) { %>
                            <li><a class="nav-link collapse-item" href="acl_evaluaciones.jsp">Evaluaciones ACL</a></li>
                                <% } %>
                        </ul>
                    </div>
                </li>
                <% }%>

            </ul>
            <!-- End of Sidebar -->

            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column">
                <!-- Main Content -->
                <div id="content">
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
    // Ensures dropdown closes when the mouse leaves the menu area
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('mouseenter', () => {
            const target = item.querySelector('.collapse');
            if (target)
                target.classList.add('show');
        });

        item.addEventListener('mouseleave', () => {
            const target = item.querySelector('.collapse');
            if (target)
                target.classList.remove('show');
        });
    });
                    </script>
