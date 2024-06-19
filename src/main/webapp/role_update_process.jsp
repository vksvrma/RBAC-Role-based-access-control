<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Role Process</title>
</head>
<body>

<%
    // Get form data
    int roleId = Integer.parseInt(request.getParameter("role_id"));
    String roleName = request.getParameter("role_name");
    String description = request.getParameter("description");
    String[] permissions = request.getParameterValues("permissions");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement updateRolePreparedStatement = null;
    PreparedStatement deletePermissionsPreparedStatement = null;
    PreparedStatement insertPermissionsPreparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Update role query
        String updateRoleQuery = "UPDATE Roles SET role_name = ?, description = ? WHERE role_id = ?";
        updateRolePreparedStatement = connection.prepareStatement(updateRoleQuery);
        updateRolePreparedStatement.setString(1, roleName);
        updateRolePreparedStatement.setString(2, description);
        updateRolePreparedStatement.setInt(3, roleId);
        updateRolePreparedStatement.executeUpdate();

        // Delete current permissions query
        String deletePermissionsQuery = "DELETE FROM RolePermissions WHERE role_id = ?";
        deletePermissionsPreparedStatement = connection.prepareStatement(deletePermissionsQuery);
        deletePermissionsPreparedStatement.setInt(1, roleId);
        deletePermissionsPreparedStatement.executeUpdate();

        // Insert new permissions query
        if (permissions != null) {
            for (String permission : permissions) {
                int permissionId = Integer.parseInt(permission);

                String insertPermissionsQuery = "INSERT INTO RolePermissions (role_id, permission_id) VALUES (?, ?)";
                insertPermissionsPreparedStatement = connection.prepareStatement(insertPermissionsQuery);
                insertPermissionsPreparedStatement.setInt(1, roleId);
                insertPermissionsPreparedStatement.setInt(2, permissionId);
                insertPermissionsPreparedStatement.executeUpdate();
            }
        }

        response.sendRedirect("dashboard.jsp?page=manage&section=roles"); // Redirect to roles page
    } catch (Exception e) {
        out.println(e);
    } finally {
        if (updateRolePreparedStatement != null) updateRolePreparedStatement.close();
        if (deletePermissionsPreparedStatement != null) deletePermissionsPreparedStatement.close();
        if (insertPermissionsPreparedStatement != null) insertPermissionsPreparedStatement.close();
        if (connection != null) connection.close();
    }
%>

</body>
</html>
