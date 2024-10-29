package com.tigersign.controller;

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

import com.tigersign.dao.ClaimedRequestDetails;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.Base64;

import javax.servlet.ServletContext;

public class PDFGenerator {

    // Define the custom gray color
    private static final BaseColor CUSTOM_GRAY = new BaseColor(209, 209, 209);

    public static byte[] generateProofOfClaimPDF(ClaimedRequestDetails details, ServletContext context) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4, 20, 20, 20, 20);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, byteArrayOutputStream);
        document.open();

        // Create a table for the header with 3 columns
        PdfPTable headerTable = new PdfPTable(5);
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingBefore(10f);
        headerTable.setSpacingAfter(10f);

        // Load logos and create cells
        String logoPath1 = context.getRealPath("/resources/images/ust.png");
        String logoPath2 = context.getRealPath("/resources/images/registrar.png");

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

        // Combine UST and Registrar titles in a single cell with different font sizes
        String titleText = "UNIVERSITY OF SANTO TOMAS\n";
        String officeText = "OFFICE OF THE REGISTRAR\n";
        String proofText = "Proof of Claim Document";

        BaseColor titleColor = new BaseColor(48, 48, 48);
        
        Font titleFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 16, Font.NORMAL, titleColor); 
        Font officeFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL, titleColor);
        Font proofFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, Font.NORMAL, titleColor);

        // Create centered paragraphs
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

        // Add cells to the header table
        headerTable.addCell(logoCell1);
        headerTable.addCell(titleCell);
        headerTable.addCell(logoCell2);

        // Optionally, add a background color to the header
        headerTable.getDefaultCell().setBackgroundColor(new BaseColor(240, 240, 240));
        headerTable.setSpacingAfter(15f);

        // Add the header table to the document
        document.add(headerTable);

        document.add(new Paragraph("\n"));

        // Create a table for Transaction ID with 4 cells
        PdfPTable transactionIdTable = new PdfPTable(4);
        transactionIdTable.setWidthPercentage(100);
        transactionIdTable.addCell(createNormalCell("O.R. Number"));
        PdfPCell transactionIdCell = createCell(" #" + details.getOrNumber(), null);
        transactionIdCell.setColspan(3); 
        transactionIdCell.setPhrase(new Phrase(" #" + details.getOrNumber(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8)));
        transactionIdTable.addCell(transactionIdCell);
        document.add(transactionIdTable);
        document.add(new Paragraph("\n"));

        // Request Information Section
        PdfPTable requestInfoTable = new PdfPTable(4);
        requestInfoTable.setWidthPercentage(100);
        requestInfoTable.addCell(createCell("Request Information", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));
        requestInfoTable.addCell(createCell("", CUSTOM_GRAY));

        // Adding Name
        requestInfoTable.addCell(createNormalCell("Full Name"));
        PdfPCell nameCell = createCell(details.getRequesterName(), null);
        nameCell.setColspan(3);
        requestInfoTable.addCell(nameCell);

        // Adding Date of Payment
        requestInfoTable.addCell(createNormalCell("Date of Payment"));
        PdfPCell datePaymentCell = createCell(details.getDateProcessed(), null);
        datePaymentCell.setColspan(3);
        requestInfoTable.addCell(datePaymentCell);

        // Adding Requested Documents
        requestInfoTable.addCell(createNormalCell("Requested Documents"));
        PdfPCell requestedDocumentsCell = createCell(details.getRequestedDocuments(), null);
        requestedDocumentsCell.setColspan(3);
        requestInfoTable.addCell(requestedDocumentsCell);

        document.add(requestInfoTable);
        document.add(new Paragraph("\n"));

        // Claimer Information Section
        PdfPTable claimerInfoTable = new PdfPTable(4);
        claimerInfoTable.setWidthPercentage(100);
        claimerInfoTable.addCell(createCell("Claimer Information", CUSTOM_GRAY));
        claimerInfoTable.addCell(createCell("", CUSTOM_GRAY));
        claimerInfoTable.addCell(createCell("", CUSTOM_GRAY));
        claimerInfoTable.addCell(createCell("", CUSTOM_GRAY));

        // Adding Name
        claimerInfoTable.addCell(createNormalCell("Full Name"));
        PdfPCell claimerNameCell = createCell(details.getClaimerName(), null);
        claimerNameCell.setColspan(3);
        claimerInfoTable.addCell(claimerNameCell);

        // Adding Email
        claimerInfoTable.addCell(createNormalCell("Email"));
        PdfPCell emailCell = createCell(details.getClaimerEmail(), null);
        emailCell.setColspan(3);
        claimerInfoTable.addCell(emailCell);

        // Adding Date Claimed
        claimerInfoTable.addCell(createNormalCell("Date Claimed"));
        PdfPCell dateClaimedCell = createCell(details.getProofDate(), null);
        dateClaimedCell.setColspan(3);
        claimerInfoTable.addCell(dateClaimedCell);

        // Adding Role
        claimerInfoTable.addCell(createNormalCell("Role"));
        PdfPCell roleCell = createCell(details.getClaimerRole(), null);
        roleCell.setColspan(3);
        claimerInfoTable.addCell(roleCell);

        // Adding Released by
        claimerInfoTable.addCell(createNormalCell("Released by"));
        PdfPCell releasedByCell = createCell(details.getReleasedBy(), null);
        releasedByCell.setColspan(3);
        claimerInfoTable.addCell(releasedByCell);

        document.add(claimerInfoTable);
        
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("\n"));

        // Claimer Signature
        Paragraph authorizationTitle = new Paragraph(
            "Authorization for the Office of the Registrar\n", 
            FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLDITALIC | Font.UNDERLINE)
        );
        authorizationTitle.setSpacingBefore(10);
        authorizationTitle.setSpacingAfter(5);

        Chunk authorizationBody = new Chunk(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ac libero sit amet elit malesuada facilisis. " +
            "Curabitur tincidunt, sapien sed sollicitudin tincidunt, nisl nisl gravida purus, eu convallis urna justo vitae odio. " +
            "Sed non quam et ipsum vehicula auctor. Nulla facilisi. Suspendisse potenti. Sed egestas urna et massa fermentum, " +
            "non suscipit ex aliquet. Donec imperdiet leo non lectus pharetra, id congue erat ultricies. Fusce nec orci " +
            "sit amet magna suscipit suscipit. Aenean aliquet, nisl non cursus efficitur, velit orci ullamcorper justo, vitae " +
            "cursus metus sapien et libero.",
            FontFactory.getFont(FontFactory.HELVETICA, 10)
        );

        Paragraph authorizationParagraph = new Paragraph();
        authorizationParagraph.add(authorizationTitle);
        authorizationParagraph.add(authorizationBody);

        document.add(authorizationParagraph);
        
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("\n"));
        
        PdfPTable signatureTable = new PdfPTable(1);
        signatureTable.setWidthPercentage(100);
        signatureTable.setHorizontalAlignment(Element.ALIGN_RIGHT);

        PdfPTable nestedSignatureTable = new PdfPTable(1);
        nestedSignatureTable.setWidthPercentage(50); 
        nestedSignatureTable.setHorizontalAlignment(Element.ALIGN_RIGHT); 

        // Signature Image (optional)
        if (details.getSignatureBase64() != null && !details.getSignatureBase64().isEmpty()) {
            byte[] signatureBytes = Base64.getDecoder().decode(details.getSignatureBase64());
            Image signatureImage = Image.getInstance(signatureBytes);
            signatureImage.scaleToFit(250, 80); 
            PdfPCell signatureImageCell = new PdfPCell(signatureImage);
            signatureImageCell.setBorder(PdfPCell.NO_BORDER);
            signatureImageCell.setHorizontalAlignment(Element.ALIGN_CENTER); 
            nestedSignatureTable.addCell(signatureImageCell);
        }

        // Claimer's Name
        PdfPCell signNameCell = new PdfPCell(new Phrase(details.getClaimerName().toUpperCase(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
        signNameCell.setBorder(PdfPCell.NO_BORDER);
        signNameCell.setPaddingBottom(0);  
        signNameCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        nestedSignatureTable.addCell(signNameCell);

        // Line
        PdfPCell lineCell = new PdfPCell(new Phrase("__________________________________________", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
        lineCell.setBorder(PdfPCell.NO_BORDER);
        lineCell.setPaddingTop(0);
        lineCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        nestedSignatureTable.addCell(lineCell);

        // Signature note
        PdfPCell signatureNoteCell = new PdfPCell(new Phrase("Signature of Candidate over Printed Name", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC)));
        signatureNoteCell.setBorder(PdfPCell.NO_BORDER);
        signatureNoteCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        nestedSignatureTable.addCell(signatureNoteCell);

        Chunk dateLabel = new Chunk("Date: ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC));
        Chunk dateValue = new Chunk(getCurrentDate(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD));

        Phrase datePhrase = new Phrase();
        datePhrase.add(dateLabel);
        datePhrase.add(dateValue);

        PdfPCell dateCell = new PdfPCell(datePhrase);
        dateCell.setBorder(PdfPCell.NO_BORDER);
        dateCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        nestedSignatureTable.addCell(dateCell);

        PdfPCell signatureContainerCell = new PdfPCell();
        signatureContainerCell.addElement(nestedSignatureTable);
        signatureContainerCell.setBorder(PdfPCell.NO_BORDER);
        signatureContainerCell.setHorizontalAlignment(Element.ALIGN_RIGHT); 
        signatureTable.addCell(signatureContainerCell);

        // Add the signature table to the document
        document.add(signatureTable);
        
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("\n"));
        
        // Note section
        Paragraph noteTitle = new Paragraph(
            "Note:\n", 
            FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLDITALIC | Font.UNDERLINE)
        );
        noteTitle.setSpacingBefore(10);
        noteTitle.setSpacingAfter(5); 

        Chunk noteBody = new Chunk(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum. " +
            "Vestibulum ac est lacinia nisi venenatis tristique. Proin laoreet, nunc ut congue tincidunt, arcu " +
            "odio congue libero, a posuere felis odio vitae elit. Sed condimentum, turpis et imperdiet tempus, justo " +
            "est feugiat quam, et pellentesque dui justo eu libero. Aliquam erat volutpat. Fusce sed urna id dui varius " +
            "imperdiet. Nam volutpat, nulla nec euismod vestibulum, risus libero bibendum risus, et commodo nunc risus et justo.",
            FontFactory.getFont(FontFactory.HELVETICA, 10)
        );

        Paragraph noteParagraph = new Paragraph();
        noteParagraph.add(noteTitle);
        noteParagraph.add(noteBody);

        document.add(noteParagraph);

        document.close();
        return byteArrayOutputStream.toByteArray();
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

    private static PdfPCell createNormalCell(String content) {
        PdfPCell cell = new PdfPCell(new Phrase(content, FontFactory.getFont(FontFactory.HELVETICA, 8))); 
        cell.setPadding(3);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }
    
    private static String getCurrentDate() {
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
        return today.format(formatter);
    }
}
