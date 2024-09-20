<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Claims - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/sidebar.css">
    <link rel="stylesheet" href="../resources/css/table.css">
    <link rel="stylesheet" href="../resources/css/pendingclaim.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <input type="checkbox" id="menu-toggle" hidden>
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    <%
        String activePage = "pending_claim";
    %>
    
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">PENDING CLAIMS</h1>
            <div class="top-nav">
                <div class="nav-item1">
                    <div class="item1-label">Show</div>
                    <div class="number">10</div>
                    <div class="drop-icon">
                        <i class="fa-solid fa-caret-down"></i>
                    </div>
                </div>
                <div class="nav-item2">
                    <div class="item2-label">Start Date</div>
                    <div class="date-box">
                        <div class="date start-date">10 Aug 2024</div>
                        <div class="calendar-icon" data-target="start-date">
                            <i class="fa-regular fa-calendar"></i>
                        </div>
                    </div>
                    <div class="item2-label">End Date</div>
                    <div class="date-box">
                        <div class="date end-date">10 Aug 2024</div>
                        <div class="calendar-icon" data-target="end-date">
                            <i class="fa-regular fa-calendar"></i>
                        </div>
                    </div>
                </div>
                <div class="nav-item3">
                    <div class="search-container">
                        <input type="text" class="search-input" placeholder="Search...">
                        <button class="search-button"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                </div>
            </div>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table">
                    <thead>
                        <tr>
                            <th>
                                O.R Number
                            </th>
                            <th>
                                Name
                                <span class="sort-icons">
                                    <i class="fa-solid fa-caret-up"></i>
                                    <i class="fa-solid fa-caret-down"></i>
                                </span>
                            </th>
                            <th class="date-processed-column">
                                Date Processed
                                <span class="sort-icons">
                                    <i class="fa-solid fa-caret-up"></i>
                                    <i class="fa-solid fa-caret-down"></i>
                                </span>
                            </th>
                            <th>
                                Status
                                <span class="sort-icons">
                                    <i class="fa-solid fa-caret-up"></i>
                                    <i class="fa-solid fa-caret-down"></i>
                                </span>
                            </th>
                            <th>
                                Documents Requested
                            </th>
                            <th>
                                Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>#123456789</td>
                            <td class="expandable-text">Dominador Del Rosario</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>

                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#132465789</td>
                            <td class="expandable-text">Rogelio Tampipi</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>

                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#274937651</td>
                            <td class="expandable-text">Bienvenido Reyes</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>

                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#182647970</td>
                            <td class="expandable-text">Esteban Dimaculangan</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>

                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#175482954</td>
                            <td class="expandable-text">Juanito Mangubat</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#175482954</td>
                            <td class="expandable-text">Nicanor Bustamante</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#175482954</td>
                            <td class="expandable-text">Salvador Dimaguiba</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#175482954</td>
                            <td class="expandable-text">Sofronio Buencamino</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#175423495</td>
                            <td class="expandable-text">Fransisco Trinidad</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                        <tr>
                            <td>#254482954</td>
                            <td class="expandable-text">Ernesto Concepcion</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td>
                                <select class="status-dropdown">
                                    <option value="paid" selected>PENDING</option>
                                    <option value="processing">PROCESSING</option>
                                    <option value="available">AVAILABLE</option>
                                </select>
                            </td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                            <td>
                                <button class="action-button">CLAIM</button>
                            </td>
                        </tr>
                    </tbody>
                    </table>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
            <div id="claimer-type-modal" class="popup-overlay">
                <div class="popup">
                    <div class="popup-header">
                        <strong>CLAIMER TYPE</strong>
                        <span class="popup-close" id="popup-close">&times;</span>
                    </div>
                    <div class="popup-content">
                        <p class="bigger-text">Select the corresponding type of claimer to activate the Document Receiving Form.</p>
                        <div class="info-text">
                            <i class="bi bi-info-circle"></i>
                            <p class="smaller-text">Select Primary Claimer if the original requester is present. If the original requester is not physically present, select Representative.</p>
                        </div>
                        <div class="claimer-button">
                            <a href="/pages/redirecting.html?redirect=../pages/receiving_form_primary.html" class="primary" target="_blank">
                                Primary Claimer<i class="bi bi-chevron-right"></i>
                              </a>
                              
                              <a href="/pages/redirecting.html?redirect=../pages/receiving_form_representative.html" class="representative" target="_blank">
                                Representative<i class="bi bi-chevron-right"></i>
                              </a>                              
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
