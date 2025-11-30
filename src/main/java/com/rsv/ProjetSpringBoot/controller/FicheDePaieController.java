package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.model.FicheDePaie;
import com.rsv.ProjetSpringBoot.model.User;
import com.rsv.ProjetSpringBoot.service.EmployeService;
import com.rsv.ProjetSpringBoot.service.FicheDePaieService;
import com.rsv.ProjetSpringBoot.service.PdfService;
import com.rsv.ProjetSpringBoot.service.UserService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/fiches")
public class FicheDePaieController {

    private final FicheDePaieService ficheService;
    private final EmployeService employeService;
    private final UserService userService;
    private final PdfService pdfService;

    public FicheDePaieController(FicheDePaieService ficheService, EmployeService employeService, UserService userService, PdfService pdfService) {
        this.ficheService = ficheService;
        this.employeService = employeService;
        this.userService = userService;
        this.pdfService = pdfService;
    }

    // --- LISTE GLOBALE (Admin) ---
    @GetMapping
    public String lister(Model model) {
        model.addAttribute("listeFiches", ficheService.getAllFiches());
        return "ficheDePaie/listeFiches";
    }

    // --- MES FICHES (Employé connecté) ---
    @GetMapping("/mes-fiches")
    public String mesFiches(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth";

        Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
        if (user.isPresent() && user.get().getEmploye() != null) {
            Employe emp = user.get().getEmploye();
            // Récupère les fiches de l'employé
            // Si c'est un chef, on pourrait ajouter la logique pour récupérer celles de son équipe ici
            // Pour simplifier, on affiche ses fiches personnelles
            model.addAttribute("listeFiches", ficheService.getFichesByEmploye(emp.getId()));
            return "ficheDePaie/listeFiches";
        }
        return "redirect:/auth?erreur=pas_employe";
    }

    // --- FORMULAIRE NOUVELLE FICHE ---
    @GetMapping("/nouvelle")
    public String formAjout(Model model) {
        model.addAttribute("listeEmployes", employeService.getAllEmployes());
        return "ficheDePaie/formFicheDePaie";
    }

    // --- TRAITEMENT AJOUT ---
    @PostMapping("/ajouter")
    public String ajouter(@ModelAttribute FicheDePaie fiche, @RequestParam Integer employeId) {
        try {
            employeService.getEmployeById(employeId).ifPresent(fiche::setEmploye);
            ficheService.saveFiche(fiche);
            return "redirect:/fiches?message=ajout_ok";
        } catch (Exception e) {
            return "redirect:/fiches/nouvelle?erreur=echec_ajout";
        }
    }

    // --- VOIR DÉTAIL ---
    @GetMapping("/voir")
    public String voir(@RequestParam Integer id, Model model) {
        Optional<FicheDePaie> fiche = ficheService.getFicheById(id);
        if (fiche.isPresent()) {
            model.addAttribute("fiche", fiche.get());
            return "ficheDePaie/viewFichePaie";
        }
        return "redirect:/fiches?erreur=introuvable";
    }

    // --- RECHERCHE ---
    @GetMapping("/rechercher")
    public String rechercher(
            @RequestParam(required = false) Integer employeId,
            @RequestParam(required = false) Integer mois,
            @RequestParam(required = false) Integer annee,
            Model model) {
        
        // Charger la liste des employés pour le select
        model.addAttribute("listeEmployes", employeService.getAllEmployes());

        // Si des critères sont présents, on lance la recherche
        if (employeId != null || mois != null || annee != null) {
            List<FicheDePaie> resultats = ficheService.rechercherFichesAvance(employeId, mois, annee);
            model.addAttribute("resultats", resultats);
        }
        return "ficheDePaie/rechercherFiches";
    }

    // --- SUPPRESSION ---
    @GetMapping("/supprimer")
    public String supprimer(@RequestParam Integer id) {
        try {
            ficheService.deleteFiche(id);
            return "redirect:/fiches?message=suppression_ok";
        } catch (Exception e) {
            return "redirect:/fiches?erreur=echec_suppression";
        }
    }

    // --- PDF ---
    @GetMapping("/pdf")
    public void downloadPdf(@RequestParam Integer id, HttpServletResponse response) {
        try {
            Optional<FicheDePaie> ficheOpt = ficheService.getFicheById(id);
            if (ficheOpt.isPresent()) {
                byte[] pdf = pdfService.genererFicheDePaiePdf(ficheOpt.get());
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"Fiche_" + id + ".pdf\"");
                response.getOutputStream().write(pdf);
                response.getOutputStream().flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}