<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claimed Request - TigerSign</title>
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
    
    <% 
        request.setAttribute("activePage", "claimed_request");  
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">CLAIMED REQUEST</h1>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
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
                            <th>
                                College
                                <span class="sort-icons">
                                    <i class="fa-solid fa-caret-down"></i>
                                </span>
                            </th>
                            <th class="date-processed-column">
                                Date Claimed
                                <span class="sort-icons">
                                    <i class="fa-solid fa-caret-up"></i>
                                    <i class="fa-solid fa-caret-down"></i>
                                </span>
                            </th>
                            <th>
                                Documents Requested
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="clickable-row">
                            <td>#123456789</td>
                            <td class="expandable-text">Dominador Del Rosario</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#132465789</td>
                            <td class="expandable-text">Rogelio Tampipi</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#274937651</td>
                            <td class="expandable-text">Bienvenido Reyes</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#182647970</td>
                            <td class="expandable-text">Esteban Dimaculangan</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#175482954</td>
                            <td class="expandable-text">Juanito Mangubat</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#175482954</td>
                            <td class="expandable-text">Nicanor Bustamante</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#175482954</td>
                            <td class="expandable-text">Salvador Dimaguiba</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#175482954</td>
                            <td class="expandable-text">Sofronio Buencamino</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#175423495</td>
                            <td class="expandable-text">Fransisco Trinidad</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                        <tr class="clickable-row">
                            <td>#254482954</td>
                            <td class="expandable-text">Ernesto Concepcion</td>
                            <td class="expandable-text">College of Information and Computing Sciences</td>
                            <td class="date-processed-column">10 Aug 2024</td>
                            <td class="expandable-text">Transcript, Certificate, Proof of Enrollment</td>
                        </tr>
                    </tbody>
                    </table>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>
