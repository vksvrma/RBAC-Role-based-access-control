<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String delete_query="delete from permissions where permission_id = ?";
int permissionId=Integer.parseInt(request.getParameter("permission_id"));


Class.forName("com.mysql.cj.jdbc.Driver");
Connection con= DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
PreparedStatement ps = con.prepareStatement(delete_query);
ps.setInt(1,permissionId);


response.sendRedirect("dashboard.jsp?page=manage&section=permission");


%>
</body>
</html>