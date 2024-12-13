<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="jsp/conexion.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
   try {
    File reportFile = new File(application.getRealPath("reportes/informe_acl_detallado.jasper"));
    if (!reportFile.exists()) {
        throw new FileNotFoundException("El archivo Jasper no se encuentra en la ruta especificada.");
    }

    // Crear mapa de parámetros
    Map<String, Object> parametros = new HashMap<>();
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

    // Obtener parámetros del request
    String feinicio = request.getParameter("fechainicio");
    String fefinal = request.getParameter("fechafinal");
    String idcliente = request.getParameter("idcliente");

    // Validar parámetros
    if (feinicio == null || feinicio.isEmpty() || fefinal == null || fefinal.isEmpty()) {
        throw new Exception("Debe proporcionar las fechas de inicio y fin.");
    }

    // Parsear fechas
    Date fechain = formatter.parse(feinicio);
    Date fechafi = formatter.parse(fefinal);

    // Agregar parámetros al mapa
    parametros.put("fecha_ini", fechain);
    parametros.put("fecha_fin", fechafi);

    // Validar idcliente (opcional)
    if (idcliente != null && !idcliente.trim().isEmpty()) {
        parametros.put("idcliente", Integer.parseInt(idcliente)); // Usar Integer si es numérico
    } else {
        parametros.put("idcliente", null); // Permitir valores nulos
    }

    // Generar informe PDF
    byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);

    // Configurar respuesta
    response.setContentType("application/pdf");
    response.setContentLength(bytes.length);

    // Enviar PDF al cliente
    try (ServletOutputStream output = response.getOutputStream()) {
        output.write(bytes, 0, bytes.length);
        output.flush();
    }
} catch (Exception e) {
    // Manejo de errores
    out.println("<h3>Error al generar el informe:</h3>");
    out.println("<p>" + e.getMessage() + "</p>");
}

%>
