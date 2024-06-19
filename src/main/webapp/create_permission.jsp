 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String permission = request.getParameter("permission_name");
permission=permission.replaceAll(" ","_").toLowerCase();

String desc = request.getParameter("description");
PreparedStatement ps = null;
Connection con = null;

try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
	String insert_permission = "insert into permissions(permission_name,description) values(?,?)";
	ps = con.prepareStatement(insert_permission);
	ps.setString(1,permission);
	ps.setString(2,desc);
	ps.executeUpdate();
	session.setAttribute("message", "Permission created successfully!");
    response.sendRedirect("success.jsp");
	
}
catch (Exception e){
	out.println(e);
}
finally {
    // Close the PreparedStatement and Connection objects
    try {
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        out.println(e);
    }
}


%>
</body>
</html>