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
</style>

<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        session.setAttribute("adminEmail", null);
        
        String firstName = (String) session.getAttribute("userFirstName");
        String lastName = (String) session.getAttribute("userLastName");
        String email = (String) session.getAttribute("adminEmail");
        String fullName = firstName + " " + lastName;

        request.setAttribute("activePage", "pending_claim");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">PENDING CLAIMS</h2>
            <div class="top-nav">
                    <div class="nav-item1">
                        <div class="item1-label">Show</div>
                        <select id="rows-per-page" class="number">
                            <option value="10" selected>10</option>
                            <option value="5">5</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                
                    <div class="nav-item2">
                        <input type="text" id="date-range" class="date-input" placeholder="Select Date Range" readonly>
                        <i class="fa-regular fa-calendar" id="calendar-icon"></i>
                    </div>
                    

                    <div class="nav-item3">
                        <div class="search-container">
                            <input type="text" id="search-input" class="search-input" placeholder="Search...">
                        </div>
                    </div>
                </div>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
                    <thead>
                        <tr>
                            <th style="cursor: pointer;">
                                O.R. Number
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
                    <div style="text-align: center; margin-top: 20px; display: none;" id="no-results">
                        <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                        <p style="font-size: 14px; font-weight: 500;">No results match your search.</p>
                    </div>
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
                dropdown.find('option[value="HOLD"]').prop('disabled', false);
            } else if (currentStatus === 'PROCESSING') {
                dropdown.find('option[value="PENDING"]').prop('disabled', true);
                dropdown.find('option[value="HOLD"]').prop('disabled', false);
            } else if (currentStatus === 'HOLD') {
                dropdown.find('option[value="PENDING"]').prop('disabled', true);
                dropdown.find('option[value="PROCESSING"]').prop('disabled', false);
            }
             else if (currentStatus === 'AVAILABLE') {
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

 document.addEventListener('DOMContentLoaded', function () {
    const dataRows = document.querySelectorAll('.actual-data');
    const table = document.getElementById('pending_table');
    const tbody = table.querySelector('tbody');
    const paginationContainer = document.querySelector('.pagination');
    const searchInput = document.getElementById('search-input');
    const rowsPerPageSelect = document.getElementById('rows-per-page');
    const dateRangeInput = document.getElementById('date-range');
    const clearDateRangeButton = document.getElementById('clear-date-range');
    const calendarIcon = document.getElementById('calendar-icon');

    let currentPage = 1;
    let rows = Array.from(dataRows);
    let filteredRows = [...rows];
    let currentSort = { columnIndex: null, isAscending: true };
    let rowsPerPage = parseInt(rowsPerPageSelect.value);
    
    const searchTerm = localStorage.getItem("pendingClaimsSearchTerm");

    if (searchTerm) {
        // Set the search term in the input field and filter the table
        searchInput.value = searchTerm;

        // Trigger input event to filter the table with the programmatically set value
        searchInput.dispatchEvent(new Event('input'));

        // Remove the search term from localStorage to reset on page refresh
        localStorage.removeItem("pendingClaimsSearchTerm");
    }
    
    flatpickr(dateRangeInput, {
        mode: 'range',
        dateFormat: 'Y-m-d',
        onClose: function(selectedDates) {
            if (selectedDates.length === 2) {
                const startDate = selectedDates[0];
                const endDate = selectedDates[1];
                filterByDateRange(startDate, endDate);
            }
        }
    });
    
    calendarIcon.addEventListener('click', function() {
        dateRangeInput._flatpickr.open();
    });

    function filterByDateRange(startDate, endDate) {
    filteredRows = rows.filter(row => {
        const dateText = row.cells[2].textContent.trim(); // Use index 4 for Date Claimed
        const rowDate = new Date(dateText);
        return rowDate >= startDate && rowDate <= endDate;
    });

    // Ensure to show data rows after filtering
    renderTable(1, filteredRows);

    const noResultsDiv = document.getElementById('no-results');
    noResultsDiv.style.display = filteredRows.length === 0 ? 'block' : 'none';
}

    function showDataRows() {
        dataRows.forEach(row => row.style.display = 'none');
        setTimeout(() => {
            dataRows.forEach(row => row.style.display = 'table-row');
            renderTable(currentPage);
        }, 10);
    }

searchInput.addEventListener('input', function () {
    const searchTerm = this.value.toLowerCase();
    filteredRows = rows.filter(row => {
        const orNumberCell = row.cells[0].textContent.toLowerCase(); // Index 0 for O.R. Number
        const nameCell = row.cells[1].textContent.toLowerCase(); // Index 1 for Name
        const collegeCell = row.cells[4].textContent.toLowerCase(); // Index 4 for College

        return orNumberCell.includes(searchTerm) || 
               nameCell.includes(searchTerm) || 
               collegeCell.includes(searchTerm);
    });

    renderTable(1, filteredRows);

    const noResultsDiv = document.getElementById('no-results');
    noResultsDiv.style.display = filteredRows.length === 0 ? 'block' : 'none';
});

    rowsPerPageSelect.addEventListener('change', function () {
        rowsPerPage = parseInt(this.value);
        currentPage = 1;
        renderTable(currentPage);
    });

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

    function renderTable(page, rowsToRender = rows) {
        const startIndex = (page - 1) * rowsPerPage;
        const endIndex = startIndex + rowsPerPage;

        tbody.innerHTML = '';
        const visibleRows = rowsToRender.slice(startIndex, endIndex);
        visibleRows.forEach(row => tbody.appendChild(row));

        renderPagination(rowsToRender);
    }

    function renderPagination(filteredRows) {
        paginationContainer.innerHTML = '';
        const pageCount = Math.ceil(filteredRows.length / rowsPerPage);
        const paginationList = document.createElement('ul');
        paginationList.className = 'pagination-list';

        for (let i = 1; i <= pageCount; i++) {
            const paginationItem = document.createElement('li');
            paginationItem.className = 'pagination-item';

            const paginationLink = document.createElement('a');
            paginationLink.className = 'pagination-link' + (i === currentPage ? ' active' : '');
            paginationLink.href = '#';
            paginationLink.textContent = i;
            paginationLink.addEventListener('click', function (e) {
                e.preventDefault();
                currentPage = i;
                renderTable(currentPage, filteredRows);
            });

            paginationItem.appendChild(paginationLink);
            paginationList.appendChild(paginationItem);
        }

        paginationContainer.appendChild(paginationList);
    }

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

    showDataRows();
});
</script>
</body>
</html>
