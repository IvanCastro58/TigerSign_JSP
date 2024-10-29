<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TOTP Reset Already Processed - TigerSign</title>
    <link rel="stylesheet" type="text/css" href="#"> 
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/error.css">
</head>
<body>
    <div class="container">
        <div class="highlight-bar"></div>
        <div class="message-box">
            <div class="image">
                <img class="check" src="${pageContext.request.contextPath}/resources/images/check.jpg" alt="Check Icon">
            </div>
            <div>
                <h1>TOTP Secret Already Reset</h1>
            </div>
            <div class="message">Your TOTP secret has already been reset some time ago. Please log in to your account and set up Google Authenticator to ensure continued access.</div> 
            <div class="button-div">
                <a href="${pageContext.request.contextPath}/SuperAdmin/main_login.jsp"><i class="bi bi-box-arrow-in-right" style="margin-right: 5px;"></i>Go to Login Page</a>
            </div>
        </div>
    </div>
</body>
</html>
