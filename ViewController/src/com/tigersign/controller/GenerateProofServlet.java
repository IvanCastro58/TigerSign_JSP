import com.itextpdf.text.DocumentException;

import com.tigersign.controller.PDFGenerator;
import com.tigersign.dao.AuditLogger;
import com.tigersign.dao.ClaimedRequestDetails;
import com.tigersign.dao.ClaimedRequestDetailsService;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GenerateProofServlet")
public class GenerateProofServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestId = request.getParameter("requestId");

        ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
        ClaimedRequestDetails details = service.getClaimedRequestDetails(requestId);

        if (details != null) {
            try {
                byte[] pdfBytes = PDFGenerator.generateProofOfClaimPDF(details);

                response.setContentType("application/pdf");
                String filename = details.getOrNumber() + "_" + "ProofOfClaim" + ".pdf";
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                response.getOutputStream().write(pdfBytes);

            } catch (DocumentException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Claimed request not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestId = request.getParameter("requestId");
        String adminEmail = (String) request.getSession().getAttribute("adminEmail");
        ClaimedRequestDetailsService service = new ClaimedRequestDetailsService();
        ClaimedRequestDetails details = service.getClaimedRequestDetails(requestId);

        String activity = "Generated proof of claim file for Service Invoice Number: " + details.getOrNumber() + " (Request: " + details.getRequestedDocuments() + ")";
        AuditLogger.logActivity(adminEmail, activity);

        response.getWriter().write("Activity logged successfully");
    }
}
