<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, com.tigersign.dao.DatabaseConnection" %>
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
    <style>
        .transaction-table th, .transaction-table td{
            padding: 15px;
        }
    </style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        request.setAttribute("activePage", "reports");  

        LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Manila"));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
        String formattedDate = now.format(formatter);
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        int pendingCount = 0;
        int processingCount = 0;
        int availableCount = 0;
        int claimedCount = 0;
        List<String> documentTypes = new ArrayList<>();
        List<Integer> documentCounts = new ArrayList<>();

        try {
            // Get connection from the DatabaseConnection class
            conn = DatabaseConnection.getConnection();
    
            // Existing queries for counts...
            String pendingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PENDING'";
            stmt = conn.prepareStatement(pendingQuery);
            rs = stmt.executeQuery();
            if (rs.next()) {
                pendingCount = rs.getInt(1);
            }

            String processingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PROCESSING'";
            stmt = conn.prepareStatement(processingQuery);
            rs = stmt.executeQuery();
            if (rs.next()) {
                processingCount = rs.getInt(1);
            }

            String availableQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'AVAILABLE'";
            stmt = conn.prepareStatement(availableQuery);
            rs = stmt.executeQuery();
            if (rs.next()) {
                availableCount = rs.getInt(1);
            }

            String claimedQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE IS_CLAIMED = 'Y'";
            stmt = conn.prepareStatement(claimedQuery);
            rs = stmt.executeQuery();
            if (rs.next()) {
                claimedCount = rs.getInt(1);
            }

            // New query to get most claimed documents
            String mostClaimedQuery = "SELECT REQUEST_DESCRIPTION, COUNT(*) AS total FROM TS_REQUEST WHERE FILE_STATUS = 'CLAIMED' GROUP BY REQUEST_DESCRIPTION ORDER BY total DESC";
            stmt = conn.prepareStatement(mostClaimedQuery);
            rs = stmt.executeQuery();
            while (rs.next()) {
                documentTypes.add(rs.getString("REQUEST_DESCRIPTION"));
                documentCounts.add(rs.getInt("total"));
            }
        
        } catch (SQLException e) {
            e.printStackTrace(); // Handle the SQL exception
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="highlight-bar"><span><%= formattedDate %></span></div>
        <div class="margin-content">
            <h2 class="title-page">REPORTS AND ANALYTICS</h2>
            <div class="nav-buttons">
                <div class="status-btn">
                    <button class="reports-btn current-page-btn">Document Status Report</button>
                </div>
                <div class="survey-btn">
                    <button class="reports-btn" onclick="window.location.href='reports_survey.jsp';">Evaluation Analytics</button>
                </div>
                <div class="filter-btn">
                    <button class="filters-btn">Filter <i class="fa-solid fa-filter"></i></button>
                </div>
            </div>
            <div class="highlight-bar2"></div>
            <div class="card-view">
                <div class="card" id="pending-card-reports">
                    <h3 class="card-heading">Pending Requests</h3>
                    <div class="card-number"><%= pendingCount %></div>
                </div>
                <div class="card" id="processing-card-reports">
                    <h3 class="card-heading">Processing Request</h3>
                    <div class="card-number"><%= processingCount %></div>
                </div>
                <div class="card" id="available-card-reports">
                    <h3 class="card-heading">Available Request</h3>
                    <div class="card-number"><%= availableCount %></div>
                </div>
                <div class="card" id="claimed-card-reports">
                    <h3 class="card-heading">Claimed Request</h3>
                    <div class="card-number"><%= claimedCount %></div>
                </div>
            </div>
            <div class="reports">
                <div class="highlight-bar2"></div>
                <div class="latest-reports">
                    <div class="report-column left">
                        <div class="heading-container">
                            <h3></h3>
                        </div>
                    </div>
                    <div class="report-column right">
                        <div class="heading-container">
                            <h3>Most Claimed Documents</h3>
                        </div>
                        <div class="table-container">
                            <div class="scrollable-table">
                                <table class="transaction-table" id="reports-dashboard">
                                    <thead>
                                        <tr>               
                                           <th>Document Type</th>
                                           <th>Total Release
                                               <span class="sort-icons">
                                                   <i class="fa-solid fa-caret-up"></i>
                                                   <i class="fa-solid fa-caret-down"></i>
                                               </span>
                                           </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            // Loop through the document types and their counts to display in the table
                                            for (int i = 0; i < documentTypes.size(); i++) {
                                        %>
                                        <tr>
                                            <td><%= documentTypes.get(i) %></td>
                                            <td><%= documentCounts.get(i) %></td>
                                        </tr>
                                        <% 
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
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
