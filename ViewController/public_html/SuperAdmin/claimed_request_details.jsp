<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claimed Request - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/claimed_request_details.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "claimed_request");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
            <div class="main-content">
                <div class="margin-content">
                    <div class="title-section">
                        <h1 class="title-page-claimed">CLAIMED REQUEST</h1>
                        <i class="fa-solid fa-angle-right title-icon"></i>
                        <h1 class="title-page-number">#123456789</h1>
                        <button class="back-btn" onclick="window.location.href = contextPath + '/SuperAdmin/claimed_request.jsp';">Back</button>
                    </div>
                    <div class="details">
                        <div class="details-container">
                            <div class="title-number">
                                <span>Transaction ID: <strong>#123456789</strong></span>
                            </div>
                            <div class="request-information">
                                <div class="title-request"><p>Request Information</p></div>
                                    <div class="request-details">
                                        <div class="personal-info">
                                            <div class="info-item" id="requester-name">
                                                Name: <strong>Dominador Del Rosario</strong>
                                            </div>
                                            <div class="info-item" id="requester-email">
                                                Email: <strong>dominador.delrosario@ust.edu.ph</strong>
                                            </div>
                                            <div class="info-item" id="claimer-date">
                                                Date of Payment: <strong>07 Aug 2024</strong>
                                            </div>
                                        </div>
                                        <div class="requested-documents">
                                            <div class="info-item">
                                                Requested Documents
                                            </div>
                                                <ul class="documents-list">
                                                    <li><strong>Reprinted Diploma</strong></li>
                                                    <li><strong>Certified True Copy of Form 137</strong></li>
                                                    <li><strong>Certificate of Batch Ranking</strong></li>
                                                    <li><strong>Certificate of Good Moral Character</strong></li>
                                                </ul>
                                        </div>
                                    </div>      
                            </div>
                            <div class="claim-information">
                                <div class="title-claim"><p>Claimer Information</p></div>
                                    <div class="claim-details">
                                        <div class="personal-info">
                                            <div class="info-item" id="claimer-name">
                                                Name: <strong>Rogelio Tampipi</strong>
                                            </div>
                                            <div class="info-item" id="claimer-email">
                                                Email: <strong>rogelio.pogi@gmail.com</strong>
                                            </div>
                                            <div class="info-item" id="claimer-date">
                                                Date Claimed: <strong>10 Aug 2024</strong>
                                            </div>
                                            <div class="info-item" id="claimer-role">
                                                Role: <strong>Authorized Representative</strong>
                                            </div>
                                            <div class="info-item" id="claimer-released">
                                                Released by: <strong>Juan Dela Cruz</strong>
                                            </div>
                                        </div>
                                        <div class="claimer-proof">
                                            <div class="claimer-signature">
                                                <button class="proof-btn">View Claimer's Signature</button>
                                            </div>
                                            <div class="claimer-photo">
                                                <button class="proof-btn">View Claimer's Photo</button>
                                            </div>
                                            <div class="claimer-id">
                                                <button class="proof-btn">View Authorization Letter & ID Authenticity</button>
                                            </div>
                                        </div>
                                    </div>      
                            </div>
                            <div class="bottom-buttons">
                                <button class="proof-btn2">Generate Proof of Claim File</button>
                                <button class="proof-btn2">Send Proof of Claim</button>
                            </div>
                        </div>
                        <%@ include file="/WEB-INF/components/view_proof.jsp" %>
                </div>
            </div>
        </div>  
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
