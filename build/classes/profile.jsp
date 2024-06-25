<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import = "java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>Profile</h2>
<% 
	String query = "select ";
String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
String jdbcUsername = "root";
String jdbcPassword = "";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
PreparedStatement ps = con.prepareStatement(query);
String userPermissions=(String)request.getSession().getAttribute("userPermissions");

%>

<p><strong>Username:</strong> <%= (String) session.getAttribute("username") %></p>
<p><strong>Full Name:</strong> <%= (String) session.getAttribute("fullName") %></p>
<p><strong>Email:</strong> <%= (String) session.getAttribute("email") %></p>
<p><strong>Roles:</strong> <%= (String) session.getAttribute("userRoles") %></p>
<p><strong>Permissions</strong>:<%=userPermissions %></p>

</body>

</html>