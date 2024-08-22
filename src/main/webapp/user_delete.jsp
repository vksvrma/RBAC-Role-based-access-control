<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete User</title>
</head>
<body>

<%
    // Get user ID from request
    int userIdToDelete = Integer.parseInt(request.getParameter("user_id"));
    Integer currentUserId = (Integer) request.getSession().getAttribute("userId");
    String userRole = (String) request.getSession().getAttribute("userRoles");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/rbac";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        if (userRole != null && userRole.contains("admin")) {
            if (userIdToDelete != currentUserId.intValue()) { // Compare int value
                // Delete query
                String deleteQuery = "DELETE FROM Users WHERE user_id = ?";
                preparedStatement = connection.prepareStatement(deleteQuery);
                preparedStatement.setInt(1, userIdToDelete);

                int rowsDeleted = preparedStatement.executeUpdate();

                if (rowsDeleted > 0) {
                    response.sendRedirect("dashboard.jsp?page=manage&section=users"); 
                    // Redirect to manage page
                } else {
                    out.println("An error occurred while deleting the user.");
                }
            } else {
                out.println("You cannot delete your own user account.");
            }
        } else {
            out.println("You are not an admin");
        }
    } catch (Exception e) {
        out.println("An error occurred: " + e.getMessage());
        
    } finally {
        try {
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            out.println(e);
        }
    }
%>

</body>
</html>
