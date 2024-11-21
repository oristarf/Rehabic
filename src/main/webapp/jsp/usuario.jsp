
<%@include file="conexion.jsp"%>
<%
    
if(request.getParameter("listar").equals("listar")){

   try{
        Statement st=null;
        ResultSet rs=null;
        st=conn.createStatement();
        rs=st.executeQuery("select * from usuarios");
    while(rs.next())
{%>
<option value="<%out.print(rs.getString(1));%>"><%out.print(rs.getString(2));%></option>

    

<% 
    }

}catch(Exception e){
     out.print("error pp"+e);
    }
} %>