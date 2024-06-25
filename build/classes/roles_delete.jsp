<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Role</title>
</head>
<body>

<%
    // Get role ID from request
    int roleId = Integer.parseInt(request.getParameter("role_id"));
    String userRole = (String) request.getSession().getAttribute("userRoles");
    int currentUserId = (int) request.getSession().getAttribute("userId");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Get the role ID of the current user
        String userRoleQuery = "SELECT ur.role_id FROM UserRoles ur WHERE ur.user_id = ?";
        preparedStatement = connection.prepareStatement(userRoleQuery);
        preparedStatement.setInt(1, currentUserId);
        resultSet = preparedStatement.executeQuery();
        
        int currentUserRoleId = -1;
        if (resultSet.next()) {
            currentUserRoleId = resultSet.getInt("role_id");
        }

        // Check if the current user is an admin
        if ("admin".equals(userRole) && roleId != currentUserRoleId) {
            // Delete query
            String deleteQuery = "DELETE FROM Roles WHERE role_id = ?";
            preparedStatement = connection.prepareStatement(deleteQuery);
            preparedStatement.setInt(1, roleId);

            int rowsDeleted = preparedStatement.executeUpdate();

            if (rowsDeleted > 0) {
                response.sendRedirect("dashboard.jsp?page=manage&section=roles"); // Redirect to manage page
            } else {
                out.println("An error occurred while deleting the role.");
            }
        } else {
            out.println("You cannot delete your own role.");
        }
    } catch (Exception e) {
        out.println(e);
    } finally {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

</body>
</html>
