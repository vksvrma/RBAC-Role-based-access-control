<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create User</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<!-- create user -->

<div class="container">       
    <form action="create_back.jsp" method="post" class="form">
        <h3>Create</h3>
        <input type="text" placeholder="Full name" name="full_name" class="input" required><br>
        <input type="text" placeholder="Username" class="input" name="username" required><br>
        <input type="password" placeholder="Password" class="input" name="password" required><br>
        <input type="email" placeholder="Email" class="input" name="email" required><br>
        <select name="role" class="input" required>
            <option value="" disabled selected>Select Role</option>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
                    String query = "SELECT role_name FROM roles";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();
                    
                    while (rs.next()) {
                        String roleName = rs.getString("role_name");
            %>
                        <option value="<%= roleName %>"><%= roleName %></option>
            <%
                    }
                } catch (Exception e) {
                    out.println(e);
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                    if (con != null) try { con.close(); } catch (SQLException ignore) {}
                }
            %>
        </select><br>
        <input type="submit" value="Create" class="submit">
    </form>
</div>

</body>
</html>
