<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.Set, java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Role</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%
    // Get role ID from request
    int roleId = Integer.parseInt(request.getParameter("role_id"));

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement rolePreparedStatement = null;
    PreparedStatement rolePermissionsPreparedStatement = null;
    PreparedStatement allPermissionsPreparedStatement = null;
    ResultSet roleResultSet = null;
    ResultSet rolePermissionsResultSet = null;
    ResultSet allPermissionsResultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Query to get role details
        String roleQuery = "SELECT role_id, role_name, description FROM Roles WHERE role_id = ?";
        rolePreparedStatement = connection.prepareStatement(roleQuery);
        rolePreparedStatement.setInt(1, roleId);
        roleResultSet = rolePreparedStatement.executeQuery();

        // Query to get role permissions
        String rolePermissionsQuery = "SELECT permission_id FROM RolePermissions WHERE role_id = ?";
        rolePermissionsPreparedStatement = connection.prepareStatement(rolePermissionsQuery);
        rolePermissionsPreparedStatement.setInt(1, roleId);
        rolePermissionsResultSet = rolePermissionsPreparedStatement.executeQuery();

        // Query to get all permissions
        String allPermissionsQuery = "SELECT permission_id, permission_name FROM Permissions";
        allPermissionsPreparedStatement = connection.prepareStatement(allPermissionsQuery);
        allPermissionsResultSet = allPermissionsPreparedStatement.executeQuery();

        // Store role permissions in a set for easy lookup
        Set<Integer> rolePermissionsSet = new HashSet<>();
        while (rolePermissionsResultSet.next()) {
            rolePermissionsSet.add(rolePermissionsResultSet.getInt("permission_id"));
        }

        if (roleResultSet.next()) {
%>
            <form action="role_update_process.jsp" method="post" class="form">
                <h3>Update Role</h3>
                <input type="hidden" name="role_id" value="<%= roleId %>" class="input">
                <label for="role_name">Role Name:</label>
                <input type="text" id="role_name" name="role_name" value="<%= roleResultSet.getString("role_name") %>" class="input" required><br>
                <label for="description">Description:</label>
                <input type="text" id="description" name="description" value="<%= roleResultSet.getString("description") %>" class="input" required><br>
                <label for="permissions">Permissions:</label><br>
                <%
                    while (allPermissionsResultSet.next()) {
                        int permissionId = allPermissionsResultSet.getInt("permission_id");
                        String permissionName = allPermissionsResultSet.getString("permission_name");
                        boolean checked = rolePermissionsSet.contains(permissionId);
                %>
                        <input type="checkbox" name="permissions" value="<%= permissionId %>" <%= checked ? "checked" : "" %>> <%= permissionName %><br>
                <%
                    }
                %>
                <input type="submit" value="Update" class="submit">
            </form>
<%
        } else {
            out.println("Role not found.");
        }
    } catch (Exception e) {
        out.println(e);
    } finally {
        if (roleResultSet != null) roleResultSet.close();
        if (rolePermissionsResultSet != null) rolePermissionsResultSet.close();
        if (allPermissionsResultSet != null) allPermissionsResultSet.close();
        if (rolePreparedStatement != null) rolePreparedStatement.close();
        if (rolePermissionsPreparedStatement != null) rolePermissionsPreparedStatement.close();
        if (allPermissionsPreparedStatement != null) allPermissionsPreparedStatement.close();
        if (connection != null) connection.close();
    }
%>

</body>
</html>
