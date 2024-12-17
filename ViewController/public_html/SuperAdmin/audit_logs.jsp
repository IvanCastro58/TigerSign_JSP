    <!DOCTYPE html>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*, java.util.List" %>
    <%@ page import="com.tigersign.dao.AuditLog" %>
    <%@ page import="com.tigersign.dao.AuditDetail" %>
    <%@ page import="com.tigersign.dao.AuditLogDAO" %>
    <%@ page import="java.text.SimpleDateFormat" %>
    <%
        List<AuditLog> auditList = null;
    
        try {
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditList = auditDAO.getAllAudits();
        } catch (Exception e) {
            e.printStackTrace(); 
        }
    %>
    <%
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    %>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Audit Logs - TigerSign</title>
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
            padding: 7px 15px;
        }
        
        .transaction-table th, .transaction-table td {
            white-space: nowrap;
            text-align: left;
            cursor: text;
        }
    
        .transaction-table th:nth-child(1), .transaction-table td:nth-child(1) {
            width: 20%;
        }
    
        .transaction-table th:nth-child(2), .transaction-table td:nth-child(2) {
            width: 15%;
        }
    
        .transaction-table th:nth-child(3), .transaction-table td:nth-child(3) {
            width: 55%;
        }
        
        .transaction-table th:nth-child(4), .transaction-table td:nth-child(4) {
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
            request.setAttribute("activePage", "audit_logs");  
        %>
        
        <%@ include file="/WEB-INF/components/header.jsp" %>
        <%@ include file="/WEB-INF/components/sidebar.jsp" %>
        
        <div class="main-content">
            <div class="margin-content">
                <div class="audit-header">
                    <div class="audit-title">
                        <h2 class="title-page">AUDIT LOGS</h2>
                    </div>
                    <div class="generate-buttons">
                        <button class="<%= (auditList == null || auditList.isEmpty()) ? "disabled-button" : "gen-btn" %>"
                            <%= (auditList == null || auditList.isEmpty()) ? "disabled" : "" %>>
                            Export Logs <i class="fa-solid fa-file-export"></i>
                        </button>
                    </div>
                </div>
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
                                <option value="update">UPDATE</option>
                                <option value="generate">GENERATE</option>
                                <option value="release">RELEASE</option>
                                <option value="send survey">SEND SURVEY</option>
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
                        <table class="transaction-table" id="audit_logs">
                            <thead>
                                <tr>
                                    <th style="cursor: pointer;">
                                        Performed by
                                        <span class="sort-icons">
                                            <i class="fa-solid fa-sort sort-icon"></i>
                                            <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                            <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                        </span>
                                    </th>
                                    <th>Activity Type</th>
                                    <th>Activity Details</th>
                                    <th style="cursor: pointer;">
                                        Timestamp
                                        <span class="sort-icons">
                                            <i class="fa-solid fa-sort sort-icon"></i>
                                            <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                            <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                        </span>
                                    </th>   
                                </tr>
                            </thead>
                            <tbody id="audit-log-body">
                                
                                <%
                                    boolean noAuditLogs = (auditList == null || auditList.isEmpty());
                                    
                                    if (!noAuditLogs) {
                                        for (int i = 0; i < 10; i++) {
                                    %>
                                        <tr class="skeleton-row">
                                            <td>
                                                <div style="display: flex; align-items: center;">
                                                    <div class="skeleton-picture"></div>
                                                    <div style="margin-left: 10px; display: flex; flex-direction: column;">
                                                        <div class="skeleton" style="width: 200px; height: 0.8em;"></div>
                                                        <div class="skeleton" style="width: 200px; height: 0.8em; margin-top: 5px;"></div>
                                                    </div>
        
                                                </div>
                                            </td>
                                            <td><div class="skeleton" style="width: 100%; height: 1em;"></div></td>
                                            <td>
                                                <div style="display: flex; flex-direction: column;">
                                                    <div class="skeleton" style="width: 100%; height: 0.8em;"></div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; flex-direction: column;">
                                                    <div class="skeleton" style="width: 100px; height: 0.8em;"></div>
                                                    <div class="skeleton" style="width: 100px; height: 0.8em; margin-top: 5px;"></div>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    }
                                %>
                                <!-- Real data rows -->
                                <%
                                    for (AuditLog audit : auditList) {
                                        String firstName = audit.getFirstName() != null ? audit.getFirstName() : "Unknown";
                                        String lastName = audit.getLastName() != null ? audit.getLastName() : "User";
                                        String position = audit.getPosition() != null ? audit.getPosition() : "Super Admin";
                                        String status = audit.getStatus() != null ? audit.getStatus() : "ACTIVE";
                                        String defaultPicture = request.getContextPath() + "/resources/images/default-profile.jpg";
                                        String picture = audit.getPicture() != null ? audit.getPicture() : defaultPicture;
                                %>
                                <tr class="data-row" style="display: none;">
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <img src="<%= picture != null ? picture : defaultPicture %>" alt="Admin Picture" style="border-radius: 50%; margin-right: 10px;" width="30" height="30"/>
                                            <div>
                                                <div style="font-size: 12px; font-weight: 600;"><%= firstName + " " + lastName %></div>
                                                <div style="font-size: 10px; color: #a1a1a1; font-weight: 500;">
                                                    <%= position %>
                                                    <% if ("DEACTIVATED".equalsIgnoreCase(status)) { %>
                                                        <span style="color: red;">(Deactivated)</span>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="expandable-text">
                                        <span style="<%= audit.getActivityClass() %> font-size: 10px; font-weight: 700;">
                                            <i class="<%= audit.getActivityIcon() %>" style="margin-right: 3px;"></i>
                                            <%= audit.getActivity() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% 
                                            StringBuilder details = new StringBuilder();
                                            for (AuditDetail detail : audit.getDetails()) {
                                                details.append("<strong>").append(detail.getKey()).append(":</strong> ").append(detail.getValue()).append(" | ");
                                            }
                                            // Remove the last " | " separator
                                            if (details.length() > 0) {
                                                details.setLength(details.length() - 2);
                                            }
                                        %>
                                        <%= details.toString() %>
                                    </td>
                                    <td>
                                        <%
                                            if (audit.getActivityDateTime() != null) {
                                                java.util.Date activityDate = audit.getActivityDateTime();
                                                String formattedDate = dateFormat.format(activityDate);
                                                String formattedTime = timeFormat.format(activityDate);
                                        %>
                                            <div style="font-size: 12px; font-weight: 600;"><%= formattedDate %></div>
                                            <div style="font-size: 10px; color: #a1a1a1; font-weight: 500;"><%= formattedTime %></div>
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        
                        <div style="text-align: center; margin-top: 20px; display: none;" id="no-results">
                            <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                            <p style="font-size: 14px; font-weight: 500;">No results match.</p>
                        </div>
                        
                        <%
                            if (auditList == null || auditList.isEmpty()) {
                        %>
                            <div style="text-align: center; margin-top: 20px;">
                                <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                                <p style="font-size: 14px; font-weight: 500;">No active accounts available at the moment.</p>
                            </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div class="pagination"></div>
            </div>
        </div>
         <div id="audit-popup" class="popup-overlay">
            <div class="popup">
                <div class="popup-header">
                    <strong>EXPORT LOGS FILE TYPE</strong>
                    <span class="popup-close" id="popup-close">&times;</span>
                </div>
                <div class="popup-content">
                    <div style="text-align: center; margin: 10px 0;">
                        <p class="big-text">Choose your preferred file type</p>
                    </div>
                    <div class="button-container" style="margin-top: 20px;">
                        <form class="audit-container" id="auditForm" method="GET" action="<%= request.getContextPath() %>/LogsGeneratorServlet" target="_blank">                           
                            <button type="submit" name="format" value="pdf" class="pdf-btn">
                                <img src="${pageContext.request.contextPath}/resources/images/pdf.png" alt="PDF Icon">
                            </button>
                                
                            <button type="submit" name="format" value="csv" class="csv-btn">
                                <img src="${pageContext.request.contextPath}/resources/images/excel.png" alt="CSV Icon">
                            </button>
                        </form>
                    </div>
                </div>
            </div> 
        </div>
        <div class="overlay"></div>
        <script>
            const auditButton = document.querySelector('.gen-btn');
            const auditPopup = document.getElementById('audit-popup');
            const auditPopupElement = auditPopup.querySelector('.popup');
            const auditCloseButton = auditPopup.querySelector('.popup-close');
            
            auditButton.addEventListener('click', () => {
                auditPopup.style.display = 'flex';
                setTimeout(() => {
                    auditPopupElement.classList.add('show');
                }, 10);
            });
            
            auditCloseButton.addEventListener('click', () => {
                auditPopupElement.classList.remove('show');
                setTimeout(() => {
                    auditPopup.style.display = 'none';
                }, 600);
            });
            
            window.addEventListener('click', (event) => {
                if (event.target === auditPopup) {
                    auditPopupElement.classList.remove('show');
                    setTimeout(() => {
                        auditPopup.style.display = 'none';
                    }, 600);
                }
            });
        </script>
       <script>
    document.addEventListener('DOMContentLoaded', function () {
        const dataRows = document.querySelectorAll('.data-row');
        const table = document.getElementById('audit_logs');
        const tbody = table.querySelector('tbody');
        const paginationContainer = document.querySelector('.pagination');
        const searchInput = document.getElementById('search-input');
        const rowsPerPageSelect = document.getElementById('rows-per-page');
        const dateRangeInput = document.getElementById('date-range');
        const calendarIcon = document.getElementById('calendar-icon');
        const clearDateIcon = document.getElementById('clear-date');
        const statusSelect = document.querySelector('.nav-item4 .status');

        let currentPage = 1;
        let rows = Array.from(dataRows);
        let currentSort = { columnIndex: 3, isAscending: false };
        let rowsPerPage = parseInt(rowsPerPageSelect.value);
        let filteredByDate = rows;
        let filteredRows = rows;

        flatpickr(dateRangeInput, {
            mode: 'range',
            dateFormat: 'Y-m-d',
            onClose: function (selectedDates) {
                if (selectedDates.length === 2) {
                    const startDate = selectedDates[0];
                    const endDate = selectedDates[1];
                    filterByDateRange(startDate, endDate);
                    clearDateIcon.style.display = 'block';
                } else {
                    clearDateIcon.style.display = 'none';
                }
            },
        });

        calendarIcon.addEventListener('click', function () {
            dateRangeInput._flatpickr.open();
        });

        clearDateIcon.addEventListener('click', function () {
            dateRangeInput._flatpickr.clear();
            filterByDateRange(null, null);
            clearDateIcon.style.display = 'none';
        });

        function filterByDateRange(startDate, endDate) {
            if (startDate && endDate) {
                filteredByDate = rows.filter(row => {
                    const dateText = row.cells[3].querySelector("div").textContent.trim();
                    const rowDate = new Date(dateText);
                    return rowDate >= startDate && rowDate <= endDate;
                });
            } else {
                filteredByDate = rows;
            }

            applyAllFilters();

            clearDateIcon.style.display = startDate && endDate ? 'block' : 'none';
        }

        function applyAllFilters() {
            let filtered = filteredByDate;

            // Apply status filter
            const selectedStatus = statusSelect.value.toLowerCase();
            if (selectedStatus) {
                filtered = filtered.filter(row =>
                    row.cells[1].textContent.trim().toLowerCase().includes(selectedStatus)
                );
            }

            // Apply search filter
            const searchTerm = searchInput.value.toLowerCase();
            if (searchTerm) {
                filtered = filtered.filter(row =>
                    row.cells[0].textContent.toLowerCase().includes(searchTerm)
                );
            }

            filteredRows = filtered;
            renderTable(1);

            const noResultsDiv = document.getElementById('no-results');
            noResultsDiv.style.display = filteredRows.length === 0 ? 'block' : 'none';
        }

        searchInput.addEventListener('input', function () {
            applyAllFilters();
        });

        statusSelect.addEventListener('change', function () {
            applyAllFilters();
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
                    sortTableByColumn(index, isAscending);
                    toggleSortIcons(sortIcons, isAscending);
                    currentPage = 1;
                    renderTable(currentPage);
                });
            }
        });

        function renderTable(page) {
            const startIndex = (page - 1) * rowsPerPage;
            const endIndex = startIndex + rowsPerPage;

            tbody.innerHTML = '';
            const visibleRows = filteredRows.slice(startIndex, endIndex);
            visibleRows.forEach(row => tbody.appendChild(row));

            renderPagination(filteredRows);
        }

        function renderPagination(filteredRows) {
            paginationContainer.innerHTML = '';
            const pageCount = Math.ceil(filteredRows.length / rowsPerPage);

            const paginationList = document.createElement('ul');
            paginationList.className = 'pagination-list';

            function createPaginationItem(content, isDisabled = false, isActive = false, page = null) {
                const paginationItem = document.createElement('li');
                paginationItem.className = 'pagination-item';

                const paginationLink = document.createElement('a');
                paginationLink.className = 'pagination-link';
                if (isActive) paginationLink.classList.add('active');
                if (isDisabled) paginationLink.classList.add('disabled');
                paginationLink.href = '#';
                paginationLink.textContent = content;

                if (!isDisabled && page !== null) {
                    paginationLink.addEventListener('click', function (e) {
                        e.preventDefault();
                        currentPage = page;
                        renderTable(currentPage);
                        renderPagination(filteredRows);
                    });
                } else {
                    paginationLink.style.pointerEvents = 'none';
                }

                paginationItem.appendChild(paginationLink);
                return paginationItem;
            }

            if (currentPage > 1) {
                paginationList.appendChild(createPaginationItem('Prev', false, false, currentPage - 1));
            }

            paginationList.appendChild(createPaginationItem('1', false, currentPage === 1, 1));

            if (currentPage > 3) {
                paginationList.appendChild(createPaginationItem('...', true));
            }

            for (let i = Math.max(2, currentPage - 1); i <= Math.min(pageCount - 1, currentPage + 1); i++) {
                paginationList.appendChild(createPaginationItem(i, false, currentPage === i, i));
            }

            if (currentPage < pageCount - 2) {
                paginationList.appendChild(createPaginationItem('...', true));
            }

            if (pageCount > 1) {
                paginationList.appendChild(createPaginationItem(pageCount, false, currentPage === pageCount, pageCount));
            }

            if (currentPage < pageCount) {
                paginationList.appendChild(createPaginationItem('Next', false, false, currentPage + 1));
            }

            paginationContainer.appendChild(paginationList);
        }

        function sortTableByColumn(columnIndex, isAscending) {
            filteredRows.sort((a, b) => {
                const aText = a.cells[columnIndex].textContent.trim();
                const bText = b.cells[columnIndex].textContent.trim();

                if (columnIndex === 2) {
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
                if (sortIcons) {
                    const defaultIcon = sortIcons.querySelector('.fa-sort');
                    const upIcon = sortIcons.querySelector('.fa-caret-up');
                    const downIcon = sortIcons.querySelector('.fa-caret-down');

                    defaultIcon.style.display = 'inline';
                    upIcon.style.display = 'none';
                    downIcon.style.display = 'none';

                    sortIcons.classList.remove('spin-up', 'spin-down');
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

        function showDataRows() {
            dataRows.forEach(row => row.style.display = 'none');

            setTimeout(() => {
                dataRows.forEach(row => row.style.display = 'table-row');
                renderTable(currentPage);
            }, 500);
        }

        showDataRows();
    });
</script>

        <%@ include file="/WEB-INF/components/script.jsp" %>
    </body>
    </html>
