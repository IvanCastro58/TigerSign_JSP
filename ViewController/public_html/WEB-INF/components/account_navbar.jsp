<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Manage Account Navigation Bar -->
<div class="account-navbar">
    <a href="${pageContext.request.contextPath}/SuperAdmin/manage_account.jsp" class="nav-link <%= "manage_account".equals(request.getAttribute("activeNav")) ? "active" : "" %>">All</a>
    <a href="${pageContext.request.contextPath}/SuperAdmin/manage_active.jsp" class="nav-link <%= "manage_active".equals(request.getAttribute("activeNav")) ? "active" : "" %>">Active</a>
    <a href="${pageContext.request.contextPath}/SuperAdmin/manage_deactivated.jsp" class="nav-link <%= "manage_deactivated".equals(request.getAttribute("activeNav")) ? "active" : "" %>">Deactivated</a>
</div>

<div class="button-div">
    <button class="add-user-btn"><i class="bi bi-person-plus"></i>Create User</button>
    <div class="search-container">
        <input type="text" id="search-input" class="search-input" placeholder="Search...">
    </div>
</div>


