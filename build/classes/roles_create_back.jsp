<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert Role</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String role = request.getParameter("role_name");
String desc = request.getParameter("desc");
String[] permissions = request.getParameterValues("permissions");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");

    // Insert role
    String createQuery = "INSERT INTO roles(role_name, description) VALUES(?, ?)";
    ps = con.prepareStatement(createQuery, Statement.RETURN_GENERATED_KEYS);
    ps.setString(1, role);
    ps.setString(2, desc);
    ps.executeUpdate();
    
    ResultSet rsRoleInsert = ps.getGeneratedKeys();
    int roleId = 0;
    if (rsRoleInsert.next()) {
        roleId = rsRoleInsert.getInt(1);
    }
    rsRoleInsert.close();
    ps.close();

    // Insert permissions
    if (permissions != null) {
        for (String permission : permissions) {
            int permissionId = Integer.parseInt(permission); // Convert String to int
            String permissionInsert = "INSERT INTO rolePermissions(role_id, permission_id) VALUES (?, ?)";
            ps = con.prepareStatement(permissionInsert);
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.executeUpdate();
            ps.close();
        }
    }
    
    session.setAttribute("message", "Role and permissions have been inserted successfully!");
    response.sendRedirect("success.jsp");

} catch(Exception e) {
    out.println(e);
} finally {
    try {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        out.println(e);
    }
}
%>
</div>

</body>
</html>
