<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Add Admin Account Modal Component -->
<div id="add-admin-popup" class="popup-overlay" style="<%= request.getAttribute("showModal") != null ? "display: flex;" : "display: none;" %>">
    <div class="popup">
        <div class="popup-header">
            <strong>ADD ADMIN ACCOUNT</strong>
            <span class="popup-close" id="popup-close">&times;</span>
        </div>
        <div class="popup-content">
            <p class="bigger-text">Enter the valid GSuite account of the person you want to invite as an Admin.</p>
            <div class="info-text">
                <i class="bi bi-info-circle"></i>
                <p class="smaller-text">Please ensure that the GSuite account you will enter is correct and the official UST Google Account of the person you want to invite.</p>
            </div>

            <!-- Display error message for invalid domain -->
            <form id="add-admin-form" action="send-invitation" method="post">
                <input type="email" id="admin-email" name="admin-email" 
                    class="<%= request.getAttribute("invalidDomain") != null ? "is-invalid" : "" %>"
                    placeholder="Enter UST GSuite Address to send invitations" required>
                    
                <% if (request.getAttribute("invalidDomain") != null) { %>
                    <span class="invalid-text">Invalid Account: Use only the domain ust.edu.ph.</span>
                <% } %>
                <button type="submit" class="submit-btn">Send Invitation<i class="bi bi-chevron-right"></i></button>
            </form>
        </div>
    </div>
</div>

