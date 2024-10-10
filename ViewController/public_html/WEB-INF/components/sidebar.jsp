<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Super Admin Sidebar Component -->
<input type="checkbox" id="menu-toggle" hidden>
<div class="sidebar">
    <ul class="menu">
        <div class="tiger-logo">
            <img src="${pageContext.request.contextPath}/resources/images/tigersign.png" alt="TigerSign Logo">
        </div>
        <div class="horizontal-line"></div>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/dashboard.jsp" class="<%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-grid"></i>
                <span>Dashboard</span>
                <span class="tooltip">Dashboard</span>
            </a>
        </li>
        <li class="profile">
            <a href="${pageContext.request.contextPath}/SuperAdmin/profile.jsp" class="<%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-person-circle"></i>
                <span>Profile</span>
                <span class="tooltip">Profile</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/pending_claim.jsp" class="<%= "pending_claim".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-clock-fill"></i>
                <span>Pending Claims</span>
                <span class="tooltip">Pending Claims</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/claimed_request.jsp" class="<%= "claimed_request".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-check-circle"></i>
                <span>Claimed Request</span>
                <span class="tooltip">Claimed Request</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/manage_account.jsp" class="<%= "manage_account".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="fas fa-users"></i>
                <span>Manage Accounts</span>
                <span class="tooltip">Manage Accounts</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/audit_logs.jsp" class="<%= "audit_logs".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-journals"></i>
                <span>Audit Logs</span>
                <span class="tooltip">Audit Logs</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/evaluation.jsp" class="<%= "evaluation".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-star-fill"></i>
                <span>Evaluation</span>
                <span class="tooltip">Evaluation</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/SuperAdmin/reports.jsp" class="<%= "reports".equals(request.getAttribute("activePage")) ? "active" : "" %>">
                <i class="bi bi-bar-chart-line"></i>
                <span>Reports</span>
                <span class="tooltip">Reports</span>
            </a>
        </li>
    </ul>
</div>
