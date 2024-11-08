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
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    
    <% 
        String firstName = (String) session.getAttribute("adminFirstName");
        String lastName = (String) session.getAttribute("adminLastName");
        String email = (String) session.getAttribute("adminEmail");
        String fullName = firstName + " " + lastName;

        request.setAttribute("activePage", "pending_claim"); 
    %>
    
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">PENDING CLAIMS</h2>
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
                        <tbody id="pending-table-body">
                            <%
                                PendingClaimsService service = new PendingClaimsService();
                                List<PendingClaim> pendingClaims = null;
                            
                                try {
                                    pendingClaims = service.getActivePendingClaims();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            
                                if (pendingClaims != null && !pendingClaims.isEmpty()) {
                                    for (PendingClaim claim : pendingClaims) {
                            %>
                                        <tr class="actual-data">
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
                                                <select class="status-dropdown" data-request-id="<%= claim.getRequestId() %>">
                                                    <option value="PENDING" <%= claim.getFileStatus().equals("PENDING") ? "selected" : "" %>>PENDING</option>
                                                    <option value="PROCESSING" <%= claim.getFileStatus().equals("PROCESSING") ? "selected" : "" %>>PROCESSING</option>
                                                    <option value="HOLD" <%= claim.getFileStatus().equals("HOLD") ? "selected" : "" %>>ON HOLD</option>
                                                    <option value="AVAILABLE" <%= claim.getFileStatus().equals("AVAILABLE") ? "selected" : "" %>>AVAILABLE</option>
                                                </select>
                                                <% if ("PROCESSING".equalsIgnoreCase(claim.getFileStatus())) { %>
                                                        <div style="margin-top: 5px; color: #6c757d;">
                                                            <% 
                                                            
                                                                int daysSinceProcessing = service.getDaysSinceProcessing(claim.getRequestId());
                                                                out.print("(" + daysSinceProcessing + " days)");
                                                            %>
                                                        </div>
                                                    <% } %>
                                            </td>
                                            <td class="expandable-text"><%= claim.getCollege() %></td>
                                            <td><%= claim.getFeeName() %></td>
                                            <td style="text-align: center;">
                                                <button type="submit" class="action-button" 
                                                    <%= "PROCESSING".equalsIgnoreCase(claim.getFileStatus()) || "PENDING".equalsIgnoreCase(claim.getFileStatus()) || "HOLD".equalsIgnoreCase(claim.getFileStatus()) ? "disabled" : "" %>>
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
                    <div style="text-align: center; margin-top: 20px;" id="no-results">
                        <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                        <p style="font-size: 14px; font-weight: 500;">No matching claims found.</p>
                    </div>
                </div>
            </div>
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
            <div id="confirm-hold-popup" class="popup-overlay">
                <div class="popup">
                    <div class="popup-header">
                        <strong>CONFIRM HOLD STATUS</strong>
                        <span class="popup-close" id="confirm-hold-popup-close">&times;</span>
                    </div>
                    <div class="popup-content">
                        <p class="bigger-text">Please provide a reason for holding this request.</p>
                        <form id="confirm-hold-form" method="post">
                            <textarea id="deactivation-reason" name="deactivation-reason" placeholder="Enter the reason for holding" required></textarea>
                            <input type="hidden" id="request-id-hold" name="request-id" value=""/>
                            <button type="submit" class="submit-btn">Hold</button>
                        </form>
                    </div>
                </div> 
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/components/script.jsp" %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript">
    const adminFullName = "<%= fullName %>";
    const adminEmail = "<%= email %>";
    $(document).ready(function() {
    var contextPath = '<%= request.getContextPath() %>';
        // Function to update the available options based on the current status
        function updateDropdownOptions(dropdown) {
            const currentStatus = dropdown.val();

            // Enable all options initially
            dropdown.find('option').prop('disabled', false);

            // Apply restrictions based on the current status
            if (currentStatus === 'PENDING') {
                dropdown.find('option[value="HOLD"]').prop('disabled', true);
            } else if (currentStatus === 'PROCESSING') {
                dropdown.find('option[value="PENDING"]').prop('disabled', true);
                dropdown.find('option[value="HOLD"]').prop('disabled', false);
            } else if (currentStatus === 'HOLD') {
                dropdown.find('option[value="PENDING"]').prop('disabled', true);
                dropdown.find('option[value="PROCESSING"]').prop('disabled', false);
            } else if (currentStatus === 'AVAILABLE') {
                dropdown.find('option[value="PENDING"]').prop('disabled', true);
                dropdown.find('option[value="PROCESSING"]').prop('disabled', true);
                dropdown.find('option[value="HOLD"]').prop('disabled', true);
            }
        }
    
        // Apply the initial restriction when the page loads
        $('.status-dropdown').each(function() {
            updateDropdownOptions($(this));
        });
    
        // Update options when the dropdown value changes
       $('.status-dropdown').change(function() {
        const newStatus = $(this).val();
        const requestId = $(this).data('request-id');
        const currentDropdown = $(this); // Set the current dropdown for reference
        const previousStatusValue = currentDropdown.val(); // Store previous value
        
        if (newStatus === "HOLD") {
            $('#request-id-hold').val(requestId); // Set request ID in hidden input
            showPopup($('#confirm-hold-popup')[0]); // Display the confirm-hold-popup
        } else {
            // Update the status if it’s not HOLD
            $.ajax({
                url: '<%= request.getContextPath() %>/UpdateStatusServlet',
                type: 'POST',
                data: { requestId: requestId, newStatus: newStatus },
                success: function(response) {
                    // Assuming response indicates success, update the dropdown
                    currentDropdown.val(newStatus); // Update the dropdown to reflect the new status
                    updateStatusStyle(currentDropdown); // Call to update the UI style
                    updateButtonState(currentDropdown.closest('tr').find('.action-button'), newStatus); // Update button state
                    updateDropdownOptions(currentDropdown); // Update available options
                },
                error: function(xhr, status, error) {
                    console.error("Error updating Status:", error);
                }
            });
        }
    });

    function updateStatusStyle(dropdown) {
        const status = dropdown.val();

        // Remove previous status classes
        dropdown.removeClass('status-PENDING status-PROCESSING status-HOLD status-AVAILABLE');

        // Add the appropriate class based on the status
        switch (status) {
            case 'PENDING':
                dropdown.addClass('status-PENDING');
                break;
            case 'PROCESSING':
                dropdown.addClass('status-PROCESSING');
                break;
            case 'HOLD':
                dropdown.addClass('status-HOLD');
                break;
            case 'AVAILABLE':
                dropdown.addClass('status-AVAILABLE');
                break;
        }
    }

    function updateButtonState(button, status) {
        // Enable or disable the button based on the status
        if (["PROCESSING", "PENDING", "HOLD"].includes(status)) {
            button.prop("disabled", true);
        } else if (status === "AVAILABLE") {
            button.prop("disabled", false);
        }
    }

    // Initialize styles and button states for existing dropdowns when the page loads
    $('.status-dropdown').each(function() {
        var dropdown = $(this);
        var button = dropdown.closest('tr').find('.action-button'); // Find the associated button
        updateStatusStyle(dropdown); // Set initial dropdown style
        updateButtonState(button, dropdown.val()); // Set initial button state
    });
});
const searchInput = document.getElementById('search-admin');
        const tableRows = document.querySelectorAll('#pending-table-body tr.actual-data');
        const noResultsDiv = document.getElementById('no-results');

        // Function to check if any rows are visible and update the no-results message accordingly
        function checkNoResults() {
            let hasVisibleRows = Array.from(tableRows).some(row => row.style.display !== 'none');
            noResultsDiv.style.display = hasVisibleRows ? 'none' : 'block'; 
        }

        // Initially check if there are results on page load
        checkNoResults();

        searchInput.addEventListener('input', () => {
            const searchValue = searchInput.value.toLowerCase();
            let hasMatches = false; 

            tableRows.forEach((row) => {
                const nameCell = row.querySelector('td:nth-child(2)').textContent.toLowerCase(); // Name
                const transactionIdCell = row.querySelector('td:nth-child(1)').textContent.toLowerCase(); // Transaction ID

                if (nameCell.includes(searchValue) || transactionIdCell.includes(searchValue)) {
                    row.style.display = 'table-row';
                    hasMatches = true; 
                } else {
                    row.style.display = 'none';
                }
            });

            // Check for results after filtering
            checkNoResults();
        });
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
        padding: 2px 5px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    
    <% 
        String statusUpdateId = request.getParameter("id");
        String statusUpdateValue = request.getParameter("status");
        String firstName = (String) session.getAttribute("adminFirstName");
        String lastName = (String) session.getAttribute("adminLastName");
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
    
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
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
                                <td><%= claim.getTransactionId() %></td>
                                <td class="expandable-text"><%= claim.getName() %></td>
                                <td class="expandable-text"><%= claim.getEmail() %></td>
                                <td>
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
                                <td>
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
