<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box-success">
        <div class="highlight-bar"></div>
        <div class="totp-text">
            <img class="check" src="${pageContext.request.contextPath}/resources/images/check.jpg" alt="Check Icon">
            <h2>Reset Email Sent</h2>
            <p class="reset-text">An email with the reset link has been sent to your registered email address. Please check your inbox.</p>
        </div>
    </div>
</body>
</html>