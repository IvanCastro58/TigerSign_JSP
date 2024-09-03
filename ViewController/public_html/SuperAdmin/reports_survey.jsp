<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reports & Analytics - TigerSign</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="../resources/css/sidebar.css">
        <link rel="stylesheet" href="../resources/css/dashboard.css">
        <link rel="stylesheet" href="../resources/css/table.css ">
        <link rel="stylesheet" href="../resources/css/reports.css ">
        <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
    
        <% 
            request.setAttribute("activePage", "reports");  
        %>
        
        <%@ include file="/WEB-INF/components/header.jsp" %>
        <%@ include file="/WEB-INF/components/sidebar.jsp" %>
        
        <div class="main-content">
        <div class="highlight-bar"><span>Sunday,&nbsp; September&nbsp; 16,&nbsp; 2023</span></div>
        <div class="margin-content">
            <h1 class="title-page">REPORTS AND ANALYTICS</h1>
            <div class="nav-buttons">
                <div class="status-btn">
                    <button class="reports-btn" onclick="window.location.href='reports.jsp';">Document Status Report</button>
                </div>
                <div class="survey-btn">
                    <button class="reports-btn current-page-btn">Evaluation Analytics</button>
                </div>
                <div class="filter-btn">
                    <button class="filters-btn">Filter <i class="fa-solid fa-filter"></i></button>
                </div>
            </div>
            <div class="highlight-bar2"></div>
            <div class="card-view">
                <div class="card" id="overall-score">
                    <h3 class="card-heading">Average Overall Score</h3>
                    <div class="card-number">3.8</div>
                </div>
                <div class="card" id="eval-sent">
                    <h3 class="card-heading">Evaluation Sent</h3>
                    <div class="card-number">15</div>
                </div>
                <div class="card" id="eval-received">
                    <h3 class="card-heading">Evaluation Received</h3>
                    <div class="card-number">20</div>
                </div>
            </div>
            <div class="reports">
                <div class="highlight-bar2"></div>
                <div class="latest-reports">
                    <div class="report-column left">
                        <div class="heading-container">
                            <h3>User Preference for Outstanding Services</h3>
                        </div>
                    </div>
                    <div class="report-column right">
                        <div class="heading-container">
                            <h3>Service Window Performance Score</h3>
                        </div>
                        <div class="table-container">
                            <div class="scrollable-table">
                                <table class="transaction-table" id="reports-dashboard">
                                    <thead>
                                        <tr>               
                                           <th>
                                                Service Window
                                            </th>
                                            <th>
                                                Score
                                                <span class="sort-icons">
                                                    <i class="fa-solid fa-caret-up"></i>
                                                    <i class="fa-solid fa-caret-down"></i>
                                                </span>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Window J (Enrollment Concerns)</td>                       
                                            <td>3.7</td>
                                        </tr>
                                        <tr>
                                            <td>Window L (Diploma, Certified True Copy)</td>                       
                                            <td>3.6</td>
                                        </tr>
                                      
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="comments-section">
                        <div class="heading-container">
                            <h3>Customer Feedback</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="generate-buttons">
                <div class="generate-btn">
                    <button class="gen-btn">Generate & Export Report <i class="fa-solid fa-file-export"></i></button>
                </div>
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    
     <%@ include file="/WEB-INF/components/script.jsp" %>     
    </body>
</html>