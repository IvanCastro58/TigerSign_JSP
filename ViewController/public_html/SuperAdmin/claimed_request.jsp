<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tigersign.dao.ClaimedRequest" %>
<%@ page import="com.tigersign.dao.ClaimedRequestsService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>

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
    <%@ include file="/WEB-INF/components/session_check.jsp" %>
    <% 
        request.setAttribute("activePage", "claimed_request");  
        ClaimedRequestsService service = new ClaimedRequestsService();
        List<ClaimedRequest> requests = service.getClaimedRequests();

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd"); 
    %>
    
    <%@ include file="/WEB-INF/components/header.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar.jsp" %>
    
    <div class="main-content">
        <div class="margin-content">
            <h1 class="title-page">CLAIMED REQUEST</h1>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
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
                        <% 
                            if (requests != null && !requests.isEmpty()) {
                                for (ClaimedRequest claimedRequest : requests) {
                                    String proofDateStr = claimedRequest.getProofDate();
                                    String formattedDate = "";
                                    if (proofDateStr != null && !proofDateStr.isEmpty()) {
                                        try {
                                            Date date = inputFormat.parse(proofDateStr); 
                                            formattedDate = outputFormat.format(date); 
                                        } catch (ParseException e) {
                                            e.printStackTrace();
                                        }
                                    }
                        %>
                            <tr class="clickable-row">
                                <td><%= claimedRequest.getTransactionId() %></td>
                                <td class="expandable-text"><%= claimedRequest.getName() %></td>
                                <td class="expandable-text"><%= claimedRequest.getCollege() %></td>
                                <td class="date-processed-column"><%= formattedDate %></td>
                                <td class="expandable-text"><%= claimedRequest.getDocumentsRequested() %></td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5">No claimed requests found.</td>
                            </tr>
                        <% 
                            }
                        %>
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
