<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Evaluation - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/send_eval.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "evaluation");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">SEND SURVEY & EVALUATION FORM</h1>
            <div class="box">
                <h2 class="title-email">Enter Email Address<span style="color: #DB3444;">*</span></h2>
                <div class="send-container">
                    <input type="text" class="send-input" placeholder="Ex. juandelacruz@gmail.com">
                    <button class="send-button">Send <i class='bx bxs-send'></i></button>
                </div>
                <div class="results">
                    <div class="heading-results">Survey & Evaluation Form Sent.</div>
                    <div class="check-icon">
                        <i class='bx bx-check-circle' style='color:#ffffff'></i>
                    </div>
                    <div class="heading-results">Success</div>
                </div>
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
