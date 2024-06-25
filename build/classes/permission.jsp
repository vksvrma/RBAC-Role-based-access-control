<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<form action="create_permission.jsp" method = "post" class = "form">
<label><input type ="text" name ="permission_name" placeholder ="Permission Name" class ="input"></label>
<label><input type ="text" name ="description" placeholder ="Description" class ="input"></label>
<label><input type ="submit" value ="Save" class = "submit"></label>

</form>
</body>
</html>