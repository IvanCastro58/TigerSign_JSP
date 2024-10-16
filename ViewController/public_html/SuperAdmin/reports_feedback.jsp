<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.SurveyDAO" %>
<%@ page import="com.tigersign.dao.Survey" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.util.stream.IntStream" %>

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
            
            <!-- Pagination Controls -->
            <div class="pagination">
                <ul class="pagination-list">
                    <% 
                        SurveyDAO surveyDAO = new SurveyDAO();
                        int pageSize = 10; // Number of feedbacks per page
                        int currentPage = 1; // Default current page
                        String pageParam = request.getParameter("page");
                        
                        if (pageParam != null) {
                            currentPage = Integer.parseInt(pageParam);
                        }
                
                        int totalFeedbacks = surveyDAO.getTotalCount();
                        int totalPages = (int) Math.ceil((double) totalFeedbacks / pageSize);
                        
                        // Display "Previous" button
                        if (currentPage > 1) {
                    %>
                            <li class="pagination-item">
                                <a href="?page=<%= currentPage - 1 %>" class="pagination-link">Prev</a>
                            </li>
                    <%
                        }
                        
                        // Display page numbers
                        int startPage = Math.max(1, currentPage - 1); // Start from the current page - 1
                        int endPage = Math.min(totalPages, currentPage + 1); // End at current page + 1
                        
                        if (startPage > 1) {
                    %>
                            <li class="pagination-item">
                                <a href="?page=1" class="pagination-link">1</a>
                            </li>
                    <%
                            if (startPage > 2) {
                    %>
                                <li class="pagination-item"><span>...</span></li>
                    <%
                            }
                        }
                        
                        for (int i = startPage; i <= endPage; i++) {
                            if (i == currentPage) {
                    %>
                                <li class="pagination-item">
                                    <span class="pagination-link active"><%= i %></span>
                                </li>
                    <%
                            } else {
                    %>
                                <li class="pagination-item">
                                    <a href="?page=<%= i %>" class="pagination-link"><%= i %></a>
                                </li>
                    <%
                            }
                        }
                        
                        if (endPage < totalPages) {
                            if (endPage < totalPages - 1) {
                    %>
                                <li class="pagination-item"><span>...</span></li>
                    <%
                            }
                    %>
                            <li class="pagination-item">
                                <a href="?page=<%= totalPages %>" class="pagination-link"><%= totalPages %></a>
                            </li>
                    <%
                        }
                
                        if (currentPage < totalPages) {
                    %>
                            <li class="pagination-item">
                                <a href="?page=<%= currentPage + 1 %>" class="pagination-link">Next</a>
                            </li>
                    <%
                        }
                    %>
                </ul>
            </div>

            <div class="feedback-container">
                <% 
                    List<Survey> feedbacks = surveyDAO.getPaginatedSurveys(currentPage, pageSize); 
                    DateTimeFormatter feedbackFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                    
                    for (Survey survey : feedbacks) { 
                        String feedback = survey.getFeedback(); 
                        String dateString = survey.getDate(); 
                        int rating = survey.getRating(); 
                        
                        LocalDateTime feedbackDate = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); 
                        String formattedFeedbackDate = feedbackDate.format(feedbackFormatter);
                    
                        StringBuilder starRating = new StringBuilder();
                        for (int i = 1; i <= 4; i++) {
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
                %>
            </div>
        </div>
    </div>
</body>
</html>
