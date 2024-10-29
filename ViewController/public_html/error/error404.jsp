<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error 404 - TigerSign</title>
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
                    <h1>Page Not Found</h1>
                </div>
                <div class="message">Oops! The page you are looking for does not exist. It might have been moved or deleted.</div>
                <div class="button-div">    
                    <a href="${pageContext.request.contextPath}/SuperAdmin/main_login.jsp"><i class="bi bi-house-fill" style="margin-right: 5px;"></i>Return Home</a>
                </div>
            </div>
            <div class="image">
              <img src="${pageContext.request.contextPath}/resources/images/empty.jpg" alt="Logo" class="empty">
            </div>
        </div>
    </div>
</body>
</html>
