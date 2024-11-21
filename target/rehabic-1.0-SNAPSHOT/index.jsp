<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Clínica de Rehabilitación y Fisioterapia">
    <meta name="author" content="Rehabic Clinic">

    <title>LOGIN REHABIC</title>

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

    <!-- Additional custom styles -->
    <style>
        /* Fondo de pantalla en gradiente */
        /* Fondo de pantalla en gradiente */
        body {
            background: linear-gradient(135deg, #10243c 15%, #17a2b8 90%);
        }


        /* Fondo suave para el formulario */
        .bg-login {
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        /* Estilos para el encabezado */
        .login-header {
            color: #10243c;
            font-weight: bold;
            font-size: 1.5rem;
        }

        /* Botón de login */
        .login-button {
            background-color: #17a2b8;
            color: #fff;
            transition: background-color 0.3s ease;
        }

        .login-button:hover {
            background-color: #10243c;
        }

        /* Tamaño máximo del contenedor */
        .login-container {
            max-width: 450px;
            margin-top: 8%;
        }

        /* Estilo de campos de entrada */
        .form-control-user {
            border-radius: 20px;
            padding: 15px;
        }

        /* Footer personalizado */
        .login-footer {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>

</head>

<body>

    <div class="container login-container">

        <!-- Outer Row -->
        <div class="row justify-content-center">

            <div class="col-lg-10 col-md-12">

                <div class="card bg-login">
                    <div class="card-body p-5">
                        <!-- Nested Row within Card Body -->
                        <div class="text-center">
                            <h1 class="login-header mb-4">¡Bienvenido a Rehabic!</h1>
                            <p class="text-gray-700 mb-4">Ingrese sus credenciales para acceder a su cuenta</p>
                        </div>

                        <form action="#" method="post" autocomplete="off" class="logInForm" id="form">
                            <div class="form-group">
                                <input type="text" class="form-control form-control-user" id="usuario" 
                                       placeholder="Usuario" name="usuario" required>
                            </div>
                            <div class="form-group">
                                <input type="password" class="form-control form-control-user" id="usu_clave" 
                                       placeholder="Contraseña" name="usu_clave" required>
                            </div>

                            <div class="form-group text-center">
                                <input type="button" value="Iniciar sesión" 
                                       class="btn login-button btn-user btn-block" id="acceso" name="acceso">
                            </div>

                            <div id="respuesta" class="text-center mt-3"></div>
                        </form>
                        
                        
                        <!--<div class="text-center login-footer mt-4">
                            <p>© 2024 Rehabic Clinic - Todos los derechos reservados</p>
                        </div> -->
                        
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>

    <!-- Login functionality -->
    <script>
        $(function () {
            $("#acceso").click(function () {
                var datosform = $("#form").serialize();
                $.ajax({
                    data: datosform,
                    url: 'jsp/login.jsp',
                    type: 'post',
                    success: function (response) {
                        $("#respuesta").html(response);
                    }
                });
            });

            $("#form").keypress(function (event) {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    $("#acceso").click();
                }
            });
        });
    </script>

</body>

</html>
