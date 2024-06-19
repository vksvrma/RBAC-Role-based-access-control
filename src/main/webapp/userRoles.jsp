<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,org.mindrot.jbcrypt.BCrypt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Check</title>
</head>
<body>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");

        // Validate user credentials
        String validateUserQuery = "SELECT * FROM Users WHERE username = ?";
        ps = con.prepareStatement(validateUserQuery);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            // Get hashed password from the database
            String hashedPasswordFromDB = rs.getString("password");
            
            // Check the password
            boolean passwordMatch = BCrypt.checkpw(password, hashedPasswordFromDB);
            if (passwordMatch) {
                // Store user details in session
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("email", rs.getString("email"));

                // Retrieve user roles
                String getUserRolesQuery = "SELECT r.role_name FROM Roles r " +
                                           "JOIN UserRoles ur ON r.role_id = ur.role_id " +
                                           "WHERE ur.user_id = ?";
                PreparedStatement psRoles = con.prepareStatement(getUserRolesQuery);
                psRoles.setInt(1, rs.getInt("user_id"));
                ResultSet rolesRs = psRoles.executeQuery();

                StringBuilder rolesBuilder = new StringBuilder();
                while (rolesRs.next()) {
                    rolesBuilder.append(rolesRs.getString("role_name")).append(",");
                }
                String userRoles = rolesBuilder.toString().replaceAll(",$", "");

                // Store user roles in session
                session.setAttribute("userRoles", userRoles);

                // Redirect to user info page
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
   }
%>
</body>
</html>
