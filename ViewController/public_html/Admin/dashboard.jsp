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
    <title>Admin Dashboard - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/dashboard.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
   <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    <% 
        request.setAttribute("activePage", "dashboard");  
        LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Manila"));
            
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
        String formattedDate = now.format(formatter);
        
         Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
        
            int pendingCount = 0;
            int processingCount = 0;
            int holdCount = 0;
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
                String holdQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'HOLD'";
                stmt = conn.prepareStatement(holdQuery);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    holdCount = rs.getInt(1);
                }
        
                // Query for Claimed Requests
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
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
     <div class="main-content dashboard-main-content">
        <div class="highlight-bar"><span><%= formattedDate %></span></div>
        <div class="margin-content">
            <!-- Display the user's first name dynamically -->
            <h1>Welcome back, <%= adminFirstName %>!</h1>

            <div class="highlight-bar1"></div>

            <div class="search">
                <div class="search-box">
                    <h2>Search for Paid Applications</h2>
                    <div class="search-container">
                        <input type="text" id="dashboard-search-input" class="search-input" placeholder="Search...">
                        <button id="search-button" class="search-button">Search <i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                </div>
            </div>
            <h2>Overview</h2>
            <div class="card-view">
                <div class="card" id="pending-card">
                    <h3 class="card-heading">Paid Applications</h3>
                    <div class="card-number"><%= pendingCount %></div>
                </div>
                <div class="card" id="processing-card">
                    <h3 class="card-heading">Processing Requests</h3>
                     <div class="card-number"><%= processingCount %></div>
                </div>
                <div class="card" id="available-card">
                    <h3 class="card-heading">On Hold Requests</h3>
                   <div class="card-number"><%= holdCount %></div>
                </div>
                <div class="card" id="completed-card">
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
    <script>
    document.getElementById("search-button").addEventListener("click", function() {
        const searchTerm = document.getElementById("dashboard-search-input").value.trim();
    
        // Set search term in localStorage and redirect to the pending claims page
        if (searchTerm) {
            localStorage.setItem("pendingClaimsSearchTerm", searchTerm);
        } else {
            localStorage.removeItem("pendingClaimsSearchTerm"); // Clear if empty
        }
        window.location.href = '<%= request.getContextPath() %>/Admin/pending_claim.jsp'; // Redirect to pending claims
    });

    // Function to format numbers
    function formatNumber(num) {
        if (num >= 1000 && num <= 9999) {
            return (num / 1000).toFixed(1) + "K+";
        } else if (num >= 10000 && num <= 99999) {
            return (num / 1000).toFixed(1) + "K+";
        }
        return num; // Return the original number for values outside the range
    }

    // Apply formatting to the card numbers
    document.addEventListener("DOMContentLoaded", function() {
        // Get all card number elements
        const cardNumbers = document.querySelectorAll(".card-number");

        // Format and update each card number
        cardNumbers.forEach(card => {
            const number = parseInt(card.textContent.trim(), 10); // Parse the number
            card.textContent = formatNumber(number); // Update with formatted value
        });
    });
    const searchInput = document.getElementById('dashboard-search-input');
    const searchButton = document.getElementById('search-button');

    // Add an event listener for the "keydown" event
    searchInput.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') { // Check if the key pressed is "Enter"
            searchButton.click(); // Trigger the search button's click event
        }
    });

    // Example: Click event for the search button
    searchButton.addEventListener('click', function () {
        const query = searchInput.value.trim();
        if (query) {
            console.log(`Searching for: ${query}`); // Replace this with your actual search logic
        } else {
            console.log('Please enter a search query');
        }
    });
</script>

    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
