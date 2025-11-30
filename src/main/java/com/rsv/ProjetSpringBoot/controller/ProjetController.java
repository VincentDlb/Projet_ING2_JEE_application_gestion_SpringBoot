package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.model.Projet;
import com.rsv.ProjetSpringBoot.model.User;
import com.rsv.ProjetSpringBoot.service.EmployeService;
import com.rsv.ProjetSpringBoot.service.FicheDePaieService;
import com.rsv.ProjetSpringBoot.service.ProjetService;
import com.rsv.ProjetSpringBoot.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/projets")
public class ProjetController {

    private final ProjetService projetService;
    private final EmployeService employeService;
    private final UserService userService;
    private final FicheDePaieService ficheDePaieService; // Pour les fiches de l'équipe

    public ProjetController(ProjetService projetService, EmployeService employeService, UserService userService, FicheDePaieService ficheDePaieService) {
        this.projetService = projetService;
        this.employeService = employeService;
        this.userService = userService;
        this.ficheDePaieService = ficheDePaieService;
    }

    // --- LISTE GLOBALE ---
    @GetMapping
    public String lister(Model model) {
        model.addAttribute("listeProjets", projetService.getAllProjets());
        return "projet/listeProjets";
    }

    // --- CRÉATION ---
    @GetMapping("/nouveau")
    public String formNouveau(Model model) {
        model.addAttribute("listeEmployes", employeService.getAllEmployes());
        model.addAttribute("projet", new Projet()); // Objet vide
        return "projet/formProjet";
    }

    @PostMapping("/creer")
    public String creer(@ModelAttribute Projet projet, 
                        @RequestParam(required = false) Integer chefProjetId,
                        @RequestParam(required = false) String dateDebutStr, // Spring gère mal les dates vides par défaut parfois
                        @RequestParam(required = false) String dateFinStr) {
        try {
            // Gestion chef
            if (chefProjetId != null) employeService.getEmployeById(chefProjetId).ifPresent(projet::setChefDeProjet);
            
            // Gestion dates (si conversion auto échoue)
            if (dateDebutStr != null && !dateDebutStr.isEmpty()) projet.setDateDebut(LocalDate.parse(dateDebutStr));
            if (dateFinStr != null && !dateFinStr.isEmpty()) projet.setDateFin(LocalDate.parse(dateFinStr));
            
            projetService.saveProjet(projet);
            return "redirect:/projets?message=creation_ok";
        } catch (Exception e) {
            return "redirect:/projets/nouveau?erreur=echec_creation";
        }
    }

    // --- MODIFICATION ---
    @GetMapping("/modifier")
    public String formModifier(@RequestParam Integer id, Model model) {
        Optional<Projet> projet = projetService.getProjetById(id);
        if (projet.isPresent()) {
            model.addAttribute("projet", projet.get());
            model.addAttribute("listeEmployes", employeService.getAllEmployes());
            return "projet/modifierProjet"; // Utilise ton fichier spécifique
        }
        return "redirect:/projets?erreur=introuvable";
    }

    @PostMapping("/modifier")
    public String modifier(@ModelAttribute Projet projet, 
                           @RequestParam(required = false) Integer chefProjetId,
                           @RequestParam(required = false) String dateDebutStr,
                           @RequestParam(required = false) String dateFinStr) {
        // Logique de mise à jour (récupérer l'existant pour ne pas perdre les employés)
        Optional<Projet> existing = projetService.getProjetById(projet.getId());
        if (existing.isPresent()) {
            Projet p = existing.get();
            p.setNom(projet.getNom());
            p.setDescription(projet.getDescription());
            p.setEtat(projet.getEtat());
            
            if (dateDebutStr != null && !dateDebutStr.isEmpty()) p.setDateDebut(LocalDate.parse(dateDebutStr));
            if (dateFinStr != null && !dateFinStr.isEmpty()) p.setDateFin(LocalDate.parse(dateFinStr));
            
            if (chefProjetId != null) {
                employeService.getEmployeById(chefProjetId).ifPresent(p::setChefDeProjet);
            } else {
                p.setChefDeProjet(null);
            }
            projetService.saveProjet(p);
        }
        return "redirect:/projets?message=modification_ok";
    }

