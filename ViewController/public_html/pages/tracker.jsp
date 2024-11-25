<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document Request Status Tracker - TigerSign</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="../resources/css/tracker.css">
        <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    </head>
    <body>
        <input type="checkbox" id="menu-toggle" hidden>
        <header>
            <div class="logo">
                <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
            </div>
        </header>
        <div class="container">
        <div class="column left-column">
            <div class="heading">Online and Walk-In Document Request</div>
            <div class="heading1">Check status of walk in application of student records via O.R. number.</div>
            <div class="highlight-bar"></div>
            <div class="instruction">
                <div class="instruction-heading">
                    <span>General Instructions</span>
                </div>
                <ul class="instruction-list">
                    <li>1. Your Official Receipt (OR) number will serve as your identification.</li>
                    <li>2. Kindly enter your Official Receipt (OR) number in the search field, for example: <strong>01-100374932</strong>.</li>
                </ul>
            </div>
            <div class="box">
                <div class="search-container">
                    <div class="input-group">
                        <i class="fas fa-barcode input-group-icon"></i>
                        <input type="text" class="search-input" placeholder="ENTER O.R. NUMBER">
                    </div>
                    <button class="search-button"><i class="bi bi-search"></i>Search Now</button>
                </div>
            </div>
            <div class="highlight-bar"></div>
            <center>
                <div class="loader" style="display: none;"></div>
            </center>
            <div class="results"></div>
        </div>
        <div class="column right-column">
            <div class="info-text">
                <div class="info-icon">
                    <i class="fas fa-info-circle"></i>
                </div>
                Important Reminders
            </div>
            <div class="reminders">
                <div class="heading">
                    <span>Retention Policy</span>
                </div>
                <ul class="indented-list">
                    <li class="sub-list">Retention Period</li>
                    <li class="sub-list1">The Office of the Registrar is responsible for storing your requested documents for only two (2) years. Once passed, we may still store your documents, but we are no longer subject to loss or damages.</li>
                </ul>
                <div class="heading">
                    <span>Requirements before claiming</span>
                </div>
                <ul class="indented-list">
                        <li class="sub-list">Documentation</li>
                        <li class="sub-list1">Claimers must bring a valid ID to provide proof of identity before claiming their requested documents.</li>
                        <br>
                        <li class="sub-list">Special Requirements</li>
                        <li class="sub-list1">If the claimer is a representative of the requester, they must provide a letter of authorization and a valid ID of the requester.</li>

                </ul>
                <div class="heading">
                    <span>How to Use the Document Tracker</span>
                    
                </div>
                <ul class="indented-list">
                        <li class="sub-list">Accessing the Tracker</li>
                        <li class="sub-list1">To use the tracker, you must input the transaction ID provided when you paid for your document request.</li>
                        <li class="sub-list1">Once entered you will find the current status of your document request.</li>
                </ul>
                <div class="heading">
                    <span>Request Status</span>
                    
                </div>
                <ul class="indented-list">
                        <li class="sub-list">Pending</li>

                        <li class="sub-list1">The request has been paid for, but the office has not begun processing it.</li>
                        <br>
                        <li class="sub-list">Processing</li>
                        <li class="sub-list1">The office has begun the processing of your request and is almost ready for claim.</li>
                        <br>
                        <li class="sub-list">Available for Claim</li>
                        <li class="sub-list1">Documents are ready to be claimed. You may claim your documents at the Office of the Registrar.</li>
                        <br>
                        <li class="sub-list">Claimed</li>
                        <li class="sub-list1">Documents have already been claimed.</li>
                </ul>
            </div>
        </div>
    </div>
    
     <footer class="footer">
        <div class="footer-container">
            <div class="footer-logo">
                <img src="../resources/images/logo.png" alt="University of Santo Tomas">
            </div>
            <div class="footer-contact">
                <h3>CONTACT US</h3>
                <p><i class="fas fa-map-marker-alt"></i> 2nd floor Main Bldg, University of Santo Tomas España, Manila C-1015</p>
                <p><i class="fas fa-phone-alt"></i> (632) 8880-1611 Loc. 8216</p>
                <p><i class="fas fa-envelope"></i> <a href="mailto:registrar.office@ust.edu.ph">registrar.office@ust.edu.ph</a></p>
                <p><i class="fas fa-clock"></i> Operation Hours: 8:00 am to 5:00 pm Monday to Friday</p>
            </div>
            <div class="footer-about">
                <h3>ABOUT OFFICE OF THE REGISTRAR</h3>
                <p>The Office of the Registrar is custodian of the academic records of students. It is responsible for monitoring the integrity of the records under its care, making them available upon request, subject to existing rules and regulations.</p>
            </div>
        </div>
        <div class="footer-yellow">
            <p>© 2016 Copyright University of Santo Tomas, Office of the Registrar. Proudly powered by <strong>UST-ICT Santo Tomas E-Service Providers</strong></p>
        </div>
    </footer>
    
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        $(".search-button").click(function() {
            var orNumber = $(".search-input").val().trim();
            if (orNumber) {
                $(".loader").show();
                $(".results").hide();

                setTimeout(function() {
                    $.ajax({
                        url: "<%= request.getContextPath() %>/SearchRequestsServlet",
                        type: "GET",
                        dataType: "json",
                        data: { or_number: orNumber },
                        success: function(data) {
                            $(".results")
                                .empty()
                                .css("display", "block")
                                .addClass("highlight-background");
                            $(".loader").hide();

                            if (Array.isArray(data) && data.length > 0) {
                                $.each(data, function(index, item) {
                                    const fileStatusRow = $("<div>").addClass("file-status-row");
                                    const fileName = $("<div>").addClass("file-name").text(item.request);
                                    const statusClass = item.status ? item.status.toLowerCase().replace(" ", "-") : "";
                                    const statusBadge = $("<div>")
                                        .addClass("status-badge " + statusClass)
                                        .text(item.status ? item.status.toUpperCase() : "UNKNOWN");

                                    fileStatusRow.append(fileName).append(statusBadge);

                                    if (item.status && item.status.toUpperCase() === "HOLD" && item.onHoldReason) {
                                        const note = $("<div>").addClass("note").text("*" + item.onHoldReason);
                                        fileStatusRow.append(note);
                                    }

                                    $(".results").append(fileStatusRow);
                                });
                            } else {
                                $(".results").append('<div class="no-results">Sorry. No requests were found.</div>');
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            $(".results")
                                .empty()
                                .append('<div class="error">Error retrieving data.</div>')
                                .css("display", "block")
                                .addClass("highlight-background");
                            $(".loader").hide();
                        }
                    });
                }, 2000);
            } else {
                console.warn("OR Number is empty");
            }
        });
    });
</script>
</body>
</html>