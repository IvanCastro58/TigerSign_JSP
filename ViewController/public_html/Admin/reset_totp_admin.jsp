<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticator" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorConfig" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorKey" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TOTP - TigerSign</title>
    <link rel="stylesheet" href="../resources/css/totp.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
    
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box">
        <div class="highlight-bar"></div>
        <div class="totp-text">
            <img class="logo" src="${pageContext.request.contextPath}/resources/images/reset.jpg" alt="Profile Picture">
            <h2>Reset Google Authenticator TOTP</h2>
            <p class="reset-text">If you can't access your TOTP(Time-Based One-Time Password) Authenticator device, please click the button below. This action will initiate a reset activation process, which will be sent to your email address.</p>
            <div class="reset-btn-div">
                <a class="reset-btn" href="${pageContext.request.contextPath}/reset-admin">Reset TOTP</a>
                <a class="cancel-btn" href="verify_superadmin.jsp">Cancel</a>
            </div>
        </div>
    </div>
</body>
</html>
