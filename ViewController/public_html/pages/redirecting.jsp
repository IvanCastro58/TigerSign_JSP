<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Redirecting...</title>
  <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
  <link rel="stylesheet" href="../resources/css/redirecting.css">
</head>
<body>
  <div class="container">
    <div class="image">
      <img src="../resources/images/tigersign.png" alt="Logo" class="logo">
    </div>
    <div class="loading">
        <div class="bouncing-circle"></div>
        <div class="bouncing-circle"></div>
        <div class="bouncing-circle"></div>
        <span>REDIRECTING...</span>
    </div>
    <div class="message">You are about to be transferred to a new page.</div>
  </div>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const targetUrl = urlParams.get('redirect'); 
    const queryParams = window.location.search; 
    
    setTimeout(function() {
      window.location.href = targetUrl + queryParams;
    }, 1000); 
  </script>
</body>
</html>
