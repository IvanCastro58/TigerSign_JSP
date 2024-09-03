<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/dashboard.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <input type="checkbox" id="menu-toggle" hidden>
    
    <% 
        request.setAttribute("activePage", "dashboard");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="highlight-bar"><span>Sunday,&nbsp; September&nbsp; 16,&nbsp; 2023</span></div>
        <div class="margin-content">
            <h1>Welcome back, Bossing!</h1>
            <div class="highlight-bar1"></div>
            <h2>Overview</h2>
            <div class="card-view">
                <div class="card" id="pending-card">
                    <h3 class="card-heading">Pending Requests</h3>
                    <div class="card-number">10</div>
                </div>
                <div class="card" id="processing-card">
                    <h3 class="card-heading">Processing Requests</h3>
                    <div class="card-number">15</div>
                </div>
                <div class="card" id="available-card">
                    <h3 class="card-heading">Available Requests</h3>
                    <div class="card-number">20</div>
                </div>
                <div class="card" id="completed-card">
                    <h3 class="card-heading">Completed Requests</h3>
                    <div class="card-number">30</div>
                    <a href="./claimed_request.jsp" class="see-more">See More</a>
                </div>
            </div>
            <div class="reports">
                <div class="highlight-bar1"></div>
                <h2>Latest Reports</h2>
                <div class="latest-reports">
                    <div class="report-column left">
                        <div class="heading-container">
                            <h3>Longstanding Pending Requests</h3>
                            <button class="btn-see-more" onclick="window.location.href='pending_claim.jsp';">See More</button>
                        </div>
                        <div class="table-container">
                            <div class="scrollable-table">
                                <table class="transaction-table" id="pending-request">
                                    <thead>
                                        <tr>               
                                            <th>
                                                O.R Number
                                            </th>
                                            <th>
                                                Date of Payment
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="clickable-row">
                                            <td>#123456789</td>                       
                                            <td>10 Aug 2024</td>
                                        </tr>
                                        <tr class="clickable-row">
                                            <td>#123456789</td>                       
                                            <td>10 Aug 2024</td>
                                        </tr>
                                        <tr class="clickable-row">
                                            <td>#123456789</td>                       
                                            <td>10 Aug 2024</td>
                                        </tr>
                                        <tr class="clickable-row">
                                            <td>#123456789</td>                       
                                            <td>10 Aug 2024</td>
                                        </tr>
                                        <tr class="clickable-row">
                                            <td>#123456789</td>                       
                                            <td>10 Aug 2024</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="report-column right">
                        <div class="heading-container">
                            <h3>Total Completed Transactions</h3>
                            <button class="btn-see-more" onclick="window.location.href='reports.jsp';">See More</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
