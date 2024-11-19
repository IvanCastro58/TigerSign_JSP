import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import com.tigersign.dao.Survey;
import com.tigersign.dao.SurveyDAO;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AnalyticsGeneratorServlet")
public class AnalyticsGeneratorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String format = request.getParameter("format");
        String filterType = request.getParameter("filterType");

        if (filterType != null) {
            switch (filterType) {
                case "day":
                    filterType = "By Day";
                    break;
                case "month":
                    filterType = "By Month";
                    break;
                case "range":
                    filterType = "By Date Range";
                    break;
                case "year":
                    filterType = "By Year";
                    break;
                default:
                    filterType = "";
                    break;
            }
        }
        
        String filterValue = request.getParameter("filterValue");
        
        SurveyDAO surveyDAO = new SurveyDAO();

        if ("pdf".equalsIgnoreCase(format)) {
            try {
                generatePDFAnalytics(response, surveyDAO, filterType, filterValue);
            } catch (DocumentException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF report");
            }
        } else if ("csv".equalsIgnoreCase(format)) {
            generateCSVReport(response, surveyDAO, filterType, filterValue);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report format");
        }
    }

    private static final BaseColor CUSTOM_GRAY = new BaseColor(209, 209, 209);
    private static final BaseColor CUSTOM_LIGHTER_GRAY = new BaseColor(240, 240, 240);

    private void generatePDFAnalytics(HttpServletResponse response, SurveyDAO surveyDAO, String filterType, String filterValue) 
                                      throws IOException, DocumentException {
        response.setContentType("application/pdf");

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4, 20, 20, 20, 20);
        PdfWriter.getInstance(document, byteArrayOutputStream);

        document.open();

        // Header Section
        PdfPTable headerTable = new PdfPTable(5);
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingBefore(10f);
        headerTable.setSpacingAfter(10f);

        String logoPath1 = getServletContext().getRealPath("/resources/images/ust.png");
        String logoPath2 = getServletContext().getRealPath("/resources/images/registrar.png");

        Image logo1 = Image.getInstance(logoPath1);
        logo1.scaleToFit(60, 60);
        PdfPCell logoCell1 = new PdfPCell(logo1);
        logoCell1.setBorder(PdfPCell.NO_BORDER);
        logoCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
        logoCell1.setVerticalAlignment(Element.ALIGN_MIDDLE);
        logoCell1.setPadding(5);

        Image logo2 = Image.getInstance(logoPath2);
        logo2.scaleToFit(60, 60);
        PdfPCell logoCell2 = new PdfPCell(logo2);
        logoCell2.setBorder(PdfPCell.NO_BORDER);
        logoCell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        logoCell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        logoCell2.setPadding(5);

        String titleText = "UNIVERSITY OF SANTO TOMAS\n";
        String officeText = "OFFICE OF THE REGISTRAR\n";
        String proofText = "TigerSign - Survey/Evaluation Analytics";

        Font titleFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 16, Font.NORMAL, BaseColor.BLACK); 
        Font officeFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL, BaseColor.BLACK);
        Font proofFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, BaseColor.BLACK);

        Paragraph titleParagraph = new Paragraph(titleText, titleFont);
        titleParagraph.setAlignment(Element.ALIGN_CENTER);
        Paragraph officeParagraph = new Paragraph(officeText, officeFont);
        officeParagraph.setAlignment(Element.ALIGN_CENTER);
        Paragraph proofParagraph = new Paragraph(proofText, proofFont);
        proofParagraph.setAlignment(Element.ALIGN_CENTER);

        PdfPCell titleCell = new PdfPCell();
        titleCell.addElement(titleParagraph);
        titleCell.addElement(officeParagraph);
        titleCell.addElement(proofParagraph);
        titleCell.setBorder(PdfPCell.NO_BORDER);
        titleCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        titleCell.setPadding(15); 
        titleCell.setColspan(3); 

        headerTable.addCell(logoCell1);
        headerTable.addCell(titleCell);
        headerTable.addCell(logoCell2);

        document.add(headerTable);

        PdfPTable filterValueTable = new PdfPTable(4);
        filterValueTable.setWidthPercentage(100);
        filterValueTable.addCell(createCell("Filter Type:", null));
        filterValueTable.addCell(createCell(filterType.isEmpty() ? "All Data" : filterType, null));
        filterValueTable.addCell(createCell("Filter Value:", null));
        filterValueTable.addCell(createCell(filterValue.isEmpty() ? "All Data" : filterValue, null));
        document.add(filterValueTable);

        
        document.add(new Paragraph("\n"));
        
        // Claimed Requests Section
        PdfPTable evaluationInfoTable = new PdfPTable(4);
        evaluationInfoTable.setWidthPercentage(100);
        evaluationInfoTable.addCell(createCell("Total Evaluation Received", null));
        evaluationInfoTable.addCell(createCell(surveyDAO.getEvaluationReceivedCount(filterType, filterValue) + " evaluation/s", null));
        evaluationInfoTable.addCell(createCell("", null));
        evaluationInfoTable.addCell(createCell("", null));
        document.add(evaluationInfoTable);
        
        // Claimed Requests Section
        PdfPTable averageInfoTable = new PdfPTable(4);
        averageInfoTable.setWidthPercentage(100);
        averageInfoTable.addCell(createCell("Overall Average Score", null));
        averageInfoTable.addCell(createCell(String.format("%.1f", surveyDAO.getAverageScore(filterType, filterValue)), null));
        averageInfoTable.addCell(createCell("", null));
        averageInfoTable.addCell(createCell("", null));
        document.add(averageInfoTable);
        
        document.add(new Paragraph("\n"));
        
        // Claimed Requests Section
        PdfPTable serviceInfoTable = new PdfPTable(4);
        serviceInfoTable.setWidthPercentage(100);
        PdfPCell standoutService = createCell("User Preference for Outstanding Services", CUSTOM_GRAY);
        standoutService.setColspan(2);
        serviceInfoTable.addCell(standoutService);
        serviceInfoTable.addCell(createCell("", CUSTOM_GRAY));
        serviceInfoTable.addCell(createCell("", CUSTOM_GRAY));
        document.add(serviceInfoTable);
        
        // Document Info Section
        PdfPTable ratingInfoTable = new PdfPTable(4);
        ratingInfoTable.setWidthPercentage(100);
        ratingInfoTable.addCell(createCell1("Types of Services", CUSTOM_LIGHTER_GRAY));
        ratingInfoTable.addCell(createCell1("Total Responses", CUSTOM_LIGHTER_GRAY));
        ratingInfoTable.addCell(createCell1("", CUSTOM_LIGHTER_GRAY));
        ratingInfoTable.addCell(createCell1("", CUSTOM_LIGHTER_GRAY));
        
        ratingInfoTable.addCell(createNormalCell("Response Time"));
        PdfPCell responseCell = createCell(String.valueOf(surveyDAO.getStandoutCount("response", filterType, filterValue)), null);
        responseCell.setColspan(3);
        ratingInfoTable.addCell(responseCell);
        
        ratingInfoTable.addCell(createNormalCell("Accuracy of Information"));
        PdfPCell accuracyCell = createCell(String.valueOf(surveyDAO.getStandoutCount("accuracy", filterType, filterValue)), null);
        accuracyCell.setColspan(3);
        ratingInfoTable.addCell(accuracyCell);
        
        ratingInfoTable.addCell(createNormalCell("Helpful"));
        PdfPCell helpCell = createCell(String.valueOf(surveyDAO.getStandoutCount("helpful", filterType, filterValue)), null);
        helpCell.setColspan(3);
        ratingInfoTable.addCell(helpCell);
        
        ratingInfoTable.addCell(createNormalCell("Respectful"));
        PdfPCell respectCell = createCell(String.valueOf(surveyDAO.getStandoutCount("respect", filterType, filterValue)), null);
        respectCell.setColspan(3);
        ratingInfoTable.addCell(respectCell);
        
        document.add(ratingInfoTable);
        
        document.add(new Paragraph("\n"));
        
        // Fetch service window scores
        List<Survey> serviceScores = surveyDAO.getServiceWindowScores(filterType, filterValue);
        
        // Header for Service Window Performance Score
        PdfPTable windowScoreHeaderTable = new PdfPTable(4);
        windowScoreHeaderTable.setWidthPercentage(100);
        PdfPCell windowScoreHeaderCell = createCell("Service Window Performance Score", CUSTOM_GRAY);
        windowScoreHeaderCell.setColspan(4);
        windowScoreHeaderTable.addCell(windowScoreHeaderCell);
        document.add(windowScoreHeaderTable);
        
        // Table for detailed scores
        PdfPTable windowScoreDetailsTable = new PdfPTable(4);
        windowScoreDetailsTable.setWidthPercentage(100);
        PdfPCell serviceWindow = createCell1("Service Window", CUSTOM_LIGHTER_GRAY);
        serviceWindow.setColspan(2);
        windowScoreDetailsTable.addCell(serviceWindow);
        windowScoreDetailsTable.addCell(createCell1("Total Responses", CUSTOM_LIGHTER_GRAY));
        windowScoreDetailsTable.addCell(createCell1("Average Score", CUSTOM_LIGHTER_GRAY));
        
        Map<String, String> serviceMap = new HashMap<>();
        serviceMap.put("IW", "Information Window");
        serviceMap.put("WA", "Window A (Foreign Students)");
        serviceMap.put("WB", "Window B (Faculty of Civil Law, Faculty of Medicine and Surgery, Institute of Physical Education and Athletics)");
        serviceMap.put("WC", "Window C (College of Commerce and College of Science)");
        serviceMap.put("WD", "Window D (College of Tourism and Hospitality Management, College of Fine Arts and Design)");
        serviceMap.put("WE", "Window E (College of Nursing, College of Education, Conservatory of Music)");
        serviceMap.put("WF", "Window F (Faculty of Pharmacy, Graduate School, Graduate School of Law)");
        serviceMap.put("WG", "Window G (Faculty of Arts and Letters, College of Rehabilitation Science)");
        serviceMap.put("WH", "Window H (College of Architecture, AMV-College of Accountancy)");
        serviceMap.put("WI", "Window I (Faculty of Engineering, College of Information and Computing Sciences)");
        serviceMap.put("WJ", "Window J (Enrollment Related Concerns, Cross Enrollment)");
        serviceMap.put("WK", "Window K (Honorable Dismissal, Transfer Credential)");
        serviceMap.put("WL", "Window L (Diploma, Certified True Copy)");
        serviceMap.put("WM", "Window M (CAV-DFA Apostille, Endorsement)");
        serviceMap.put("other", "Other");
        
        // Populate rows dynamically
        for (Survey survey : serviceScores) {
            String serviceValue = survey.getService();
            String serviceTitle = serviceMap.getOrDefault(serviceValue, "Other");
            
            PdfPCell serviceWindowTitle = createNormalCell(serviceTitle);
            serviceWindowTitle.setColspan(2);
            windowScoreDetailsTable.addCell(serviceWindowTitle);
            windowScoreDetailsTable.addCell(createNormalCell(String.valueOf(survey.getEvaluationCount()))); 
            windowScoreDetailsTable.addCell(createNormalCell(String.valueOf(survey.getRating()))); 
        }
        
        document.add(windowScoreDetailsTable);
        
        document.close();

        response.getOutputStream().write(byteArrayOutputStream.toByteArray());
        response.getOutputStream().flush();
    }

    private static PdfPCell createCell(String content, BaseColor backgroundColor) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8)));
        if (backgroundColor != null) {
            cell.setBackgroundColor(backgroundColor);
        }
        cell.setPadding(4);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
    
    private static PdfPCell createCell1(String content, BaseColor backgroundColor) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA, 8)));
        if (backgroundColor != null) {
            cell.setBackgroundColor(backgroundColor);
        }
        cell.setPadding(4);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }

    private static PdfPCell createNormalCell(String content) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA, 8))); 
        cell.setPadding(3);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
    
    private void generateCSVReport(HttpServletResponse response, SurveyDAO surveyDAO, String filterType, String filterValue) 
                                    throws IOException {
        String sanitizedFilterValue = (filterValue == null || filterValue.isEmpty()) ? "All_Data" 
                                         : filterValue.replaceAll("[^a-zA-Z0-9-_]", "_");
        String filename = "survey_analytics_" + sanitizedFilterValue + ".csv";
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Create a StringBuilder to generate CSV content
        StringBuilder csvBuilder = new StringBuilder();
        
        csvBuilder.append("=== TIGERSIGN - SURVEY/EVALUATION ANALYTICS ===\n\n");
        
        csvBuilder.append("=== Filter Information ===\n\n");

        // Add the headers for the CSV
        csvBuilder.append("Type:,").append(filterType.isEmpty() ? "All Data" : filterType).append("\n");
        csvBuilder.append("Value:,").append(filterValue.isEmpty() ? "All Data" : filterValue).append("\n\n");

        // Claimed Requests Section
        csvBuilder.append("Total Evaluation Received,");
        csvBuilder.append(surveyDAO.getEvaluationReceivedCount(filterType, filterValue)).append("\n");

        // Average Score Section
        csvBuilder.append("Overall Average Score,");
        csvBuilder.append(String.format("%.1f", surveyDAO.getAverageScore(filterType, filterValue))).append("\n\n");

        // User Preference for Outstanding Services
        csvBuilder.append("=== User Preference for Outstanding Services ===\n\n");
        
        csvBuilder.append("Types of Services*,Total Responses*\n");
        csvBuilder.append("Response Time,");
        csvBuilder.append(surveyDAO.getStandoutCount("response", filterType, filterValue)).append("\n");
        csvBuilder.append("Accuracy of Information,");
        csvBuilder.append(surveyDAO.getStandoutCount("accuracy", filterType, filterValue)).append("\n");
        csvBuilder.append("Helpful,");
        csvBuilder.append(surveyDAO.getStandoutCount("helpful", filterType, filterValue)).append("\n");
        csvBuilder.append("Respectful,");
        csvBuilder.append(surveyDAO.getStandoutCount("respect", filterType, filterValue)).append("\n\n");

        // Service Window Performance Scores
        csvBuilder.append("=== Service Window Performance Scores ===\n\n");
        
        csvBuilder.append("Service Window*,Total Responses*,Average Score*\n");

        List<Survey> serviceScores = surveyDAO.getServiceWindowScores(filterType, filterValue);
        Map<String, String> serviceMap = new HashMap<>();
        serviceMap.put("IW", "Information Window");
        serviceMap.put("WA", "Window A (Foreign Students)");
        serviceMap.put("WB", "Window B (Faculty of Civil Law, Faculty of Medicine and Surgery, Institute of Physical Education and Athletics)");
        serviceMap.put("WC", "Window C (College of Commerce and College of Science)");
        serviceMap.put("WD", "Window D (College of Tourism and Hospitality Management, College of Fine Arts and Design)");
        serviceMap.put("WE", "Window E (College of Nursing, College of Education, Conservatory of Music)");
        serviceMap.put("WF", "Window F (Faculty of Pharmacy, Graduate School, Graduate School of Law)");
        serviceMap.put("WG", "Window G (Faculty of Arts and Letters, College of Rehabilitation Science)");
        serviceMap.put("WH", "Window H (College of Architecture, AMV-College of Accountancy)");
        serviceMap.put("WI", "Window I (Faculty of Engineering, College of Information and Computing Sciences)");
        serviceMap.put("WJ", "Window J (Enrollment Related Concerns, Cross Enrollment)");
        serviceMap.put("WK", "Window K (Honorable Dismissal, Transfer Credential)");
        serviceMap.put("WL", "Window L (Diploma, Certified True Copy)");
        serviceMap.put("WM", "Window M (CAV-DFA Apostille, Endorsement)");
        serviceMap.put("other", "Other");

        for (Survey survey : serviceScores) {
            String serviceValue = survey.getService();
            String serviceTitle = serviceMap.getOrDefault(serviceValue, "Other");
            csvBuilder.append("\"").append(serviceTitle).append("\"").append(",");
            csvBuilder.append(survey.getEvaluationCount()).append(",");
            csvBuilder.append(survey.getRating()).append("\n");
        }

        // Write CSV content to the response output stream
        response.getWriter().write(csvBuilder.toString());
        response.getWriter().flush();
    }
}
