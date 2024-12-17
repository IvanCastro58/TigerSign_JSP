<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.SurveyDAO" %>
<%@ page import="com.tigersign.dao.Survey" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap, java.util.Map" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>

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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/confetti.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    
</head>
<style>
    .transaction-table th, .transaction-table td{
        padding: 15px;
    }
    
    .sort-icons {
        font-size: 12px;
        display: inline-block;
        transform: scale(0.8);
        transition: opacity 0.3s ease, transform 0.3s ease;
    }
    
    .sort-icons.visible {
        opacity: 1;
        transform: scale(1);
    }
    
    .spin-up {
        animation: spin-up 0.3s linear forwards;
    }
    
    @keyframes spin-up {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(180deg); 
        }
    }
    
    .spin-down {
        animation: spin-down 0.3s linear forwards;
    }
    
    @keyframes spin-down {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(-180deg);
        }
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    
    <% 
        request.setAttribute("activePage", "reports");  
        SurveyDAO surveyDAO = new SurveyDAO();
    
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        
        double averageScore = surveyDAO.getAverageScore(filterType, filterValue);
        int evaluationsReceived = surveyDAO.getEvaluationReceivedCount(filterType, filterValue);
        List<Survey> serviceScores = surveyDAO.getServiceWindowScores(filterType, filterValue);
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
            <h2 class="title-page">REPORTS</h2>
            <div class="nav-buttons">
                <div class="status-btn">
                    <button class="reports-btn" onclick="window.location.href='reports.jsp';">Document Status</button>
                </div>
                <div class="survey-btn">
                    <button class="reports-btn current-page-btn">Survey/Evaluation</button>
                </div>
                <div class="filter-btn">
                    <button class="filters-btn"  onclick="openModal()">Filter <i class="fa-solid fa-filter"></i></button>
                </div>
                
                <div id="dateFilterModal" class="modal">
                    <div class="modal-content">
                        <div class="filter-box">
                            <!-- Date Inputs -->
                            <div id="todayInput" class="calendar-container" style="display: none;">
                                <div id="todayCalendar"></div>
                            </div>
                            <div id="monthInput" class="calendar-container" style="display: none;">
                                <div id="monthCalendar"></div>
                            </div>
                            <div id="yearInput" class="year-container" style="display: none;">
                                <select id="byYear">
                                    <!-- Year options will be dynamically populated -->
                                </select>
                            </div>
                            <div id="rangeInput" class="calendar-container" style="display: none;">
                                <div id="rangeCalendar"></div>
                            </div>
                            
                            <div class="filter">
                                <div class="select-container">
                                    <select id="dateFilterOption" onchange="displayDateInput()">
                                        <option value="" disabled>Select Filter Type</option>
                                        <option value="day">By Day</option>
                                        <option value="range">Date Range</option>
                                        <option value="month">By Month</option>
                                        <option value="year">By Year</option>
                                    </select>
                                </div>
                                
                                <div id="todaySelect" class="today-container" style="display: none;">
                                    <label for="dayCalendarInput">Select Date</label>
                                    <input type="date" id="dayCalendarInput" name="dayCalendarInput" readonly/>
                                </div>
                                
                                <div id="startInput" class="start-container" style="display: none;">
                                    <label for="rangeCalendarStart">Start Date</label>
                                    <input type="date" id="rangeCalendarStart" name="rangeCalendarStart" readonly>
                                </div>
                                
                                <div id="endInput" class="end-container" style="display: none;">
                                    <label for="rangeCalendarEnd">End Date</label>
                                    <input type="date" id="rangeCalendarEnd" name="rangeCalendarEnd" readonly>
                                </div>
                                
                                <div id="monthCalendarInputContainer" class="today-container" style="display: none;">
                                    <label for="monthCalendarInput">Select Month</label>
                                    <input type="text" id="monthCalendarInput" name="monthCalendarInput" readonly/>
                                </div>

                                
                                <div class="button-container">
                                    <button onclick="applyFilter()" class="apply-btn">Apply</button>
                                    <button onclick="resetModal()" class="cancel-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="highlight-bar2"></div>
            <div class="filter-summary" style="margin-bottom: 20px; text-align: left;">
                <% if (filterType != null && filterValue != null) { %>
                    <div class="filter-display">
                        <span>
                            <% 
                                String readableType = "";
                                String displayValue = "";
                                SimpleDateFormat inputFormat;
                                SimpleDateFormat outputFormat;
            
                                switch (filterType) {
                                    case "day":
                                        readableType = "By Day";
                                        inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                                        outputFormat = new SimpleDateFormat("dd MMM yyyy");
                                        try {
                                            displayValue = outputFormat.format(inputFormat.parse(filterValue));
                                        } catch (ParseException e) {
                                            displayValue = "Invalid Date";
                                        }
                                        break;
                                    case "month":
                                        readableType = "By Month";
                                        inputFormat = new SimpleDateFormat("yyyy-MM");
                                        outputFormat = new SimpleDateFormat("MMMM yyyy");
                                        try {
                                            displayValue = outputFormat.format(inputFormat.parse(filterValue));
                                        } catch (ParseException e) {
                                            displayValue = "Invalid Month Format";
                                        }
                                        break;
                                    case "range":
                                        readableType = "Date Range";
                                        inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                                        outputFormat = new SimpleDateFormat("dd MMM yyyy");
                                        try {
                                            String[] range = filterValue.split(",");
                                            String start = outputFormat.format(inputFormat.parse(range[0]));
                                            String end = outputFormat.format(inputFormat.parse(range[1]));
                                            displayValue = start + " to " + end;
                                        } catch (ParseException e) {
                                            displayValue = "Invalid Date Range";
                                        }
                                        break;
                                    case "year":
                                        readableType = "By Year";
                                        displayValue = filterValue;
                                        break;
                                    default:
                                        readableType = "Unknown Filter";
                                        displayValue = filterValue;
                                        break;
                                }
                            %>
                            <%= readableType %>: <%= displayValue %>
                        </span>
                    </div>
                <% } %>
            </div>
            <% if (evaluationsReceived == 0) { %>
                <div style="text-align: center; margin-top: 20px;">
                    <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 300px; height: 300px;" />
                    <p style="font-size: 14px; font-weight: 500;">
                        No evaluation data are available at the moment. Please check back later. 
                    </p>
                </div>
            <% } else { %>
            <div class="card-view">
                <div class="card" id="overall-score">
                    <h3 class="card-heading">Average Overall Score</h3>
                    <div class="card-number" 
                         style="color: <%= averageScore > 3.5 ? "#1C8454" : 
                                          (averageScore >= 2.1 ? "#F4BB00" : "#d9534f") %>;">
                        <%= String.format("%.1f", averageScore) %>
                    </div>
                    <div class="stars">
                        <% int fullStars = (int) averageScore; %>
                        <% boolean hasHalfStar = (averageScore % 1) >= 0.5; %>
                        <% for (int i = 1; i <= 4; i++) { %>
                            <% if (i <= fullStars) { %>
                                <i class="fas fa-star" style="color: #F4BB00;"></i>
                            <% } else if (i == fullStars + 1 && hasHalfStar) { %>
                                <i class="fas fa-star-half-alt" style="color: #F4BB00;"></i>
                            <% } else { %>
                                <i class="far fa-star" style="color: #F4BB00;"></i>
                            <% } %>
                        <% } %>
                    </div>

                </div>
<div class="card" id="eval-received">
    <h3 class="card-heading">Evaluation Received</h3>
    <div class="card-number" id="evaluation-count"><%= evaluationsReceived %></div>
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
                                            <th style="cursor: pointer;">
                                                Evaluations
                                                <span class="sort-icons">
                                                    <i class="fa-solid fa-sort sort-icon"></i>
                                                    <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                                    <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
                                                </span>
                                            </th>
                                            <th style="cursor: pointer;">
                                                Score
                                                <span class="sort-icons">
                                                    <i class="fa-solid fa-sort sort-icon"></i>
                                                    <i class="fa-solid fa-caret-up sort-icon" style="display: none;"></i>
                                                    <i class="fa-solid fa-caret-down sort-icon" style="display: none;"></i>
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
                                                <td><%= survey.getWindowRating() %></td>
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
                                List<Survey> feedbacks = surveyDAO.getAllSurveys(filterType, filterValue); 
                    
                                DateTimeFormatter feedbackFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                                int feedbackCount = 0; 
                                for (Survey survey : feedbacks) { 
                                    if (feedbackCount < 5) { 
                                        String feedback = survey.getFeedback(); 
                                        String dateString = survey.getDate(); 
                                        int rating = survey.getRating(); 
                                        if (feedback != null && dateString != null) {
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
                                    }
                                    feedbackCount++; 
                                } 
                            %>
                        </div>
                    
                        <% if (feedbacks.size() >= 5) { %>
                            <div class="show-more-btn">
                                <button class="show-btn" onclick="showMoreWithFilter()">
                                    SHOW MORE <i class="bi bi-chevron-right"></i>
                                </button>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
            <div class="generate-buttons">
                <button class="<%= (evaluationsReceived == 0) ? "  disabled-button" : "gen-btn" %>"
                        <%= (evaluationsReceived == 0) ? "disabled" : "" %>
                >Generate & Export Report <i class="fa-solid fa-file-export"></i></button>
            </div>

            <div id="report-popup" class="popup-overlay">
                <div class="popup">
                    <div class="popup-header">
                        <strong>REPORT DOCUMENT FILE TYPE</strong>
                        <span class="popup-close" id="popup-close">&times;</span>
                    </div>
                    <div class="popup-content">
                        <div style="text-align: center; margin: 10px 0;"
                            <p class="bigger-text">Choose your preferred file type</p>
                        </div>
                        <div class="button-container" style="margin-top: 20px;">
                            <form class="report-container" id="reportForm" method="GET" action="<%= request.getContextPath() %>/AnalyticsGeneratorServlet" target="_blank">
                                <input type="hidden" name="filterType" id="reportFilterType" value="<%= filterType != null ? filterType : "" %>">
                                <input type="hidden" name="filterValue" id="reportFilterValue" value="<%= filterValue != null ? filterValue : "" %>">
                                <button type="submit" name="format" value="pdf" class="pdf-btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/pdf.png" alt="PDF Icon">
                                </button>
                                
                                <button type="submit" name="format" value="csv" class="csv-btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/excel.png" alt="CSV Icon">
                                </button>
                            </form>
                        </div>
                    </div>
                </div> 
            </div>
        </div>
    </div>
    <div class="overlay"></div>
    
    <% 
        Map<String, Integer> standoutCounts = new HashMap<>();
        standoutCounts.put("Response Time", surveyDAO.getStandoutCount("response", filterType, filterValue));
        standoutCounts.put("Accuracy of Information", surveyDAO.getStandoutCount("accuracy", filterType, filterValue));
        standoutCounts.put("Helpful", surveyDAO.getStandoutCount("helpful", filterType, filterValue));
        standoutCounts.put("Respectful", surveyDAO.getStandoutCount("respect", filterType, filterValue));
        
        // Initialize total responses with filters
        int totalResponses = surveyDAO.getTotalCount(filterType, filterValue);
        
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
        const reportButton = document.querySelector('.gen-btn');
        const reportPopup = document.getElementById('report-popup');
        const reportPopupElement = reportPopup.querySelector('.popup');
        const reportCloseButton = reportPopup.querySelector('.popup-close');
        
        reportButton.addEventListener('click', () => {
            reportPopup.style.display = 'flex';
            setTimeout(() => {
                reportPopupElement.classList.add('show');
            }, 10);
        });
        
        reportCloseButton.addEventListener('click', () => {
            reportPopupElement.classList.remove('show');
            setTimeout(() => {
                reportPopup.style.display = 'none';
            }, 600);
        });
        
        window.addEventListener('click', (event) => {
            if (event.target === reportPopup) {
                reportPopupElement.classList.remove('show');
                setTimeout(() => {
                    reportPopup.style.display = 'none';
                }, 600);
            }
        });
    </script>
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
                        position: 'top',
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
                        top: 10, 
                        bottom: 10,
                        left: 10,
                        right: 10
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    </script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            function addSortingFunctionality() {
                const tableHeaders = document.querySelectorAll("#reports-dashboard th");
                const tableBody = document.querySelector("#reports-dashboard tbody");
                const rows = Array.from(tableBody.querySelectorAll("tr"));
    
                tableHeaders.forEach((header, index) => {
                    header.addEventListener("click", function () {
                        const isAscending = header.classList.toggle("ascending");
                        resetSortIcons();
    
                        const sortIcons = header.querySelector(".sort-icons");
                        sortIcons.classList.add("visible");
                        sortIcons.classList.remove("spin-up", "spin-down");
    
                        if (isAscending) {
                            sortIcons.classList.add("spin-up");
                        } else {
                            sortIcons.classList.add("spin-down");
                        }
    
                        const icons = sortIcons.querySelectorAll("i");
                        icons[0].style.display = "none";
                        icons[1].style.display = isAscending ? "inline" : "none";
                        icons[2].style.display = isAscending ? "none" : "inline";
    
                        rows.sort((a, b) => {
                            const aText = a.cells[index].innerText.trim();
                            const bText = b.cells[index].innerText.trim();
    
                            return isAscending
                                ? aText.localeCompare(bText, undefined, { numeric: true })
                                : bText.localeCompare(aText, undefined, { numeric: true });
                        });
    
                        rows.forEach(row => tableBody.appendChild(row));
                    });
                });
            }
    
            function resetSortIcons() {
                document.querySelectorAll(".sort-icons").forEach(sortIcon => {
                    sortIcon.classList.remove("visible", "spin-up", "spin-down");
                    sortIcon.querySelectorAll("i").forEach(icon => {
                        icon.style.display = "none";
                    });
                    sortIcon.querySelector(".fa-sort").style.display = "inline";
                });
            }
    
            addSortingFunctionality();
        });
    </script>
    
    <script>
        function openModal() {
            const modal = document.getElementById("dateFilterModal");
            const dateFilterOption = document.getElementById("dateFilterOption");
            const savedFilterType = localStorage.getItem("filterType");
            const savedFilterValue = localStorage.getItem("filterValue");
    
            if (modal.style.display === "block") {
                closeModal();
                return;
            }
    
            if (savedFilterType) {
                dateFilterOption.value = savedFilterType;
                displayDateInput();
    
                if (savedFilterType === "day") {
                    document.getElementById("dayCalendarInput").value = savedFilterValue;
                    todayPicker.setDate(savedFilterValue);
                } else if (savedFilterType === "range") {
                    const [start, end] = savedFilterValue.split(",");
                    document.getElementById("rangeCalendarStart").value = start;
                    document.getElementById("rangeCalendarEnd").value = end;
                    rangePicker.setDate([start, end]);
                } else if (savedFilterType === "month") {
                    document.getElementById("monthCalendarInput").value = savedFilterValue;
                    monthPicker.setDate(savedFilterValue);
                } else if (savedFilterType === "year") {
                    document.getElementById("byYear").value = savedFilterValue;
                }
            } else {
                dateFilterOption.value = "day";
                displayDateInput();
            }
    
            modal.style.display = "block";
            requestAnimationFrame(() => {
                modal.style.opacity = 1;
                modal.style.transform = "translateY(0)";
            });
        }
    
        function closeModal() {
            const modal = document.getElementById("dateFilterModal");
            modal.style.opacity = 0;
            modal.style.transform = "translateY(-10px)";
            setTimeout(() => modal.style.display = "none", 300);
        }

        function resetModal() {
            localStorage.removeItem("filterType");
            localStorage.removeItem("filterValue");
            const modal = document.getElementById("dateFilterModal");
            modal.style.opacity = 0;
            modal.style.transform = "translateY(-10px)";
            setTimeout(() => {
                modal.style.display = "none";
                window.location.href = "reports_survey.jsp"; 
            }, 300);
        }

        const todayPicker = flatpickr("#todayCalendar", { 
            inline: true,
            dateFormat: "Y-m-d",
            onChange: function(selectedDates, dateStr) {
                document.getElementById("dayCalendarInput").value = dateStr;
            }
        });

        
       const monthPicker = flatpickr("#monthCalendar", {
            inline: true,
            plugins: [
                new monthSelectPlugin({
                    shorthand: true,
                    dateFormat: "Y-m",
                    altFormat: "F Y"
                })
            ],
            onChange: function(selectedDates, dateStr) {
                document.getElementById("monthCalendarInput").value = dateStr;
                
            }
        });

        const rangePicker = flatpickr("#rangeCalendar", {
            mode: "range",
            inline: true,
            dateFormat: "Y-m-d",
            onChange: function(selectedDates) {
                if (selectedDates.length === 2) {
                    const startDate = new Date(selectedDates[0].getTime() - selectedDates[0].getTimezoneOffset() * 60000)
                                        .toISOString().split("T")[0];
                    const endDate = new Date(selectedDates[1].getTime() - selectedDates[1].getTimezoneOffset() * 60000)
                                        .toISOString().split("T")[0];
        
                    document.getElementById("rangeCalendarStart").value = startDate;
                    document.getElementById("rangeCalendarEnd").value = endDate;
                }
            }
        });

        function displayDateInput() {
            const selectedOption = document.getElementById("dateFilterOption").value;
    
            document.querySelectorAll(".calendar-container").forEach(div => div.style.display = "none");
            document.getElementById("yearInput").style.display = "none";
    
            if (selectedOption === "day") {
                document.getElementById("todaySelect").style.display = "block";
                document.getElementById("todayInput").style.display = "block";
                document.getElementById("monthCalendarInputContainer").style.display = "none";
                document.getElementById("startInput").style.display = "none";
                document.getElementById("endInput").style.display = "none";
            } else if (selectedOption === "month") {
                document.getElementById("monthInput").style.display = "block";
                document.getElementById("monthCalendarInputContainer").style.display = "block";
                document.getElementById("todaySelect").style.display = "none";
                document.getElementById("startInput").style.display = "none";
                document.getElementById("endInput").style.display = "none";
            } else if (selectedOption === "year") {
                document.getElementById("yearInput").style.display = "block";
                document.getElementById("todaySelect").style.display = "none";
                document.getElementById("monthCalendarInputContainer").style.display = "none";
                document.getElementById("startInput").style.display = "none";
                document.getElementById("endInput").style.display = "none";
                populateYearDropdown();
            } else if (selectedOption === "range") {
                document.getElementById("rangeInput").style.display = "block";
                document.getElementById("todaySelect").style.display = "none";
                document.getElementById("monthCalendarInputContainer").style.display = "none";
                document.getElementById("startInput").style.display = "block";
                document.getElementById("endInput").style.display = "block";
            }
        }
    
        function populateYearDropdown() {
            const yearSelect = document.getElementById("byYear");
            yearSelect.innerHTML = "";
        
            const currentYear = new Date().getFullYear();
            for (let year = currentYear - 50; year <= currentYear + 10; year++) {
                const option = document.createElement("option");
                option.value = year;
                option.text = year;
                if (year === currentYear) {
                    option.selected = true;
                }
                yearSelect.add(option);
            }
        }

        
        function showMoreWithFilter() {
            const urlParams = new URLSearchParams(window.location.search);
            const filterType = urlParams.get('filterType');
            const filterValue = urlParams.get('filterValue');
        
            if (filterType === null && filterValue === null) {
                window.location.href = 'reports_feedback.jsp';
            } else {
                window.location.href = 'reports_feedback.jsp?filterType=' + filterType + '&filterValue=' + filterValue;
            }
        }

        function applyFilter() {
            const filterType = document.getElementById("dateFilterOption").value;
            let filterValue = "";
        
            if (filterType === "day") {
                filterValue = document.getElementById("dayCalendarInput").value;
            } else if (filterType === "range") {
                var startDate = document.getElementById("rangeCalendarStart").value; 
                var endDate = document.getElementById("rangeCalendarEnd").value; 
                filterValue = startDate + "," + endDate;
            } else if (filterType === "month") {
                filterValue = document.getElementById("monthCalendarInput").value;
            } else if (filterType === "year") {
                filterValue = document.getElementById("byYear").value;
            }
        
            if (filterValue) {
                localStorage.setItem("filterType", filterType);
                localStorage.setItem("filterValue", filterValue);
                window.location.href = 'reports_survey.jsp?filterType=' + filterType + '&filterValue=' + filterValue; 
            } else {
                alert("Please select a valid date.");
            }
            closeModal();
        }
        
        window.onload = function() {
            const currentPage = window.location.pathname;
            const currentQuery = window.location.search;
        
            if (!currentPage.endsWith("reports_survey.jsp") || !currentQuery.includes("filterType")) {
                localStorage.removeItem("filterType");
                localStorage.removeItem("filterValue");
            }
        };
        
        // Function to format numbers
  function formatNumber(num) {
        if (num >= 1000 && num <= 9999) {
            return (num / 1000).toFixed(1) + "K+";
        } else if (num >= 10000 && num <= 99999) {
            return (num / 1000).toFixed(1) + "K+";
        }
        return num;
    }

    document.addEventListener("DOMContentLoaded", function () {
        const evaluationCountElem = document.getElementById("evaluation-count");
        if (evaluationCountElem) {
            const number = parseInt(evaluationCountElem.textContent.trim(), 10);
            evaluationCountElem.textContent = formatNumber(number);
        }
    });
    </script>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>  
</body>
</html>

