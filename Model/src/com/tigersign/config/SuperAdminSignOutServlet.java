package com.tigersign.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/superadmin-signout")
public class SuperAdminSignOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the current session
        request.getSession().invalidate();
        
        // Redirect to login page
        response.sendRedirect("pages/main_login.jsp");
    }
}
