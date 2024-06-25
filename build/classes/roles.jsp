<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.Set, java.util.HashSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Role</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";
    
    Connection con = null;
    PreparedStatement allPermissionsPreparedStatement = null;
    ResultSet allPermissionsResultSet = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    
        String allPermissionsQuery = "SELECT permission_id, permission_name FROM Permissions";
        allPermissionsPreparedStatement = con.prepareStatement(allPermissionsQuery);
        allPermissionsResultSet = allPermissionsPreparedStatement.executeQuery();
%>

    <form method="post" action="roles_create_back.jsp" class="form">
    <label><input type="text" name="role_name" placeholder="Role Name" class="input" required></label><br>
    <label><input type="text" name="desc" placeholder="Description" class="input" required></label><br>
    <label for="permissions">Permissions:</label><br>
    <%
    while (allPermissionsResultSet.next()) {
        int permissionId = allPermissionsResultSet.getInt("permission_id");
        String permissionName = allPermissionsResultSet.getString("permission_name");
    %>
        <input type="checkbox" name="permissions" value="<%= permissionId %>" id="permission_<%= permissionId %>">
        <label for="permission_<%= permissionId %>"><%= permissionName %></label><br>
    <%
    }
    %>
    <input type="submit" value="Submit" class="submit">
</form>


<%
    } catch (Exception e) {
    	 out.println(e);
    } finally {
        try {
            if (allPermissionsResultSet != null) allPermissionsResultSet.close();
            if (allPermissionsPreparedStatement != null) allPermissionsPreparedStatement.close();
            if (con != null) con.close();
        } catch (SQLException e) {
        	 out.println(e);
        }
    }
%>

</body>
</html>
