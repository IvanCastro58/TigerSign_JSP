<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimerDAO" %>
<%@ page import="com.tigersign.dao.ProofDAO" %>
<%@ page import="com.tigersign.dao.RequestDAO" %>
<%@ page import="com.tigersign.dao.EmailService" %>
<%@ page import="java.sql.SQLException" %>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document Receiving Form for Primary Claimers</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../resources/css/receiving_form.css">
        <link rel="stylesheet" href="../resources/css/manage_account.css">
        <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            var images = [
                "../resources/images/background.jpg",
                "../resources/images/background2.jpg",
                "../resources/images/background3.jpg"
            ];
            var randomImage = images[Math.floor(Math.random() * images.length)];
            var mainContent = document.querySelector('.main-content'); 
            
            if (mainContent) {
                mainContent.style.backgroundImage = "url('" + randomImage + "')";
            }
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
                        <h1 class="title-page">DOCUMENT RECEIVING FORM FOR PRIMARY CLAIMERS</h1>
                        <div class="form-box">
                            <h1 class="title-form">Personal Information</h1>
                            <div class="reminders">
                                <i class="bi bi-info-circle"></i>
                                <p class="smaller-text">Please review all the details before submitting the form to avoid any potential issues and problems in the future.</p>
                            </div>
                            <%
                                String orNumber = request.getParameter("orNumber");
                                String customerName = request.getParameter("customerName");
                                String email = request.getParameter("field-email");
                                String feeName = request.getParameter("feeName");
                                String proofDate = request.getParameter("field-date");
                                String role = "OWNER";
                                String photoData = request.getParameter("photo-data");
                                String signatureData = request.getParameter("signature-data");
                                String idData = null;
                                String letterData = null;
                                String fullName = request.getParameter("fullname");
                                String submit = request.getParameter("submit"); 
                                
                            
                                if (submit != null && customerName != null && email != null) {
                                    ClaimerDAO claimerDAO = new ClaimerDAO();
                                    int claimerId = claimerDAO.insertClaimer(customerName, email, role); 

                                    if (claimerId > 0) {
                                        ProofDAO proofsDAO = new ProofDAO();
                                        proofsDAO.insertProofs(photoData, signatureData, proofDate, "", "", claimerId, orNumber, fullName, feeName);
                            
                                        // Update the is_claimed status
                                        RequestDAO requestDAO = new RequestDAO();
                                        requestDAO.updateClaimedStatus(orNumber, feeName);
                                        
                                        EmailService emailService = new EmailService();
                                        boolean emailSent = emailService.sendSurveyEmail(email, request);
                            
                                        if (emailSent) {
                                            response.sendRedirect("success_page.jsp");
                                        } else {
                                            out.println("Failed to send email.");
                                        }
                                    }
                                }
                                
                            %>
                            <h2 class="number-form"><span>O.R. Number: <%= orNumber != null ? "#" + orNumber : "" %></span></h2>
                            <form action="" class="form" method="POST" id="document-receiving-form">
                                <input type="hidden" name="photo-data" id="photo-data">
                                <input type="hidden" name="signature-data" id="signature-data">
                                <input type="hidden" name="adminFullName" value="<%= fullName %>" />
                                <div class="input-fields">
                                    <label for="claimer-name" class="form-label">Name</label>
                                    <input type="text" name="field-name" id="field-name" value="<%= customerName != null ? customerName : "" %>" placeholder="Enter Full Name" readonly>
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-date" class="form-label">Date</label>
                                    <input type="date" name="field-date" id="field-date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-email" class="form-label">Email Address:</label>
                                    <input type="text" name="field-email" id="field-email" placeholder="Enter email address" required>
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
                                    <label for="claimer-signature" class="form-label">E-Signature</label>
                                    <div class="input-with-button">
                                      <input type="text" name="field-signature" id="signature-field" placeholder="Upload Signature" readonly>
                                      <button type="button" class="upload-btn" id="open-signature-modal-btn"><i class="fa-solid fa-pen-to-square"></i></button>
                                      <i class="fas fa-check-circle success-icon" id="signature-check-icon"></i>
                                    </div>                                
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-photo" class="form-label">Self-Captured Photo</label>
                                    <div class="input-with-button">
                                        <input type="file" name="field-photo" id="photo-field" accept="image/*">
                                        <input type="text" id="photo-filename" placeholder="Upload Photo" readonly onclick="viewCapturedImage()">
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
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>



