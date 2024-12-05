import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import com.itextpdf.text.Image;

import java.awt.Color;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.renderer.category.BarRenderer;

@WebServlet("/ReportGeneratorServlet")
public class ReportGeneratorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String format = request.getParameter("format");
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        String claimedCount = request.getParameter("claimedCount");
        String[] documentTypesArray = request.getParameterValues("documentTypes");
        String[] documentCountsArray = request.getParameterValues("documentCounts");
        String[] documentAvgProcessingHoursArray = request.getParameterValues("documentAvgProcessingHours");
    
        List<String> documentTypes = documentTypesArray != null ? Arrays.asList(documentTypesArray) : new ArrayList<>();
        List<Integer> documentCounts = documentCountsArray != null ?
            Arrays.stream(documentCountsArray).map(Integer::parseInt).collect(Collectors.toList()) : new ArrayList<>();
        List<Double> documentAvgProcessingHours = documentAvgProcessingHoursArray != null ?
            Arrays.stream(documentAvgProcessingHoursArray).map(Double::parseDouble).collect(Collectors.toList()) : new ArrayList<>();
        
        
        if ("pdf".equalsIgnoreCase(format)) {
            try {
                generatePDFReport(response, filterType, filterValue, claimedCount, documentTypes, documentCounts, documentAvgProcessingHours);
            } catch (DocumentException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF report");
            }
        } else if ("csv".equalsIgnoreCase(format)) {
            generateCSVReport(response, filterType, filterValue, claimedCount, documentTypes, documentCounts, documentAvgProcessingHours);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report format");
        }
    }

    private static final BaseColor CUSTOM_GRAY = new BaseColor(209, 209, 209);
    private static final BaseColor CUSTOM_LIGHTER_GRAY = new BaseColor(240, 240, 240);

    private void generatePDFReport(HttpServletResponse response, String filterType, String filterValue, 
                                   String claimedCount, List<String> documentTypes, 
                                   List<Integer> documentCounts, List<Double> documentAvgProcessingHours) 
                                   throws IOException, DocumentException {
        String sanitizedFilterValue = (filterValue == null || filterValue.isEmpty()) 
            ? "All_Data" 
            : filterValue.replaceAll("[^a-zA-Z0-9-_]", "_");

        String filename = "document_report_" + sanitizedFilterValue + ".pdf";

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

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
        String proofText = "TigerSign - Document Report";

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
        filterValueTable.addCell(createCell("Filter Type:", null));
        filterValueTable.addCell(createCell(readableType, null));
        filterValueTable.addCell(createCell("Filter Value:", null));
        filterValueTable.addCell(createCell(displayValue, null));
        document.add(filterValueTable);

        document.add(new Paragraph("\n"));

        // Claimed Requests Section
        PdfPTable requestInfoTable = new PdfPTable(4);
        requestInfoTable.setWidthPercentage(100);
        requestInfoTable.addCell(createCell("Claimed Request", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));
        
        requestInfoTable.addCell(createNormalCell("Total Claimed"));
        PdfPCell claimCell = createCell(claimedCount + " request/s", null);
        claimCell.setColspan(3);
        requestInfoTable.addCell(claimCell);
        document.add(requestInfoTable);

        document.add(new Chunk(line));
        
        document.add(new Paragraph("\n"));

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (int i = 0; i < documentTypes.size(); i++) {
            dataset.addValue(documentCounts.get(i), "Total Releases", documentTypes.get(i));
            dataset.addValue(documentAvgProcessingHours.get(i) / 24.0, "Avg Processing Time (days)", documentTypes.get(i)); 
        }

        JFreeChart barChart = ChartFactory.createBarChart(
            "Average Processing Time of Documents",
            "Document Type",
            "Values",
            dataset,
            PlotOrientation.HORIZONTAL,
            true,
            true,
            false
        );

        CategoryPlot plot = barChart.getCategoryPlot();
        plot.setRangeGridlinePaint(java.awt.Color.BLACK);
        plot.setBackgroundPaint(Color.WHITE);
        
        BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setMaximumBarWidth(0.04); 
        renderer.setItemMargin(0.02); 
        
        renderer.setSeriesPaint(0, new java.awt.Color(244, 187, 0));  
        renderer.setSeriesPaint(1, new java.awt.Color(59, 131, 251));
        
        NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
        rangeAxis.setAutoRangeIncludesZero(true);
        rangeAxis.setTickUnit(new org.jfree.chart.axis.NumberTickUnit(1)); 

        java.awt.image.BufferedImage chartImage = barChart.createBufferedImage(800, 800);
        ByteArrayOutputStream chartOutputStream = new ByteArrayOutputStream();
        javax.imageio.ImageIO.write(chartImage, "png", chartOutputStream);
        byte[] chartBytes = chartOutputStream.toByteArray();
        Image chartPdfImage = Image.getInstance(chartBytes);

        chartPdfImage.scaleToFit(550, 700);
        document.add(chartPdfImage);
            
        document.close();

        // Write the PDF to the response output stream for direct download
        response.getOutputStream().write(byteArrayOutputStream.toByteArray());
        response.getOutputStream().flush();
        response.getOutputStream().close();
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
        cell.setPadding(4);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }

    private void generateCSVReport(HttpServletResponse response, String filterType, String filterValue, String claimedCount,
                                       List<String> documentTypes, List<Integer> documentCounts, List<Double> documentAvgProcessingHours) 
                                       throws IOException {
        response.setContentType("text/csv");

        // Sanitize the filter value to be used in the filename
        String sanitizedFilterValue = (filterValue == null || filterValue.isEmpty()) ? "All_Data" 
                                         : filterValue.replaceAll("[^a-zA-Z0-9-_]", "_");
        String filename = "document_report_" + sanitizedFilterValue + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        StringBuilder csvBuilder = new StringBuilder();
        
        csvBuilder.append("=== TIGERSIGN - DOCUMENT REPORT ===\n\n");
        
        csvBuilder.append("=== Filter Information ===\n\n");

        // Filter Information Section
        csvBuilder.append("Type:,").append((filterType == null || filterType.isEmpty()) ? "All Data" : filterType).append("\n");
        csvBuilder.append("Value:,").append((filterValue == null || filterValue.isEmpty()) ? "All Data" : filterValue).append("\n\n");

        // Claimed Requests Section
        csvBuilder.append("=== Claimed Requests ===\n\n");
        csvBuilder.append("Total Claimed,").append(claimedCount).append(" request/s\n\n");

        // Average Processing Time Section
        csvBuilder.append("=== Average Processing Time of Documents ===\n\n");

        // Document Info Section
        csvBuilder.append("Document Type*, Total Release*, Average Processing Time (hrs)*\n");
        for (int i = 0; i < documentTypes.size(); i++) {
            String documentTypeEscaped = "\"" + documentTypes.get(i) + "\"";
            csvBuilder.append(documentTypeEscaped).append(",")
                      .append(documentCounts.get(i)).append(",")
                      .append(String.format("%.2f", documentAvgProcessingHours.get(i))).append("\n");
        }

        // Output the CSV content to the response
        response.getWriter().write(csvBuilder.toString());
    }
}
