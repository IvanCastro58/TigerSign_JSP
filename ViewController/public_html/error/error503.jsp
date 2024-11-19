<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error 503 - TigerSign</title>
    <link rel="stylesheet" type="text/css" href="#"> 
    <link rel="icon" href="<%= request.getContextPath() %>/resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/error.css">
</head>
<body>
    <div class="error-container">
        <div class="highlight-bar"></div>
        <div class="error-box">
            <div class="text-field">
                <div>
                    <h1>Service Unavailable</h1>
                </div>
                <div class="message">The server is temporarily unable to handle the request due to maintenance or overloading. Please try again later.</div>
            </div>
            <div class="image">
              <img src="${pageContext.request.contextPath}/resources/images/error503.jpg" alt="Error Image" class="empty">
            </div>
        </div>
    </div>
</body>
</html>
