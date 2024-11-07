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
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/profile.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.js"></script>
</head>
<%@ include file="/WEB-INF/components/toastify_style.jsp" %>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <%
        String deactivationReason = request.getParameter("deactivation-reason");
        if (deactivationReason != null && !deactivationReason.trim().isEmpty()) {
            UserService userService = new UserService();
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean success = userService.deactivateUser(userId, deactivationReason);
    
            if (success) {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-check-circle-fill toast-icon-success\"></i> Account Successfully Deactivated!', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-success', escapeMarkup: false, duration: 3000 }).showToast();</script>");
            } else {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-exclamation-circle-fill toast-icon-error\"></i> Failed to deactivate account!', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-error', escapeMarkup: false, duration: 3000 }).showToast();</script>");
            }
        }
    %>
    
    <%
        if (request.getParameter("confirm-input-activation") != null && request.getParameter("confirm-input-activation").equalsIgnoreCase("CONFIRM")) {
            UserService userService = new UserService();
            boolean success = userService.activateUser(Integer.parseInt(request.getParameter("userId")));
            
            if (success) {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-check-circle-fill toast-icon-success\"></i> Account Successfully Activated !', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-success', escapeMarkup: false, duration: 3000}).showToast();</script>");
            } else {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-exclamation-circle-fill toast-icon-error\"></i> Failed to activate account!', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-error', escapeMarkup: false, duration: 3000}).showToast();</script>");
            }
        }
    %>
    
    <%
        if (request.getParameter("admin-position") != null) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newPosition = request.getParameter("admin-position");
    
            UserService userService = new UserService();
            boolean success = userService.updateUserPosition(userId, newPosition);
    
            if (success) {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-check-circle-fill toast-icon-success\"></i> Position Successfully Updated!', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-success', escapeMarkup: false, duration: 3000 }).showToast();</script>");
            } else {
                out.println("<script>Toastify({ text: '<i class=\"bi bi-exclamation-circle-fill toast-icon-error\"></i> Failed to update position!', backgroundColor: '#ffffff', gravity: 'bottom', position: 'right', className: 'toast-error', escapeMarkup: false, duration: 3000 }).showToast();</script>");
            }
        }
    %>

    <% 
        request.setAttribute("activePage", "manage_account");
        
        String userIdParam = request.getParameter("userId");
        User user = null;
        String accountStatus = "Unknown";
        String reason = null;
        
        if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);
            UserService userService = new UserService();
            user = userService.getUserById(userId);
            accountStatus = (user != null) ? user.getStatus() : "Unknown";
            
            if ("DEACTIVATED".equalsIgnoreCase(accountStatus)) {
                reason = userService.getDeactivationReason(userId);
            }
        }
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <div class="title-section">
                <h2 class="title-page-claimed">MANAGE ACCOUNT</h2>
                <i class="fa-solid fa-angle-right title-icon"></i>
                <h2 class="title-page-number"><%= (user != null) ? (user.getFirstname() + " " + user.getLastname()) : "User Details" %></h2>
                <button class="back-button" onclick="window.location.href='manage_account.jsp';">Back</button>
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
                    <div class="position-section">
                        <p id="admin-position-display">
                            Admin - <strong><%= (user != null) ? user.getPosition() : "N/A" %></strong>
                            <i class="fas fa-edit" id="edit-position-icon" style="cursor: pointer;"></i>
                        </p>
                       <form id="edit-position-form" method="post" class="horizontal-form" style="display: none;">
                            <input type="hidden" name="userId" value="<%= user != null ? user.getId() : "" %>">
                            <select id="admin-position" name="admin-position" required>
                                <option value="" disabled selected>Select Position</option>
                                <option value="academic-clerk" <%= "academic-clerk".equals(user.getPosition()) ? "selected" : "" %>>Academic Clerk</option>
                                <option value="records-officer" <%= "records-officer".equals(user.getPosition()) ? "selected" : "" %>>Records Officer</option>
                                <option value="ict-support-representative" <%= "ict-support-representative".equals(user.getPosition()) ? "selected" : "" %>>ICT Support Representative</option>
                                <option value="supervisor" <%= "supervisor".equals(user.getPosition()) ? "selected" : "" %>>Supervisor</option>
                                <option value="secretary" <%= "secretary".equals(user.getPosition()) ? "selected" : "" %>>Secretary</option>
                                <option value="liaison-officer" <%= "liaison-officer".equals(user.getPosition()) ? "selected" : "" %>>Liaison Officer</option>
                            </select>
                        
                            <button type="submit" class="save-btn">
                                <i class="fas fa-save"></i>
                                Save
                            </button>
                            <button type="button" class="cancel-btn">
                                <i class="fas fa-times"></i>
                                Cancel
                            </button>
                        </form>

                    </div>
                    <p>Office of the Registrar</p>
                </div>
            </div>
            <div class="profile-details">
                <h3 class="title">Personal Information</h3>
                <div class="details-container">
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
                                <p class="<%= accountStatus.equals("ACTIVE") ? "status-active" : "status-deactivate" %>">
                                    <%= accountStatus %>
                                </p>
                            </div>
                        </div>
                </div>
                <% if ("DEACTIVATED".equalsIgnoreCase(accountStatus)){ %>
                    <div class="custom-alert" role="alert">
                        <div class="alert-icon">
                            <i class="bi bi-info-circle-fill"></i>
                        </div>
                        <div class="alert-content">
                            <strong>Reason for Deactivation: &nbsp</strong> <%= reason %>
                        </div>
                    </div>
                <% } %>
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
                                <button type="submit" class="submit-btn" id="activateButton" disabled>Activate Account</button>
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
                            <p class="bigger-text">Please provide a reason for deactivating this account.</p>
                            <form id="confirm-deactivation-form" method="post">
                                <input type="hidden" name="userId" value="<%= userIdParam %>">
                                <textarea id="deactivation-reason" name="deactivation-reason" placeholder="Enter the reason for deactivation" required></textarea>
                                <button type="submit" class="submit-btn" id="deactivateButton" disabled>Deactivate Account</button>
                            </form>
                        </div>
                    </div> 
                </div>
            <% } %>
        </div>
    </div>
    <div class="overlay"></div>
    <script>
       document.addEventListener('DOMContentLoaded', function() {
            const editIcon = document.getElementById('edit-position-icon');
            const positionDisplay = document.getElementById('admin-position-display');
            const editForm = document.getElementById('edit-position-form');
            const cancelBtn = document.querySelector('.cancel-btn');
        
            editIcon.addEventListener('click', function() {
                positionDisplay.style.display = 'none';
                editForm.style.display = 'block';
            });
        
            cancelBtn.addEventListener('click', function() {
                editForm.style.display = 'none';
                positionDisplay.style.display = 'block';
            });
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            const activateForm = document.getElementById('confirm-activation-form');
    
            activateForm.addEventListener('submit', function(event) {
                event.preventDefault();
                const activateButton = document.getElementById('activateButton');
                activateButton.innerHTML = "Activating Account<div class='spinner'></div>";
                activateButton.disabled = true;
                activateButton.classList.add('sending');
    
                setTimeout(() => {
                    this.submit();
                }, 1000);
            });
        });
    
        document.addEventListener('DOMContentLoaded', function() {
            const deactivateForm = document.getElementById('confirm-deactivation-form');
    
            deactivateForm.addEventListener('submit', function(event) {
                event.preventDefault();
                const deactivateButton = document.getElementById('deactivateButton');
                deactivateButton.innerHTML = "Deactivating Account <div class='spinner'></div>";
                deactivateButton.disabled = true;
                deactivateButton.classList.add('sending');
    
                setTimeout(() => {
                    this.submit();
                }, 1000); 
            });
        });
    </script>

    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
