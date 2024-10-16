package com.tigersign.servlet;

import com.tigersign.dao.PendingClaimsService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PendingClaimsService pendingClaimsService = new PendingClaimsService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orNumber = request.getParameter("orNumber");
        String feeName = request.getParameter("feeName");
        String fileStatus = request.getParameter("fileStatus");
        String userType = request.getParameter("userType");
        try {
            // Call the method to update the status in the database
            pendingClaimsService.updateFileStatus(orNumber, feeName, fileStatus);
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exception (e.g., show an error message)
        }

        if ("admin".equalsIgnoreCase(userType)) {
                   response.sendRedirect("./Admin/pending_claim.jsp");
               } else if ("superadmin".equalsIgnoreCase(userType)) {
                   response.sendRedirect("./SuperAdmin/pending_claim.jsp");
               } else {

                  
               }
    }
}