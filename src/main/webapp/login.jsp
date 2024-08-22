<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="topnav">
  <a href="home.jsp" style="margin-left:560px">Home</a>
  <a class="active"  href="login.jsp">Login</a>
</div>

<form method = "post" action = "userRoles.jsp" class = "login_form">
<h3>Login</h3>
<input type = "text" placeholder = "Username" name = "username" class="inp" required><br>
<input type = "password" placeholder = "Password" name = "password" class = "inp" required><br>
<input type = "submit" value = "Login" class = "submit">
</form>
</body>
</html>