<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<%

PreparedStatement ps =null;
Connection con =null;
ResultSet rs = null;
String roles = (String)request.getSession().getAttribute("userRoles");
String userPermissions =(String)request.getSession().getAttribute("userPermissions");


try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
	String show_permission ="select * from permissions";
	ps=con.prepareStatement(show_permission);
	rs = ps.executeQuery();
	%>
	<%! 
    // Function to check if user has a specific permission
    public boolean hasPermission(String userPermissions, String permission) {
        return userPermissions != null && userPermissions.contains(permission);
    }
%>
<div class="manage_table">
	<table class="table">
    <thead>
        <tr>
           
            <th>Permission</th>
            <th>Description</th>
            <% if (hasPermission(userPermissions, "update")) { %>
            <th>Actions</th>
            <% } %>
        </tr>
    </thead>
    <tbody>
	<% 
	
	while(rs.next()){
	%>
	<tr>
                <td><%= rs.getString("permission_name") %></td>
                <td><%= rs.getString("description") %></td>
                <% if (hasPermission(userPermissions, "delete")) { %>
                <td>
                   <form method ="post" action="permission_delete.jsp">
                   <input type="hidden" name="permission_id" value="<%= rs.getInt("permission_id") %>">
                   <input type="submit" class ="btn" value="Delete" onclick="return confirm('Are you sure want to delete this permission?');">
                   </form>
                </td>
                <% } %>	
            </tr>
	<% 
	}
}
catch (Exception e){
	out.println(e);
}

%>
</tbody>
</table>
</div>
</body>
</html>