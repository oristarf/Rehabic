<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="jsp/conexion.jsp" %>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        // Obtén el parámetro `idcab_pago` desde la URL
        String idcab_pago = request.getParameter("idcab_pago");

        if (idcab_pago == null || idcab_pago.trim().isEmpty()) {
            out.println("<h3>Error: No se proporcionó un ID válido para el reporte.</h3>");
            return;
        }

        // Ruta al archivo del reporte
        File reportFile = new File(application.getRealPath("reportes/REPORTEPAGO.jasper"));

        // Parámetros para el reporte
        Map<String, Object> parametros = new HashMap<>();
        parametros.put("idcab_pago", Integer.parseInt(idcab_pago)); // Pasamos el ID como parámetro

        // Generar el PDF
        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);
        response.setContentType("application/pdf");
        response.setContentLength(bytes.length);

        // Enviar el PDF al navegador
        ServletOutputStream output = response.getOutputStream();
        output.write(bytes, 0, bytes.length);
        output.flush();
        output.close();
    } catch (Exception ex) {
        out.println("<h3>Error al generar el reporte: " + ex.getMessage() + "</h3>");
    }
%>
