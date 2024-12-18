<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.config.GoogleOAuthConfig"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TigerSign</title>
    <link rel="stylesheet" href="../resources/css/login.css">
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
<%
    GoogleOAuthConfig googleOAuthConfig = new GoogleOAuthConfig();
    String authUrl = googleOAuthConfig.getAuthUrl(); 
%>

<body>
    <div class="container">
        <div class="overlay"></div>
        <div class="registrar-logo">
            <img src="../resources/images/logo.png" alt="Google Icon">
            <br>
            <span>Super Admin Account Sign In</span>
        </div>
        <div class="login-box">
            <div class="highlight-bar"></div>
            <div class="login-text">
                <div class="registrar-logo1">
                    <img src="../resources/images/logo1.png" alt="Google Icon">
                    <span>Super Admin Account Sign In</span>
                </div>
                <div class="sign-in-text">Sign In</div>
                <div class="requirements-text">
                    To access TigerSign, please make sure you meet the following requirements:
                </div>
                <div class="google-text">
                    1. UST Google Workspace Personal Account
                </div>
                <div class="google-text">
                    2. Google Authenticator Application
                </div> 
                <div>
                    <a href="<%= authUrl %>" class="google-button">
                        <div class="google-icon">
                            <img src="../resources/images/google.png" alt="Google Icon">
                        </div>
                        <div class="sign-in-google">Sign in with Google</div>
                    </a>
                </div>
                <div class="warning-text">
                    <div class="warning-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    Keep Google Authenticator accessible for logging into TigerSign.
                </div>
                <div class="horizontal-line"></div>
            </div>
        </div>
    </div>
</body>
</html>