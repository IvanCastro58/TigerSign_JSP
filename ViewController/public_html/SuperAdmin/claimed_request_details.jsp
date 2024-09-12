<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimedRequestDetailsService" %>
<%@ page import="com.tigersign.dao.ClaimedRequestDetails" %>
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
        String transactionId = request.getParameter("transactionId");
        ClaimedRequestDetails details = null;

        if (transactionId != null && !transactionId.isEmpty()) {
            ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
            details = service.getClaimedRequestDetails(transactionId);
        }
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <div class="title-section">
                <h1 class="title-page-claimed">CLAIMED REQUEST</h1>
                <i class="fa-solid fa-angle-right title-icon"></i>
                <h1 class="title-page-number">
                    <%= (details != null) ? "#" + details.getTransactionId() : "No Data" %>
                </h1>
                <button class="back-btn" onclick="window.location.href = contextPath + '/SuperAdmin/claimed_request.jsp';">Back</button>
            </div>
            
            <% if (details != null) { %>
                <div class="details">
                    <div class="details-container">
                        <div class="title-number">
                            <span>Transaction ID: <strong>#<%= details.getTransactionId() %></strong></span>
                        </div>
                        <div class="request-information">
                            <div class="title-request"><p>Request Information</p></div>
                                <div class="request-details">
                                    <div class="personal-info">
                                        <div class="info-item" id="requester-name">
                                            Name: <strong><%= details.getRequesterName() %></strong>
                                        </div>
                                        <div class="info-item" id="requester-email">
                                            Email: <strong><%= details.getRequesterEmail() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-date">
                                            Date of Payment: <strong><%= details.getDateProcessed() %></strong>
                                        </div>
                                    </div>
                                    <div class="requested-documents">
                                        <div class="info-item">
                                            Requested Documents
                                        </div>
                                        <ul class="documents-list">
                                            <%
                                                String[] documents = details.getRequestedDocuments().split(",");
                                                for (String doc : documents) {
                                            %>
                                                <li><strong><%= doc.trim() %></strong></li>
                                            <% } %>
                                        </ul>
                                    </div>
                                </div>      
                        </div>
                        <div class="claim-information">
                            <div class="title-claim"><p>Claimer Information</p></div>
                                <div class="claim-details">
                                    <div class="personal-info">
                                        <div class="info-item" id="claimer-name">
                                            Name: <strong><%= details.getClaimerName() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-email">
                                            Email: <strong><%= details.getClaimerEmail() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-date">
                                            Date Claimed: <strong><%= details.getProofDate() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-role">
                                            Role: <strong><%= details.getClaimerRole() %></strong>
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
            <% } else { %>
                <p>No details found for the selected transaction.</p>
            <% } %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
