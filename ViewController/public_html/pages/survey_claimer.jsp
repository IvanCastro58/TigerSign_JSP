<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Survey & Evaluation - TigerSign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="../resources/css/survey.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
</head>
<body>
    <input type="checkbox" id="menu-toggle" hidden>
    <header>
        <div class="logo">
            <img src="../resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="container">
        <div class="main-content">
            <div class="margin-content">
                <div class="receiving-form">
                    <div class="form-container">
                        <div class="highlight-bar"></div>
                        <div class="form-details"> 
                            <h1 class="title-page">Survey/Evaluation Form For Office Of The Registrar's Service</h1>
                            <div class="form-box">
                                <div class="reminders">
                                    <i class="bi bi-info-circle"></i>
                                    <p class="smaller-text">Questions with<span style="color: #DB3444;"> *</span> are required to be answered.</p>
                                </div>
                                <form action="${pageContext.request.contextPath}/submitSurvey" method="post" class="form">
                                    <div class="input-fields">
                                        <label for="claimer-name" class="form-label">Enter Name (Optional)</label>
                                        <input type="text" name="field-name" id="field-name" placeholder="Enter Full Name">
                                    </div>
                                    <div class="input-fields">
                                        <label for="claimer-date" class="form-label">Date<span style="color: #DB3444;"> *</span></label>
                                        <input type="date" name="field-date" id="field-date" required>
                                    </div>
                                    <div class="input-fields">
                                        <label for="claimer-email" class="form-label">Email Address<span style="color: #DB3444;"> *</span></label>
                                        <input type="text" name="field-email" id="field-email" placeholder="Enter Email Address">
                                    </div>

                                    <div class="input-fields">
                                        <label class="form-label">Choose Service<span style="color: #DB3444;"> *</span></label>
                                        <div class="service-options">
                                            <div>
                                                <input type="radio" id="service1" name="service" value="IW" required>
                                                <label for="service1" class="form-label2"><strong>Information Window</strong></label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service2" name="service" value="WA">
                                                <label for="service2" class="form-label2"><strong>Window A</strong> (Foreign Students)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service3" name="service" value="WB">
                                                <label for="service3" class="form-label2"><strong>Window B</strong> (Faculty of Civil Law, Faculty of Medicine and Surgery, Institute of Physical Education and Athletics)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service4" name="service" value="WC">
                                                <label for="service4" class="form-label2"><strong>Window C</strong> (College of Commerce and College of Science)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service5" name="service" value="WD">
                                                <label for="service5" class="form-label2"><strong>Window D</strong> (College of Tourism and Hospitality Management, College of Fine Arts and Design)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service6" name="service" value="WE">
                                                <label for="service6" class="form-label2"><strong>Window E</strong> (College of Nursing, College of Education, Conservatory of Music)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service7" name="service" value="WF">
                                                <label for="service7" class="form-label2"><strong>Window F</strong> (Faculty of Pharmacy, Graduate School, Graduate School of Law)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service8" name="service" value="WG">
                                                <label for="service8" class="form-label2"><strong>Window G</strong> (Faculty of Arts and Letters, College of Rehabilitation Science)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service9" name="service" value="WH">
                                                <label for="service9" class="form-label2"><strong>Window H</strong> (College of Architecture, AMV-College of Accountancy)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service10" name="service" value="WI">
                                                <label for="service10" class="form-label2"><strong>Window I</strong> (Faculty of Engineering, College of Information and Computing Sciences)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service11" name="service" value="WJ">
                                                <label for="service11" class="form-label2"><strong>Window J</strong> (Enrollment Related Concerns, Cross Enrollment)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service12" name="service" value="WK">
                                                <label for="service12" class="form-label2"><strong>Window K</strong> (Honorable Dismissal, Transfer Credential)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service13" name="service" value="WL">
                                                <label for="service13" class="form-label2"><strong>Window L</strong> (Diploma, Certified True Copy)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="service14" name="service" value="WM">
                                                <label for="service14" class="form-label2"><strong>Window M</strong> (CAV-DFA Apostille, Endorsement)</label>
                                            </div>
                                            <div>
                                                <input type="radio" id="other" name="service" value="other">
                                                <label for="other" class="form-label2"><strong>Other</strong></label>
                                                <input type="text" id="other-text" name="other-service" placeholder="Please specify" style="display:none;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="input-fields">
                                        <label class="form-label">Service Rating<span style="color: #DB3444;"> *</span></label>
                                        <p class="rating-description"><strong>1</strong> being the lowest and <strong>4</strong> being the highest</p>
                                        <div class="rating-options">
                                            <div class="rating-option">
                                                <div class="rating-label"><strong>1</strong></div>
                                                <input type="radio" id="rating1" name="rating" value="1" required>
                                                <label for="rating1"></label>
                                            </div>
                                            <div class="rating-option">
                                                <div class="rating-label"><strong>2</strong></div>
                                                <input type="radio" id="rating2" name="rating" value="2">
                                                <label for="rating2"></label>
                                            </div>
                                            <div class="rating-option">
                                                <div class="rating-label"><strong>3</strong></div>
                                                <input type="radio" id="rating3" name="rating" value="3">
                                                <label for="rating3"></label>
                                            </div>
                                            <div class="rating-option">
                                                <div class="rating-label"><strong>4</strong></div>
                                                <input type="radio" id="rating4" name="rating" value="4">
                                                <label for="rating4"></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="input-fields">
                                        <label class="form-label">Which Service stand out for you?<span style="color: #DB3444;"> *</span></label>
                                        <div class="standout-options">
                                            <div>
                                                <input type="radio" id="standout1" name="standout" value="response">
                                                <label for="standout1" class="form-label"><strong>Response Time</strong></label>
                                            </div>
                                            <div>
                                                <input type="radio" id="standout2" name="standout" value="accuracy">
                                                <label for="standout2" class="form-label"><strong>Accuracy of Information</strong></label>
                                            </div>
                                            <div>
                                                <input type="radio" id="standout3" name="standout" value="helpful">
                                                <label for="standout3" class="form-label"><strong>Helpful</strong></label>
                                            </div>
                                            <div>
                                                <input type="radio" id="standout4" name="standout" value="respect">
                                                <label for="standout4" class="form-label"><strong>Respectful</strong></label>
                                            </div>
                                            <div>
                                                <input type="radio" id="standout5" name="standout" value="other">
                                                <label for="standout5" class="form-label"><strong>Other</strong></label>
                                                <input type="text" id="standout-other-text" name="standout-other" placeholder="Please specify" style="display:none;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="input-fields">
                                        <label for="feedback" class="form-label">Feedback</label>
                                        <textarea id="feedback" name="feedback" rows="4" placeholder="Enter your feedback here..."></textarea>
                                    </div>

                                    <div class="submit-button-container">
                                        <button type="submit" class="submit-btn">Submit</button>
                                    </div>
                                    <p class="smaller-text">UST:S033-00-O69</p>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-logo">
                <img src="../resources/images/logo.png" alt="University of Santo Tomas">
            </div>  
            <div class="footer-contact">
                <h3>Contact Us</h3>
                <p><i class="fas fa-map-marker-alt"></i> 2nd floor Main Bldg, University of Santo Tomas España, Manila C-1015</p>
                <p><i class="fas fa-phone-alt"></i> (632) 8880-1611 Loc. 8216</p>
                <p><i class="fas fa-envelope"></i> <a href="mailto:registrar.office@ust.edu.ph">registrar.office@ust.edu.ph</a></p>
                <p><i class="fas fa-clock"></i> Operation Hours: 8:00 am to 5:00 pm Monday to Friday</p>
            </div>
            <div class="footer-about">
                <h3>About Office of the Registrar</h3>
                <p>The Office of the Registrar is custodian of the academic records of students. It is responsible for monitoring the integrity of the records under its care, making them available upon request, subject to existing rules and regulations.</p>
            </div>
        </div>
        <div class="footer-yellow">
            <p>© 2016 Copyright University of Santo Tomas, Office of the Registrar. Proudly powered by <strong>UST-ICT Santo Tomas E-Service Providers</strong></p>
        </div>
    </footer>
    <%@ include file="/WEB-INF/components/script.jsp" %>
</body>
</html>


