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
            <img class="logo" src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="Profile Picture">
            <h2>Account Verification</h2>
            <form action="${pageContext.request.contextPath}/adminOauth2callback" method="post">
                <label for="otp">Enter the six-digit TOTP from Google Authenticator.</label>
                <input type="text" id="otp" name="otp" required />
                <button type="submit">Verify</button>
            </form>
            <hr>
            <a href="${pageContext.request.contextPath}/alternative-verification">Can't access your TOTP?</a>
        </div>
    </div>
</body>
</html>
