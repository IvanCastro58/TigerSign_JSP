<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Denied - TigerSign</title>
    <link rel="stylesheet" type="text/css" href="#"> 
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
  <link rel="stylesheet" href="../resources/css/error.css">
</head>
<body>
    <div class="container">
        <div class="image">
          <img src="../resources/images/tigersign.png" alt="Logo" class="logo">
        </div>
        <div>
            <h1>Access Denied</h1>
        </div>
        <div class="message">You do not have permission to access this system.</div>
        <div class="button-div">
            <a href="${pageContext.request.contextPath}/SuperAdmin/main_login.jsp">Go to Login Page</a>
        </div>
    </div>
</body>
</html>
