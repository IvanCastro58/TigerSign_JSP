import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
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
import com.itextpdf.text.pdf.draw.LineSeparator;

import com.tigersign.dao.AuditDetail;
import com.tigersign.dao.AuditLog;
import com.tigersign.dao.AuditLogDAO;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LogsGeneratorServlet")
public class LogsGeneratorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String format = request.getParameter("format");
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        
        List<AuditLog> auditList;
        try {
            AuditLogDAO auditDAO = new AuditLogDAO();
            auditList = auditDAO.getAllAudits(); 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error loading audit logs");
            return;
        }

        try {
            if ("pdf".equalsIgnoreCase(format)) {
                generatePDFAnalytics(response, auditList);
            } else if ("csv".equalsIgnoreCase(format)) {
                generateCSVReport(response, auditList);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                                   "Invalid report format");
            }
        } catch (DocumentException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error generating report");
        }
    }

    
    private static final BaseColor CUSTOM_GRAY = new BaseColor(209, 209, 209);

    private void generatePDFAnalytics(HttpServletResponse response, List<AuditLog> auditList)
            throws IOException, DocumentException {
            
         String filename = "Audit_Logs.pdf";
         response.setContentType("application/pdf");
         response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
    
         ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
         Document document = new Document(PageSize.A4, 20, 20, 20, 20);
         PdfWriter.getInstance(document, byteArrayOutputStream);

         document.open();

         PdfPTable headerTable = new PdfPTable(5);
         headerTable.setWidthPercentage(100);
         headerTable.setSpacingBefore(10f);
         headerTable.setSpacingAfter(10f);

         String contextRoot = "http://127.0.0.1:7101/TigerSign-ViewController-context-root";
//         String contextRoot = "https://registrarbeta.ust.edu.ph/tigersign";
         String logoPath1 = contextRoot + "/resources/images/ust.png";
         String logoPath2 = contextRoot + "/resources/images/registrar.png";

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
         String proofText = "TigerSign - Audit Logs";

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
         
         LineSeparator line = new LineSeparator();
         line.setLineWidth(0.5f);
         line.setLineColor(new BaseColor(204, 204, 204));
         document.add(new Chunk(line));
         
         document.add(new Paragraph("\n"));
         
         PdfPTable dateGeneratedTable = new PdfPTable(4);
         dateGeneratedTable.setWidthPercentage(100);
         dateGeneratedTable.addCell(createCell2("Date Generated:", null));

         SimpleDateFormat dateTodayFormat = new SimpleDateFormat("MMM dd, yyyy");
         String todayDate = dateTodayFormat.format(new Date());
         dateGeneratedTable.addCell(createCell2(todayDate, null));
         dateGeneratedTable.addCell(createCell2("", null));
         dateGeneratedTable.addCell(createCell2("", null));
         document.add(dateGeneratedTable);
         
         document.add(new Paragraph("\n"));
         
         PdfPTable table = new PdfPTable(4);
         table.setWidthPercentage(100);
         table.setSpacingBefore(15f);
         table.setWidths(new float[] {4, 2, 7, 2});

         table.addCell(createCell("Performed by", new BaseColor(244, 187, 0)));
         table.addCell(createCell("Activity", new BaseColor(244, 187, 0)));
         table.addCell(createCell("Details", new BaseColor(244, 187, 0)));
         table.addCell(createCell("Date & Time", new BaseColor(244, 187, 0)));

         int rowIndex = 0;
         for (AuditLog audit : auditList) {
             String nameAndPosition = (audit.getFirstName() != null ? audit.getFirstName() : "Unknown") +
                                      " " +
                                      (audit.getLastName() != null ? audit.getLastName() : "User") +
                                      "\n" +
                                      (audit.getPosition() != null ? audit.getPosition() : "Super Admin");

             String activity = audit.getActivity() != null ? audit.getActivity() : "N/A";

             StringBuilder details = new StringBuilder();
             for (AuditDetail detail : audit.getDetails()) {
                 details.append(detail.getKey()).append(": ").append(detail.getValue()).append(" | ");
             }
             if (details.length() > 0) {
                 details.setLength(details.length() - 3);
             }

             String dateTime = "";
             if (audit.getActivityDateTime() != null) {
                 java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd yyyy");
                 java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm");
                 dateTime = dateFormat.format(audit.getActivityDateTime()) +
                            "\n" +
                            timeFormat.format(audit.getActivityDateTime());
             } else {
                 dateTime = "N/A";
             }

             BaseColor backgroundColor = (rowIndex % 2 == 0) ? null : new BaseColor(240, 240, 240);

             PdfPCell nameCell1 = createCell1(nameAndPosition, backgroundColor);
             nameCell1.setColspan(1);
             nameCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
             table.addCell(nameCell1);

             PdfPCell activityCell1 = createCell1(activity, backgroundColor);
             activityCell1.setColspan(1);
             activityCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
             table.addCell(activityCell1);

             PdfPCell detailsCell1 = createCell1(details.toString(), backgroundColor);
             detailsCell1.setColspan(1);
             detailsCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
             table.addCell(detailsCell1);

             PdfPCell dateTimeCell1 = createCell1(dateTime, backgroundColor);
             dateTimeCell1.setColspan(1);
             dateTimeCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
             table.addCell(dateTimeCell1);

             rowIndex++;
         }

         document.add(table);

         document.close();
                 
         response.getOutputStream().write(byteArrayOutputStream.toByteArray());
         response.getOutputStream().flush();
     }

     private static PdfPCell createCell(String content, BaseColor backgroundColor) {
         PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8)));
         if (backgroundColor != null) {
             cell.setBackgroundColor(backgroundColor);
         }
         cell.setPadding(10);
         cell.setHorizontalAlignment(Element.ALIGN_LEFT);
         cell.setBorder(PdfPCell.NO_BORDER);
         return cell;
     }
     
    private static PdfPCell createCell1(String content, BaseColor backgroundColor) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA, 8)));
        if (backgroundColor != null) {
            cell.setBackgroundColor(backgroundColor);
        }
        cell.setPadding(8);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
    
    private static PdfPCell createCell2(String content, BaseColor backgroundColor) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8)));
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
        cell.setPadding(4);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
     
    
    private void generateCSVReport(HttpServletResponse response, List<AuditLog> auditList) throws IOException {
        String filename = "Audit_Logs.csv";
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        StringBuilder csvBuilder = new StringBuilder();
        
        csvBuilder.append("Name,Position,Activity,Activity Details,Date,Time\n");

        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

        for (AuditLog audit : auditList) {
            String name = (audit.getFirstName() != null ? audit.getFirstName() : "Unknown") +
                          " " +
                          (audit.getLastName() != null ? audit.getLastName() : "User");
            String position = audit.getPosition() != null ? audit.getPosition() : "Super Admin";
            String activity = audit.getActivity() != null ? audit.getActivity() : "N/A";
            
            StringBuilder activityDetails = new StringBuilder();
            for (AuditDetail detail : audit.getDetails()) {
                activityDetails.append(detail.getKey()).append(": ").append(detail.getValue()).append(" | ");
            }
            if (activityDetails.length() > 0) {
                activityDetails.setLength(activityDetails.length() - 3);
            }

            String date = "";
            String time = "";
            if (audit.getActivityDateTime() != null) {
                date = dateFormat.format(audit.getActivityDateTime());
                time = timeFormat.format(audit.getActivityDateTime());
            }

            csvBuilder.append(name).append(",")
                      .append(position).append(",")
                      .append(activity).append(",")
                      .append(activityDetails.toString()).append(",")
                      .append(date).append(",")
                      .append(time).append("\n");
        }

        response.getWriter().write(csvBuilder.toString());
        response.getWriter().flush();
    }
}
