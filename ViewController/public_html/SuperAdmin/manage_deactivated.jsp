<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.UserDAO, com.tigersign.dao.User, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Account - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
   <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/table.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/manage_account.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<style>
    .transaction-table th{
        padding: 15px;
    }
    
    .transaction-table td{
        padding: 10px;
    }
    
    .transaction-table th, .transaction-table td {
        white-space: nowrap;
        text-align: left;
    }

    .transaction-table th:nth-child(1), .transaction-table td:nth-child(1) {
        width: 5%;
    }

    .transaction-table th:nth-child(2), .transaction-table td:nth-child(2) {
        width: 10%;
    }

    .transaction-table th:nth-child(3), .transaction-table td:nth-child(3) {
        width: 30%;
    }

    .transaction-table th:nth-child(4), .transaction-table td:nth-child(4) {
        width: 30%;
    }
    
    .transaction-table th:nth-child(5), .transaction-table td:nth-child(5) {
        width: 25%;
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
        request.setAttribute("activePage", "manage_account");  
        request.setAttribute("activeNav", "manage_deactivated");  
        
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">MANAGE ACCOUNT</h2>
            
            <%@ include file="/WEB-INF/components/account_navbar.jsp" %>
            
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="account_table">
                        <thead>
                            <tr>
                                <th style="cursor: pointer;">
                                    ID
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-sort sort-icon"></i>
                                        <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                        <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                    </span>
                                </th>
                                <th>
                                    Picture
                                </th>
                                <th style="cursor: pointer;">
                                    Name
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-sort sort-icon"></i>
                                        <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                        <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                    </span>
                                </th>
                                <th style="cursor: pointer;">
                                    Email
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-sort sort-icon"></i>
                                        <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                        <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                    </span>
                                </th>
                                <th>
                                    Status
                                </th>
                            </tr>
                        </thead>
                            <tbody id="account-table-body">
                                <% 
                                    List<User> userList = (List<User>) request.getAttribute("users");
                                    int skeletonRowCount = 5;
                            
                                    for (int i = 0; i < skeletonRowCount; i++) {
                                %>
                                    <tr class="skeleton-row">
                                        <td><span class="skeleton"></span></td>
                                        <td class="profile-column"><span class="skeleton-picture"></span></td>
                                        <td class="expandable-text"><span class="skeleton"></span></td>
                                        <td class="expandable-text"><span class="skeleton"></span></td>
                                        <td><span class="skeleton"></span></td>
                                    </tr>
                                <% 
                                    }
                            
                                    if (userList != null && !userList.isEmpty()) {
                                        for (User user : userList) {
                                            if ("DEACTIVATED".equals(user.getStatus())) {
                                %>
                                                <tr class="actual-data account-row" data-user-id="<%= user.getId() %>">
                                                    <td><%= user.getId() %></td>
                                                    <td class="profile-column">
                                                        <%
                                                            String picture = user.getPicture();
                                                            String defaultPicture = request.getContextPath() + "/resources/images/default-profile.jpg";
                                                        %>
                                                        <img src="<%= picture != null ? picture : defaultPicture %>" alt="Profile Picture" />
                                                    </td>
                                                    <td class="expandable-text"><%= user.getFirstname() + " " + user.getLastname() %></td>
                                                    <td class="expandable-text"><%= user.getEmail() %></td>
                                                    <td class="status-deactivate"><span><%= user.getStatus() %></span></td>
                                                </tr>
                                <% 
                                            }
                                        }
                                    }
                                %>
                            </tbody>
                            </table>
                            <div style="text-align: center; margin-top: 20px; display: none;" id="no-results">
                                <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                                <p style="font-size: 14px; font-weight: 500;">No matching accounts found.</p>
                            </div>

                            
                            <% 
                                if (userList == null || userList.isEmpty() || !userList.stream().anyMatch(user -> "DEACTIVATED".equals(user.getStatus()))) {
                            %> 
                                <div style="text-align: center;  margin-top: 20px;">
                                    <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                                    <p style="font-size: 14px; font-weight: 500;">No deactivated accounts available at the moment.</p>
                                </div>
                            <% 
                                } 
                            %>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/add_account.jsp" %>
        </div>
    </div>
    <div class="overlay"></div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const searchInput = document.getElementById('search-input');
            const tableRows = Array.from(document.querySelectorAll('#account_table tbody tr.actual-data'));
            const noResultsDiv = document.getElementById('no-results');
            const rowsPerPage = 5;
            let currentPage = 1;
            let filteredRows = [...tableRows];
    
            function updateTableRows() {
                const start = (currentPage - 1) * rowsPerPage;
                const end = start + rowsPerPage;
    
                filteredRows.forEach((row, index) => {
                    row.style.display = (index >= start && index < end) ? "table-row" : "none";
                });
            }
    
            function updateActiveLink() {
                document.querySelectorAll(".pagination-link").forEach(link => {
                    link.classList.toggle("active", parseInt(link.dataset.page) === currentPage);
                });
            }
    
            function initializePagination() {
                const paginationContainer = document.querySelector('.pagination');
                if (paginationContainer) paginationContainer.remove();
    
                const pageCount = Math.ceil(filteredRows.length / rowsPerPage);
                const paginationContainerNew = document.createElement("div");
                paginationContainerNew.className = "pagination";
                const paginationList = document.createElement("ul");
                paginationList.className = "pagination-list";
    
                for (let i = 1; i <= pageCount; i++) {
                    const pageItem = document.createElement("li");
                    pageItem.className = "pagination-item";
                    const pageLink = document.createElement("a");
                    pageLink.className = "pagination-link";
                    pageLink.href = "#";
                    pageLink.textContent = i;
                    pageLink.dataset.page = i;
    
                    pageLink.addEventListener("click", function (e) {
                        e.preventDefault();
                        currentPage = parseInt(e.target.dataset.page);
                        updateTableRows();
                        updateActiveLink();
                    });
    
                    pageItem.appendChild(pageLink);
                    paginationList.appendChild(pageItem);
                }
    
                paginationContainerNew.appendChild(paginationList);
                document.querySelector(".table-container").parentElement.appendChild(paginationContainerNew);
    
                updateTableRows();
                updateActiveLink();
            }
    
            searchInput.addEventListener('input', () => {
                const searchValue = searchInput.value.toLowerCase();
                let hasMatches = false;
    
                filteredRows = tableRows.filter(row => {
                    const rowData = row.textContent.toLowerCase();
                    const isMatch = rowData.includes(searchValue);
                    row.style.display = isMatch ? 'table-row' : 'none';
                    return isMatch;
                });
    
                hasMatches = filteredRows.length > 0;
    
                if (!hasMatches && searchValue) {
                    noResultsDiv.style.display = 'block';
                } else {
                    noResultsDiv.style.display = 'none';
                }
    
                currentPage = 1;
                initializePagination();
            });
    
            function fetchData() {
                return new Promise((resolve) => {
                    setTimeout(() => {
                        resolve("Data loaded");
                    }, 500);
                });
            }
    
            document.querySelectorAll(".skeleton-row").forEach(function (el) {
                el.style.display = 'table-row';
            });
    
            fetchData().then(function () {
                document.querySelectorAll(".skeleton-row").forEach(function (el) {
                    el.style.display = 'none';
                });
    
                tableRows.forEach(function (el) {
                    el.style.display = 'table-row';
                });
    
                filteredRows = [...tableRows];
                initializePagination();
                addSortingFunctionality();
            }).catch(function (error) {
                console.error("Error loading data:", error);
            });
    
            function addSortingFunctionality() {
                const tableHeaders = document.querySelectorAll(".transaction-table th");
    
                tableHeaders.forEach((header, index) => {
                    header.addEventListener("click", function () {
                        const isAscending = header.classList.toggle("ascending");
    
                        resetSortIcons();
    
                        const sortIcons = header.querySelector(".sort-icons");
                        sortIcons.classList.remove("spin-up", "spin-down");
    
                        if (isAscending) {
                            sortIcons.classList.add("spin-up");
                        } else {
                            sortIcons.classList.add("spin-down");
                        }
    
                        const icons = sortIcons.querySelectorAll("i");
                        icons[0].style.display = isAscending ? "none" : "none";
                        icons[1].style.display = isAscending ? "inline" : "none";
                        icons[2].style.display = isAscending ? "none" : "inline";
    
                        filteredRows.sort((a, b) => {
                            const aText = a.cells[index].innerText.trim();
                            const bText = b.cells[index].innerText.trim();
    
                            return isAscending
                                ? aText.localeCompare(bText, undefined, { numeric: true })
                                : bText.localeCompare(aText, undefined, { numeric: true });
                        });
    
                        const tbody = document.getElementById("account-table-body");
                        filteredRows.forEach(row => tbody.appendChild(row));
                        updateTableRows();
                    });
                });
            }
    
            function resetSortIcons() {
                const allSortIcons = document.querySelectorAll(".sort-icons i");
                allSortIcons.forEach(icon => {
                    icon.style.display = "none";
                });
    
                document.querySelectorAll(".transaction-table th .sort-icons i:nth-child(1)").forEach(icon => {
                    icon.style.display = "inline";
                });
            }
        });
    </script>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
