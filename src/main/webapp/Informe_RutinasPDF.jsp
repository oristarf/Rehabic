<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="jsp/conexion.jsp" %>


<%
    String nombre = request.getParameter("nombreCliente");
    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");

    Map<String, Object> parametros = new HashMap<>();
    parametros.put("nombreCliente", (nombre != null && !nombre.trim().isEmpty()) ? "%" + nombre + "%" : null);
    parametros.put("fechaInicio", fechaInicio != null && !fechaInicio.trim().isEmpty() ? java.sql.Date.valueOf(fechaInicio) : null);
    parametros.put("fechaFin", fechaFin != null && !fechaFin.trim().isEmpty() ? java.sql.Date.valueOf(fechaFin) : null);

    try {
        File reportFile = new File(application.getRealPath("/reportes/RutinasFisioterapeuta.jasper"));
        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);
        
        response.setContentType("application/pdf");
        response.setContentLength(bytes.length);
        ServletOutputStream outputStream = response.getOutputStream();
        outputStream.write(bytes, 0, bytes.length);
        outputStream.flush();
        outputStream.close();
    } catch (Exception e) {
        out.println("Error al generar el reporte: " + e.getMessage());
    }
%>
