package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.Statistiques;
import com.rsv.ProjetSpringBoot.service.PdfService;
import com.rsv.ProjetSpringBoot.service.StatistiquesService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/statistiques")
public class StatistiquesController {

    private final StatistiquesService statistiquesService;
    private final PdfService pdfService;

    public StatistiquesController(StatistiquesService statistiquesService, PdfService pdfService) {
        this.statistiquesService = statistiquesService;
        this.pdfService = pdfService;
    }

    @GetMapping
    public String afficherStatistiques(Model model) {
        Statistiques stats = statistiquesService.getStatistiquesGlobales();
        model.addAttribute("statistiques", stats);
        return "statistiques"; // statistiques.jsp
    }

    @GetMapping("/export-pdf")
    public void exportPdf(HttpServletResponse response) {
        try {
            Statistiques stats = statistiquesService.getStatistiquesGlobales();
            byte[] pdfBytes = pdfService.genererStatistiquesPdf(stats);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Rapport_Stats.pdf\"");
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}