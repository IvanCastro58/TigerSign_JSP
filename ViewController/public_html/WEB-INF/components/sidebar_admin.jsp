<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Admin Sidebar Component -->
<div class="sidebar">
    <ul class="menu">
        <div class="tiger-logo">
            <img src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="TigerSign Logo">
        </div>
        <div class="horizontal-line"></div>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/dashboard.jsp" class="${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid"></i>
                <span>Dashboard</span>
                <span class="tooltip">Dashboard</span>
            </a>
        </li>
        <li class="profile">
            <a href="${pageContext.request.contextPath}/Admin/profile.jsp" class="${activePage == 'profile' ? 'active' : ''}">
                <i class="bi bi-person-circle"></i>
                <span>Profile</span>
                <span class="tooltip">Profile</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/pending_claim.jsp" class="${activePage == 'pending_claim' ? 'active' : ''}">
                <i class="bi bi-clock-history"></i>
                <span>Pending Claims</span>
                <span class="tooltip">Pending Claims</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/claimed_request.jsp" class="${activePage == 'claimed_request' ? 'active' : ''}">
                <i class="bi bi-check-circle-fill"></i>
                <span>Claimed Request</span>
                <span class="tooltip">Claimed Request</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/Admin/evaluation.jsp" class="${activePage == 'evaluation' ? 'active' : ''}">
                <i class="bi bi-star-fill"></i>
                <span>Evaluation</span>
                <span class="tooltip">Evaluation</span>
            </a>
        </li>
    </ul>
</div>
