<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
    // Invalidate the session
    HttpSession sess = request.getSession(false); 
    if (sess != null) {
        sess.invalidate(); 
    }
	
    response.sendRedirect("login.jsp");

%>

     

</body>
</html>