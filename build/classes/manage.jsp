<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Section</title>
    <link rel="stylesheet" type="text/css" href="manage_styles.css">
</head>
<body>
<div class="dashdiv">
     <a href="?page=manage&section=users">Users</a>
     <a href="?page=manage&section=roles">Roles</a>
     <a href="?page=manage&section=permission">Permissions</a>
     
    
</div>

<div class="content">
<%
    String section = request.getParameter("section");
    if (section == null || section.equals("users")) {
        %>
        <jsp:include page="manage_users.jsp"/>
        <% 
    }
    else if(section.equals("roles")){
    	%>
    	<jsp:include page="manage_roles.jsp" />
    	<% 
    }
    else if(section.equals("permission")){
    	%>
    	<jsp:include page="manage_permission.jsp" />
    	<% 
    }
    else {
    
        %>
        <p>Please select a valid section from the navigation above.</p>
        <%
    }
%>
</div>

</body>
</html>
