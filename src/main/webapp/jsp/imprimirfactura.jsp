
<%@page contentType="application/pdf" %>
<%@page import="net.sf.jasperreports.engine.JasperExportManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.jasperreports.engine.JasperFillManager"%>
<%@page import="net.sf.jasperreports.engine.JasperPrint"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>





<%
    String dirPath = "/rpt";
    String realPath = this.getServletContext().getRealPath(dirPath);
    System.out.println("---->" + realPath);
    String listado = "reporte_pago.jasper";

   
    String idcab_pago= (request.getParameter("idcab_pago"));
   // String numero_letras = (request.getParameter("numero_letras"));
  


    String jasperReport = "reporte_pago.jasper";

    System.out.println("-------->"+listado);
    JasperPrint print = null;
    Connection conn = null;

    

    try {
     

        Map parameters = new HashMap();
        parameters.put("ID", idcab_pago);
     //   parameters.put("MONTO_LETRAS", numero_letras);

        
 
        print = JasperFillManager.fillReport(realPath + "//" + jasperReport, parameters, conn);
        response.setContentType("application/pdf");
        JasperExportManager.exportReportToPdfStream(print, response.getOutputStream());
        
        
     
        
        response.getOutputStream().flush();
        response.getOutputStream().close();
    } catch (Exception ex) {
        ex.printStackTrace();
        System.out.println(ex.getMessage());
    } finally {
        if (conn != null) {
            conn.close();
        }
    }

%>