<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.PendingClaimsService" %>
<%@ page import="com.tigersign.dao.PendingClaim" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
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
<style>
    .transaction-table th{
        padding: 15px 5px; 
    } 
    
    .transaction-table td{
        padding: 5px 5px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        String firstName = (String) session.getAttribute("userFirstName");
        String lastName = (String) session.getAttribute("userLastName");
        String fullName = firstName + " " + lastName;

        request.setAttribute("activePage", "pending_claim");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">PENDING CLAIMS</h2>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
                    <thead>
                        <tr>
                            <th>O.R. Number</th>
                            <th>Name</th>
                            <th>Date of Payment</th>
                            <th style="text-align: center;">Status</th>
                            <th>College</th>
                            <th>Request</th>
                            <th style="text-align: center;">Action</th>
                        </tr>
                    </thead>
                        <tbody>
                            <%
                                PendingClaimsService service = new PendingClaimsService();
                                List<PendingClaim> pendingClaims = null;
                            
                                try {
                                    pendingClaims = service.getActivePendingClaims();
                                    service.insertPendingClaims(pendingClaims);
                            
                                    
                                    for (PendingClaim claim : pendingClaims) {
                                        
                                        String fileStatus = service.getFileStatus(claim.getOrNumber(), claim.getFeeName());
                                        claim.setFileStatus(fileStatus); 
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            
                                if (pendingClaims != null && !pendingClaims.isEmpty()) {
                                    for (PendingClaim claim : pendingClaims) {
                            %>
                                        <tr>
                                            <td class="expandable-text"><%= claim.getOrNumber() %></td>
                                            <td class="expandable-text"><%= claim.getCustomerName() %></td>
                                            <td>
                                                <% 
                                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
                                                    String formattedDateProcessed = sdf.format(claim.getDateProcessed());
                                                %>
                                                <%= formattedDateProcessed %>
                                            </td>
                                            <td style="text-align: center;">
                                                <form method="POST" action="${pageContext.request.contextPath}/UpdateStatusServlet">
                                                    <input type="hidden" name="orNumber" value="<%= claim.getOrNumber() %>">
                                                    <input type="hidden" name="feeName" value="<%= claim.getFeeName() %>">
                                                    <input type="hidden" name="userType" value="superadmin">
                                                    <select class="status-dropdown 
                                                        <%= "PENDING".equalsIgnoreCase(claim.getFileStatus()) ? "status-PENDING" : 
                                                            "PROCESSING".equalsIgnoreCase(claim.getFileStatus()) ? "status-PROCESSING" : 
                                                            "AVAILABLE".equalsIgnoreCase(claim.getFileStatus()) ? "status-AVAILABLE" : "" %>"
                                                        name="fileStatus" onchange="this.form.submit()">
                                                        
                                                        <option value="PENDING" <%= "PENDING".equalsIgnoreCase(claim.getFileStatus()) ? "selected" : "" %>>PENDING</option>
                                                        <option value="PROCESSING" <%= "PROCESSING".equalsIgnoreCase(claim.getFileStatus()) ? "selected" : "" %>>PROCESSING</option>
                                                        <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(claim.getFileStatus()) ? "selected" : "" %>>AVAILABLE</option>
                                                    </select>
                                            
                                                    <% if ("PROCESSING".equalsIgnoreCase(claim.getFileStatus())) { %>
                                                        <div style="margin-top: 5px; color: #6c757d;">
                                                            <% 
                                                            
                                                                int daysSinceProcessing = service.getDaysSinceProcessing(claim.getOrNumber(), claim.getFeeName());
                                                                out.print("(" + daysSinceProcessing + " days)");
                                                            %>
                                                        </div>
                                                    <% } %>
                                                </form>
                                            </td>
                                            <td class="expandable-text"><%= claim.getCollege() %></td>
                                            <td><%= claim.getFeeName() %></td>
                                            <td style="text-align: center;">
                                                <button type="submit" class="action-button" 
                                                    <%= "PROCESSING".equalsIgnoreCase(claim.getFileStatus()) || "PENDING".equalsIgnoreCase(claim.getFileStatus()) ? "disabled" : "" %>>
                                                    CLAIM
                                                </button>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr>
                                        <td colspan="7">No pending claims found.</td>
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
                            <p class="smaller-text">Select <strong>Owner</strong> if the original requester is present. If the original requester is not physically present, select <strong>Representative.</strong></p>
                        </div>
                        <div class="claimer-button">
                            <a href="../pages/redirecting.jsp?redirect=../pages/receiving_form_primary.jsp" class="primary" target="_blank">
                                Owner<i class="bi bi-chevron-right"></i>
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
    <script type="text/javascript">
        const adminFullName = "<%= fullName %>";
    </script>
</body>
</html>



<%--<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.PendingClaimsService" %>
<%@ page import="com.tigersign.dao.PendingClaim" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
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
<style>
    .transaction-table th{  
        padding: 15px 5px; 
    } 
    
    .transaction-table td{
        padding: 3px 5px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        String statusUpdateId = request.getParameter("id");
        String statusUpdateValue = request.getParameter("status");
        String firstName = (String) session.getAttribute("userFirstName");
        String lastName = (String) session.getAttribute("userLastName");
        String fullName = firstName + " " + lastName;
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

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">PENDING CLAIMS</h2>
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
                            <th style="text-align: center;">Status</th>
                            <th>College</th> 
                            <th>Date Processed</th>
                            <th>Files</th>
                            <th style="text-align: center;">Action</th>
                        </tr>
                    </thead>
                        <tbody>
                        <%
                            PendingClaimsService service = new PendingClaimsService();
                            List<PendingClaim> claims = service.getPendingClaims();
                            if (claims != null) {
                                for (PendingClaim claim : claims) {
                                    String dateStr = claim.getDateProcessed();
                                    String formattedDate = "";
                                    if (dateStr != null && !dateStr.isEmpty()) {
                                        try {
                                            Date date = inputFormat.parse(dateStr); 
                                            formattedDate = outputFormat.format(date);
                                        } catch (ParseException e) {
                                            e.printStackTrace();
                                        }
                                    }
                        %>
                            <tr>
                                <td><%= claim.getId() %></td>
                                <td class="expandable-text"><%= claim.getTransactionId() %></td>
                                <td class="expandable-text"><%= claim.getName() %></td>
                                <td class="expandable-text"><%= claim.getEmail() %></td>
                                <td style="text-align: center;">
                                    <form action="pending_claim.jsp" method="post">
                                        <input type="hidden" name="id" value="<%= claim.getId() %>">
                                        <select name="status" class="status-dropdown 
                                            <%= "PENDING".equalsIgnoreCase(claim.getStatus()) ? "status-PENDING" : 
                                                "PROCESSING".equalsIgnoreCase(claim.getStatus()) ? "status-PROCESSING" : 
                                                "AVAILABLE".equalsIgnoreCase(claim.getStatus()) ? "status-AVAILABLE" : "" %>" 
                                            onchange="this.form.submit()">
                                            <option value="pending" <%= "PENDING".equals(claim.getStatus()) ? "selected" : "" %>>PENDING</option>
                                            <option value="processing" <%= "PROCESSING".equals(claim.getStatus()) ? "selected" : "" %>>PROCESSING</option>
                                            <option value="available" <%= "AVAILABLE".equals(claim.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
                                        </select>
                                        <div style="margin-top: 3px; color: #6c757d;">
                                            (X days)
                                        </div>
                                    </form>
                                </td>
                                <td class="expandable-text"><%= claim.getCollege() %></td>
                                <td><%= formattedDate %></td>
                                <td class="expandable-text"><%= claim.getFiles() %></td>
                                <td style="text-align: center;">
                                    <button type="submit" class="action-button" 
                                        <%= "PROCESSING".equalsIgnoreCase(claim.getStatus()) || "PENDING".equalsIgnoreCase(claim.getStatus()) ? "disabled" : "" %>>
                                        CLAIM
                                    </button>
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
    <script type="text/javascript">
        const adminFullName = "<%= fullName %>";
    </script>
</body>
</html>--%>

