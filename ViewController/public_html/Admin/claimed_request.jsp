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
<style>
    .transaction-table th, .transaction-table td{
        padding: 15px;
    }
</style>
<body>
    <%@ include file="/WEB-INF/components/session_admin.jsp" %>
    <% 
        request.setAttribute("activePage", "claimed_request");  
        ClaimedRequestsService service = new ClaimedRequestsService();
        List<ClaimedRequest> requests = service.getClaimedRequests();

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd"); 
    %>
    <%@ include file="/WEB-INF/components/header_admin.jsp" %>
    <%@ include file="/WEB-INF/components/sidebar_admin.jsp" %>
    
   <div class="main-content">
        <div class="margin-content">
            <h2 class="title-page">CLAIMED REQUEST</h2>
            <%@ include file="/WEB-INF/components/top_nav.jsp" %>
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="transaction-table" id="pending_table">
                    <thead>
                        <tr>
                            <th>
                                Request ID
                            </th>
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
                            <th style="display: none;">
                                Documents Description
                            </th>
                        </tr>
                    </thead>
                        <tbody id="claimed-table-body">
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
                            <tr class="admin-clickable-row actual-data">
                                <td><%= claimedRequest.getRequestId() %></td> <!-- Added requestId -->
                                <td><%= claimedRequest.getOrNumber() %></td>
                                <td class="expandable-text"><%= claimedRequest.getName() %></td>
                                <td class="expandable-text"><%= claimedRequest.getCollege() %></td>
                                <td class="date-processed-column"><%= formattedDate %></td>
                                <td class="expandable-text"><%= claimedRequest.getDocumentsRequested() %></td>
                                <td class="expandable-text" style="display: none;"><%= claimedRequest.getDocumentsDescription() %></td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="6">No claimed requests found.</td> <!-- Adjusted colspan to match new column -->
                                </tr>
                            <% 
                                }
                            %>
                        </tbody>
                    </table>
                    <div style="text-align: center; margin-top: 20px;" id="no-results">
                        <img src="<%= request.getContextPath() %>/resources/images/empty.jpg" alt="No Data" style="width: 200px; height: 200px;" />
                        <p style="font-size: 14px; font-weight: 500;">No matching requests found.</p>
                    </div>
                </div>
            </div>
            <%@ include file="/WEB-INF/components/pagination.jsp" %>
        </div>
    </div>
    <div class="overlay"></div>
    
    <%@ include file="/WEB-INF/components/script.jsp" %>
    <script type="text/javascript">
        const searchInput = document.getElementById('search-admin');
        const tableRows = document.querySelectorAll('#claimed-table-body tr.actual-data');
        const noResultsDiv = document.getElementById('no-results');

        function checkNoResults() {
            let hasVisibleRows = Array.from(tableRows).some(row => row.style.display !== 'none');
            noResultsDiv.style.display = hasVisibleRows ? 'none' : 'block'; 
        }

        searchInput.addEventListener('input', () => {
            const searchValue = searchInput.value.toLowerCase();
            tableRows.forEach((row) => {
                const transactionIdCell = row.querySelector('td:nth-child(2)').textContent.toLowerCase(); 
                const nameCell = row.querySelector('td:nth-child(3)').textContent.toLowerCase(); 

                if (transactionIdCell.includes(searchValue) || nameCell.includes(searchValue)) {
                    row.style.display = 'table-row';
                } else {
                    row.style.display = 'none';
                }
            });

            checkNoResults();
        });

        checkNoResults();
    </script>
</body>
</html>

