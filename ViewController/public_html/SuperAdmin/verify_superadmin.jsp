<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticator" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorConfig" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorKey" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TOTP - TigerSign</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/totp.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        var images = [];
        
        // Add images from background1.jpg to background15.jpg
        for (var i = 1; i <= 10; i++) {
            images.push("../resources/images/background" + i + ".JPG");
        }
        
        // Select a random image
        var randomImage = images[Math.floor(Math.random() * images.length)];
        
        // Set the selected image as the background
        document.body.style.backgroundImage = "url('" + randomImage + "')";
    });
</script>
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box">
        <div class="highlight-bar"></div>
        <div class="totp-text">
            <img class="logo" src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="Profile Picture">
            <h2>Account Verification</h2>
            <form action="${pageContext.request.contextPath}/oauth2callback" method="post">
                <label for="otp">Enter the six-digit TOTP from Google Authenticator.</label>
                <input type="number" id="otp" name="otp" 
                       class="<%= request.getAttribute("errorMessage") != null ? "is-invalid" : "" %>"
                       required />
                
                <div class="invalid-feedback" style="display: <%= request.getAttribute("errorMessage") != null ? "block" : "none" %>;">
                    <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
                </div>
            
                <div class="totp-button">
                    <div class="remember">
                        <input type="checkbox" id="rememberMe" name="rememberMe" class="custom-checkbox">
                        <label for="rememberMe" class="custom-label">Remember Me</label>
                    </div>   
                    <div>
                        <button class="submit" type="submit"><i class="bi bi-check-lg"></i>Verify</button>
                        <button class="cancel" onclick="window.location.href='<%= request.getContextPath() %>/SuperAdmin/main_login.jsp';"><i class="bi bi-x-lg"></i>Cancel</button>
                    </div>
                </div>
            </form>
            <hr>
            <a class="reset-button" href="reset_totp.jsp">Can't access your TOTP?</a>
        </div>
    </div>
</body>
</html>
