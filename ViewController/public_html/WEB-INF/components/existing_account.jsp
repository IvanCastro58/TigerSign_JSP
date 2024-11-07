<!-- Existing Admin Details Modal Component -->
<div id="existing-admin-popup" class="popup-overlay">   
    <div class="popup">
        <div class="popup-header">
            <strong>EXISTING ADMIN ACCOUNT</strong>
            <span class="popup-close" id="popup-close-existing">&times;</span>
        </div>
        <div class="popup-content">

            <% 
                String existingStatus = (String) request.getAttribute("existingStatus");
            %>

            <% if ("Not Logged In".equals(existingStatus)) { %>
                <p class="bigger-text">This email address has already been granted admin access, but the user is currently not logged in.</p>
                <div class="info-text">
                    <i class="bi bi-info-circle"></i>
                    <p class="smaller-text">Details cannot be displayed for this email at this time.</p>
                </div>
            <% } else { %>
                <p class="bigger-text">This email already belongs to an existing Admin account.</p>
                <div class="info-text">
                    <i class="bi bi-info-circle"></i>
                    <p class="smaller-text">Here are the details of the existing Admin account associated with this email address.</p>
                </div>
            <% } %>

            <div class="admin-details">
                <div class="user-pic">
                    <% if (request.getAttribute("existingPicture") != null && !((String) request.getAttribute("existingPicture")).isEmpty()) { %>
                        <img id="user-picture" src="<%= request.getAttribute("existingPicture") %>" alt="Profile Picture" style="width: 120px; height: 120px;">
                    <% } else { %>
                        <img id="user-picture" src="${pageContext.request.contextPath}/resources/images/default-profile.jpg" alt="Default Picture" style="width: 120px; height: 120px;"> 
                    <% } %>
                </div>
                <div class="user-info">
                    <p><strong>Name:</strong> <span id="admin-name"><%= request.getAttribute("existingFirstname") %> <%= request.getAttribute("existingLastname") %></span></p>
                    <p><strong>Email:</strong> <span id="admin-email-popup"><%= request.getAttribute("existingEmail") %></span></p>
                    <p><strong>Status:</strong> <span id="admin-status"><%= request.getAttribute("existingStatus") %></span></p>
                    <p><strong>Current Position:</strong> <span id="admin-status"><%= request.getAttribute("existingPosition") %></span></p>
                    <input type="hidden" id="admin-id" value="<%= request.getAttribute("userId") %>">
                </div>
            </div>

            <center>
                <a href="<%= "Not Logged In".equals(existingStatus) ? "#" : "admin_details.jsp?userId=" + request.getAttribute("userId") %>" 
                   id="view-account-btn" 
                   class="view-btn" 
                   <% if ("Not Logged In".equals(existingStatus)) { %> 
                       style="background-color: grey; cursor: not-allowed;" 
                       aria-disabled="true" 
                   <% } %>>
                    <i class="bi bi-eye"></i>
                    View Account
                </a>
            </center>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const viewAccountBtn = document.getElementById("view-account-btn");

        viewAccountBtn.addEventListener("click", function(event) {
            if (viewAccountBtn.getAttribute("aria-disabled") === "true") {
                event.preventDefault();
            } else {
                event.preventDefault();
                viewAccountBtn.innerHTML = "<div class='spinner'></div> Viewing Account";
                viewAccountBtn.disabled = true;
                viewAccountBtn.classList.add('sending');

                setTimeout(() => {
                    window.location.href = viewAccountBtn.getAttribute("href");
                }, 2000);
            }
        });
    });
</script>

