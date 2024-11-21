<%-- 
    Document   : reservas
    Created on : 25 jun. 2024, 17:10:47
    Author     : david
--%>

<%@include file="header.jsp"%>
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
<main id="main" class="main">
    <div id="mensaje"></div>
    <form action="#" method="post" id="form" onsubmit="return false" class="row g-3"> 
        <input type="hidden" name="listar" id="listar" value="cargar">
        
        <div class="container">
            <div class="row">
                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h2 class="card-title text-primary text-center mb-4">Datos de la Reserva</h2>
                            <!-- Vertical Form -->
                            <div class="row mb-3">
                                <div class="col-6">
                                    <label for="idpersona" class="form-label">Persona</label>
                                    <select class="select2 form-control" name="idpersona" id="idpersona" onchange="dividirpersona(this.value)">
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="ci_persona" class="form-label">CI</label>
                                    <input type="text" class="form-control" id="ci_persona" name="ci_persona" placeholder="CI" readonly> 
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-6">
                                    <label for="idusuario" class="form-label">Usuario</label>
                                    <input type="hidden" id="idusuario" name="idusuario" value="<% out.print(sesion.getAttribute("idusuario")); %>">
                                    <input type="text" class="form-control" placeholder="Usuario" value="<% out.print(sesion.getAttribute("user")); %>" readonly>
                                </div>
                                <div class="col-6">
                                    <label for="fechareserva" class="form-label">Fecha de la Reserva</label>
                                    <input type="text" class="form-control" id="fechareserva" name="fechareserva" value="<%= fechaFormateada %>" readonly>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-6">
                                    <label for="idlibro" class="form-label">Libro</label>
                                    <select class="select2 form-control" name="idlibro" id="idlibro" onchange="validarDisponibilidad(this.value)">
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="cantidad_reserva" class="form-label">Cantidad</label>
                                    <input type="number" class="form-control" id="cantidad_reserva" name="cantidad_reserva" value="1" min="1" oninput="validarCantidadReserva(this.value)">
                                </div>
                            </div>
                            <div class="col-6 mx-auto mb-3">
                                <label for="fechafinreserva" class="form-label">Fecha Final de la Reserva</label>
                                <input type="date" class="form-control" id="fechafinreserva" name="fechafinreserva" min="<?php echo date('Y-m-d'); ?>">
                            </div>
                            
                            <div class="text-center mt-4">
                                <button type="button" class="btn btn-primary" id="botonagregar" name="boton">Agregar</button>
                                <div id="respuesta" class="mt-3"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de registro -->
        <div class="container text-center my-4">
            <div class="row">
                <div class="col">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h2 class="card-title text-primary mb-4">Registro de la Reserva</h2>
                            <table class="table table-bordered table-hover" id="resultados">
                                <thead class="table-primary">
                                    <tr>
                                        <th>#</th>
                                        <th>Libro</th>
                                        <th>Cantidad</th>
                                        <th>Fecha Final de la Reserva</th>
                                        <th>Opciones</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                            <div class="text-center">
                                <button type="button" class="btn btn-danger me-2" id="cancelar-reserva">Cancelar</button>
                                <button type="button" class="btn btn-success" id="final-reserva">Registrar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="basicModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmación</h5>
                        <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="pkdel" id="pkdel"/>
                        <p>¿Está seguro de querer eliminar los datos del registro?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <button type="button" class="btn btn-primary" data-dismiss="modal" id="delreserva">Sí</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</main>

