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

import com.tigersign.dao.Survey;
import com.tigersign.dao.SurveyDAO;

import java.awt.Color;
import java.awt.Paint;
import java.awt.image.BufferedImage;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import java.text.AttributedString;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.labels.PieSectionLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot3D;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.RingPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

@WebServlet("/AnalyticsGeneratorServlet")
public class AnalyticsGeneratorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String format = request.getParameter("format");
        String filterType = request.getParameter("filterType");
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

    private void generatePDFAnalytics(HttpServletResponse response, SurveyDAO surveyDAO, String filterType, String filterValue) 
            throws IOException, DocumentException {
            
            String sanitizedFilterValue = (filterValue == null || filterValue.isEmpty()) ? "All_Data" 
                                         : filterValue.replaceAll("[^a-zA-Z0-9-_]", "_");
            String filename = "survey_analytics_" + sanitizedFilterValue + ".pdf";
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
         
         // Add horizontal line 
         LineSeparator line = new LineSeparator();
         line.setLineWidth(0.5f);
         line.setLineColor(new BaseColor(204, 204, 204));
         document.add(new Chunk(line));
         
         document.add(new Paragraph("\n"));
         
         String readableType = "All Data";
         String displayValue = "All Data";
         SimpleDateFormat inputFormat;
         SimpleDateFormat outputFormat;

         if (filterType != null && !filterType.isEmpty()) {
             switch (filterType) {
                 case "day":
                     readableType = "By Day";
                     inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                     outputFormat = new SimpleDateFormat("dd MMM yyyy");
                     try {
                         displayValue = outputFormat.format(inputFormat.parse(filterValue));
                     } catch (ParseException e) {
                         displayValue = "Invalid Date";
                     }
                     break;
                 case "month":
                     readableType = "By Month";
                     inputFormat = new SimpleDateFormat("yyyy-MM");
                     outputFormat = new SimpleDateFormat("MMMM yyyy");
                     try {
                         displayValue = outputFormat.format(inputFormat.parse(filterValue));
                     } catch (ParseException e) {
                         displayValue = "Invalid Month Format";
                     }
                     break;
                 case "range":
                     readableType = "Date Range";
                     inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                     outputFormat = new SimpleDateFormat("dd MMM yyyy");
                     try {
                         String[] range = filterValue.split(",");
                         String start = outputFormat.format(inputFormat.parse(range[0]));
                         String end = outputFormat.format(inputFormat.parse(range[1]));
                         displayValue = start + " to " + end;
                     } catch (ParseException e) {
                         displayValue = "Invalid Date Range";
                     }
                     break;
                 case "year":
                     readableType = "By Year";
                     displayValue = filterValue;
                     break;
                 default:
                     readableType = "Unknown Filter";
                     displayValue = filterValue;
                     break;
             }
         }

         PdfPTable filterValueTable = new PdfPTable(4);
         filterValueTable.setWidthPercentage(100);
         filterValueTable.addCell(createCell2("Filter Type:", null));
         filterValueTable.addCell(createCell2(readableType, null));
         filterValueTable.addCell(createCell2("Filter Value:", null));
         filterValueTable.addCell(createCell2(displayValue, null));
         document.add(filterValueTable);
         
         document.add(new Paragraph("\n"));
         
         // Claimed Requests Section
         PdfPTable evaluationInfoTable = new PdfPTable(4);
         evaluationInfoTable.setWidthPercentage(100);
         evaluationInfoTable.addCell(createCell2("Survey & Evaluation", CUSTOM_GRAY));
         evaluationInfoTable.addCell(createCell2("", CUSTOM_GRAY));
         evaluationInfoTable.addCell(createCell2("", CUSTOM_GRAY));
         evaluationInfoTable.addCell(createCell2("", CUSTOM_GRAY));
         
         evaluationInfoTable.addCell(createNormalCell("Total Responses"));
         PdfPCell claimCell = createCell2(surveyDAO.getEvaluationReceivedCount(filterType, filterValue) + " evaluation/s", null);
         claimCell.setColspan(3);
         evaluationInfoTable.addCell(claimCell);
         document.add(evaluationInfoTable);
         
         document.add(new Chunk(line));

         double averageScore = surveyDAO.getAverageScore(filterType, filterValue);

         DefaultPieDataset ringDataset = new DefaultPieDataset();
         ringDataset.setValue("Score", averageScore);
         ringDataset.setValue("Remaining", 4 - averageScore);

         RingPlot ringPlot = new RingPlot(ringDataset);

         ringPlot.setSectionPaint("Score", 
             averageScore <= 2 
                 ? new Color(217, 83, 79) 
                 : (averageScore <= 3.5 
                     ? new Color(244, 187, 0) 
                     : new Color(28, 132, 84)) 
         );
         ringPlot.setSectionPaint("Remaining", new Color(200, 200, 200)); 

         ringPlot.setBackgroundPaint(Color.WHITE);
         ringPlot.setOutlineVisible(false);
         ringPlot.setSeparatorPaint(Color.WHITE);
         ringPlot.setSectionDepth(0.35);
         ringPlot.setInnerSeparatorExtension(0.02);
         ringPlot.setOuterSeparatorExtension(0.02);
         ringPlot.setCircular(true);

         // Remove legend and labels
         ringPlot.setSimpleLabels(false);
         ringPlot.setLabelGenerator(null);

         // Create a chart
         JFreeChart ringChart = new JFreeChart(
             "Overall Average Score",
             JFreeChart.DEFAULT_TITLE_FONT,
             ringPlot,
             false
         );

         ringChart.setBackgroundPaint(Color.WHITE);

         int ringChartWidth = 400;
         int ringChartHeight = 400;
         BufferedImage ringChartImage = ringChart.createBufferedImage(ringChartWidth, ringChartHeight);
         ByteArrayOutputStream ringChartOut = new ByteArrayOutputStream();
         ImageIO.write(ringChartImage, "png", ringChartOut);

         // Add the chart image to the PDF
         Image ringChartPdfImage = Image.getInstance(ringChartOut.toByteArray());
         ringChartPdfImage.setAlignment(Element.ALIGN_CENTER);
         
         Map<String, Integer> standoutCounts = new HashMap<>();
         standoutCounts.put("Response Time", surveyDAO.getStandoutCount("response", filterType, filterValue));
         standoutCounts.put("Accuracy of Information", surveyDAO.getStandoutCount("accuracy", filterType, filterValue));
         standoutCounts.put("Helpful", surveyDAO.getStandoutCount("helpful", filterType, filterValue));
         standoutCounts.put("Respectful", surveyDAO.getStandoutCount("respect", filterType, filterValue));

         int totalResponses = surveyDAO.getTotalCount(filterType, filterValue);

         standoutCounts.put("Other", totalResponses 
             - (standoutCounts.get("Response Time") 
                + standoutCounts.get("Accuracy of Information") 
                + standoutCounts.get("Helpful") 
                + standoutCounts.get("Respectful")));

         StringBuilder standoutData = new StringBuilder("[");
         StringBuilder standoutLabels = new StringBuilder("[");

         for (Map.Entry<String, Integer> entry : standoutCounts.entrySet()) {
             standoutLabels.append("\"").append(entry.getKey()).append("\",");
             standoutData.append(entry.getValue()).append(",");
         }

         if (standoutLabels.length() > 1) {
             standoutLabels.setLength(standoutLabels.length() - 1);
             standoutData.setLength(standoutData.length() - 1);
         }
         standoutLabels.append("]");
         standoutData.append("]");

         JFreeChart pieChart3D = ChartFactory.createPieChart3D(
             "User Preference for Outstanding Services",
             createPieDataset(standoutCounts),
             true,
             true,
             false
         );

         pieChart3D.setBackgroundPaint(Color.WHITE);

         PiePlot3D plot3D = (PiePlot3D) pieChart3D.getPlot();
         plot3D.setBackgroundPaint(Color.WHITE);
         plot3D.setOutlineVisible(false);

         plot3D.setSectionPaint("Respectful", new Color(244, 187, 0));
         plot3D.setSectionPaint("Accuracy of Information", new Color(59, 131, 251));
         plot3D.setSectionPaint("Response Time", new Color(217, 83, 79));
         plot3D.setSectionPaint("Helpful", new Color(28, 132, 84));
         plot3D.setSectionPaint("Other", new Color(26, 26, 26));

         plot3D.setLabelGenerator(new PieSectionLabelGenerator() {
             @Override
             public String generateSectionLabel(PieDataset dataset, Comparable key) {
                 Number value = dataset.getValue(key);
                 if (value != null && value.doubleValue() > 0) {
                     return key + ": " + value + " responses";
                 }
                 return null;
             }

             @Override
             public AttributedString generateAttributedSectionLabel(PieDataset dataset, Comparable key) {
                 return null;
             }
         });

         plot3D.setForegroundAlpha(0.6f);
         plot3D.setDepthFactor(0.1);
         plot3D.setCircular(false);

         int width = 400;
         int height = 400;
         BufferedImage chartImage = pieChart3D.createBufferedImage(width, height);
         ByteArrayOutputStream chartOut = new ByteArrayOutputStream();
         ImageIO.write(chartImage, "png", chartOut);

         Image chartPdfImage = Image.getInstance(chartOut.toByteArray());
         chartPdfImage.setAlignment(Element.ALIGN_CENTER);

         PdfPTable chartsTable = new PdfPTable(2);
         chartsTable.setWidthPercentage(100);
         chartsTable.setSpacingBefore(10f);
         chartsTable.setSpacingAfter(10f);

         ringChartPdfImage.scaleToFit(200, 200);
         chartPdfImage.scaleToFit(200, 200);

         PdfPCell ringChartCell = new PdfPCell(ringChartPdfImage);
         ringChartCell.setBorder(PdfPCell.NO_BORDER);
         ringChartCell.setHorizontalAlignment(Element.ALIGN_CENTER);

         PdfPCell pieChartCell = new PdfPCell(chartPdfImage);
         pieChartCell.setBorder(PdfPCell.NO_BORDER);
         pieChartCell.setHorizontalAlignment(Element.ALIGN_CENTER);

         chartsTable.addCell(ringChartCell);
         chartsTable.addCell(pieChartCell);

         document.add(chartsTable);
         
         document.add(new Chunk(line));
         
         List<Survey> serviceScores = surveyDAO.getServiceWindowScores(filterType, filterValue);

         DefaultCategoryDataset barDataset = new DefaultCategoryDataset();

         for (Survey survey : serviceScores) {
             String serviceValue = survey.getService();
             String serviceLabel;

             switch (serviceValue) {
                 case "IW": serviceLabel = "IW"; break;
                 case "WA": serviceLabel = "WA"; break;
                 case "WB": serviceLabel = "WB"; break;
                 case "WC": serviceLabel = "WC"; break;
                 case "WD": serviceLabel = "WD"; break;
                 case "WE": serviceLabel = "WE"; break;
                 case "WF": serviceLabel = "WF"; break;
                 case "WG": serviceLabel = "WG"; break;
                 case "WH": serviceLabel = "WH"; break;
                 case "WI": serviceLabel = "WI"; break;
                 case "WJ": serviceLabel = "WJ"; break;
                 case "WK": serviceLabel = "WK"; break;
                 case "WL": serviceLabel = "WL"; break;
                 case "WM": serviceLabel = "WM"; break;
                 default: serviceLabel = "Other"; break;
             }

             barDataset.addValue(survey.getWindowRating(), "Average Score", serviceLabel);
         }

         JFreeChart barChart = ChartFactory.createBarChart(
             "Service Window Ratings",
             "Service",
             "Average Score",
             barDataset,
             PlotOrientation.VERTICAL,
             true, true, false
         );

         CategoryPlot barPlot = barChart.getCategoryPlot();
         barPlot.setRangeGridlinePaint(Color.BLACK);
         barPlot.setBackgroundPaint(Color.WHITE);

         BarRenderer renderer = new BarRenderer() {
             @Override
             public Paint getItemPaint(int row, int column) {
                 double rating = barDataset.getValue(row, column).doubleValue();
                 if (rating >= 1 && rating <= 2) {
                     return new Color(217, 83, 79);
                 } else if (rating > 2 && rating <= 3.5) {
                     return new Color(244, 187, 0);
                 } else if (rating > 3.5 && rating <= 4) {
                     return new Color(28, 132, 84);
                 }
                 return Color.GRAY;
             }
         };

         barPlot.setRenderer(renderer);
         renderer.setMaximumBarWidth(0.05);
         renderer.setItemMargin(0.02);

         int barChartWidth = 800;
         int barChartHeight = 400;
         BufferedImage barChartImage = barChart.createBufferedImage(barChartWidth, barChartHeight);
         ByteArrayOutputStream barChartOut = new ByteArrayOutputStream();
         ImageIO.write(barChartImage, "png", barChartOut);

         Image barChartPdfImage = Image.getInstance(barChartOut.toByteArray());
         barChartPdfImage.scaleToFit(500, 250);
         barChartPdfImage.setAlignment(Element.ALIGN_CENTER);

         PdfPTable barChartTable = new PdfPTable(1);
         barChartTable.setWidthPercentage(100);
         PdfPCell barChartCell = new PdfPCell(barChartPdfImage);
         barChartCell.setBorder(PdfPCell.NO_BORDER);
         barChartCell.setHorizontalAlignment(Element.ALIGN_CENTER);
         barChartTable.addCell(barChartCell);

         document.add(barChartTable);

         List<Survey> surveys = surveyDAO.getAllSurveys(filterType, filterValue);

                 if (!surveys.isEmpty()) {

                     document.newPage();

                     Font feedbackTitleFont = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD, BaseColor.BLACK);
                     Paragraph feedbackTitle = new Paragraph("Customer Feedbacks", feedbackTitleFont);
                     feedbackTitle.setAlignment(Element.ALIGN_LEFT);
                     document.add(feedbackTitle);
                     
                     document.add(new Paragraph("\n"));

                     PdfPTable feedbackTable = new PdfPTable(10); 
                     feedbackTable.setWidthPercentage(100);
                     feedbackTable.setSpacingBefore(10f);
                     feedbackTable.setSpacingAfter(10f);

                     PdfPCell nameCell = createCell("Name", new BaseColor(244, 187, 0));
                     nameCell.setColspan(2);  
                     feedbackTable.addCell(nameCell);
                     PdfPCell dateCell = createCell("Date", new BaseColor(244, 187, 0));
                     dateCell.setColspan(2);
                     feedbackTable.addCell(dateCell);
                     PdfPCell rateCell = createCell("Rating", new BaseColor(244, 187, 0));
                     rateCell.setColspan(1);      
                     rateCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                     feedbackTable.addCell(rateCell);
                     PdfPCell feedCell = createCell("Feedback", new BaseColor(244, 187, 0));
                     feedCell.setColspan(5);  
                     feedbackTable.addCell(feedCell);

                     int rowIndex = 0;
                     for (Survey survey : surveys) {
                         BaseColor backgroundColor = (rowIndex % 2 == 0) ? null : new BaseColor(240, 240, 240);
                         PdfPCell nameCell1 = createCell1(survey.getName(), backgroundColor);
                         nameCell1.setColspan(2);  
                         feedbackTable.addCell(nameCell1);
                         
                         PdfPCell dateCell1 = createCell1(survey.getDate(), backgroundColor);
                         dateCell1.setColspan(2);
                         feedbackTable.addCell(dateCell1);
                         
                         PdfPCell rateCell1 = createCell1(String.valueOf(survey.getRating()), backgroundColor);
                         rateCell1.setColspan(1);
                         rateCell1.setHorizontalAlignment(Element.ALIGN_CENTER);
                         feedbackTable.addCell(rateCell1);
                         
                         String feedback = survey.getFeedback();
                         if (feedback != null && !feedback.isEmpty()) {
                             PdfPCell feedCell1 = createCell1(feedback, backgroundColor);
                             feedCell1.setColspan(5);
                             feedbackTable.addCell(feedCell1);
                         }
                         
                         rowIndex++;
                     }

                     document.add(feedbackTable);
                 }

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
     
     private static PieDataset createPieDataset(Map<String, Integer> data) {
         DefaultPieDataset dataset = new DefaultPieDataset();
         for (Map.Entry<String, Integer> entry : data.entrySet()) {
             dataset.setValue(entry.getKey(), entry.getValue());
         }
         return dataset;
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
    
        csvBuilder.append("\n\n=== Customer Feedbacks ===\n\n");
        csvBuilder.append("Name,,,Date,Rating,Feedback\n"); 

        List<Survey> surveys = surveyDAO.getAllSurveys(filterType, filterValue);
        for (Survey survey : surveys) {
            String feedback = survey.getFeedback();
            if (feedback == null || feedback.isEmpty()) {
                continue;
            }
            csvBuilder.append("\"").append(survey.getName()).append("\",,,");

            csvBuilder.append("\"").append(survey.getDate()).append("\",");
            csvBuilder.append(survey.getRating()).append(",");
            csvBuilder.append("\"").append(feedback).append("\"\n");
        }

        response.getWriter().write(csvBuilder.toString());
        response.getWriter().flush();
    }
}