<%--<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimerDAO" %>
<%@ page import="com.tigersign.dao.ProofDAO" %>
<%@ page import="com.tigersign.dao.RequestDAO" %>
<%@ page import="com.tigersign.dao.EmailService" %>
<%@ page import="java.sql.SQLException" %>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document Receiving Form for Primary Claimers</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../resources/css/receiving_form.css">
        <link rel="stylesheet" href="../resources/css/manage_account.css">
        <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
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
                        <h1 class="title-page">DOCUMENT RECEIVING FORM FOR PRIMARY CLAIMERS</h1>
                        <div class="form-box">
                            <h1 class="title-form">Personal Information</h1>
                            <div class="reminders">
                                <i class="bi bi-info-circle"></i>
                                <p class="smaller-text">Please review all the details before submitting the form to avoid any potential issues and problems in the future.</p>
                            </div>
                            <%
                                String transactionId = request.getParameter("transactionId");
                                String name = request.getParameter("name");
                                String email = request.getParameter("field-email");
                                String files = request.getParameter("files");
                                String proofDate = request.getParameter("field-date");
                                String role = "PRIMARY";
                                String photoData = request.getParameter("photo-data");
                                String signatureData = request.getParameter("signature-data");
                                String idData = null;
                                String letterData = null;
                                String fullName = request.getParameter("fullname");
                                String submit = request.getParameter("submit"); 
                                
                            
                                if (submit != null && name != null && email != null) {
                                    ClaimerDAO claimerDAO = new ClaimerDAO();
                                    int claimerId = claimerDAO.insertClaimer(name, email, role); 
                            
                                    if (claimerId > 0) {
                                        ProofDAO proofsDAO = new ProofDAO();
                                        proofsDAO.insertProofs(photoData, signatureData, proofDate, "", "", claimerId, transactionId, fullName);
                            
                                        RequestDAO requestDAO = new RequestDAO();
                                        requestDAO.updateClaimedStatus(transactionId);
                            
                                        EmailService emailService = new EmailService();
                                        boolean emailSent = emailService.sendSurveyEmail(email, request);
                            
                                        if (emailSent) {
                                            response.sendRedirect("success_page.jsp");
                                        } else {
                                            out.println("Failed to send email.");
                                        }
                                    }
                                }
                            %>
                            <h2 class="number-form"><span>Transaction ID: <%= transactionId != null ? "#" + transactionId : "" %></span></h2>
                            <form action="" class="form" method="POST" id="document-receiving-form">
                                <input type="hidden" name="photo-data" id="photo-data">
                                <input type="hidden" name="signature-data" id="signature-data">
                                <input type="hidden" name="adminFullName" value="<%= fullName %>" />
                                <div class="input-fields">
                                    <label for="claimer-name" class="form-label">Name</label>
                                    <input type="text" name="field-name" id="field-name" value="<%= name != null ? name : "" %>" placeholder="Enter Full Name" readonly>
                                </div>
                               <div class="input-fields">
                                    <label for="claimer-date" class="form-label">Date</label>
                                    <input type="date" name="field-date" id="field-date" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                                </div>

                                <div class="input-fields">
                                    <label for="claimer-email" class="form-label">Email Address</label>
                                    <input type="text" name="field-email" id="field-email" placeholder="Enter email address" required>
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-documents" class="form-label">Requested Documents:</label>
                                    <div class="list-documents">
                                        <ul class="documents-list">
                                            <%
                                                if (files != null) {
                                                    String[] documents = files.split(",");
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
                                    <label for="claimer-signature" class="form-label">E-Signature</label>
                                    <div class="input-with-button">
                                      <input type="text" name="field-signature" id="signature-field" placeholder="Upload Signature" readonly>
                                      <button type="button" class="upload-btn" id="open-signature-modal-btn"><i class="fa-solid fa-pen-to-square"></i></button>
                                      <i class="fas fa-check-circle success-icon" id="signature-check-icon"></i>
                                    </div>                                
                                </div>
                                <div class="input-fields">
                                    <label for="claimer-photo" class="form-label">Self-Captured Photo</label>
                                    <div class="input-with-button">
                                        <input type="file" name="field-photo" id="photo-field" accept="image/*">
                                        <input type="text" id="photo-filename" placeholder="Upload Photo" readonly onclick="viewCapturedImage()">
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
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>--%>
