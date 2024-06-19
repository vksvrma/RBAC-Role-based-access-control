<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.Set, java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update User</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%
    // Get user ID from request
    int userId = Integer.parseInt(request.getParameter("user_id"));

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement userPreparedStatement = null;
    PreparedStatement userPermissionsPreparedStatement = null;
    PreparedStatement allPermissionsPreparedStatement = null;
    ResultSet userResultSet = null;
    ResultSet userPermissionsResultSet = null;
    ResultSet allPermissionsResultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Query to get user details
        String userQuery = "SELECT user_id, username, full_name, email FROM users WHERE user_id = ?";
        userPreparedStatement = connection.prepareStatement(userQuery);
        userPreparedStatement.setInt(1, userId);
        userResultSet = userPreparedStatement.executeQuery();

        // Query to get user permissions
        String userPermissionsQuery = "SELECT permission_id FROM UserPermissions WHERE user_id = ?";
        userPermissionsPreparedStatement = connection.prepareStatement(userPermissionsQuery);
        userPermissionsPreparedStatement.setInt(1, userId);
        userPermissionsResultSet = userPermissionsPreparedStatement.executeQuery();

        // Query to get all permissions
        String allPermissionsQuery = "SELECT permission_id, permission_name FROM Permissions";
        allPermissionsPreparedStatement = connection.prepareStatement(allPermissionsQuery);
        allPermissionsResultSet = allPermissionsPreparedStatement.executeQuery();

        // Store user permissions in a set for easy lookup
        Set<Integer> userPermissionsSet = new HashSet<>();
        while (userPermissionsResultSet.next()) {
            userPermissionsSet.add(userPermissionsResultSet.getInt("permission_id"));
        }

        if (userResultSet.next()) {
%>
            <form action="user_update_process.jsp" method="post" class="form">
                <h3>Update user</h3>
                <input type="hidden" name="user_id" value="<%= userId %>" class="input">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" value="<%= userResultSet.getString("username") %>" class="input" required><br>
                <label for="full_name">Full Name:</label>
                <input type="text" id="full_name" name="full_name" value="<%= userResultSet.getString("full_name") %>" class="input" required><br>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= userResultSet.getString("email") %>" class="input" required><br>
                <label for="permissions">Permissions:</label><br>
                <%
                    while (allPermissionsResultSet.next()) {
                        int permissionId = allPermissionsResultSet.getInt("permission_id");
                        String permissionName = allPermissionsResultSet.getString("permission_name");
                        boolean checked = userPermissionsSet.contains(permissionId);
                %>
                        <input type="checkbox" name="permissions" value="<%= permissionId %>" <%= checked ? "checked" : "" %>> <%= permissionName %><br>
                <%
                    }
                %>
                <input type="submit" value="Update" class="submit">
            </form>
<%
        } else {
            out.println("User not found.");
        }
    } catch (Exception e) {
        out.println(e);
    } finally {
        if (userResultSet != null) userResultSet.close();
        if (userPermissionsResultSet != null) userPermissionsResultSet.close();
        if (allPermissionsResultSet != null) allPermissionsResultSet.close();
        if (userPreparedStatement != null) userPreparedStatement.close();
        if (userPermissionsPreparedStatement != null) userPermissionsPreparedStatement.close();
        if (allPermissionsPreparedStatement != null) allPermissionsPreparedStatement.close();
        if (connection != null) connection.close();
    }
%>

</body>
</html>
