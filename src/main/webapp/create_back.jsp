<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*,java.security.MessageDigest, org.mindrot.jbcrypt.BCrypt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Creates</title>
</head>
<body>

<!-- it saves the data that's been coming from creation form -->

<%

	String full_name  = request.getParameter("full_name");
	String username = request.getParameter("username");
	String password  = request.getParameter("password");
	String email  = request.getParameter("email");
	String role  = request.getParameter("role");
	
	Connection con = null;
	PreparedStatement ps = null;
	PreparedStatement psRole = null;
	PreparedStatement psUserRole = null;
	PreparedStatement psAddRole = null;
	ResultSet rs = null;

try{
	
	String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
	
	Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/rbac", "root", "");
    String createQuery = "insert into users(full_name, username, password, email) values (?,?,?,?)";
    ps = con.prepareStatement(createQuery, Statement.RETURN_GENERATED_KEYS);
    ps.setString(1,full_name);
    ps.setString(2,username);
    ps.setString(3,hashedPassword);
    ps.setString(4,	email);
    ps.executeUpdate();
    
    ResultSet rsUser = ps.getGeneratedKeys();
    int userId = 0;
    if (rsUser.next()) {
        userId = rsUser.getInt(1);
    }
    rsUser.close();
    
    String roleQuery = "select role_id from roles where role_name = ?";
    psRole = con.prepareStatement(roleQuery);
    psRole.setString(1,role);
    ResultSet rsRole = psRole.executeQuery();
    int roleId = 0;
    if(rsRole.next()){
    	roleId = rsRole.getInt("role_id");
    }
    rsRole.close();
    
    String insertRole = "insert into userroles(user_id, role_id) values (?,?)";
    psUserRole = con.prepareStatement(insertRole);
    psUserRole.setInt(1, userId);
    psUserRole.setInt(2, roleId);
    psUserRole.executeUpdate();
    session.setAttribute("message", "User created successfully!");
    response.sendRedirect("success.jsp");
   
}	
catch(Exception e){
	out.println(e);
}
finally {
    try {
        if (ps != null) ps.close();
        if (psRole != null) psRole.close();
        if (psUserRole != null) psUserRole.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

%>

</body>
</html>