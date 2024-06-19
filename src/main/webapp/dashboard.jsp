<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String username = (String) session.getAttribute("username");
    String fullName = (String) session.getAttribute("fullName");
    String email = (String) session.getAttribute("email");
    String userRoles = (String) session.getAttribute("userRoles");

    if (username == null || fullName == null || email == null || userRoles == null) {
        response.sendRedirect("login.jsp?error=invalid");
        return;
    }
%>

<h1>Welcome to the Dashboard, <%= fullName %>!</h1>

<div class="nav">
    <a href="?page=home">Home</a>
    <a href="?page=profile">Profile</a>
    <% if (userRoles.contains("admin") || userRoles.contains("manager")) { %>
        <a href="?page=manage">Manage</a>
    <% } %>
    <% if (userRoles.contains("admin")) { %>
        <a href="?page=newtab">New</a>
    <% } %>
    <a href="?page=logout" class="logout">Logout</a>
</div>

<div class="content">
<%
    String pages = request.getParameter("page");
    if (pages == null || pages.equals("home")) {
        %>
        <jsp:include page="home.jsp" />
        <%
    } else if (pages.equals("profile")) {
        %>
        <jsp:include page="profile.jsp" />
        <%
    } else if (pages.equals("manage") && (userRoles.contains("admin") || userRoles.contains("manager"))) {
        %>
        <jsp:include page="manage.jsp" />
        <%
    } else if (pages.equals("newtab") && userRoles.contains("admin")) {
        %>
        <jsp:include page="new_tab_dashboard.jsp" />
        <%
    } else if (pages.equals("logout")) {
        response.sendRedirect("logout.jsp");
        return;
    } else {
        %>
        <jsp:include page="home.jsp" />
        <%
    }
%>
</div>

</body>
</html>
	