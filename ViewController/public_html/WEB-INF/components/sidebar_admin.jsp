<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Admin Sidebar Component -->
<input type="checkbox" id="menu-toggle" hidden>
<div class="sidebar">
    <ul class="menu">
        <div class="tiger-logo">
            <img src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="TigerSign Logo">
        </div>
        <div class="horizontal-line"></div>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/dashboard.jsp" class="<%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-grid"></i>
                <span>Dashboard</span>
                <span class="tooltip">Dashboard</span>
            </a>
        </li>
        <li class="profile">
            <a href="${pageContext.request.contextPath}/Admin/profile.jsp" class="<%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-person-circle"></i>
                <span>Profile</span>
                <span class="tooltip">Profile</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/pending_claim.jsp" class="<%= "pending_claim".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-clock-fill"></i>
                <span>Paid Applications</span>
                <span class="tooltip">Paid Applications</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/claimed_request.jsp" class="<%= "claimed_request".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-check-circle"></i>
                <span>Claimed Request</span>
                <span class="tooltip">Claimed Request</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/evaluation.jsp" class="<%= "evaluation".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-star-fill"></i>
                <span>Evaluation</span>
                <span class="tooltip">Evaluation</span>
            </a>
        </li>
    </ul>
</div>
