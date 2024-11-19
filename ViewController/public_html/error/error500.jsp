<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error 500 - TigerSign</title>
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
                    <h1>Internal Server Error</h1>
                </div>
                <div class="message">We apologize for the inconvenience. An unexpected error occurred on our server. Please try refreshing the page or visit again later.</div>
            </div>
            <div class="image">
              <img src="${pageContext.request.contextPath}/resources/images/error500.jpg" alt="Logo" class="empty">
            </div>
        </div>
    </div>
</body>
</html>
