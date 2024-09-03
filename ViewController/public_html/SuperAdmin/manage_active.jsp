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
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="stylesheet" href="../resources/css/manage_account.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <input type="checkbox" id="menu-toggle" hidden>
    
    <% 
        request.setAttribute("activePage", "manage_account");  
        request.setAttribute("activeNav", "manage_active");  
        
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">MANAGE ACCOUNT</h1>
            
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
                        <tbody>
                        <!-- Skeleton loader rows -->
                        <tr class="skeleton-row">
                            <td><span class="skeleton"></span></td>
                            <td class="profile-column"><span class="skeleton-picture"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td><span class="skeleton"></span></td>
                        </tr>
                        <tr class="skeleton-row">
                            <td><span class="skeleton"></span></td>
                            <td class="profile-column"><span class="skeleton-picture"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td><span class="skeleton"></span></td>
                        </tr>
                        <tr class="skeleton-row">
                            <td><span class="skeleton"></span></td>
                            <td class="profile-column"><span class="skeleton-picture"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td class="expandable-text"><span class="skeleton"></span></td>
                            <td><span class="skeleton"></span></td>
                        </tr>
                    
                        <!-- Actual data rows -->
                        <% 
                            List<User> userList = (List<User>) request.getAttribute("users");
                            for (User user : userList) {
                                if ("ACTIVE".equals(user.getStatus())) {
                        %>
                            <tr class="actual-data account-row" data-user-id="<%= user.getId() %>">
                                <td><%= user.getId() %></td>
                                <td class="profile-column">
                                    <img src="${pageContext.request.contextPath}/resources/pictures/<%= user.getPicture() %>" alt="Profile Picture" />  
                                </td>
                                <td class="expandable-text"><%= user.getFirstname() + " " + user.getLastname() %></td>
                                <td class="expandable-text"><%= user.getEmail() %></td>
                                <td class="status-active"><span><%= user.getStatus() %></span></td>
                            </tr>
                        <% 
                                } 
                            } 
                        %>
                    </tbody>

                    </table>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
            <%@ include file="/WEB-INF/components/add_account.jsp" %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
