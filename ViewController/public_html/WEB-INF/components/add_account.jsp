<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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

            <form id="add-admin-form" action="send-invitation" method="post" onsubmit="return showLoading();">
                <input type="email" id="admin-email" name="admin-email" 
                    class="<%= request.getAttribute("invalidDomain") != null ? "is-invalid" : "" %>"
                    placeholder="Enter UST GSuite Address to send invitations" required>
                    
                <% if (request.getAttribute("invalidDomain") != null) { %>
                    <span class="invalid-text">Invalid Account: Use only the domain ust.edu.ph.</span>
                <% } %>
                
                <div style="display: inline-flex; align-items: center; width: fit-content; margin-left: auto;">
                    <div id="loading-spinner" class="loading-spinner" style="display: none;">
                        <div class="spinner"></div>
                    </div>
                    <button type="submit" class="submit-btn">Send Invitation <i class="bi bi-chevron-right"></i></button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .loading-spinner {
        display: inline-flex; 
        align-items: center; 
        margin-right: 10px; 
        font-size: 2em; 
    }

    .spinner {
        width: 25px; 
        height: 25px;
        border: 3px solid transparent;
        border-top-color: #F4BB00; 
        border-radius: 50%; 
        animation: spin 0.8s linear infinite; 
        margin-top: 10px;
        margin-right: 5px; 
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<script>
    function showLoading() {
        const spinner = document.getElementById('loading-spinner');
        spinner.style.display = 'inline-flex'; 

        setTimeout(() => {
            document.getElementById('add-admin-form').submit(); 
        }, 1500); 

        return false; 
    }
</script>
