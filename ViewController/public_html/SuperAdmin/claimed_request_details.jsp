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
        String requestId = request.getParameter("requestId");
        ClaimedRequestDetails details = null;

        if (requestId != null && !requestId.isEmpty()) {
            ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
            details = service.getClaimedRequestDetails(requestId);
        }

        if (details != null) {
            request.setAttribute("details", details);
        }
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <div class="title-section">
                <h2 class="title-page-claimed">CLAIMED REQUEST</h2>
                <i class="fa-solid fa-angle-right title-icon"></i>
                <h2 class="title-page-number">
                    <%= (details != null) ? "#" + details.getOrNumber() : "No Data" %>
                </h2>
                <button class="back-btn" onclick="window.location.href = contextPath + '/SuperAdmin/claimed_request.jsp';">Back</button>
            </div>
            
            <% if (details != null) { %>
                <div class="details">
                    <div class="details-container">
                        <div class="title-number">
                            <span>Service Invoice: <strong>#<%= details.getOrNumber() %></strong></span>
                        </div>
                        <div class="request-information">
                            <div class="title-request"><p>Request Information</p></div>
                                <div class="request-details">
                                    <div class="personal-info">
                                        <div class="info-item" id="requester-name">
                                            Name: <strong><%= details.getRequesterName() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-date">
                                            Date of Payment: <strong><%= details.getDateProcessed() %></strong>
                                        </div>
                                        <div class="info-item" id="claimer-date">
                                            College: <strong><%= details.getCollege() %></strong>
                                        </div>
                                    </div>
                                    <div class="requested-documents">
                                        <div class="info-item">
                                            Requested Documents
                                        </div>
                                        <ul class="documents-list">
                                            <%
                                                // Assuming you have a method to get descriptions for documents
                                                String[] documents = details.getRequestedDocuments().split(",");
                                                String[] descriptions = details.getRequestedDescription().split(","); // Assuming you have this method
                                    
                                                for (int i = 0; i < documents.length; i++) {
                                                    String doc = documents[i].trim();
                                                    String description = descriptions.length > i ? descriptions[i].trim() : "No description available"; // Fallback if no description
                                            %>
                                                <li onclick="toggleDescription(this)">
                                                    <strong class="document-name"><%= doc %></strong>
                                                    <strong class="document-description" style="display:none;"><%= description %></strong>
                                                </li>
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
                                            Released by: <strong><%= (details.getReleasedBy() != null && !details.getReleasedBy().isEmpty()) ? details.getReleasedBy() : "Juan Dela Cruz" %></strong>
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
                                            <button class="proof-btn" 
                                                <% if ("OWNER".equals(details.getClaimerRole())) { %>
                                                    disabled
                                                <% } %> 
                                            >View Authorization Letter & ID Authenticity</button>
                                        </div>
                                    </div>
                                </div>      
                        </div>
                        <div class="bottom-buttons">
                            <button class="proof-btn2" onclick="openPdfInNewTab();">
                                Generate Proof of Claim File
                            </button>
                        </div>
                    </div>
                     <jsp:include page="/WEB-INF/components/view_proof.jsp">
                        <jsp:param name="details" value="<%= details %>" />
                    </jsp:include>
                </div>
            <% } else { %>
                <p>No details found for the selected transaction.</p>
            <% } %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
    <script>
        function toggleDescription(element) {
            const nameElement = element.querySelector('.document-name');
            const descriptionElement = element.querySelector('.document-description');
        
            if (descriptionElement.style.display === 'none') {
                descriptionElement.style.display = 'inline';
                nameElement.style.display = 'none';
            } else {
                descriptionElement.style.display = 'none';
                nameElement.style.display = 'inline';
            }
        }
        
        function openPdfInNewTab() {
            const requestId = '<%= details.getRequestId() %>';
            const pdfUrl = '<%= request.getContextPath() %>/GenerateProofServlet?requestId=' + requestId;
            
            window.open(pdfUrl, '_blank');
                
            logActivity(requestId);
        }

        function logActivity(requestId) {
            const url = '<%= request.getContextPath() %>/GenerateProofServlet';

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'requestId': requestId
                })
            })
            .then(response => {
                if (response.ok) {
                    console.log("Activity logged successfully.");
                } else {
                    console.error("Failed to log activity.");
                }
            })
            .catch(error => {
                console.error("Error logging activity:", error);
            });
        }
    </script>
</body>
</html>