<%@include file="footer.jsp"%>
<script>
    $(document).ready(function () {
        buscarpersona();

        buscarlibros();
    });
    function buscarpersona() {
        $.ajax({
            data: {listar: 'buscarpersona'},
            url: 'jsp/consulta_persona.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#idpersona").html(response);

            }
        });
    }

    /* function buscarusuario() {
     $.ajax({
     data: {listar: 'buscarusuario'},
     url: 'jsp/consulta_usuario.jsp',
     type: 'post',
     beforeSend: function () {
     //$("#resultado").html("Procesando, espere por favor...");
     },
     success: function (response) {
     $("#idusuario").html(response);
     }
     });
     } */
    
    
    
    function buscarlibros() {
    $.ajax({
        data: {listar: 'buscarlibros'},
        url: 'jsp/consulta_libros.jsp',
        type: 'post',
        beforeSend: function () {
            //$("#resultado").html("Procesando, espere por favor...");
        },
        success: function (response) {
            $("#idlibro").html(response);
            // Agregar atributo data-cantidad-disponible a cada opción
            $("#idlibro option").each(function() {
                var idlibro = $(this).val();
                $.ajax({
                    data: {listar: 'buscarcantidaddisponible', idlibro: idlibro},
                    url: 'jsp/consulta_libros.jsp',
                    type: 'post',
                    async: false,
                    success: function (response) {
                        $(this).attr("data-cantidad-disponible", response);
                    }
                });
            });
        }
    });
}
    /*function dividirproveedor(a) {
     //alert(a)
     datos = a.split(',');
     //alert(datos[0]);
     // alert(datos[1]);
     $("#codproveedor").val(datos[0]);
     $("#ruc").val(datos[1]);
     }
     */
    /*
     function dividirproducto(a) {
     //alert(a)
     datos = a.split(',');
     //alert(datos[0]);
     // alert(datos[1]);
     $("#codproducto").val(datos[0]);
     $("#precio").val(datos[1]);
     }
     */
    $("#botonagregar").click(function () {

        datosform = $("#form").serialize();
        //alert(datosform);
        $.ajax({
            data: datosform,
            url: 'jsp/reserva.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#respuesta").html(response);
                cargardetalle();
            }
        });
    });

    function cargardetalle() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/reserva.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {

                $("#resultados tbody").html(response);
            }
        });
    }
    $("#delreserva").click(function () {
        pkd = $("#pkdel").val();
        $.ajax({
            data: {listar: 'elimregreserva', pkd: pkd},
            url: 'jsp/reserva.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                //console.log(response);
                cargardetalle();


            }
        });
    });

    $("#cancelar-reserva").click(function () {
        $.ajax({
            data: {listar: 'cancelreserva'},
            url: 'jsp/reserva.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                location.href = 'listarreserva.jsp';

            }
        });
    });
    $("#final-reserva").click(function () {

        $.ajax({
            data: {listar: 'finalreserva'},
            url: 'jsp/reserva.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                //console.log(response);
                location.href = 'listarreserva.jsp';

            }
        });
    });
    function dividirpersona(a) {
        var selectedOption = document.querySelector('#idpersona option[value="' + a + '"]');
        var ciPersona = selectedOption.getAttribute('data-ci');

        $("#ci_persona").val(ciPersona);
        $("#idpersona").val(a);
    }

$(document).ready(function () {
    $('#idpersona').select2({
        placeholder: 'Seleccionar Persona',
        allowClear: true
    });
});
$("#form").submit(function() {
    var idPersona = $("#idpersona").val();
    if (!idPersona) {
        alert("Por favor, selecciona una persona.");
        return false;  // Evita el envío del formulario
    }
});

</script>
<script>
  const fechaActual = new Date().toISOString().split('T')[0];
  document.getElementById('fechafinreserva').setAttribute('min', fechaActual);
</script>
<script>
    function validarDisponibilidad(idlibro) {
        var seleccion = document.getElementById("idlibro");
        var cantidadDisponible = parseInt(seleccion.options[seleccion.selectedIndex].getAttribute("data-cantidad-disponible"), 10);
        
        if (cantidadDisponible === 0) {
            alert("El libro seleccionado no está disponible.");
        }
    }
    
    function validarCantidadReserva(cantidad) {
        var seleccion = document.getElementById("idlibro");
        var cantidadDisponible = parseInt(seleccion.options[seleccion.selectedIndex].getAttribute("data-cantidad-disponible"), 10);
        
        if (parseInt(cantidad, 10) > cantidadDisponible) {
            alert("No puede reservar más libros de los que están disponibles.");
            document.getElementById("cantidad_reserva").value = cantidadDisponible;
        }
    }
</script>