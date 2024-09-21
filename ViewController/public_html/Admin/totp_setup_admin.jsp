<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Setup Google Authenticator - TigerSign</title>
    <link rel="stylesheet" href="../resources/css/totp.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/totp.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
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
                <img src="${setupUrl}" alt="QR Code"/>
                <p class="text2">Can&rsquo;t scan? Enter this code manually via &ldquo;Enter a setup key&rdquo;</p>
                <p class="text3"><strong>${setupKey}</strong></p>
            </div>
            <form action="${pageContext.request.contextPath}/adminOauth2callback" method="post">
                <label for="otp">Enter the six-digit TOTP from Google Authenticator.</label>
                <input type="text" id="otp" name="otp" required />
                <button type="submit">Verify</button>
            </form>
        </div>
    </div>
</body>
</html>