<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Section</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<div class="nav">
     <a href="?page=newtab&sub_section=create">Create Users</a>
    <a href="?page=newtab&sub_section=roles">Create Roles</a>
    <a href="?page=newtab&sub_section=permission">Create Permission</a>
    
</div>

<div class="content">
<%
    String sub_section = request.getParameter("sub_section");
    if (sub_section == null || sub_section.equals("create")) {
        %>
        <jsp:include page="create.jsp" />
        <%
    } else if (sub_section.equals("roles")) {
        %>
        <jsp:include page="roles.jsp" />
        <%
    } 
    else if(sub_section.equals("permission")){
    	%>
    	<jsp:include page="permission.jsp"/>
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
