<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Prevent browser from caching this page
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Retrieve all the necessary session attributes
    String userFirstName = (String) session.getAttribute("userFirstName");
    String userLastName = (String) session.getAttribute("userLastName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPicture = (String) session.getAttribute("userPicture");

    if (userFirstName == null || userEmail == null) {
        // If required session attributes are not found, redirect to login page
        response.sendRedirect("../SuperAdmin/main_login.jsp");
        return;
    }
%>
