<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- create user -->

<div class="container">       
	
        <form action="create_back.jsp" method="post" class="form">
         <h3>Create</h3>
            <input type="text" placeholder="Full name" name="full_name" class="input"><br>
            <input type="text" placeholder="Username" class="input" name="username"><br>
            <input type="text" placeholder="Password" class="input" name="password"><br>
            <input type="text" placeholder="Email" class="input" name="email"><br>
            <select name="role" class="input" required>
                <option value="" disabled selected>Select Role</option>
                <option value="admin">Admin</option>
                <option value="manager">Manager</option>
                <option value="employee">Employee</option>
            </select><br>
            <input type="submit" value="Create" class="submit">
        </form>
        
        <!-- create new roles -->
       
        <!--  <button onclick="window.location.href=''">click me</button> -->
    </div>
    
</body>
</html>