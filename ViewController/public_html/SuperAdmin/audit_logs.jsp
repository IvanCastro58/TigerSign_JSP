<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.List" %>
<%@ page import="com.tigersign.dao.AuditLog" %>
<%@ page import="com.tigersign.dao.AuditLogDAO" %>
<%
    List<AuditLog> auditList = null;

    try {
        AuditLogDAO auditDAO = new AuditLogDAO();
        auditList = auditDAO.getAllAudits();
    } catch (Exception e) {
        e.printStackTrace(); 
    }
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Logs - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="stylesheet" href="../resources/css/pendingclaim.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<style>
    .transaction-table th, .transaction-table td{
        padding: 15px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "audit_logs");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">AUDIT LOGS</h2>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="audit_logs">
                        <thead>
                        <tr>
                            <th>PICTURE</th>
                            <th>NAME</th>
                            <th>ADMIN ID</th>
                            <th>POSITION</th>
                            <th>ACTIVITY</th>
                            <th>DATE</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (auditList != null) {
                                for (AuditLog audit : auditList) {
                        %>
                            <tr>
                                <td>
                                    <%
                                        String picture = audit.getPicture();
                                        String defaultPicture = request.getContextPath() + "/resources/images/default-profile.jpg";
                                    %>
                                    <img src="<%= picture != null ? picture : defaultPicture %>" alt="Admin Picture" style="border-radius: 50%;" width="40" height="40"/>
                                </td>
                                <td><%= audit.getFirstName() + " " + audit.getLastName() %></td>
                                <td><%= audit.getAdminId() %></td>
                                <td><%= audit.getPosition() %></td>
                                <td><%= audit.getActivity() %></td>
                                <td><%= audit.getActivityDateTime() %></td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    </table>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
