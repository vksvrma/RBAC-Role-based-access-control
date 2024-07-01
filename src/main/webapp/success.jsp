<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Success</title>
<script type="text/javascript">
    function redirectAfterDelay() {
        setTimeout(function() {
            window.location.href = 'login.jsp'; 
        }, 2500);
    }
</script>
</head>
<body onload="redirectAfterDelay()">
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
        out.println("<h2 class ='success'>" + message + "</h2>");
        session.removeAttribute("message"); 
    }
%>
</body>
</html>
