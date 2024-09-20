<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Prevent browser from caching this page
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Retrieve all the necessary session attributes
    String adminFirstName = (String) session.getAttribute("adminFirstName");
    String adminLastName = (String) session.getAttribute("adminLastName");
    String adminEmail = (String) session.getAttribute("adminEmail");
    String adminPicture = (String) session.getAttribute("adminPicture");

    // Check if the session attributes are present
    if (adminFirstName == null || adminEmail == null) {
        // If required session attributes are not found, invalidate the session and redirect to login page
        session.invalidate();
        response.sendRedirect("../Admin/login.jsp");
        return;
    }
%>