<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Existing Admin Details Modal Component -->
<div id="existing-admin-popup" class="popup-overlay">   
    <div class="popup">
        <div class="popup-header">
            <strong>EXISTING ADMIN ACCOUNT</strong>
            <span class="popup-close" id="popup-close-existing">&times;</span>
        </div>
        <div class="popup-content">
            <p class="bigger-text">This email already belongs to an existing Admin account.</p>
            <div class="info-text">
                <i class="bi bi-info-circle"></i>
                <p class="smaller-text">Here are the details of the existing Admin account associated with this email address.</p>
            </div>
            <div class="admin-details">
                <div class="user-pic">
                    <img id="user-picture" src="<%= request.getAttribute("existingPicture") %>" alt="Profile Picture" style="width: 100px; height: 100px;">
                </div>
                <div class="user-info">
                    <p><strong>Name:</strong> <span id="admin-name"><%= request.getAttribute("existingFirstname") %> <%= request.getAttribute("existingLastname") %></span></p>
                    <p><strong>Email:</strong> <span id="admin-email-popup"><%= request.getAttribute("existingEmail") %></span></p>
                    <p><strong>Status:</strong> <span id="admin-status"><%= request.getAttribute("existingStatus") %></span></p>
                    <input type="hidden" id="admin-id" value="<%= request.getAttribute("userId") %>">
                </div>
            </div>
            <center>
                <a href="admin_details.jsp?userId=<%= request.getAttribute("userId") %>" id="view-account-btn" class="view-btn">
                    <i class="bi bi-eye"></i>
                    View Account
                </a>
            </center>
        </div>
    </div>
</div>