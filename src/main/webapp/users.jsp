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

<div class="manage_table">
    <%
    String roles = (String)request.getSession().getAttribute("userRoles");
    int user_id = 0;

    try {
        String query = "SELECT u.user_id, u.username, u.full_name, u.email, r.role_name " +
                       "FROM Users u " +
                       "JOIN UserRoles ur ON u.user_id = ur.user_id " +
                       "JOIN Roles r ON ur.role_id = r.role_id";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
    %>
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Role</th>
                <% if (roles.equals("admin")) { %>
                <th>Actions</th>
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
                <% if (roles.equals("admin")) { %>
                <td>
                    <form method="post" action="user_update.jsp" style="display:inline;">
                        <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
                        <input type="submit" value="Update">
                    </form>
                    <form method="post" action="user_delete.jsp" style="display:inline;">
                        <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
                        <input type="submit" value="Delete">
                    </form>
                </td>
                <% } %>
            </tr>
    <%
    user_id=rs.getInt("user_id");
        }
    session.setAttribute("user_id", user_id);
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
