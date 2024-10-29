<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.SurveyDAO" %>
<%@ page import="com.tigersign.dao.Survey" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap, java.util.Map" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneId" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/table.css ">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/reports.css ">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
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
        SurveyDAO surveyDAO = new SurveyDAO();

        // Fetching data
        double averageScore = surveyDAO.getAverageScore();
        int evaluationsSent = surveyDAO.getEvaluationSentCount();
        int evaluationsReceived = surveyDAO.getEvaluationReceivedCount();
        List<Survey> serviceScores = surveyDAO.getServiceWindowScores();
    %>
    
    <% 
        Map<String, String> serviceMap = new HashMap<>();
        serviceMap.put("IW", "Information Window");
        serviceMap.put("WA", "Window A (Foreign Students)");
        serviceMap.put("WB", "Window B (Faculty of Civil Law, Faculty of Medicine and Surgery, Institute of Physical Education and Athletics)");
        serviceMap.put("WC", "Window C (College of Commerce and College of Science)");
        serviceMap.put("WD", "Window D (College of Tourism and Hospitality Management, College of Fine Arts and Design)");
        serviceMap.put("WE", "Window E (College of Nursing, College of Education, Conservatory of Music)");
        serviceMap.put("WF", "Window F (Faculty of Pharmacy, Graduate School, Graduate School of Law)");
        serviceMap.put("WG", "Window G (Faculty of Arts and Letters, College of Rehabilitation Science)");
        serviceMap.put("WH", "Window H (College of Architecture, AMV-College of Accountancy)");
        serviceMap.put("WI", "Window I (Faculty of Engineering, College of Information and Computing Sciences)");
        serviceMap.put("WJ", "Window J (Enrollment Related Concerns, Cross Enrollment)");
        serviceMap.put("WK", "Window K (Honorable Dismissal, Transfer Credential)");
        serviceMap.put("WL", "Window L (Diploma, Certified True Copy)");
        serviceMap.put("WM", "Window M (CAV-DFA Apostille, Endorsement)");
        serviceMap.put("other", "Other");
    %>
    
    <%
        LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Manila"));
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
        String formattedDate = now.format(formatter);
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="highlight-bar"><span><%= formattedDate %></span></div>
        <div class="margin-content">
            <h2 class="title-page">REPORTS AND ANALYTICS</h2>
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
                    <div class="card-number"><%= String.format("%.1f", averageScore) %></div>
                </div>
                <div class="card" id="eval-received">
                    <h3 class="card-heading">Evaluation Received</h3>
                    <div class="card-number"><%= evaluationsReceived %></div>
                </div>
            </div>
            <div class="reports">
                <div class="highlight-bar2"></div>
                <div class="latest-reports">
                    <div class="report-column left">
                        <div class="heading-container">
                            <h3>User Preference for Outstanding Services</h3>
                        </div>
                        <div class="canvas-container">
                            <canvas id="standoutPieChart" class="responsive-canvas"></canvas>
                        </div>
                    </div>
                    <div class="highlight-bar2"></div>
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
                                                Evaluations
                                                <span class="sort-icons">
                                                    <i class="fa-solid fa-caret-up"></i>
                                                    <i class="fa-solid fa-caret-down"></i>
                                                </span>
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
                                        <% for (Survey survey : serviceScores) { 
                                            String serviceValue = survey.getService(); 
                                            String serviceTitle = serviceMap.getOrDefault(serviceValue, "Other"); 
                                        %>
                                            <tr>
                                                <td><%= serviceTitle %></td>                       
                                                <td><%= survey.getEvaluationCount() %></td> 
                                                <td><%= survey.getRating() %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="highlight-bar2"></div>
                    <div class="comments-section">
                        <div class="heading-container">
                            <h3>Customer Feedback</h3>
                        </div>
                        <div class="feedback-container">
                            <% 
                                List<Survey> feedbacks = surveyDAO.getAllSurveys(); 
                                DateTimeFormatter feedbackFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                                int feedbackCount = 0; 
                                for (Survey survey : feedbacks) { 
                                    if (feedbackCount < 5) { 
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
                                    feedbackCount++; 
                                } 
                            %>
                        </div>
                        <div class="show-more-btn">
                            <button class="show-btn" onclick="window.location.href='reports_feedback.jsp';">
                                SHOW MORE <i class="bi bi-chevron-right"></i>
                            </button>
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
    
    <% 
        Map<String, Integer> standoutCounts = new HashMap<>();
        standoutCounts.put("Response Time", surveyDAO.getStandoutCount("response"));
        standoutCounts.put("Accuracy of Information", surveyDAO.getStandoutCount("accuracy"));
        standoutCounts.put("Helpful", surveyDAO.getStandoutCount("helpful"));
        standoutCounts.put("Respectful", surveyDAO.getStandoutCount("respect"));
        
        // Initialize total responses
        int totalResponses = surveyDAO.getTotalCount();
        
        // Count the "Other" category
        standoutCounts.put("Other", totalResponses 
            - (standoutCounts.get("Response Time") 
               + standoutCounts.get("Accuracy of Information") 
               + standoutCounts.get("Helpful") 
               + standoutCounts.get("Respectful")));
        
        StringBuilder standoutData = new StringBuilder("[");
        StringBuilder standoutLabels = new StringBuilder("[");
        
        for (Map.Entry<String, Integer> entry : standoutCounts.entrySet()) {
            standoutLabels.append("\"").append(entry.getKey()).append("\",");
            standoutData.append(entry.getValue()).append(",");
        }
        
        if (standoutLabels.length() > 1) {
            standoutLabels.setLength(standoutLabels.length() - 1);
            standoutData.setLength(standoutData.length() - 1);
        }
        standoutLabels.append("]");
        standoutData.append("]");
    %>
    <script>
    const ctx = document.getElementById('standoutPieChart').getContext('2d');
    const standoutDoughnutChart = new Chart(ctx, {
        type: 'doughnut', 
        data: {
            labels: <%= standoutLabels.toString() %>,
            datasets: [{
                label: 'Total Respondents',
                data: <%= standoutData.toString() %>,
                backgroundColor: [
                    '#d9534f',   
                    '#1C8454',   
                    '#3B83FB',   
                    '#F4BB00',   
                    '#1a1a1a'    
                ],
                borderColor: [
                    '#d9534f',
                    '#1C8454',
                    '#3B83FB',
                    '#F4BB00',
                    '#1a1a1a'
                ],
                hoverBackgroundColor: [
                    'rgba(217, 83, 79, 0.8)',
                    'rgba(28, 132, 84, 0.8)',
                    'rgba(59, 131, 251, 0.8)',
                    'rgba(244, 187, 0, 0.8)',
                    'rgba(26, 26, 26, 0.8)'
                ],
                hoverBorderColor: [
                    '#b03a32',
                    '#146b3a',
                    '#2b6bbf',
                    '#d89e00',
                    '#111111'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            cutout: '50%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 20,
                        padding: 20,
                        font: {
                            size: 12,
                            weight: '600',
                            family: 'Montserrat'
                        },
                        color: '#333333'
                    }
                },
                datalabels: {
                    formatter: (value, context) => {
                        if (value === 0) {
                            return null;
                        }
                        const total = context.chart.data.datasets[0].data.reduce((acc, val) => acc + val, 0);
                        const percentage = (value / total * 100).toFixed(1) + '%';
                        return percentage;
                    },
                    color: '#FFFFFF',
                    font: {
                        weight: 'bold',
                        size: 12
                    }
                }
            },
            layout: {
                padding: {
                    left: 10,
                    right: 20
                }
            }
        },
        plugins: [ChartDataLabels]
    });
</script>


    <%@ include file="/WEB-INF/components/script.jsp" %>  
</body>
</html>

