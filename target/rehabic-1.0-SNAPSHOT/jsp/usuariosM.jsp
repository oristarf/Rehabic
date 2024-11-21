
<%@include file="conexion.jsp"%>
<%
 if ("verificar_duplicado".equals(request.getParameter("listar"))) {
    String usuario = request.getParameter("usuario");

    try {
        PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM usuarios WHERE usuario ILIKE ?");
        pstmt.setString(1, usuario);
        ResultSet rs = pstmt.executeQuery();
        
        rs.next();
        int count = rs.getInt(1);
        
        if (count > 0) {
            out.print("duplicado"); // Indica que ya existe un servicio con ese nombre
        } else {
            out.print("no_duplicado"); // Indica que no existe y se puede insertar
        }
    } catch (Exception e) {
        out.print("<div class='alert alert-danger'>Error al verificar duplicado: " + e.getMessage() + "</div>");
    }
}   else if(request.getParameter("listar").equals("listar")){

   try{
        Statement st=null;
        ResultSet rs=null;
        st=conn.createStatement();
        rs=st.executeQuery("select u.idusuarios,u.usuario,u.usu_clave,r.idroles,r.rol from usuarios u inner join roles r on u.idroles =r.idroles order by u.idusuarios asc");
    while(rs.next())
{%>
<tr>
    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
  
    <td><%out.print(rs.getString(5));%></td>
    
  
    <td><i title="modificar" class="bi bi-pencil-square" onclick="rellenaredit('<%out.print(rs.getString(1));%>','<%out.print(rs.getString(2));%>','<%out.print(rs.getString(3));%>','<%out.print(rs.getString(4));%>')"></i>
        <i title="eliminar" class="bi bi-trash" onclick="$('#idpersonal_e').val('<%out.print(rs.getString(1));%>')" data-bs-toggle="modal" data-bs-target="#exampleModal"></i></td>
</tr>


<% 
    }

}catch(Exception e){
     out.print("error pp"+e);
    }

}else if(request.getParameter("listar").equals("cargar")){

String usuario =request.getParameter("usuario");
String clave =request.getParameter("clave");
String rol =request.getParameter("rol");

if(usuario==""){
out.print("<div class='alert alert-danger' role='alert'>campo vacio usuario</div>");
}else if(clave==""){
out.print("<div class='alert alert-danger' role='alert'>campo vacio clave</div>");
}else if(rol==""){
out.print("<div class='alert alert-danger' role='alert'>campo vacio rol</div>");
}
else{
 try{
        Statement st=null;
        st=conn.createStatement();
        st.executeUpdate("INSERT INTO usuarios(usuario, usu_clave, idroles) VALUES (upper('"+usuario+"'),'"+clave+"','"+rol+"')");

        out.print("<div class='alert alert-success' role='alert'>guardado correcto</div>");

}catch(Exception e){
     out.print("no funciona"+e);
    }
}
}else if(request.getParameter("listar").equals("modificar")){

String usuario =request.getParameter("usuario");
String clave =request.getParameter("clave");
String rol =request.getParameter("rol");
String pk =request.getParameter("idpersonal");
if(usuario==""){
out.print("<div class='alert alert-success' role='alert'>valor vacio</div>");
}else{
 try{
        Statement st=null;
        st=conn.createStatement();
        st.executeUpdate("update usuarios set usuario= upper('"+usuario+"'), usu_clave='"+clave+"',idroles='"+rol+"' where idusuarios='"+pk+"'");

        out.print("<div class='alert alert-success' role='alert'>modificado correcto</div>");

}catch(Exception e){
     out.print("no funciona"+e);
    }
}
}
else if(request.getParameter("listar").equals("eliminar")){
String pk =request.getParameter("idpersonal_e");

 try{
        Statement st=null;
        st=conn.createStatement();
        st.executeUpdate("DELETE FROM usuarios WHERE idusuarios='" + pk + "'");

        out.print("<div class='alert alert-success' role='alert'>Usuario eliminado</div>");

}catch(Exception e){
     out.print("no funciona"+e);
    }

}
     %>