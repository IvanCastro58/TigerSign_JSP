<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, com.tigersign.dao.DatabaseConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.google.gson.Gson" %>


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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
        <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/confetti.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        List<Double> documentAvgProcessingHours = new ArrayList<>();
    
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
    
        try {
            conn = DatabaseConnection.getConnection();
        
            String dateConditionTSRequest = "";
            if ("day".equals(filterType)) {
                dateConditionTSRequest = " AND TRUNC(PAYMENT_DATE) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("range".equals(filterType)) {
                dateConditionTSRequest = " AND TRUNC(PAYMENT_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                dateConditionTSRequest = " AND TO_CHAR(PAYMENT_DATE, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                dateConditionTSRequest = " AND TO_CHAR(PAYMENT_DATE, 'YYYY') = ?";
            }
    
            String dateConditionTSProofs = "";
            if ("day".equals(filterType)) {
                dateConditionTSProofs = " WHERE TRUNC(PROOF_DATE) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("range".equals(filterType)) {
                dateConditionTSProofs = " WHERE TRUNC(PROOF_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                dateConditionTSProofs = " WHERE TO_CHAR(PROOF_DATE, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                dateConditionTSProofs = " WHERE TO_CHAR(PROOF_DATE, 'YYYY') = ?";
            }
            
            String dateAverageTSProofs = "";
            if ("day".equals(filterType)) {
                dateAverageTSProofs = " AND TRUNC(PROOF_DATE) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("range".equals(filterType)) {
                dateAverageTSProofs = " AND TRUNC(PROOF_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                dateAverageTSProofs = " AND TO_CHAR(PROOF_DATE, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                dateAverageTSProofs = " AND TO_CHAR(PROOF_DATE, 'YYYY') = ?";
            }
            
            String pendingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PENDING'" + dateConditionTSRequest;
            stmt = conn.prepareStatement(pendingQuery);
            
            if ("day".equals(filterType)) {
                stmt.setString(1, filterValue);
            } else if ("range".equals(filterType)) {
                String[] range = filterValue.split(",");
                stmt.setString(1, range[0]);
                stmt.setString(2, range[1]);
            } else if ("month".equals(filterType) || "year".equals(filterType)) {
                stmt.setString(1, filterValue);
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                pendingCount = rs.getInt(1);
            }
    
            String processingQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'PROCESSING'" + dateConditionTSRequest;
            stmt = conn.prepareStatement(processingQuery);
            
            if ("day".equals(filterType)) {
                stmt.setString(1, filterValue);
            } else if ("range".equals(filterType)) {
                String[] range = filterValue.split(",");
                stmt.setString(1, range[0]);
                stmt.setString(2, range[1]);
            } else if ("month".equals(filterType) || "year".equals(filterType)) {
                stmt.setString(1, filterValue);
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                processingCount = rs.getInt(1);
            }
    
            String availableQuery = "SELECT COUNT(*) FROM TS_REQUEST WHERE FILE_STATUS = 'AVAILABLE'" + dateConditionTSRequest;
            stmt = conn.prepareStatement(availableQuery);
            
            if ("day".equals(filterType)) {
                stmt.setString(1, filterValue);
            } else if ("range".equals(filterType)) {
                String[] range = filterValue.split(",");
                stmt.setString(1, range[0]);
                stmt.setString(2, range[1]);
            } else if ("month".equals(filterType) || "year".equals(filterType)) {
                stmt.setString(1, filterValue);
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                availableCount = rs.getInt(1);
            }
    
            String claimedQuery = "SELECT COUNT(*) FROM TS_PROOFS" + dateConditionTSProofs;
            stmt = conn.prepareStatement(claimedQuery);
            
            if ("day".equals(filterType)) {
                stmt.setString(1, filterValue);
            } else if ("range".equals(filterType)) {
                String[] range = filterValue.split(",");
                stmt.setString(1, range[0]);
                stmt.setString(2, range[1]);
            } else if ("month".equals(filterType) || "year".equals(filterType)) {
                stmt.setString(1, filterValue);
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                claimedCount = rs.getInt(1);
            }
    
            String mostClaimedQuery = "SELECT REQUESTS, COUNT(*) AS total, " +
                          "AVG((CAST(DATE_AVAILABLE AS DATE) - CAST(DATE_PROCESSING AS DATE)) * 86400) AS avg_processing_hours " +
                          "FROM TS_REQUEST " +
                          "JOIN TS_PROOFS ON TS_REQUEST.REQUEST_ID = TS_PROOFS.REQUEST_ID " +
                          "WHERE FILE_STATUS = 'CLAIMED' " + dateAverageTSProofs +
                          " GROUP BY REQUESTS ORDER BY total DESC";

            
            stmt = conn.prepareStatement(mostClaimedQuery);
            if ("day".equals(filterType)) {
                stmt.setString(1, filterValue);
            } else if ("range".equals(filterType)) {
                String[] range = filterValue.split(",");
                stmt.setString(1, range[0]);
                stmt.setString(2, range[1]);
            } else if ("month".equals(filterType) || "year".equals(filterType)) {
                stmt.setString(1, filterValue);
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                documentTypes.add(rs.getString("REQUESTS"));
                documentCounts.add(rs.getInt("total"));
                documentAvgProcessingHours.add(rs.getDouble("avg_processing_hours") / 3600);
            }
        
        } catch (SQLException e) {
            e.printStackTrace();
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
            <div class="highlight-bar2"></div>
            <% if (claimedCount > 0) { %>
                <div class="reports">
                    <div class="latest-reports">
                        <div class="report-column right">
                            <div class="heading-container">
                                <h3>Average Processing Time of Documents</h3>
                            </div>
                            <div class="chart-container">
                                <canvas id="documentChart" class="bar-canvas"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <div style="text-align: center; margin-top: 20px;">
                    <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 300px; height: 300px;" />
                    <p style="font-size: 14px; font-weight: 500;">
                        No claimed requests are available at the moment. Please check back later.  
                    </p>
                </div>
            <% } %>

            
            <div class="generate-buttons">
                <button class="<%= (claimedCount == 0) ? "  disabled-button" : "gen-btn" %>"
                        <%= (claimedCount == 0) ? "disabled" : "" %>
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
                            <p class="bigger-text"><b>Choose your preferred file type<b></p>
                        </div>
                        <div class="button-container" style="margin-top: 20px;">
                            <form class="report-container" id="reportForm" method="GET" action="<%= request.getContextPath() %>/ReportGeneratorServlet" target="_blank">
                                <input type="hidden" name="filterType" id="reportFilterType" value="<%= filterType != null ? filterType : "" %>">
                                <input type="hidden" name="filterValue" id="reportFilterValue" value="<%= filterValue != null ? filterValue : "" %>">
                                <input type="hidden" name="claimedCount" id="reportClaimedCount" value="<%= claimedCount != 0 ? claimedCount : "" %>">
                            
                                <% for (int i = 0; i < documentTypes.size(); i++) { %>
                                    <input type="hidden" name="documentTypes" value="<%= documentTypes.get(i) %>">
                                    <input type="hidden" name="documentCounts" value="<%= documentCounts.get(i) %>">
                                    <input type="hidden" name="documentAvgProcessingHours" value="<%= String.format("%.2f", documentAvgProcessingHours.get(i)) %>">
                                <% } %>
                            
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
    <script>
        const documentTypes = <%= new Gson().toJson(documentTypes) %>;
        const documentCounts = <%= new Gson().toJson(documentCounts) %>;
        const documentAvgProcessingDays = <%= new Gson().toJson(documentAvgProcessingHours.stream().map(hours -> hours / 24).toArray()) %>; 
        
        const canvas = document.getElementById('documentChart');
        const rowHeight = 100; 
        canvas.height = documentTypes.length * rowHeight; 
    
        const ctx = document.getElementById('documentChart').getContext('2d');
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: documentTypes,
                datasets: [
                    {
                        label: 'Total Releases',
                        data: documentCounts,
                        borderColor: '#F4BB00', 
                        backgroundColor: 'rgba(244, 187, 0, 0.5)', 
                        borderWidth: 1,
                        borderDash: [5, 5],
                        barThickness: 20,
                    },
                    {
                        label: 'Average Processing Time (Days)',
                        data: documentAvgProcessingDays,             
                        borderColor: '#3B83FB', 
                        backgroundColor: 'rgba(59, 131, 251, 0.5)', 
                        borderWidth: 1,
                        borderDash: [5, 5],
                        barThickness: 20,
                    }
                ],
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        beginAtZero: true,
                    },
                    y: {
                        ticks: {
                            color: '#1a1a1a',
                            font: {
                                size: 12,
                                weight: '600',
                                family: 'Montserrat'
                            },
                        },
                    },
                },
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
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.dataset.label || '';
                                if (label) label += ': ';
                                label += context.raw.toFixed(2);
                                return label;
                            }
                        }
                    }
                },
            },
        });
    </script>
    
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
                window.location.href = "reports.jsp"; 
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
                yearSelect.add(option);
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
                window.location.href = 'reports.jsp?filterType=' + filterType + '&filterValue=' + filterValue; 
            } else {
                alert("Please select a valid date.");
            }
            closeModal();
        }
    </script>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
