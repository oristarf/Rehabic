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
                        try{
                  
                        File reportFile=new File(application.getRealPath("reportes/infopagos.jasper"));
                        /**/
                        Map parametros=new HashMap();
                        SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd",Locale.ENGLISH);
                        String feinicio= request.getParameter("fechainicio");
                                                String fefinal= request.getParameter("fechafinal");
Date fechain=formatter.parse(feinicio);
Date fechafi =formatter.parse(fefinal);
                        //String codigo="2";
                        parametros.put("fecha_ini",fechain);
                                                parametros.put("fecha_fin",fechafi);



                       
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