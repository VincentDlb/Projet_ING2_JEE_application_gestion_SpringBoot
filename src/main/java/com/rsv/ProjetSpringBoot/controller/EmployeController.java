package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.service.DepartementService;
import com.rsv.ProjetSpringBoot.service.EmployeService;
import com.rsv.ProjetSpringBoot.service.ProjetService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/employes")
public class EmployeController {

    private final EmployeService employeService;
    private final DepartementService departementService;
    private final ProjetService projetService;

    public EmployeController(EmployeService employeService, DepartementService departementService, ProjetService projetService) {
        this.employeService = employeService;
        this.departementService = departementService;
        this.projetService = projetService;
    }

    // --- LISTE + FILTRES ---
    @GetMapping
    public String lister(
            @RequestParam(required = false) Integer departement,
            @RequestParam(required = false) String grade,
            @RequestParam(required = false) String poste,
            Model model) {
        
        List<Employe> employes;
        if (departement != null || (grade != null && !grade.isEmpty()) || (poste != null && !poste.isEmpty())) {
            employes = employeService.filtrerEmployes(departement, grade, poste);
            model.addAttribute("filtresActifs", true);
            model.addAttribute("filtreDepartement", departement != null ? String.valueOf(departement) : "");
            model.addAttribute("filtreGrade", grade);
            model.addAttribute("filtrePoste", poste);
        } else {
            employes = employeService.getAllEmployes();
        }

        model.addAttribute("listeEmployes", employes);
        model.addAttribute("departements", departementService.getAllDepartements());
        return "employe/gestionnaireEmploye";
    }

    // --- RECHERCHE ---
    @GetMapping("/rechercher")
    public String rechercher(
            @RequestParam(required = false) String critere,
            @RequestParam(required = false) String valeur,
            Model model) {
        if (critere != null && valeur != null && !valeur.trim().isEmpty()) {
            model.addAttribute("resultats", employeService.searchEmployes(critere, valeur));
        }
        model.addAttribute("departements", departementService.getAllDepartements());
        return "employe/rechercherEmploye";
    }

    // --- FORMULAIRE AJOUT ---
    @GetMapping("/nouveau")
    public String formAjout(Model model) {
        model.addAttribute("departements", departementService.getAllDepartements());
        model.addAttribute("employe", new Employe());
        return "employe/ajouterEmploye";
    }

    // --- TRAITEMENT AJOUT ---
    @PostMapping("/ajouter")
    public String ajouter(@ModelAttribute Employe employe, 
                          @RequestParam(value = "departementIdStr", required = false) String departementIdStr) {
        try {
            // Nettoyage objet fantôme
            employe.setDepartement(null);

            // Gestion manuelle département
            if (departementIdStr != null && !departementIdStr.isEmpty()) {
                try {
                    Integer deptId = Integer.parseInt(departementIdStr);
                    departementService.getDepartementById(deptId).ifPresent(employe::setDepartement);
                } catch (NumberFormatException ignored) {}
            }

            employeService.saveEmploye(employe);
            return "redirect:/employes?message=ajout_ok";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/employes/nouveau?erreur=echec_ajout";
        }
    }

    // --- FORMULAIRE MODIFICATION ---
    @GetMapping("/modifier")
    public String formModif(@RequestParam Integer id, Model model) {
        Optional<Employe> emp = employeService.getEmployeById(id);
        if (emp.isPresent()) {
            model.addAttribute("employe", emp.get());
            model.addAttribute("listeDepartements", departementService.getAllDepartements());
            model.addAttribute("listeProjets", projetService.getAllProjets());
            return "employe/modifierEmploye";
        }
        return "redirect:/employes?erreur=employe_introuvable";
    }

    // --- TRAITEMENT MODIFICATION (Version sécurisée) ---
    // On récupère les champs un par un pour éviter les erreurs de conversion automatique (Date, etc.)
    @PostMapping("/modifier")
    public String modifier(
            @RequestParam Integer id,
            @RequestParam String nom,
            @RequestParam String prenom,
            @RequestParam String email,
            @RequestParam(required = false) String telephone,
            @RequestParam(required = false) String adresse,
            @RequestParam String poste,
            @RequestParam String grade,
            @RequestParam Double salaire,
            @RequestParam String dateEmbauche, // Reçu en String pour éviter le crash
            @RequestParam(value = "departementIdStr", required = false) String departementIdStr,
            @RequestParam(required = false) List<Integer> projetIds) {
        
        try {
            // 1. On charge l'employé existant
            Optional<Employe> empOpt = employeService.getEmployeById(id);
            if (empOpt.isEmpty()) {
                return "redirect:/employes?erreur=employe_introuvable";
            }
            
            Employe employe = empOpt.get();
            
            // 2. Mise à jour manuelle des champs
            employe.setNom(nom);
            employe.setPrenom(prenom);
            employe.setEmail(email);
            employe.setTelephone(telephone);
            employe.setAdresse(adresse);
            employe.setPoste(poste);
            employe.setGrade(grade);
            employe.setSalaire(salaire);
            
            // 3. Conversion sécurisée de la date
            if (dateEmbauche != null && !dateEmbauche.isEmpty()) {
                employe.setDateEmbauche(LocalDate.parse(dateEmbauche));
            }

            // 4. Gestion sécurisée du département
            employe.setDepartement(null); 
            if (departementIdStr != null && !departementIdStr.isEmpty()) {
                try {
                    Integer deptId = Integer.parseInt(departementIdStr);
                    departementService.getDepartementById(deptId).ifPresent(employe::setDepartement);
                } catch (NumberFormatException ignored) {}
            }

            // 5. Sauvegarde via le service qui gère aussi les projets
            employeService.updateEmployeAvecProjets(employe, projetIds);
            
            return "redirect:/employes?message=modif_ok";
            
        } catch (Exception e) {
            e.printStackTrace(); 
            return "redirect:/employes/modifier?id=" + id + "&erreur=echec_modification";
        }
    }

    // --- SUPPRESSION ---
    @GetMapping("/supprimer")
    public String supprimer(@RequestParam Integer id) {
        try {
            employeService.deleteEmploye(id);
            return "redirect:/employes?message=suppression_ok";
        } catch (Exception e) {
            return "redirect:/employes?erreur=echec_suppression";
        }
    }
}