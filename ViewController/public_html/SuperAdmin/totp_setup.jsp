<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticator" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorConfig" %>
<%@ page import="com.warrenstrange.googleauth.GoogleAuthenticatorKey" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Setup Google Authenticator - TigerSign</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/totp.css">
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
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box-totp">
        <div class="highlight-bar"></div>
        <div class="totp-text">
            <img class="logo" src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="Profile Picture">
            <h2>Setup Google Authenticator</h2>
            <div class="qr-box">
                <p class="text1">Scan the QR code below with the Google Authenticator app.</p>
                <img src="<%= request.getAttribute("setupUrl") %>" alt="QR Code"/>
                <p class="text2">Can&rsquo;t scan? Enter this code manually via &ldquo;Enter a setup key&rdquo;</p>
                <p class="text3"><strong><%= request.getAttribute("setupKey") %></strong></p>
            </div>
            <form action="${pageContext.request.contextPath}/oauth2callback" method="post">
                <label for="otp">Enter the six-digit TOTP from Google Authenticator.</label>
                <input type="number" id="otp" name="otp" required />
                <div class="totp-button">
                    <div class="remember">
                        <input type="checkbox" id="rememberMe" name="rememberMe" class="custom-checkbox">
                        <label for="rememberMe" class="custom-label">Remember Me</label>
                    </div> 
                    <div>
                        <button class="submit" type="submit"><i class="bi bi-check-lg"></i>Verify</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
