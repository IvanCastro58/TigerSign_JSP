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
    <title>Paid Applications - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="stylesheet" href="../resources/css/pendingclaim.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/confetti.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</head>
<style>
    .transaction-table th{
        padding: 15px 5px; 
    } 
    
    .transaction-table td{
        padding: 5px 5px;
    }
    
    .transaction-table th, .transaction-table td {
        white-space: nowrap;
        text-align: left;
    }

    .transaction-table th:nth-child(1), .transaction-table td:nth-child(1) {
        width: 15%;
    }

    .transaction-table th:nth-child(2), .transaction-table td:nth-child(2) {
        width: 30%;
    }

    .transaction-table th:nth-child(3), .transaction-table td:nth-child(3) {
        width: 10%;
    }

    .transaction-table th:nth-child(4), .transaction-table td:nth-child(4) {
        width: 15%;
    }
    .transaction-table th:nth-child(5), .transaction-table td:nth-child(5) {
        width: 10%;
    }
    .transaction-table th:nth-child(6), .transaction-table td:nth-child(6) {
        width: 30%;
    }
    .transaction-table th:nth-child(7), .transaction-table td:nth-child(7) {
        width: 10%;
    }
    
    .sort-icons {
        font-size: 12px;
        display: inline-block;
        transform: scale(0.8);
        transition: opacity 0.3s ease, transform 0.3s ease;
    }
    
    .sort-icons.visible {
        opacity: 1;
        transform: scale(1);
    }
    
    .spin-up {
        animation: spin-up 0.3s linear forwards;
    }
    
    @keyframes spin-up {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(180deg); 
        }
    }
    
    .spin-down {
        animation: spin-down 0.3s linear forwards;
    }
    
    @keyframes spin-down {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(-180deg);
        }
    }
    
    .parent {
        position: relative;
        height: 90vh;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        font-size: 16px;
        font-weight: 560;
        gap: 20px;
    }
    
    .loader {
        position: relative;
        width: 120px;
        height: 150px;
        background: #F4BB00;
        border-radius: 4px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5), 0 1px 3px rgba(0, 0, 0, 0.4);
    }
    
    .loader:before {
      content: '';
      position: absolute;
      width: 54px;
      height: 25px;
      left: 50%;
      top: 0;
      background-image: radial-gradient(ellipse at center, #0000 24%, #101010 25%, #101010 64%, #0000 65%), linear-gradient(to bottom, #0000 34%, #a1a1a1 35%);
      background-size: 12px 12px, 100% auto;
      background-repeat: no-repeat;
      background-position: center top;
      transform: translate(-50%, -65%);
      box-shadow: 0 -3px rgba(0, 0, 0, 0.25) inset;
    }
    
    .loader:after {
      content: '';
      position: absolute;
      left: 50%;
      top: 20%;
      transform: translateX(-50%);
      width: 66%;
      height: 60%;
      background: linear-gradient(to bottom, #101010 30%, #0000 31%);
      background-size: 100% 16px;
      animation: writeDown 2s ease-out infinite;
    }
    
    @keyframes writeDown {
      0% {
        height: 0%;
        opacity: 0;
      }
      20% {
        height: 0%;
        opacity: 1;
      }
      80% {
        height: 65%;
        opacity: 1;
      }
      100% {
        height: 65%;
        opacity: 0;
      }
    }
</style>

<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <%  
        String firstName = (String) session.getAttribute("userFirstName");
        String lastName = (String) session.getAttribute("userLastName");
        String fullName = firstName + " " + lastName;
        String userRole = "superadmin";
        String user = (String) session.getAttribute("userEmail");

        request.setAttribute("activePage", "pending_claim");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    <div class="main-content">
        <div class="parent">
            <div class="loader"></div>
            Retrieving Data...
        </div>
        <div id="margin-content" class="margin-content" style="display: none;">
            <h2 class="title-page">PAID APPLICATIONS</h2>
            <div class="top-nav">
                    <div class="row1">
                        <div class="nav-item1">
                            <div class="item1-label">Show</div>
                            <select id="rows-per-page" class="number">
                                <option value="10" selected>10</option>
                                <option value="5">5</option>
                                <option value="2">2</option>
                            </select>
                        </div>
                    
                        <div class="nav-item2">
                            <i class="fa-regular fa-calendar" id="calendar-icon"></i>
                            <div class="input-container">
                                <input type="text" id="date-range" class="date-input" placeholder="Select Date Range" readonly>
                                <i class="bi bi-x-circle-fill" id="clear-date" style="display:none;"></i>
                            </div>
                        </div>
                    </div>
                    <div class="row2">
                        <div class="nav-item4">
                            <select class="status">
                                <option value="" selected>Select Status</option> 
                                <option value="pending">PAID</option>
                                <option value="processing">PROCESSING</option>
                                <option value="hold">ON HOLD</option>
                                <option value="available">AVAILABLE</option>
                            </select>
                        </div>
    
                        <div class="nav-item3">
                            <div class="search-container">
                                <input type="text" id="search-input" class="search-input" placeholder="Search...">
                            </div>
                        </div>
                    </div>
                </div>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
                    <thead>
                        <tr>
                            <th style="cursor: pointer;">
                                Service Invoice
                                <span class="sort-icons">
                                    <i class="fa fa-sort"></i>
                                    <i class="fa fa-caret-up" style="display:none;"></i>
                                    <i class="fa fa-caret-down" style="display:none;"></i>
                                </span>
                            </th>
                            <th style="cursor: pointer;">
                                Name
                                <span class="sort-icons">
                                    <i class="fa fa-sort"></i>
                                    <i class="fa fa-caret-up" style="display:none;"></i>
                                    <i class="fa fa-caret-down" style="display:none;"></i>
                                </span>
                            </th>
                            <th style="cursor: pointer;">
                                Date of Payment
                                <span class="sort-icons">
                                    <i class="fa fa-sort"></i>
                                    <i class="fa fa-caret-up" style="display:none;"></i>
                                    <i class="fa fa-caret-down" style="display:none;"></i>
                                </span>
                            </th>
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
                                if (pendingClaims != null) {
                                    pendingClaims.sort((c1, c2) -> {
                                        try {
                                            int days1 = "PROCESSING".equalsIgnoreCase(c1.getFileStatus()) ? service.getDaysSinceProcessing(c1.getRequestId()) : -1;
                                            int days2 = "PROCESSING".equalsIgnoreCase(c2.getFileStatus()) ? service.getDaysSinceProcessing(c2.getRequestId()) : -1;
                    
                                            if (days1 >= 7 && days2 >= 7) {
                                                return Integer.compare(days2, days1);
                                            } else if (days1 >= 7) {
                                                return -1;
                                            } else if (days2 >= 7) {
                                                return 1;
                                            } else {
                                                return 0;
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                            return 0;
                                        }
                                    });
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                    
                            if (pendingClaims != null && !pendingClaims.isEmpty()) {
                                for (PendingClaim claim : pendingClaims) {
                        %>
                                <tr class="actual-data" 
                                    <% 
                                        if ("PROCESSING".equalsIgnoreCase(claim.getFileStatus()) && service.getDaysSinceProcessing(claim.getRequestId()) >= 7) { 
                                    %>
                                        style="background-color: rgba(255, 56, 56, 0.07);"
                                    <% 
                                        } 
                                    %>
                                >
                                    <td class="expandable-text">
                                        <% 
                                            if ("PROCESSING".equalsIgnoreCase(claim.getFileStatus())) {
                                                int daysSinceProcessing = service.getDaysSinceProcessing(claim.getRequestId());
                                                if (daysSinceProcessing >= 7) {
                                        %>
                                            <i class="bi bi-exclamation-triangle-fill" style="color: red; margin-right: 5px; font-size: 12px;" id="warning-icon-<%= claim.getRequestId() %>"></i>
                                        <% 
                                                }
                                            }
                                        %>
                                        <%= claim.getOrNumber() %>
                                    </td>
                                    <td class="expandable-text">
                                        <%= claim.getCustomerName() %>
                                    </td>
                                    <td>
                                        <% 
                                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
                                            String formattedDateProcessed = sdf.format(claim.getDateProcessed());
                                        %>
                                        <%= formattedDateProcessed %>
                                    </td>
                                    <td style="text-align: center;">
                                        <select class="status-dropdown" data-request-id="<%= claim.getRequestId() %>">
                                            <option value="PENDING" <%= claim.getFileStatus().equals("PENDING") ? "selected" : "" %>>PAID</option>
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
                                    <td class="expandable-text">
                                        <%= claim.getCollege() %>
                                    </td>
                                    <td>
                                        <%= claim.getFeeName() %>
                                    </td>
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
                    <% 
                            if (pendingClaims == null || pendingClaims.isEmpty()) { 
                        %>
                            <div style="text-align: center; margin-top: 20px;">
                                <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                                <p style="font-size: 14px; font-weight: 500;">No pending claims available at the moment.</p>
                            </div>
                        <% 
                            } 
                        %>
                    <div style="text-align: center; margin-top: 20px; display: none;" id="no-results">
                        <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                        <p style="font-size: 14px; font-weight: 500;">No results match your search.</p>
                    </div>
                </div>
            </div>
                <div class="pagination">
                    <ul class="pagination-list">
                        <!-- Pagination links will be generated by JavaScript -->
                    </ul>
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
    <script>
        document.querySelectorAll('.status-dropdown').forEach(function(selectElement) {
            selectElement.addEventListener('change', function() {
                const requestId = this.getAttribute('data-request-id');
                const row = this.closest('tr');
                const icon = document.getElementById('warning-icon-' + requestId);
    
                if (icon) {
                    icon.remove();
                }
    
                if (this.value !== 'PROCESSING') {
                    row.style.backgroundColor = ''; 
                } else {
                    const daysSinceProcessing = parseInt(this.getAttribute('data-days-since-processing'), 10);
                    if (daysSinceProcessing >= 7) {
                        row.style.backgroundColor = '#f8d7da'; 
                    }
                }
            });
        });
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const parent = document.querySelector(".parent");
            const marginContent = document.getElementById("margin-content");
    
            parent.style.display = "none";
            marginContent.style.display = "block";
        });
    </script>
    <script type="text/javascript">
    const adminFullName = "<%= fullName %>";
    const adminEmail = "";
    const userEmail = "<%= user %>";
    const BASE_URL = "<%= request.getContextPath() %>";
    const userRole = "<%= userRole %>";
$(document).ready(function() {
    // Function to update the available options based on the current status
    function updateDropdownOptions(dropdown) {
        const currentStatus = dropdown.val();

        // Enable all options initially
        dropdown.find('option').prop('disabled', false);

        // Apply restrictions based on the current status
        if (currentStatus === 'PENDING') {
            dropdown.find('option[value="HOLD"]').prop('disabled', false);
            dropdown.find('option[value="AVAILABLE"]').prop('disabled', true);
        } else if (currentStatus === 'PROCESSING') {
            dropdown.find('option[value="PENDING"]').prop('disabled', false);
            dropdown.find('option[value="HOLD"]').prop('disabled', false);
        } else if (currentStatus === 'HOLD') {
            dropdown.find('option[value="PENDING"]').prop('disabled', false);
            dropdown.find('option[value="PROCESSING"]').prop('disabled', false);
        } else if (currentStatus === 'AVAILABLE') {
            dropdown.find('option[value="PENDING"]').prop('disabled', false);
            dropdown.find('option[value="PROCESSING"]').prop('disabled', false);
            dropdown.find('option[value="HOLD"]').prop('disabled', false);
        }
    }

    window.updateDropdownOptions = updateDropdownOptions;

    // Apply the initial restriction when the page loads
    $('.status-dropdown').each(function() {
        updateDropdownOptions($(this));
    });

    // Update options when the dropdown value changes
    $(document).on('change', '.status-dropdown', function () {
    const newStatus = $(this).val();
    const requestId = $(this).data('request-id');
    const dropdown = $(this);

    if (newStatus === "HOLD") {
        // Store the original status before opening the modal
        const originalStatus = dropdown.data('original-status') || dropdown.val(); // Ensure the original value is stored only once
        dropdown.data('original-status', originalStatus); // Save original status

        // Temporarily store the intended status (HOLD), but don't change the dropdown value yet
        dropdown.data('temp-status', 'HOLD'); 

        // Revert the dropdown value to the original status
        dropdown.val(originalStatus);

        $('#request-id-hold').val(requestId);
        showPopup($('#confirm-hold-popup')[0]); // Display the confirm-hold-popup
    } else {
        // Update status immediately if it's not HOLD
        updateStatus(requestId, newStatus, dropdown);
    }
});

    // Update status function
    function updateStatus(requestId, newStatus, dropdown) {
    $.ajax({
        url: '<%= request.getContextPath() %>/UpdateStatusServlet',
        type: 'POST',
        data: { requestId: requestId, newStatus: newStatus },
        success: function() {
            dropdown.val(newStatus); // Apply new status
            updateStatusStyle(dropdown); // Update style
            updateDropdownOptions(dropdown); // Reset options
            updateButtonState(dropdown.closest('tr').find('.action-button'), newStatus);
        },
        error: function(xhr, status, error) {
            console.error("Error updating Status:", error);
            alert("Failed to update the status. Please try again."); // Provide user feedback
        }
    });
}

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

    window.updateStatusStyle = updateStatusStyle;

    function updateButtonState(button, status) {
        // Enable or disable the button based on the status
        if (["PROCESSING", "PENDING", "HOLD"].includes(status)) {
            button.prop("disabled", true);
        } else if (status === "AVAILABLE") {
            button.prop("disabled", false);
        }
    }

    // Handle modal close behavior
    $('#confirm-hold-popup-close').on('click', function () {
    const requestId = $('#request-id-hold').val();
    const dropdown = $('.status-dropdown[data-request-id="' + requestId + '"]');

    // Retrieve the original status stored earlier
    const originalStatus = dropdown.data('original-status');

    if (originalStatus) {
        dropdown.val(originalStatus); // Revert to the original status
        updateStatusStyle(dropdown); // Update UI style
        updateDropdownOptions(dropdown); // Reset available options
    }

    $('#deactivation-reason').val(''); // Clear the input field
    $('#confirm-hold-popup').hide(); // Close the modal
});

    // Handle the form submission for holding
    $('#confirm-hold-form').on('submit', function (event) {
    event.preventDefault();

    const requestId = $('#request-id-hold').val();
    const reason = $('#deactivation-reason').val();
    const dropdown = $('.status-dropdown[data-request-id="' + requestId + '"]');
    const intendedStatus = dropdown.data('temp-status'); // Retrieve temporary status

    if (intendedStatus === "HOLD" && reason.trim() !== "") {
        updateStatus(requestId, 'HOLD', dropdown); // Update the status to 'HOLD'
        $('#confirm-hold-popup').hide(); // Close the modal
        $('#deactivation-reason').val(''); // Clear the input field
    } else {
        alert('Please provide a reason for placing the request on hold.');
    }
});

    // Initialize styles and button states for existing dropdowns when the page loads
    $('.status-dropdown').each(function() {
        var dropdown = $(this);
        var button = dropdown.closest('tr').find('.action-button'); // Find the associated button
        updateStatusStyle(dropdown); // Set initial dropdown style
        updateButtonState(button, dropdown.val()); // Set initial button state
    });
});



  document.addEventListener('DOMContentLoaded', function () {
    const dataRows = document.querySelectorAll('.actual-data');
    const table = document.getElementById('pending_table');
    const tbody = table.querySelector('tbody');
    const paginationContainer = document.querySelector('.pagination');
    const searchInput = document.getElementById('search-input');
    const rowsPerPageSelect = document.getElementById('rows-per-page');
    const dateRangeInput = document.getElementById('date-range');
    const clearDateRangeButton = document.getElementById('clear-date');
    const calendarIcon = document.getElementById('calendar-icon');
    const statusSelect = document.querySelector('.nav-item4 .status');

    let currentPage = 1;
    let rows = Array.from(dataRows);
    let filteredRows = [...rows];
    let currentSort = { columnIndex: null, isAscending: true };
    let rowsPerPage = parseInt(rowsPerPageSelect.value);
    
    const searchTerm = localStorage.getItem("pendingClaimsSearchTerm");

    if (searchTerm) {
        searchInput.value = searchTerm;
        localStorage.removeItem("pendingClaimsSearchTerm"); 
    } 
    
    flatpickr(dateRangeInput, {
        mode: 'range',
        dateFormat: 'Y-m-d',
        onClose: function(selectedDates) {
            if (selectedDates.length === 2) {
                const startDate = selectedDates[0];
                const endDate = selectedDates[1];
                filterData(startDate, endDate, statusSelect.value, searchInput.value);
                clearDateRangeButton.style.display = 'block';
            } else {
                clearDateRangeButton.style.display = 'none';
            }
        }
    });
    
    calendarIcon.addEventListener('click', function() {
        dateRangeInput._flatpickr.open();
    });

 
    clearDateRangeButton.addEventListener('click', function() {
        dateRangeInput._flatpickr.clear();
        clearDateRangeButton.style.display = 'none';
        filterData(null, null, statusSelect.value, searchInput.value);
    });
    
    function showDataRows() {
        dataRows.forEach(row => row.style.display = 'none');
        setTimeout(() => {
            dataRows.forEach(row => row.style.display = 'table-row');
            renderTable(currentPage);
        }, 1);
    }

    function filterData(startDate, endDate, status, searchTerm) {
        filteredRows = rows;
    
        // Filter by date range
        if (startDate && endDate) {
            endDate.setHours(23, 59, 59, 999); // Adjust end date to include the whole day
            filteredRows = filteredRows.filter(row => {
                const dateText = row.cells[2].textContent.trim();
                const rowDate = new Date(dateText);
                return rowDate >= startDate && rowDate <= endDate;
            });
        }
    
        // Filter by status
        if (status && status !== 'ALL') {
            filteredRows = filteredRows.filter(row => {
                const rowStatus = row.querySelector('.status-dropdown').value.toUpperCase();
                return rowStatus === status.toUpperCase();
            });
        }
    
        // Filter by search term
        if (searchTerm && searchTerm.trim() !== '') {
            searchTerm = searchTerm.toLowerCase().trim();
            filteredRows = filteredRows.filter(row => {
                const orNumberCell = row.cells[0].textContent.toLowerCase();
                const nameCell = row.cells[1].textContent.toLowerCase();
                const collegeCell = row.cells[4].textContent.toLowerCase();
                return orNumberCell.includes(searchTerm) || nameCell.includes(searchTerm) || collegeCell.includes(searchTerm);
            });
        }
    
        renderTable(1, filteredRows);
    
        // Show or hide the 'No results' div
        const noResultsDiv = document.getElementById('no-results');
        noResultsDiv.style.display = filteredRows.length === 0 ? 'block' : 'none';
    }

    // Status filter
     statusSelect.addEventListener('change', function() {
        const selectedStatus = this.value.toUpperCase();
        const selectedDates = dateRangeInput._flatpickr.selectedDates;  // Get selected dates from flatpickr
        const startDate = selectedDates.length === 2 ? selectedDates[0] : null;
        const endDate = selectedDates.length === 2 ? selectedDates[1] : null;
    
        filterData(startDate, endDate, selectedStatus, searchInput.value);
    });

        // Search input filter
        searchInput.addEventListener('input', function () {
            const searchTerm = this.value;
            filterData(null, null, statusSelect.value, searchTerm);
        
            // Reapply the status styles after the search filter
            $('.status-dropdown').each(function () {
                updateStatusStyle($(this)); // Apply status-specific styling
            });
        });

    rowsPerPageSelect.addEventListener('change', function () {
        rowsPerPage = parseInt(this.value);
        currentPage = 1;
        renderTable(currentPage, filteredRows);
    });

    function renderTable(page, rowsToRender = filteredRows) {
    const startIndex = (page - 1) * rowsPerPage;
    const endIndex = startIndex + rowsPerPage;

    tbody.innerHTML = ''; // Clear the table body before re-rendering
    const visibleRows = rowsToRender.slice(startIndex, endIndex);
    visibleRows.forEach(row => tbody.appendChild(row)); // Add rows to the table body

    // Reapply styles to status dropdowns
    $('.status-dropdown').each(function () {
        updateStatusStyle($(this)); // Apply status-specific styling
    });

    renderPagination(rowsToRender); // Update pagination
}


    function renderPagination(rowsToRender) {
        const pageCount = Math.ceil(rowsToRender.length / rowsPerPage);
        paginationContainer.innerHTML = '';  // Clear pagination container
        const paginationList = document.createElement('ul');
        paginationList.className = 'pagination-list';

        const addPaginationLink = (page, text = page, isActive = false) => {
            const paginationItem = document.createElement('li');
            paginationItem.className = 'pagination-item';

            const paginationLink = document.createElement('a');
            paginationLink.className = 'pagination-link';
            paginationLink.href = '#';
            paginationLink.textContent = text;
            
            if (page !== null) {
                paginationLink.dataset.page = page;
                paginationLink.addEventListener('click', function (e) {
                    e.preventDefault();
                    currentPage = page;
                    renderTable(currentPage, rowsToRender);
                    updateActiveLink();
                });
            } else {
                paginationLink.classList.add('disabled');
            }

            if (isActive) {
                paginationLink.classList.add('active');
            }

            paginationItem.appendChild(paginationLink);
            paginationList.appendChild(paginationItem);
        };

        // Add 'Prev' button
        if (currentPage > 1) {
            addPaginationLink(currentPage - 1, 'Prev');
        }

        // Start of pagination
        if (currentPage > 3) {
            addPaginationLink(1);
            addPaginationLink(null, '...');
        }

        // Main pages around the current page
        for (let i = Math.max(1, currentPage - 1); i <= Math.min(pageCount, currentPage + 1); i++) {
            addPaginationLink(i, i, i === currentPage);
        }

        // End of pagination
        if (currentPage < pageCount - 2) {
            addPaginationLink(null, '...');
            addPaginationLink(pageCount);
        }

        // Add 'Next' button
        if (currentPage < pageCount) {
            addPaginationLink(currentPage + 1, 'Next');
        }

        paginationContainer.appendChild(paginationList);
        updateActiveLink();
    }

    // Active page highlighting
    function updateActiveLink() {
        document.querySelectorAll('.pagination-link').forEach(link => {
            link.classList.toggle('active', parseInt(link.dataset.page) === currentPage);
        });
    }
    
     if (searchTerm) {
        searchInput.dispatchEvent(new Event('input'));
    }

    const headers = table.querySelectorAll('th');
    headers.forEach((header, index) => {
        const sortIcons = header.querySelector('.sort-icons');
        if (sortIcons) {
            sortIcons.addEventListener('click', () => {
                const isAscending = currentSort.columnIndex !== index ? true : !currentSort.isAscending;
                currentSort = { columnIndex: index, isAscending };
                sortTableByColumn(index, isAscending, filteredRows);
                toggleSortIcons(sortIcons, isAscending);
                renderTable(1, filteredRows);
            });
        }
    });

    function sortTableByColumn(columnIndex, isAscending, rowsToSort = rows) {
        rowsToSort.sort((a, b) => {
            const aText = a.cells[columnIndex].textContent.trim();
            const bText = b.cells[columnIndex].textContent.trim();

            if (columnIndex === 4) { // Assuming Date Claimed is in column index 4
                const aDate = new Date(aText);
                const bDate = new Date(bText);
                return isAscending ? aDate - bDate : bDate - aDate;
            }

            if (!isNaN(aText) && !isNaN(bText)) {
                return isAscending ? aText - bText : bText - aText;
            }

            return isAscending ? aText.localeCompare(bText) : bText.localeCompare(aText);
        });
    }

    function resetSortIcons() {
    headers.forEach(header => {
        const sortIcons = header.querySelector('.sort-icons');
        console.log('sortIcons:', sortIcons); // Log the sortIcons element

        if (sortIcons) {
            const defaultIcon = sortIcons.querySelector('.fa-sort');
            const upIcon = sortIcons.querySelector('.fa-caret-up');
            const downIcon = sortIcons.querySelector('.fa-caret-down');

            if (defaultIcon) defaultIcon.style.display = 'inline';
            if (upIcon) upIcon.style.display = 'none';
            if (downIcon) downIcon.style.display = 'none';

            sortIcons.classList.remove('spin-up', 'spin-down');
        } else {
            console.warn('No sort icons found for header:', header); // Warn if no sortIcons found
        }
    });
}

    function toggleSortIcons(sortIcons, isAscending) {
        resetSortIcons();

        const defaultIcon = sortIcons.querySelector('.fa-sort');
        const upIcon = sortIcons.querySelector('.fa-caret-up');
        const downIcon = sortIcons.querySelector('.fa-caret-down');

        if (isAscending) {
            defaultIcon.style.display = 'none';
            upIcon.style.display = 'none';
            downIcon.style.display = 'inline';
            sortIcons.classList.remove('spin-up');
            sortIcons.classList.add('spin-down');
        } else {
            defaultIcon.style.display = 'none';
            upIcon.style.display = 'inline';
            downIcon.style.display = 'none';
            sortIcons.classList.remove('spin-down');
            sortIcons.classList.add('spin-up');
        }
    }
 // Initial rendering of the table with no filters applied
    showDataRows();
});
</script>
</body>
</html>
