<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.PendingClaimsService" %>
<%@ page import="com.tigersign.dao.PendingClaim" %>
<%@ page import="java.util.List" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Claims - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="stylesheet" href="../resources/css/pendingclaim.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        String statusUpdateId = request.getParameter("id");
        String statusUpdateValue = request.getParameter("status");
        if (statusUpdateId != null && statusUpdateValue != null) {
            try {
                int id = Integer.parseInt(statusUpdateId);
                PendingClaimsService service = new PendingClaimsService();
                service.updateClaimStatus(id, statusUpdateValue.toUpperCase()); 
                response.sendRedirect("pending_claim.jsp"); 
            } catch (NumberFormatException e) {
                e.printStackTrace(); 
            }
        }

        request.setAttribute("activePage", "pending_claim");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">PENDING CLAIMS</h1>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Transaction ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>College</th>
                            <th>Date Processed</th>
                            <th>Files</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                        <tbody>
                        <%
                            PendingClaimsService service = new PendingClaimsService();
                            List<PendingClaim> claims = service.getPendingClaims();
                            if (claims != null) {
                                for (PendingClaim claim : claims) {
                        %>
                            <tr>
                                <td><%= claim.getId() %></td>
                                <td><%= claim.getTransactionId() %></td>
                                <td class="expandable-text"><%= claim.getName() %></td>
                                <td class="expandable-text"><%= claim.getEmail() %></td>
                                <td>
                                    <form action="pending_claim.jsp" method="post">
                                        <input type="hidden" name="id" value="<%= claim.getId() %>">
                                        <select name="status" class="status-dropdown" onchange="this.form.submit()">
                                            <option value="pending" <%= "PENDING".equals(claim.getStatus()) ? "selected" : "" %>>PENDING</option>
                                            <option value="processing" <%= "PROCESSING".equals(claim.getStatus()) ? "selected" : "" %>>PROCESSING</option>
                                            <option value="available" <%= "AVAILABLE".equals(claim.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="expandable-text"><%= claim.getCollege() %></td>
                                <td><%= claim.getDateProcessed() %></td>
                                <td class="expandable-text"><%= claim.getFiles() %></td>
                                <td>
                                    <button type="submit" class="action-button">CLAIM</button>
                               </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="9">No pending claims found.</td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                    </table>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
            <div id="claimer-type-modal" class="popup-overlay">
                <div class="popup">
                    <div class="popup-header">
                        <strong>CLAIMER TYPE</strong>
                        <span class="popup-close" id="popup-close">&times;</span>
                    </div>
                    <div class="popup-content">
                        <p class="bigger-text">Select the corresponding type of claimer to activate the Document Receiving Form.</p>
                        <div class="info-text">
                            <i class="bi bi-info-circle"></i>
                            <p class="smaller-text">Select <strong>Primary Claimer</strong> if the original requester is present. If the original requester is not physically present, select <strong>Representative.</strong></p>
                        </div>
                        <div class="claimer-button">
                            <a href="../pages/redirecting.jsp?redirect=../pages/receiving_form_primary.jsp" class="primary" target="_blank">
                                Primary Claimer<i class="bi bi-chevron-right"></i>
                            </a>
                            <a href="../pages/redirecting.jsp?redirect=../pages/receiving_form_representative.jsp" class="representative" target="_blank">
                                Representative<i class="bi bi-chevron-right"></i>
                            </a>                              
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
