<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="jsp/conexion.jsp" %>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
                        try{
                        /*INDICAMOS EL LUGAR DONDE SE ENCUENTRA NUESTRO ARCHIVO JASPER*/
                        File reportFile=new File(application.getRealPath("reportes/DatoCliente.jasper"));
                        /**/
                        Map parametros=new HashMap();
                        
                        //String codigo= request.getParameter("nombre_variable_GET");
                        String codigo= request.getParameter("eyecli"); //eyecli es el nombre de la variable que yo quiero estirar, en este caso es el id del cliente
                        //String codigo = "5";
                        
                        int cangrejo = Integer.parseInt(codigo);
                        parametros.put("codcliente", cangrejo);
                        
                        byte [] bytes= JasperRunManager.runReportToPdf(reportFile.getPath(), parametros,conn);
                        response.setContentType("application/pdf");
                        response.setContentLength(bytes.length);

                        ServletOutputStream output=response.getOutputStream();
                        response.getOutputStream();
                        output.write(bytes,0,bytes.length);
                        output.flush();
                        output.close();
                        }
                        catch(java.io.FileNotFoundException ex)
                        {
                            ex.getMessage();
                        }
                    %>