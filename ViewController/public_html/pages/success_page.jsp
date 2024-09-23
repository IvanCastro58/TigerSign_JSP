<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Receiving Form - TigerSign</title>
    <link rel="stylesheet" href="../resources/css/totp.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box-success">
        <div class="highlight-bar"></div>
        <div class="form-details">
            <h1 class="title-sucess">DOCUMENT RECEIVING FORM SUBMITTED</h1>
            <div class="success-icon">
                <img src="../resources/images/success.png"  alt="Success Icon">
            </div>
            <div class="success-text">
                <i class="bi bi-info-circle"></i>
                <p>A <strong>Survey Evaluation Form</strong> will be sent to the Email Address you provided in the Document Receiving Form. 
                Your response will be highly appreciated for the improvement of our service. Thank you!</p>
            </div>
        </div>
    </div>
</body>
</html>