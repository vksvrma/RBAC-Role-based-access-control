<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%
    // Get form data
    int userId = Integer.parseInt(request.getParameter("user_id"));
	String username = request.getParameter("username");
	String name = request.getParameter("full_name");
	String email = request.getParameter("email");
    String[] permissions = request.getParameterValues("permissions");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement deletePermissionsPreparedStatement = null;
    PreparedStatement insertPermissionsPreparedStatement = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
		
        connection.setAutoCommit(false);
        
        String updateQuery = "update users set username =?, full_name =?, email =? where user_id = ?";
        ps = connection.prepareStatement(updateQuery);
        ps.setString(1,username);
        ps.setString(2, name);
        ps.setString(3,email);
        ps.setInt(4,userId);
        ps.executeUpdate();

        // Delete current permissions for the user
        String deletePermissionsQuery = "DELETE FROM UserPermissions WHERE user_id = ?";
        deletePermissionsPreparedStatement = connection.prepareStatement(deletePermissionsQuery);
        deletePermissionsPreparedStatement.setInt(1, userId);
        deletePermissionsPreparedStatement.executeUpdate();

        // Insert new permissions for the user
        if (permissions != null) {
            String insertPermissionsQuery = "INSERT INTO UserPermissions (user_id, permission_id) VALUES (?, ?)";
            insertPermissionsPreparedStatement = connection.prepareStatement(insertPermissionsQuery);
            for (String permission : permissions) {
                int permissionId = Integer.parseInt(permission);
                insertPermissionsPreparedStatement.setInt(1, userId);
                insertPermissionsPreparedStatement.setInt(2, permissionId);
                insertPermissionsPreparedStatement.executeUpdate();
            }
        }
        connection.commit();

        response.sendRedirect("dashboard.jsp?page=manage"); // Redirect to users page
    } catch (Exception e) {
        // Rollback transaction on error
        if (connection != null) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                out.println(rollbackEx);
            }
        }
        out.println(e);
    } finally {
        try {
            if (ps != null) ps.close();
            if (deletePermissionsPreparedStatement != null) deletePermissionsPreparedStatement.close();
            if (insertPermissionsPreparedStatement != null) insertPermissionsPreparedStatement.close();
            if (connection != null) {
                connection.setAutoCommit(true); // Restore auto-commit mode
                connection.close();
            }
        } catch (SQLException closeEx) {
            out.println(closeEx);
        }
    }
    
%>
