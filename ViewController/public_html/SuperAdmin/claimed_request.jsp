<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimedRequest" %>
<%@ page import="com.tigersign.dao.ClaimedRequestsService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claimed Request - TigerSign</title>
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
        padding: 15px; 
    } 
    
    .transaction-table td{
        padding: 15px;
    }
    
    .transaction-table th, .transaction-table td {
        white-space: nowrap;
        text-align: left;
    }

    .transaction-table th:nth-child(1), .transaction-table td:nth-child(1) {
        width: 10%;
    }

    .transaction-table th:nth-child(2), .transaction-table td:nth-child(2) {
        width: 15%;
    }

    .transaction-table th:nth-child(3), .transaction-table td:nth-child(3) {
        width: 30%;
    }

    .transaction-table th:nth-child(4), .transaction-table td:nth-child(4) {
        width: 10%;
    }
     .transaction-table th:nth-child(5), .transaction-table td:nth-child(5) {
        width: 10%;
    }
     .transaction-table th:nth-child(6), .transaction-table td:nth-child(6) {
        width: 30%;
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
    
    .skeleton {
        background: linear-gradient(
            90deg, 
            #e0e0e0 25%, 
            #f0f0f0 50%, 
            #e0e0e0 75%
        );
        background-size: 200% 100%;
        border-radius: 4px;
        display: inline-block;
        animation: shimmer 1.5s infinite linear;
    }
    
    .skeleton-picture {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: inline-block;
        background: linear-gradient(
            90deg, 
            #e0e0e0 25%, 
            #f0f0f0 50%, 
            #e0e0e0 75%
        );
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite linear;
    }
    
    @keyframes shimmer {
        0% {
            background-position: -200% 0;
        }
        100% {
            background-position: 200% 0;
        }
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "claimed_request");  
        ClaimedRequestsService service = new ClaimedRequestsService();
        List<ClaimedRequest> requests = service.getClaimedRequests();

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy");
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">CLAIMED REQUEST</h2>
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
                            <th>
                                Request ID
                            </th>
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
                            <th>
                                College
                            </th>
                            <th style="cursor: pointer;">
                                Date Claimed
                                <span class="sort-icons">
                                    <i class="fa fa-sort"></i>
                                    <i class="fa fa-caret-up" style="display:none;"></i>
                                    <i class="fa fa-caret-down" style="display:none;"></i>
                                </span>
                            </th>
                            <th>
                                Documents Requested
                            </th>
                            <th style="display: none;">
                                Documents Description
                            </th>
                        </tr>
                    </thead>
                        <tbody id="claimed-table-body">
                            <!-- Skeleton rows to display while loading data -->
                            <%
                                for (int i = 0; i < 10; i++) {
                            %>
                                <tr class="skeleton-row">
                                    <td><div class="skeleton" style="width: 80%; height: 1em;"></div></td>
                                    <td><div class="skeleton" style="width: 100%; height: 1em;"></div></td>
                                    <td><div class="skeleton" style="width: 100%; height: 1em;"></div></td>
                                    <td><div class="skeleton" style="width: 80%; height: 1em;"></div></td>
                                    <td><div class="skeleton" style="width: 80%; height: 1em;"></div></td>
                                    <td><div class="skeleton" style="width: 100%; height: 1em;"></div></td>
                                </tr>
                            <%
                                }
                            %>
                        
                            <!-- Real data rows -->
                            <% 
                                if (requests != null && !requests.isEmpty()) {
                                    for (ClaimedRequest claimedRequest : requests) {
                                        String proofDateStr = claimedRequest.getProofDate();
                                        String formattedDate = "";
                                        if (proofDateStr != null && !proofDateStr.isEmpty()) {
                                            try {
                                                Date date = inputFormat.parse(proofDateStr); 
                                                formattedDate = outputFormat.format(date); 
                                            } catch (ParseException e) {
                                                e.printStackTrace();
                                            }
                                        }
                            %>
                                <tr class="clickable-row actual-data" style="display: none;">
                                    <td><%= claimedRequest.getRequestId() %></td>
                                    <td><%= claimedRequest.getOrNumber() %></td>
                                    <td><%= claimedRequest.getName() %></td>
                                    <td><%= claimedRequest.getCollege() %></td>
                                    <td><%= formattedDate %></td>
                                    <td><%= claimedRequest.getDocumentsRequested() %></td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6">No claimed requests found.</td> 
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
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
    const dataRows = document.querySelectorAll('.clickable-row.actual-data');
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
        const dateText = row.cells[4].textContent.trim(); // Use index 4 for Date Claimed
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
        }, 500);
    }

   searchInput.addEventListener('input', function () {
        const searchTerm = this.value.toLowerCase();
        filteredRows = rows.filter(row => {
            const orNumberCell = row.cells[1].textContent.toLowerCase();
            const nameCell = row.cells[2].textContent.toLowerCase();
            return orNumberCell.includes(searchTerm) || nameCell.includes(searchTerm);
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

