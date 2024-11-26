<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Evaluation - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/send_eval.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<%@ include file="/WEB-INF/components/toastify_style.jsp" %>
<body>
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    <% 
        request.setAttribute("activePage", "evaluation");  
    %>
    
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">SEND SURVEY & EVALUATION FORM</h2>
            <div class="box">
                <h2 class="title-email">Enter Email Address<span style="color: #DB3444;">*</span></h2>
                <form action="${pageContext.request.contextPath}/SendSurveyServlet" method="POST" id="surveyForm" class="send-container">
                    <input type="email" name="email" class="send-input" placeholder="Ex. juandelacruz@gmail.com" required>
                    <button type="submit" class="send-button" id="sendButton">Send
                        <i class='bx bxs-send'></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastify-js/1.12.0/toastify.min.js"></script>
    <script>
        window.onload = function() {
            const url = new URL(window.location.href);
            const successMessage = url.searchParams.get("success");
        
            if (successMessage) {
                Toastify({
                    text: "<i class='bi bi-check-circle-fill toast-icon-success'></i> Survey/Evaluation Link Sent Successfully !",
                    backgroundColor: '#ffffff',
                    gravity: 'bottom',
                    position: 'right',
                    className: 'toast-success',
                    escapeMarkup: false,
                    duration: 3000
                }).showToast();

                url.searchParams.delete("success");
                window.history.replaceState({}, document.title, url.pathname + url.search); 
            }
            
            const failedMessage = url.searchParams.get("failed");
            if (failedMessage) {
                Toastify({
                    text: "<i class='bi bi-exclamation-circle-fill toast-icon-error'></i> Failed to Sent Survey/Evaluation Link !",
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
        };
    </script>
    
    <script>
         document.getElementById("surveyForm").addEventListener("submit", function(event) {
            event.preventDefault();
            
            const sendButton = document.getElementById('sendButton');
            sendButton.innerHTML = "Sending <div class='spinner'></div>";
            sendButton.disabled = true; 
            sendButton.classList.add('sending');
            
            setTimeout(() => {
                this.submit();
            }, 2000);
        });
    </script>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
