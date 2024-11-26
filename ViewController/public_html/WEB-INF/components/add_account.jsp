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
                <label for="email">Email</label>
                <div class="input-wrapper">
                    <input type="text" id="admin-email" name="admin-email"
                        class="<%= request.getAttribute("invalidDomain") != null ? "is-invalid" : "" %>"
                        placeholder="Enter UST GSuite Address" required>
                </div>
                
                <% if (request.getAttribute("invalidDomain") != null) { %>
                    <span class="invalid-text">Invalid account: Please use only the domain ust.edu.ph.</span>
                <% } %>
                
                <br>
                
                <label for="position">Select Position</label>
                <select id="admin-position" name="admin-position" required>
                    <option value="" disabled selected>Select Position</option>
                    <option value="academic-clerk">Academic Clerk</option>
                    <option value="records-officer">Records Officer</option>
                    <option value="ict-support-representative">ICT Support Representative</option>
                    <option value="supervisor">Supervisor</option>
                    <option value="secretary">Secretary</option>
                    <option value="liaison-officer">Liaison Officer</option>
                </select>

                <div style="display: inline-flex; align-items: center; width: fit-content; margin-left: auto;">
                    <button type="submit" class="submit-btn" id="sendButton">Send Invitation <i class="bi bi-chevron-right"></i></button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    select {
        font-family: 'Montserrat', sans-serif;
        width: 100%;
        padding: 10px 5px;
        margin-bottom: 15px;
        font-size: 12px;
        border: 1px solid #a1a1a1;
        box-sizing: border-box;
    }
    
    select:focus{
        border: 1px solid #80bdff;
        outline: 0;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }
    
    .input-wrapper {
        position: relative;
        display: inline-flex;
        width: 100%;
    }

    .input-wrapper input {
        padding-right: 120px; 
        width: 100%;
    }

    .input-wrapper::after {
        content: "@ust.edu.ph";
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        color: #1a1a1a;
        font-size: 12px;
        pointer-events: none;
    }

    .spinner {
        display: inline-block;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        position: relative;
        margin-left: 5px;
        animation: rotate 1s linear infinite
      }
      
      .spinner::before , .spinner::after {
        content: "";
        box-sizing: border-box;
        position: absolute;
        inset: 0px;
        border-radius: 50%;
        border: 3px solid #FFF;
        animation: prixClipFix 2s linear infinite ;
      }
      .spinner::after{
        transform: rotate3d(90, 90, 0, 180deg );
        border-color: #F4BB00;
      }

      @keyframes rotate {
        0%   {transform: rotate(0deg)}
        100%   {transform: rotate(360deg)}
      }

      @keyframes prixClipFix {
          0%   {clip-path:polygon(50% 50%,0 0,0 0,0 0,0 0,0 0)}
          50%  {clip-path:polygon(50% 50%,0 0,100% 0,100% 0,100% 0,100% 0)}
          75%, 100%  {clip-path:polygon(50% 50%,0 0,100% 0,100% 100%,100% 100%,100% 100%)}
    }
</style>

<script>
    function showLoading() {
        const emailInput = document.getElementById('admin-email');
        const domain = '@ust.edu.ph';
    
        // Check if the email already has a domain (anything after '@')
        if (!emailInput.value.includes('@')) {
            emailInput.value = emailInput.value + domain;
        }
    
        const sendButton = document.getElementById('sendButton');
        sendButton.innerHTML = "Sending Invitation<div class='spinner'></div>";
        sendButton.disabled = true; 
        sendButton.classList.add('sending');
    
        setTimeout(() => {
            document.getElementById('add-admin-form').submit();
        }, 1500);
    
        return false;
    }
</script>
