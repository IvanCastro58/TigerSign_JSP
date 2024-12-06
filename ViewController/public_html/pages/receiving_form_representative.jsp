<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimerDAO" %>
<%@ page import="com.tigersign.dao.ProofDAO" %>
<%@ page import="com.tigersign.dao.RequestDAO" %>
<%@ page import="com.tigersign.dao.EmailService" %>
<%@ page import="com.tigersign.dao.AuditLogger" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.tigersign.dao.AuditLoggerSuperAdmin" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Receiving Form for Authorized Representatives</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../resources/css/receiving_form.css">
    <link rel="stylesheet" href="../resources/css/manage_account.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var images = [];
            
            // Add images from background1.jpg to background15.jpg
            for (var i = 1; i <= 10; i++) {
                images.push("../resources/images/background" + i + ".JPG");
            }
            
            // Select a random image
            var randomImage = images[Math.floor(Math.random() * images.length)];
            
            // Set the selected image as the background
            document.body.style.backgroundImage = "url('" + randomImage + "')";
        });
    </script>
</head>

<body>
    <%@ include file="/WEB-INF/components/privacy_modal.jsp" %>
    <header>
        <div class="logo">
            <img src="../resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="container">
        <div class="main-content">
            <div class="margin-content">
                <div class="receiving-form">
                    <div class="form-container">
                        <div class="highlight-bar"></div>
                        <div class="form-details">
                            <h1 class="title-page">DOCUMENT RECEIVING FORM FOR AUTHORIZED REPRESENTATIVES</h1>
                            <h1 class="title-form">Personal Information</h1>
                            <div class="reminders">
                                <i class="bi bi-info-circle"></i>
                                <p class="smaller-text">Please review all the details before submitting the form to avoid any potential issues and problems in the future.</p>
                            </div>
                            <%
                                String orNumber = request.getParameter("orNumber");
                                String requestId = request.getParameter("requestId");
                                String feeName = request.getParameter("feeName");
                                String name = request.getParameter("field-name");
                                String email = request.getParameter("field-email");
                                String proofDate = request.getParameter("field-date");
                                String role = "REPRESENTATIVE";
                                String photoData = request.getParameter("photo-data");
                                String signatureData = request.getParameter("signature-data");
                                String idData = request.getParameter("id-data");
                                String letterData = request.getParameter("letter-data");
                                String fullName = request.getParameter("fullname");
                                String adminEmail = request.getParameter("admin");
                                String userEmail = request.getParameter("user");
                                String submit = request.getParameter("submit"); 
                                
                                   if (submit != null && name != null && email != null) {
                                        ClaimerDAO claimerDAO = new ClaimerDAO();
                                        int claimerId = claimerDAO.insertClaimer(name, email, role); 
    
                                       if (claimerId > 0) {
                                        ProofDAO proofsDAO = new ProofDAO();
                                        proofsDAO.insertProofs(photoData, signatureData, proofDate, idData, letterData, claimerId, requestId, fullName);
                                
                                        // Update the is_claimed status
                                        RequestDAO requestDAO = new RequestDAO();
                                        requestDAO.updateClaimedStatus(requestId);
                                            
                                        // Sending Email
                                        EmailService emailService = new EmailService();
                                        boolean emailSent = emailService.sendSurveyEmail(email, request);
                                        
                                        if (adminEmail != null && !adminEmail.isEmpty()) {
                                            String activity = "Released the document titled '" + feeName + "' associated with Service Invoice Number " + orNumber + " to an authorized representative.";
                                            AuditLogger.logActivity(adminEmail, activity);
                                        } else if (userEmail != null && !userEmail.isEmpty()) {
                                            String activity = "Released the document titled '" + feeName + "' associated with Service Invoice Number " + orNumber + " to an authorized representative.";
                                            AuditLoggerSuperAdmin.logActivity(userEmail, activity);
                                        }
                                        
                                        if (emailSent) {
                                            response.sendRedirect("success_page.jsp");
                                        } else {
                                            out.println("Failed to send email.");
                                        }
                                    } else {
                                        throw new SQLException("Failed to retrieve the generated claimer_id.");
                                    }
                                }
                                %>
                            <h2 class="number-form"><span>Service Invoice: <%= orNumber != null ? "#" + orNumber : "" %></span></h2>
                            <form action="" class="form" method="POST" id="document-receiving-form">
                                <input type="hidden" name="photo-data" id="photo-data">
                                <input type="hidden" name="signature-data" id="signature-data">
                                <input type="hidden" name="id-data" id="id-data">
                                <input type="hidden" name="letter-data" id="letter-data">
                                <input type="hidden" name="adminFullName" value="<%= fullName %>" />
                                <div class="input-fields">
                                    <label for="claimer-name" class="form-label">Name:</label>
                                    <input type="text" name="field-name" id="field-name" placeholder="Enter Full Name" required>
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-date" class="form-label">Date:</label>
                                    <input type="date" name="field-date" id="field-date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-email" class="form-label">Email Address:</label>
                                    <input type="email" name="field-email" id="field-email" placeholder="Enter email address" required>
                                </div>
                                 
                               <div class="input-fields">
                                        <label for="claimer-documents" class="form-label">Requested Documents:</label>
                                        <div class="list-documents">
                                            <ul class="documents-list">
                                                <%
                                                    if (feeName != null) {
                                                        String[] documents = feeName.split(",");
                                                        for (String doc : documents) {
                                                %>
                                                            <li><strong><%= doc.trim() %></strong></li>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </ul>
                                        </div>
                                    </div>
                                <div class="input-fields">
                                    <label for="claimer-letter" class="form-label">Authorization Letter:</label>
                                    <div class="input-with-button">
                                        <input type="file" name="field-letter" id="letter-photo-field" accept="image/*">
                                        <input type="text" id="letter-photo-filename" placeholder="Upload Authorization Letter" readonly onclick="viewCapturedLetterImage()" required>
                                        <button type="button" class="upload-btn" id="open-letter-camera-btn"><i class="fa-solid fa-camera"></i></button>
                                        <i class="fas fa-check-circle success-icon" id="letter-photo-check-icon"></i>
                                    </div>
                                </div>
    
                                <div class="input-fields">
                                    <label for="claimer-id" class="form-label">ID Photo:</label>
                                    <div class="input-with-button">
                                        <input type="file" name="field-id" id="id-photo-field" accept="image/*">
                                        <input type="text" id="id-photo-filename" placeholder="Upload Owner's ID" readonly onclick="viewCapturedIdImage()" required>
                                        <button type="button" class="upload-btn" id="open-id-camera-btn"><i class="fa-solid fa-camera"></i></button>
                                        <i class="fas fa-check-circle success-icon" id="id-photo-check-icon"></i>
                                    </div>
                                </div>
    
                                <div class="input-fields">
                                    <label for="claimer-signature" class="form-label">E-Signature</label>
                                    <div class="input-with-button">
                                        <input type="text" name="field-signature" id="signature-field" placeholder="Upload Signature" readonly required>
                                        <button type="button" class="upload-btn" id="open-signature-modal-btn">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <i class="fas fa-check-circle success-icon" id="signature-check-icon"></i>
                                    </div>
                                    <span class="error-message" id="signature-error" style="color: red; display: none;">Signature is required.</span>
                                </div>
                                
                                <div class="input-fields">
                                    <label for="claimer-photo" class="form-label">Self-Captured Photo</label>
                                    <div class="input-with-button">
                                        <input type="file" name="field-photo" id="photo-field" accept="image/*">
                                        <input type="text" id="photo-filename" placeholder="Upload Photo" readonly onclick="viewCapturedImage()" required>
                                        <button type="button" class="upload-btn" id="open-camera-btn"><i class="fa-solid fa-camera"></i></button>
                                        <i class="fas fa-check-circle success-icon" id="photo-check-icon"></i>
                                    </div>
                                </div>
                                
                                <%@ include file="/WEB-INF/components/form_modals.jsp" %>
    
                                <div class="submit-button-container">
                                    <button type="submit" name="submit" value="submit" class="submit-button" id="submit-button">Submit</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
     <script>
    document.getElementById("open-signature-modal-btn").addEventListener("click", function () {
        // Simulate signature upload (replace this with your modal logic)
        document.getElementById("signature-field").value = "Sample Signature"; // Set this after upload
        document.getElementById("signature-check-icon").style.display = "inline";
        document.getElementById("signature-error").style.display = "none";
    });

    document.querySelector("form").addEventListener("submit", function (event) {
        const signatureField = document.getElementById("signature-field");
        const signatureError = document.getElementById("signature-error");

        if (!signatureField.value) {
            event.preventDefault(); // Prevent form submission
            signatureError.style.display = "block"; // Show error message
        } else {
            signatureError.style.display = "none";
        }
    });
</script>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
