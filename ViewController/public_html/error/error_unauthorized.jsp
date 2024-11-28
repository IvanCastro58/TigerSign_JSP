<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Denied - TigerSign</title>
    <link rel="stylesheet" type="text/css" href="#"> 
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/error.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
    <div class="container">
    <div class="highlight-bar"></div>
        <div class="message-box">
            <div class="image">
                <img class="error" src="${pageContext.request.contextPath}/resources/images/error403.jpg" alt="Check Icon">
            </div>
            <div>
                <h1>Access Denied</h1>
            </div>
            <div class="message">You do not have permission to access this system.</div>
            <div class="message">Please contact <strong><u>registrar.office@ust.edu.ph</u></strong></div>
            <div class="button-div">
                <a href="${pageContext.request.contextPath}/SuperAdmin/main_login.jsp"><i class="bi bi-box-arrow-in-right" style="margin-right: 5px;"></i>Go to Login Page</a>
            </div>
        </div>
    </div>
</body>
</html>



