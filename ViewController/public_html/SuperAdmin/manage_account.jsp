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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/table.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/manage_account.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<%@ include file="/WEB-INF/components/toastify_style.jsp" %>
<style>
    .transaction-table th{
        padding: 15px;
    }
    
    .transaction-table td{
        padding: 10px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "manage_account");  
        request.setAttribute("activeNav", "manage_account");  
        
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    <%@ include file="/WEB-INF/components/existing_account.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">MANAGE ACCOUNT</h2>
            
            <%@ include file="/WEB-INF/components/account_navbar.jsp" %>
            
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="account_table">
                        <thead>
                            <tr>
                                <th>
                                    ID
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-caret-up"></i>
                                        <i class="fa-solid fa-caret-down"></i>
                                    </span>
                                </th>
                                <th>
                                    Picture
                                </th>
                                <th class="date-processed-column">
                                    Name
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-caret-up"></i>
                                        <i class="fa-solid fa-caret-down"></i>
                                    </span>
                                </th>
                                <th>
                                    Email
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-caret-up"></i>
                                        <i class="fa-solid fa-caret-down"></i>
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
                                int userCount = userList != null ? userList.size() : 0;
                            
                                // Display skeleton rows based on the user count
                                for (int i = 0; i < userCount; i++) { 
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
                            
                                // After skeleton rows, display actual user data if available
                                if (userList != null && !userList.isEmpty()) { 
                                    for (User user : userList) {
                                        String statusClass = "status-active"; 
                                        if ("DEACTIVATED".equals(user.getStatus())) {
                                            statusClass = "status-deactivate";
                                        }
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
                                            <td class="<%= statusClass %>">
                                                <span><%= user.getStatus() %></span>
                                            </td>
                                        </tr>
                            <% 
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
                            if (userList == null || userList.isEmpty()) { 
                        %>
                            <div style="text-align: center; margin-top: 20px;">
                                <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                                <p style="font-size: 14px; font-weight: 500;">No admin accounts available at the moment.</p>
                            </div>
                        <% 
                            } 
                        %>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
            <%@ include file="/WEB-INF/components/add_account.jsp" %>
        </div>
    </div>
    
    <div class="overlay"></div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.js"></script>
    <script>
        window.onload = function() {
            const url = new URL(window.location.href);
        
            const successMessage = url.searchParams.get("success") ? "Invitation sent successfully." : "";
            
            if (successMessage) {
                Toastify({
                    text: "<i class='bi bi-check-circle-fill toast-icon-success'></i> Invitation Sent Successfully !",
                    backgroundColor: '#ffffff',
                    gravity: 'bottom',
                    position: 'right',
                    className: 'toast-success',
                    escapeMarkup: false,
                    duration: 3000
                }).showToast();
        
                url.searchParams.delete("success");
                window.history.replaceState(null, null, url.toString());
            }
        
            const failedMessage = url.searchParams.get("failed") ? "Failed to Sent Invitation." : "";
            if (failedMessage) {
                Toastify({
                    text: "<i class='bi bi-exclamation-circle-fill toast-icon-error'></i> Failed to Sent Invitation !",
                    backgroundColor: '#ffffff',
                    gravity: 'bottom',
                    position: 'right',
                    className: 'toast-error',
                    escapeMarkup: false,
                    duration: 3000
                }).showToast();
        
                url.searchParams.delete("failed");
                window.history.replaceState(null, null, url.toString());
            }
        
            const adminName = '<%= request.getAttribute("existingFirstname") != null ? request.getAttribute("existingFirstname") : "" %>';
            const existingAdminPopup = document.getElementById('existing-admin-popup');
            const closeExistingAdminPopup = document.getElementById('popup-close-existing');
        
            if (adminName !== "") {
                existingAdminPopup.style.display = 'flex'; 
                setTimeout(() => {
                    existingAdminPopup.querySelector('.popup').classList.add('show'); 
                }, 10);
            }
        
            closeExistingAdminPopup.addEventListener('click', () => {
                existingAdminPopup.querySelector('.popup').classList.remove('show'); 
                setTimeout(() => {
                    existingAdminPopup.style.display = 'none'; 
                }, 600);
            });
        
            window.addEventListener('click', (event) => {
                if (event.target === existingAdminPopup) {
                    existingAdminPopup.querySelector('.popup').classList.remove('show'); 
                    setTimeout(() => {
                        existingAdminPopup.style.display = 'none'; 
                    }, 600);
                }
            });
        };
    </script>
    
    <script>
        const adminPopup = document.getElementById('add-admin-popup');
        const addAdmin = document.querySelector('.add-user-btn');
        const closeAddAdmin = document.getElementById('popup-close');
        
        if (adminPopup.style.display === 'flex') {
            adminPopup.querySelector('.popup').classList.add('show');
        }
        
        addAdmin.addEventListener('click', () => {
            adminPopup.style.display = 'flex';
            setTimeout(() => {
                adminPopup.querySelector('.popup').classList.add('show');
            }, 10);
        });
        
        closeAddAdmin.addEventListener('click', () => {
            adminPopup.querySelector('.popup').classList.remove('show');
            setTimeout(() => {
                adminPopup.style.display = 'none';
            }, 600);
        });
        
        window.addEventListener('click', (event) => {
            if (event.target === adminPopup) {
                adminPopup.querySelector('.popup').classList.remove('show');
                setTimeout(() => {
                    adminPopup.style.display = 'none';
                }, 600);
            }
        });
    </script>
    <script>
        const searchInput = document.getElementById('search-input');
        const tableRows = document.querySelectorAll('#account_table tbody tr.actual-data');
        const noResultsDiv = document.getElementById('no-results'); 
    
        searchInput.addEventListener('input', () => {
            const searchValue = searchInput.value.toLowerCase();
            let hasMatches = false; 
    
            tableRows.forEach((row) => {
                const rowData = row.textContent.toLowerCase();
    
                if (rowData.includes(searchValue)) {
                    row.style.display = 'table-row';
                    hasMatches = true; 
                } else {
                    row.style.display = 'none';
                }
            });
    
            if (!hasMatches && searchValue) {
                noResultsDiv.style.display = 'block'; 
            } else {
                noResultsDiv.style.display = 'none'; 
            }
        });
    </script>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
