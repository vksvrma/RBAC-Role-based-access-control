<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" type="text/css" href="dashboard_styles.css">
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
    String userPermissions = (String) session.getAttribute("userPermissions");

    if (username == null || fullName == null || email == null || userRoles == null || userPermissions == null) {
        response.sendRedirect("login.jsp?error=invalid");
        return;
    }
%>

<%! 
    // Function to check if user has a specific permission
    public boolean hasPermission(String userPermissions, String permission) {
        return userPermissions != null && userPermissions.contains(permission);
    }
%>
<div class="dashdiv">
    <h2>Welcome, <%= fullName %>!</h2>
    <a href="?page=profile">Profile</a>
    <% if (hasPermission(userPermissions, "manage")) { %>
        <a href="?page=manage">Manage</a>
    <% } %>
    <% if (hasPermission(userPermissions, "new")) { %>
        <a href="?page=newtab">New</a>
    <% } %>
     <% if (hasPermission(userPermissions, "images")) { %>
        <a href="?page=images">Images</a>
    <% } %>
    <a href="?page=logout" class="logout">Logout</a>
</div>

<div class="content">
<%
    String pages = request.getParameter("page");
    if (pages == null || pages.equals("profile")) {
        %>
        <jsp:include page="profile.jsp" />
        <%
    } else if (pages.equals("manage") && hasPermission(userPermissions, "manage")) {
        %>
        <jsp:include page="manage.jsp" />
        <%
    } else if (pages.equals("newtab") && hasPermission(userPermissions, "new")) {
        %>
        <jsp:include page="new_tab_dashboard.jsp" />
        <%
    } else if (pages.equals("images") && hasPermission(userPermissions, "images")) {
        %>
        <jsp:include page="viewDirectory.jsp" />
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

<script>
/* When the user clicks on the button, toggle between hiding and showing the dropdown content */
function myFunction() {
  document.getElementById("myDropdown").classList.toggle("show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown_content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
</script>

</body>
</html>
