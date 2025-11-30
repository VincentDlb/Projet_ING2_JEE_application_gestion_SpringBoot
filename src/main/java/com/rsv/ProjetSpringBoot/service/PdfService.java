package com.rsv.ProjetSpringBoot.service;

import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.rsv.ProjetSpringBoot.model.FicheDePaie;
import com.rsv.ProjetSpringBoot.model.Statistiques;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class PdfService {

    // Logique extraite de GeneratePdfServlet
    public byte[] genererFicheDePaiePdf(FicheDePaie fiche) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        // --- Copie ici la logique de création du document de ton GeneratePdfServlet ---
        // J'allège le code pour l'exemple, mais tu remets tes Paragraph, Table, etc.
        document.add(new Paragraph("BULLETIN DE PAIE").setFontSize(18).setBold());
        document.add(new Paragraph("Employé: " + fiche.getEmploye().getNom()));
        document.add(new Paragraph("Net à payer: " + fiche.getNetAPayer() + " €"));
        
        document.close();
        return baos.toByteArray();
    }

    // Logique extraite de ExportStatistiquesPdfServlet
    public byte[] genererStatistiquesPdf(Statistiques stats) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        document.add(new Paragraph("RAPPORT STATISTIQUES ROWTECH").setFontSize(20).setBold());
        
        // Tableau Vue d'ensemble
        Table table = new Table(UnitValue.createPercentArray(new float[]{1, 1}));
        table.addCell("Total Employés");
        table.addCell(String.valueOf(stats.getTotalEmployes()));
        table.addCell("Masse Salariale");
        table.addCell(String.valueOf(stats.getMasseSalarialeTotal()));
        
        document.add(table);
        
        document.close();
        return baos.toByteArray();
    }
}