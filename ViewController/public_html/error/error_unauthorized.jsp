<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
    <link rel="stylesheet" type="text/css" href="#"> 
</head>
<body>
    <div class="container">
        <h1>Access Denied</h1>
        <p>You do not have permission to access this page.</p>
        <p>Please contact your system administrator if you believe this is an error.</p>
        <a href="${pageContext.request.contextPath}/pages/main_login.jsp">Go to Login Page</a>
    </div>
</body>
</html>
