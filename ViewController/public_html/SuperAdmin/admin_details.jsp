<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.service.UserService, com.tigersign.dao.User" %>
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
    <link rel="stylesheet" href="../resources/css/profile.css">
    <link rel="stylesheet" href="../resources/css/toastify.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.js"></script>
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <%
        if (request.getParameter("confirm-input") != null && request.getParameter("confirm-input").equalsIgnoreCase("CONFIRM")) {
            UserService userService = new UserService();
            boolean success = userService.deactivateUser(Integer.parseInt(request.getParameter("userId")));
            
            if (success) {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-check-circle-fill toast-icon-success\"></i> Account successfully deactivated!', backgroundColor: '#ffffff', position: 'right', className: 'toast-success', escapeMarkup: false, duration: 3000}).showToast();</script>");
            } else {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-exclamation-circle-fill toast-icon-error\"></i> Failed to deactivate account!', backgroundColor: '#ffffff', position: 'right', className: 'toast-error', escapeMarkup: false, duration: 3000}).showToast();</script>");
            }
        }
    %>
    
    <%
        if (request.getParameter("confirm-input-activation") != null && request.getParameter("confirm-input-activation").equalsIgnoreCase("CONFIRM")) {
            UserService userService = new UserService();
            boolean success = userService.activateUser(Integer.parseInt(request.getParameter("userId")));
            
            if (success) {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-check-circle-fill toast-icon-success\"></i> Account successfully activated!', backgroundColor: '#ffffff', position: 'right', className: 'toast-success', escapeMarkup: false, duration: 3000}).showToast();</script>");
            } else {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-exclamation-circle-fill toast-icon-error\"></i> Failed to activate account!', backgroundColor: '#ffffff', position: 'right', className: 'toast-error', escapeMarkup: false, duration: 3000}).showToast();</script>");
            }
        }
    %>

    <% 
        request.setAttribute("activePage", "manage_account");
        
        String userIdParam = request.getParameter("userId");
        User user = null;
        String accountStatus = "Unknown";

        if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);
            UserService userService = new UserService();
            user = userService.getUserById(userId);
            accountStatus = (user != null) ? user.getStatus() : "Unknown";
        }
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <div class="title-section">
                <h1 class="title-page-claimed">MANAGE ACCOUNT</h1>
                <i class="fa-solid fa-angle-right title-icon"></i>
                <h1 class="title-page-number"><%= (user != null) ? (user.getFirstname() + " " + user.getLastname()) : "User Details" %></h1>
                <button class="back-button" onclick="window.location.href='${contextPath}/SuperAdmin/manage_account.jsp';">Back</button>
            </div>
            <div class="profile-box">
                <div class="admin-profile">
                    <label for="admin-profile">
                        <img src="<%= user.getPicture() %>" alt="Profile Picture" id="profile-pic-img">
                    </label>
                </div>
                <div class="profile-name">
                    <div class="name-line">
                        <h3><%= (user != null) ? (user.getFirstname() + " " + user.getLastname()) : "Unknown User" %></h3>
                    </div>
                    <p>Admin</p>
                    <p>Office of the Registrar</p>
                </div>
            </div>
            <div class="profile-details">
                <h3 class="title">Personal Information</h3>
                <div class="details-container">
                    <div>
                        <div class="name">
                            <div class="firstname">
                                <label>First Name</label>
                                <p><%= (user != null) ? user.getFirstname() : "N/A" %></p>
                            </div>
                            <div>
                                <label>Last Name</label>
                                <p><%= (user != null) ? user.getLastname() : "N/A" %></p>
                            </div>
                        </div>
                        <div class="email">
                            <div>
                                <label>Email</label>
                                <p><%= (user != null) ? user.getEmail() : "N/A" %></p>
                            </div>
                            <div class="account-status">
                                <label>Account Status</label>
                                <p class="<%= accountStatus.equals("ACTIVE") ? "status-active" : "status-deactivated" %>">
                                    <%= accountStatus %>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>     

            <!-- Button and Modal based on Account Status -->
            <% if (accountStatus.equals("DEACTIVATED")) { %>
                <div class="btn-activate">
                    <button class="activate-btn">Activate</button>
                </div>
                <!-- Modal for Activation -->
                <div id="confirm-activation-popup" class="popup-overlay">
                    <div class="popup">
                        <div class="popup-header">
                            <strong>CONFIRM ACCOUNT ACTIVATION</strong>
                            <span class="popup-close" id="popup-close">&times;</span>
                        </div>
                        <div class="popup-content">
                            <p class="bigger-text">Please type "CONFIRM" to proceed with activating this account.</p>
                            <form id="confirm-activation-form" method="post">
                                <input type="hidden" name="userId" value="<%= userIdParam %>">
                                <input type="text" id="confirm-input-activation" name="confirm-input-activation" placeholder="Type 'CONFIRM' to proceed" required>
                                <button type="submit" class="submit-btn" disabled>Activate Account</button>
                            </form>
                        </div>
                    </div> 
                </div>
            <% } else { %>
                <div class="btn-activate">
                    <button class="deactivate-btn">Deactivate</button>
                </div>
                <!-- Modal for Deactivation -->
                <div id="confirm-deactivation-popup" class="popup-overlay">
                    <div class="popup">
                        <div class="popup-header">
                            <strong>CONFIRM ACCOUNT DEACTIVATION</strong>
                            <span class="popup-close" id="popup-close">&times;</span>
                        </div>
                        <div class="popup-content">
                            <p class="bigger-text">Please type "CONFIRM" to proceed with deactivating this account.</p>
                            <form id="confirm-deactivation-form" method="post">
                                <input type="hidden" name="userId" value="<%= userIdParam %>">
                                <input type="text" id="confirm-input-deactivation" name="confirm-input" placeholder="Type 'CONFIRM' to proceed" required>
                                <button type="submit" class="submit-btn" disabled>Deactivate Account</button>
                            </form>
                        </div>
                    </div> 
                </div>
            <% } %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
