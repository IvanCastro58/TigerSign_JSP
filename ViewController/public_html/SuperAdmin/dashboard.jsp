<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.sql.*, com.tigersign.dao.DatabaseConnection" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/dashboard.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "dashboard");  
    %>
    <%
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

            try {
                // Get connection from the DatabaseConnection class
                conn = DatabaseConnection.getConnection();
        
                // Query for Pending Requests
                String pendingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PENDING'";
                stmt = conn.prepareStatement(pendingQuery);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    pendingCount = rs.getInt(1);
                }
        
                // Query for Processing Requests
                String processingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PROCESSING'";
                stmt = conn.prepareStatement(processingQuery);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    processingCount = rs.getInt(1);
                }
        
                // Query for Available Requests
                String availableQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'AVAILABLE'";
                stmt = conn.prepareStatement(availableQuery);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    availableCount = rs.getInt(1);
                }
        
                // Query for Claimed Requests
                String claimedQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE IS_CLAIMED = 'Y'";
                stmt = conn.prepareStatement(claimedQuery);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    claimedCount = rs.getInt(1);
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
    
    <div class="main-content dashboard-main-content">
        <div class="highlight-bar"><span><%= formattedDate %></span></div>
        <div class="margin-content">
            <!-- Display the user's first name dynamically -->
            <h1>Welcome back, <%= userFirstName %>!</h1>

            <div class="highlight-bar1"></div>

            <div class="search">
                <div class="search-box">
                    <h2>Search for Pending Claims</h2>
                    <div class="search-container">
                        <input type="text" class="search-input" placeholder="Enter Name or O.R Number">
                        <button class="search-button">Search <i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                </div>
            </div>
            <h2>Overview</h2>
            <div class="card-view">
                <div class="card" id="pending-card">
                    <h3 class="card-heading">Pending Requests</h3>
                    <div class="card-number"><%= pendingCount %></div>
                </div>
                <div class="card" id="processing-card">
                    <h3 class="card-heading">Processing Requests</h3>
                     <div class="card-number"><%= processingCount %></div>
                </div>
                <div class="card" id="available-card">
                    <h3 class="card-heading">Available Requests</h3>
                   <div class="card-number"><%= availableCount %></div>
                </div>
                <div class="card" id="completed-card">
                    <h3 class="card-heading">Claimed Requests</h3>
                    <div class="card-number"><%= claimedCount %></div>
                    <a href="./claimed_request.jsp" class="see-more">See More <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
