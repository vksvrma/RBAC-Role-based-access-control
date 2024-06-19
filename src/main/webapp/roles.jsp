<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Role</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

    <form method="post" action="roles_create_back.jsp" class = "form">
        <label><input type="text" name="role_name" placeholder = "Role Name" class = "input" required></label><br>
        <label><input type="text" name="desc" placeholder = "Description" class = "input" required></label><br>
        <fieldset>
            <legend>Permissions:</legend>
            <label><input type="checkbox" name="permissions" value="view_dashboard"> View Dashboard</label><br>
            <label><input type="checkbox" name="permissions" value="manage_users"> Manage Users</label><br>
            <label><input type="checkbox" name="permissions" value="view_reports"> View Reports</label><br>
            <label><input type="checkbox" name="permissions" value="edit_content"> Edit Content</label><br>
        </fieldset>
        <input type="submit" value="Submit" class = "submit">
    </form>
    
</body>
</html>