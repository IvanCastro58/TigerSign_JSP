<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.SurveyDAO" %>
<%@ page import="com.tigersign.dao.Survey" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Customer Feedback - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/table.css ">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/reports.css ">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>

    <div class="main-content">
        <div class="margin-content">  
            <div class="title-section">
                <h2 class="title-page">All Customer Feedback</h2>
                <button class="back-btn" onclick="window.location.href='reports_survey.jsp';">Back</button>
            </div>
            <div class="pagination">
                <ul class="pagination-list"></ul>
            </div>
            <div class="feedback-container">
                <% 
                    SurveyDAO surveyDAO = new SurveyDAO();
                    
                    String filterType = request.getParameter("filterType");
                    String filterValue = request.getParameter("filterValue");
                    List<Survey> feedbacks = surveyDAO.getAllSurveys(filterType, filterValue); 
                    DateTimeFormatter feedbackFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                    
                    for (Survey survey : feedbacks) { 
                        String feedback = survey.getFeedback(); 
                        String dateString = survey.getDate(); 
                        int rating = survey.getRating(); 
                        
                        if (feedback != null && dateString != null) {
                            LocalDateTime feedbackDate = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); 
                            String formattedFeedbackDate = feedbackDate.format(feedbackFormatter);
                    
                            StringBuilder starRating = new StringBuilder();
                            for (int i = 1; i <= 5; i++) { // Change to 5 stars
                                if (i <= rating) {
                                    starRating.append("<i class='fa-solid fa-star'></i>"); 
                                } else {
                                    starRating.append("<i class='fa-regular fa-star'></i>"); 
                                }
                            }
                %>
                <div class="feedback-item">
                    <div class="feedback-header">
                        <strong class="feedback-name"><%= survey.getMaskedName() %></strong> 
                        <em class="feedback-date"><%= formattedFeedbackDate %></em> 
                    </div>
                    <div class="star-rating">
                        <%= starRating.toString() %> <span>(<%= rating %>)</span>
                    </div>
                    <div class="feedback-text"><%= feedback %></div>
                </div>
                <% 
                        } 
                    } 
                %>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const feedbackItems = document.querySelectorAll(".feedback-item");
            const itemsPerPage = 10; 
            const totalPages = Math.ceil(feedbackItems.length / itemsPerPage);
            let currentPage = 1;
        
            function showPage(page) {
                currentPage = page;
                const start = (page - 1) * itemsPerPage;
                const end = start + itemsPerPage;
        
                feedbackItems.forEach((item, index) => {
                    item.style.display = (index >= start && index < end) ? "block" : "none";
                });
        
                updatePagination();
            }
        
            function addPaginationLink(page, text = page, isActive = false) {
                const paginationItem = document.createElement("li");
                paginationItem.className = "pagination-item";
        
                const paginationLink = document.createElement("a");
                paginationLink.className = "pagination-link";
                paginationLink.href = "#";
                paginationLink.textContent = text;
        
                if (page !== null) {
                    paginationLink.dataset.page = page;
                    paginationLink.addEventListener("click", function (e) {
                        e.preventDefault();
                        showPage(page);
                    });
                } else {
                    paginationLink.classList.add("disabled");
                }
        
                if (isActive) {
                    paginationLink.classList.add("active");
                }
        
                paginationItem.appendChild(paginationLink);
                document.querySelector(".pagination-list").appendChild(paginationItem);
            }
        
            function updatePagination() {
                const paginationContainer = document.querySelector(".pagination-list");
                paginationContainer.innerHTML = "";
        
                if (currentPage > 1) {
                    addPaginationLink(currentPage - 1, "Prev");
                }
        
                if (currentPage > 3) {
                    addPaginationLink(1);
                    addPaginationLink(null, "...");
                }
        
                for (let i = Math.max(1, currentPage - 1); i <= Math.min(totalPages, currentPage + 1); i++) {
                    addPaginationLink(i, i, i === currentPage);
                }
        
                if (currentPage < totalPages - 2) {
                    addPaginationLink(null, "...");
                    addPaginationLink(totalPages);
                }
        
                if (currentPage < totalPages) {
                    addPaginationLink(currentPage + 1, "Next");
                }
            }
        
            showPage(currentPage);
        });
    </script>
</body>
</html>