    // --- DÉTAILS ---
    @GetMapping("/detail")
    public String detail(@RequestParam Integer id, HttpSession session, Model model) {
        Optional<Projet> projet = projetService.getProjetById(id);
        if (projet.isPresent()) {
            model.addAttribute("projet", projet.get());
            model.addAttribute("membres", projet.get().getEmployes()); // Pour viewMembresProjet.jsp
            
            // Vérifier si l'utilisateur est chef (pour afficher les boutons d'édition)
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
                if (user.isPresent() && user.get().getEmploye() != null) {
                    Employe emp = user.get().getEmploye();
                    boolean isChef = projet.get().getChefDeProjet() != null && 
                                     projet.get().getChefDeProjet().getId().equals(emp.getId());
                    model.addAttribute("isChef", isChef);
                }
            }
            return "projet/detailProjet";
        }
        return "redirect:/projets?erreur=introuvable";
    }

    // --- GESTION ÉQUIPE ---
    @GetMapping("/gerer-equipe")
    public String gererEquipe(@RequestParam Integer id, Model model) {
        Optional<Projet> projet = projetService.getProjetById(id);
        if (projet.isPresent()) {
            model.addAttribute("projet", projet.get());
            // Liste des employés pas encore dans le projet (simplifié: on envoie tous)
            model.addAttribute("employesDisponibles", employeService.getAllEmployes());
            return "projet/gererEquipe";
        }
        return "redirect:/projets?erreur=introuvable";
    }

    @PostMapping("/ajouter-membre")
    public String ajouterMembre(@RequestParam Integer projetId, @RequestParam Integer employeId) {
        projetService.ajouterMembre(projetId, employeId);
        return "redirect:/projets/gerer-equipe?id=" + projetId + "&message=affectation_ok";
    }

    @PostMapping("/retirer-membre")
    public String retirerMembre(@RequestParam Integer projetId, @RequestParam Integer employeId) {
        projetService.retirerMembre(projetId, employeId);
        return "redirect:/projets/gerer-equipe?id=" + projetId + "&message=retrait_ok";
    }

    // --- MES PROJETS ---
    @GetMapping("/mes-projets")
    public String mesProjets(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth";

        Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
        if (user.isPresent() && user.get().getEmploye() != null) {
            Employe emp = user.get().getEmploye();
            model.addAttribute("tousMesProjets", projetService.getProjetsPourEmploye(emp.getId()));
            model.addAttribute("employeNom", emp.getNom() + " " + emp.getPrenom());
            model.addAttribute("employeId", emp.getId());
            return "projet/tousMesProjets"; 
        }
        return "redirect:/auth?erreur=pas_employe";
    }
    
    // --- SUPPRESSION ---
    @GetMapping("/supprimer")
    public String supprimer(@RequestParam Integer id) {
        try {
            projetService.deleteProjet(id);
            return "redirect:/projets?message=suppression_ok";
        } catch (Exception e) {
            return "redirect:/projets?erreur=echec_suppression";
        }
    }
    
    // --- FICHES DE PAIE ÉQUIPE (Pour le chef) ---
    @GetMapping("/fiches-paie-equipe")
    public String fichesPaieEquipe(@RequestParam Integer id, Model model) {
        Optional<Projet> projet = projetService.getProjetById(id);
        if (projet.isPresent()) {
            // Logique simplifiée: on récupère les fiches de tous les membres
            // Dans un vrai cas, il faudrait filtrer dans le service
            model.addAttribute("projet", projet.get());
            // model.addAttribute("fichesDePaie", ...); // À implémenter si besoin
            return "chefProjet/fichesPaieEquipe"; // Si tu as ce fichier
        }
        return "redirect:/projets/mes-projets";
    }
}