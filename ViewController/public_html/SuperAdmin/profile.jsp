<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/profile.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <%  
        request.setAttribute("activePage", "profile");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">PROFILE</h1>
            <div class="profile-box">
                <div class="profile-pic">
                    <label for="profile-pic-toggle">
                        <!-- Display the user's profile picture dynamically -->
                        <img src="<%= (userPicture != null ? userPicture : "../resources/images/tigersign.png") %>" alt="Profile Picture" id="profile-pic-img">
                        <div class="camera-icon">
                            <i class="bi bi-camera-fill"></i>
                        </div>
                    </label>
                    <div class="profile-pic-popup" id="profile-pic-popup">
                        <a href="#"><i class="bi bi-person-square"></i>See Profile Picture</a>
                        <a href="#"><i class="bi bi-images"></i>Choose Profile Picture</a>
                    </div>
                </div>
                <div class="profile-name">
                    <div class="name-line">
                        <!-- Display the user's first and last names dynamically -->
                        <h3><%= userFirstName %> <%= userLastName %></h3>
                        <span>ACTIVE</span>
                    </div>
                    <p>Super Admin</p>
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
                                <p><%= userFirstName %></p>
                            </div>
                            <div>
                                <label>Last Name</label>
                                <p><%= userLastName %></p>
                            </div>
                        </div>
                        <div class="email">
                            <div>
                                <label>Email</label>
                                <p><%= userEmail %></p>
                            </div>
                        </div>
                    </div>
                    <div style="text-align: center;">
                        <button class="edit-btn">Edit<i class="bi bi-pencil-square"></i></button>
                    </div>
                </div>
            </div>           
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
