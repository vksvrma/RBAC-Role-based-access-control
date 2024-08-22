<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.* ,jakarta.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Information</title>
<link rel="stylesheet" type="text/css" href="style.css">
<link href="https://fonts.googleapis.com/css?family=Rock+Salt" rel="stylesheet" type="text/css" />

</head>
<body>


<!-- This page indicates the manage section, it shows all the current users and their basic info  -->
<div class="container">
<form action="manage.jsp?page=manage&section=users" method="get" class="search" style="margin-left: 20px;
">
<input type="text" name="search" placeholder="Search Username" class="input">
<input type="submit" value="Search" class="submit">
</form>
</div>
<div class="manage_table">
    <%
    
    String roles = (String)request.getSession().getAttribute("userRoles");
    String userPermissions=(String)request.getSession().getAttribute("userPermissions");
    String search=request.getParameter("search");
	PreparedStatement ps=null;
	ResultSet rs=null;
	if(search!=null){
	out.println(search); 
	}
    try {
        String query = "SELECT u.user_id, u.username, u.full_name, u.email, r.role_name " +
                       "FROM Users u " +
                       "JOIN UserRoles ur ON u.user_id = ur.user_id " +
                       "JOIN Roles r ON ur.role_id = r.role_id";
        
        String searchResult="SELECT u.user_id, u.username, u.full_name, u.email, r.role_name " +
                			"FROM Users u " +
                			"JOIN UserRoles ur ON u.user_id = ur.user_id " +
                			"JOIN Roles r ON ur.role_id = r.role_id where u.username=?";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
        if(search!=null&&!search.isEmpty()){
        	if(search!=null&&!search.isEmpty()){
        ps=con.prepareStatement(searchResult);
        ps.setString(1,search);
         rs = ps.executeQuery();
        }
        	else{
        		out.println("Search returns 0 results");
        	}
        }
        else{
        	ps = con.prepareStatement(query);
        	 rs = ps.executeQuery();
        }
    
    %>
    <%!
    public boolean hasPermission(String userPermissions,String permission){
    	return userPermissions.contains(permission);
    }
    
    %>
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Role</th>
                <% if (hasPermission(userPermissions,"update")||hasPermission(userPermissions,"delete")) { %>
                <th>Actions</th>
                <th></th>
                <% } %>
            </tr>
        </thead>
        <tbody>
    <%
        while (rs.next()) {
    %>
            <tr>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("role_name") %></td>
               
                <% if (hasPermission(userPermissions,"update")) { %>
                <td>
                    <form method="post" action="user_update.jsp" style="display:inline;">
                        <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
                        <input type="submit" class ="btn" value="Update">
                    </form>
                    </td>
                    
                    <% } %>
                     <td>
                   <% if(hasPermission(userPermissions, "delete")) { %>
					   
					    <form method="post" action="user_delete.jsp" style="display:inline;">
					        <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
					        <input type="submit" class="btn" value="Delete" onclick="return confirm('Are you sure you want to delete this user?');">
					    </form>
                </td>
                <% } %>
            </tr>
    <%
    
        }
        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        out.println(e);
    }
    %>
        </tbody>
    </table>
</div>

</body>
</html>
