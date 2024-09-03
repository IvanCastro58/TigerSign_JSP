<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Admin Header Component -->
<header>
    <label for="menu-toggle" class="menu">
        <span>&#9776;</span>
    </label>
    <div class="logo">
        <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
    </div>
    <div class="profile" id="profile">
        <input type="checkbox" id="profile-toggle" style="display: none;">
        <label for="profile-toggle">
            <img src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="Profile Picture">
        </label>
        <div class="profile-popup" id="profile-popup">
            <a href="${pageContext.request.contextPath}/Admin/profile.jsp"><i class="bi bi-person-circle"></i> View Profile</a>
            <a href="${pageContext.request.contextPath}/signout"><i class="bi bi-box-arrow-right" style="color: #DB3444;"></i> Sign Out</a>
        </div>
    </div>
</header>
