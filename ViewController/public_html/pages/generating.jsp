<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generating...</title>
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
        <span>GENERATING...</span>
    </div>
    <div class="message">Your file is being generated. Please wait a moment.</div>
  </div>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const targetUrl = urlParams.get('generate'); 
    setTimeout(function() {
      if (targetUrl) {
        window.location.href = targetUrl;
      }
    }, 1000); 
  </script>
</body>
</html>
