<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Role Management</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="manage_table">
    <%
    String roles = (String)request.getSession().getAttribute("userRoles");
    String userPermissions=(String)request.getSession().getAttribute("userPermissions");
    try {
        String show_roles =  "SELECT r.role_id, r.role_name, r.description, " +
                             "GROUP_CONCAT(p.permission_name SEPARATOR ', ') AS permissions " +
                             "FROM roles r " +
                             "JOIN rolepermissions rp ON r.role_id = rp.role_id " +
                             "JOIN permissions p ON rp.permission_id = p.permission_id " +
                             "GROUP BY r.role_id, r.role_name, r.description";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
        PreparedStatement ps = con.prepareStatement(show_roles);
        ResultSet rs = ps.executeQuery();
    %>  
    <%! 
    // Function to check if user has a specific permission
    public boolean hasPermission(String userPermissions, String permission) {
        return userPermissions != null && userPermissions.contains(permission);
    }
%>
        <table class="table">
        <thead>
            <tr>
                <th>Role ID</th>
                <th>Role Name</th>
                <th>Role Description</th>
                <th>Permissions</th>
                <% if (hasPermission(userPermissions,"update")||hasPermission(userPermissions,"delete")) { %>
                <th>Actions</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
        <% 
        while (rs.next()) {
        	String rawPermissions = rs.getString("permissions");
        	
        	 StringBuilder formattedPermissions = new StringBuilder();
             if (rawPermissions != null && !rawPermissions.isEmpty()) {
                 String[] permissionsArray = rawPermissions.split(", ");
                 for (String permission : permissionsArray) {
                     String[] words = permission.split("_");
                     for (int i = 0; i < words.length; i++) {
                         words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase();
                     }
                     formattedPermissions.append(String.join(" ", words)).append(", ");
                 }
                 formattedPermissions.setLength(formattedPermissions.length() - 2); // Remove the last comma and space
             }
        	
        %>
            <tr>
                <td><%= rs.getInt("role_id") %></td>
                <td><%= rs.getString("role_name") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= formattedPermissions.toString() %></td>
                 <% if (hasPermission(userPermissions,"update")) { %>
                <td>
                    <form method="post" action="role_update.jsp" style="display:inline;">
                        <input type="hidden" name="role_id" value="<%= rs.getInt("role_id") %>">
                        <input type="submit" class ="btn1"  value="Update">
                    </form>
                    <%} 
                    if(hasPermission(userPermissions,"delete")){
                    %>
                    
                    <form method="post" action="roles_delete.jsp" style="display:inline;">
                        <input type="hidden" name="role_id" value="<%= rs.getInt("role_id") %>">
                        <input type="submit" class ="btn1"  value="Delete">
                    </form>
                </td>
                <% } %>
            </tr>
        <%
        
        
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println(e);
    }
    %>
        </tbody>
        </table>
</div>

</body>
</html>
