import com.itextpdf.text.DocumentException;

import com.tigersign.controller.PDFGenerator;
import com.tigersign.dao.AuditLogger;
import com.tigersign.dao.ClaimedRequestDetails;
import com.tigersign.dao.ClaimedRequestDetailsService;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//@WebServlet("/GenerateProofServlet")
//public class GenerateProofServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String orNumber = request.getParameter("orNumber");
//        String feeName = request.getParameter("feeName");
//
//        ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
//        ClaimedRequestDetails details = service.getClaimedRequestDetails(orNumber, feeName);
//
//        ServletContext context = getServletContext(); 
//        String adminEmail = (String) request.getSession().getAttribute("adminEmail");
//
//        if (details != null) {
//            try {
//                byte[] pdfBytes = PDFGenerator.generateProofOfClaimPDF(details, context);
//
//                response.setContentType("application/pdf");
//                String filename = orNumber + "_" + "ProofOfClaim" + ".pdf";
//                response.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
//                response.getOutputStream().write(pdfBytes);
//            } catch (DocumentException e) {
//                e.printStackTrace();
//                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
//            }
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Claimed request not found");
//        }
//    }
//
//    // New endpoint for logging activity
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String orNumber = request.getParameter("orNumber");
//        String feeName = request.getParameter("feeName");
//        String adminEmail = (String) request.getSession().getAttribute("adminEmail");
//
//        // Log the activity
//        String activity = "Generated proof of claim file for OR Number: " + orNumber + ", File: " + feeName;
//        AuditLogger.logActivity(adminEmail, activity);
//
//        // Return a success message
//        response.getWriter().write("Activity logged successfully");
//    }
//}


@WebServlet("/GenerateProofServlet")
public class GenerateProofServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transactionId = request.getParameter("transactionId");

        ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
        ClaimedRequestDetails details = service.getClaimedRequestDetails(transactionId);

        ServletContext context = getServletContext(); 
        String adminEmail = (String) request.getSession().getAttribute("adminEmail"); 

        if (details != null) {
            try {
                byte[] pdfBytes = PDFGenerator.generateProofOfClaimPDF(details, context);

                response.setContentType("application/pdf");
                String filename = transactionId + "_" + "ProofOfClaim" + ".pdf";
                response.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
                response.getOutputStream().write(pdfBytes);
                
                // Move the logging to another endpoint or separate request
            } catch (DocumentException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Claimed request not found");
        }
    }

    // New endpoint for logging activity
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transactionId = request.getParameter("transactionId");
        String adminEmail = (String) request.getSession().getAttribute("adminEmail");
        
        // Log the activity
        String activity = "Generated proof of claim file for Transaction ID: " + transactionId;
        AuditLogger.logActivity(adminEmail, activity);

        // Return a success message
        response.getWriter().write("Activity logged successfully");
    }
}



