<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "audit_logs");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">AUDIT LOGS</h1>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="audit_logs">
                        <thead>
                            <tr>
                                <th class="date-processed-column">
                                    Date
                                    <span class="sort-icons">
                                        <i class="fa-solid fa-caret-up"></i>
                                        <i class="fa-solid fa-caret-down"></i>
                                    </span>
                                </th>
                                <th>
                                    Event
                                </th>
                                <th>
                                    User
                                    <span class="sort-user">
                                        <i class="bi bi-sort-alpha-down"></i>
                                        <i class="bi bi-sort-alpha-down-alt" style="display: none;"></i>
                                    </span>
                                </th>
                                <th>
                                    Role
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">User logged in</td>
                                <td class="expandable-text">Ivan Castro</td>
                                <td>Admin</td> 
                            </tr>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">Claimed Form #123456789</td>
                                <td class="expandable-text">Joshua Embestro</td>
                                <td>Admin</td> 
                            </tr>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">Claimed Form #123456789</td>
                                <td class="expandable-text">Jarred Reyes</td>
                                <td>Admin</td> 
                            </tr>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">User logged in</td>
                                <td class="expandable-text">Karl Barce</td>
                                <td>Admin</td> 
                            </tr>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">Claimed Form #123456789</td>
                                <td class="expandable-text">Jarred Reyes</td>
                                <td>Admin</td> 
                            </tr>
                            <tr>
                                <td class="date-processed-column">10 Aug 2024</td>
                                <td class="expandable-text">Claimed Form #123456789</td>
                                <td class="expandable-text">Joshua Embestro</td>
                                <td>Admin</td> 
                            </tr>
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
