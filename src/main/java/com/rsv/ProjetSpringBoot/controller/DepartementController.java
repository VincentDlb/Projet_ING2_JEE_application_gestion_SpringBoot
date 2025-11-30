package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.Departement;
import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.model.User;
import com.rsv.ProjetSpringBoot.service.DepartementService;
import com.rsv.ProjetSpringBoot.service.EmployeService;
import com.rsv.ProjetSpringBoot.service.UserService;
import com.rsv.ProjetSpringBoot.service.FicheDePaieService; // Ajouté pour fiches paie équipe
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/departements")
public class DepartementController {

    private final DepartementService departementService;
    private final EmployeService employeService;
    private final UserService userService;
    private final FicheDePaieService ficheDePaieService;

    public DepartementController(DepartementService departementService, EmployeService employeService, UserService userService, FicheDePaieService ficheDePaieService) {
        this.departementService = departementService;
        this.employeService = employeService;
        this.userService = userService;
        this.ficheDePaieService = ficheDePaieService;
    }

    // ==================== GESTION (ADMIN) ====================

    @GetMapping
    public String lister(Model model) {
        model.addAttribute("listeDepartements", departementService.getAllDepartements());
        return "departement/listeDepartements";
    }

    @GetMapping("/nouveau")
    public String formAjout(Model model) {
        model.addAttribute("listeEmployes", employeService.getAllEmployes());
        model.addAttribute("departement", new Departement());
        return "departement/formDepartement";
    }

    @GetMapping("/modifier")
    public String formModif(@RequestParam Integer id, Model model) {
        Optional<Departement> dept = departementService.getDepartementById(id);
        if (dept.isPresent()) {
            model.addAttribute("departement", dept.get());
            model.addAttribute("listeEmployes", employeService.getAllEmployes());
            return "departement/formDepartement";
        }
        return "redirect:/departements?erreur=introuvable";
    }

    @PostMapping("/ajouter")
    public String enregistrer(@ModelAttribute Departement departement, 
                              @RequestParam(value = "chefDepartementId", required = false) String chefIdStr) {
        try {
            // Conversion manuelle sécurisée pour le chef
            if (chefIdStr != null && !chefIdStr.isEmpty()) {
                try {
                    Integer chefId = Integer.parseInt(chefIdStr);
                    employeService.getEmployeById(chefId).ifPresent(departement::setChefDepartement);
                } catch (NumberFormatException e) {
                    departement.setChefDepartement(null);
                }
            } else {
                departement.setChefDepartement(null);
            }

            departementService.saveDepartement(departement);
            return "redirect:/departements?message=ok";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/departements/nouveau?erreur=echec_enregistrement";
        }
    }
    
    @GetMapping("/supprimer")
    public String supprimer(@RequestParam Integer id) {
        try {
            departementService.deleteDepartement(id);
            return "redirect:/departements?message=suppression_ok";
        } catch (Exception e) {
            return "redirect:/departements?erreur=echec_suppression";
        }
    }

    // ==================== VUES SPÉCIFIQUES & MON DÉPARTEMENT ====================

    // Affiche les membres d'un département (Vue Admin)
    @GetMapping("/voirMembres")
    public String voirMembres(@RequestParam Integer id, Model model) {
        return afficherVueDepartement(id, model, "departement/viewMembres");
    }

    // Affiche "Mon Département" (Vue Chef/Employé)
    @GetMapping("/mon-departement")
    public String monDepartement(HttpSession session, @RequestParam(required = false) Integer id, Model model) {
        // 1. Si un ID est passé explicitement (lien admin), on l'utilise
        if (id != null) {
            // Vérifier si l'utilisateur est le chef pour activer le mode édition
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
                if (user.isPresent() && user.get().getEmploye() != null) {
                    Employe emp = user.get().getEmploye();
                    Optional<Departement> dept = departementService.getDepartementById(id);
                    if (dept.isPresent() && dept.get().getChefDepartement() != null && 
                        dept.get().getChefDepartement().getId().equals(emp.getId())) {
                        model.addAttribute("isChef", true);
                    }
                }
            }
            return afficherVueDepartement(id, model, "chefDepartement/monDepartement");
        }

        // 2. Sinon, on cherche le département de l'utilisateur connecté
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth";

        Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
        if (user.isPresent() && user.get().getEmploye() != null) {
            Employe emp = user.get().getEmploye();
            
            // Priorité 1 : Département dont il est CHEF
            Optional<Departement> deptChef = departementService.getDepartementByChef(emp.getId());
            if (deptChef.isPresent()) {
                model.addAttribute("isChef", true);
                return afficherVueDepartement(deptChef.get().getId(), model, "chefDepartement/monDepartement");
            }
            
            // Priorité 2 : Département dont il est MEMBRE
            if (emp.getDepartement() != null) {
                model.addAttribute("isChef", false);
                return afficherVueDepartement(emp.getDepartement().getId(), model, "chefDepartement/monDepartement");
            }
        }
        
        // Aucun département trouvé
        return "chefDepartement/aucunDepartement"; // Assure-toi que ce JSP existe
    }

    // ==================== GESTION DES MEMBRES (CHEF) ====================

    @GetMapping("/mon-departement/gerer-membres")
    public String gererMembres(@RequestParam Integer id, Model model) {
        Optional<Departement> dept = departementService.getDepartementById(id);
        if (dept.isPresent()) {
            model.addAttribute("departement", dept.get());
            model.addAttribute("membresActuels", employeService.getEmployesByDepartement(id));
            // Pour simplifier, on affiche tous les employés comme "disponibles" pour l'instant
            // Idéalement : filtrer ceux qui n'ont pas de département
            model.addAttribute("employesDisponibles", employeService.getAllEmployes()); 
            return "chefDepartement/gererMembres";
        }
        return "redirect:/departements/mon-departement";
    }

    @PostMapping("/ajouter-membre")
    public String ajouterMembre(@RequestParam Integer departementId, @RequestParam Integer employeId) {
        departementService.ajouterMembre(departementId, employeId);
        return "redirect:/departements/mon-departement/gerer-membres?id=" + departementId + "&message=membre_ajoute";
    }

    @PostMapping("/retirer-membre")
    public String retirerMembre(@RequestParam Integer departementId, @RequestParam Integer employeId) {
        departementService.retirerMembre(employeId);
        return "redirect:/departements/mon-departement/gerer-membres?id=" + departementId + "&message=membre_retire";
    }
    
    // ==================== FICHES DE PAIE ÉQUIPE (CHEF) ====================
    
    @GetMapping("/mon-departement/fiches-paie-equipe") // Correction URL
    public String fichesPaieEquipe(@RequestParam(value = "id", required = false) Integer id, HttpSession session, Model model) {
        // Si pas d'ID, essayer de trouver celui du chef connecté
        if (id == null) {
             Integer userId = (Integer) session.getAttribute("userId");
             if (userId != null) {
                 Optional<User> user = userService.findByUsername((String) session.getAttribute("username"));
                 if (user.isPresent() && user.get().getEmploye() != null) {
                     Optional<Departement> dept = departementService.getDepartementByChef(user.get().getEmploye().getId());
                     if (dept.isPresent()) id = dept.get().getId();
                 }
             }
        }

        if (id != null) {
            Optional<Departement> dept = departementService.getDepartementById(id);
            if (dept.isPresent()) {
                model.addAttribute("departement", dept.get());
                // Récupérer les fiches de paie des membres (logique simplifiée : on passe la liste des membres)
                // Le JSP ou un service dédié devrait filtrer les fiches.
                // Ici on réutilise la méthode d'affichage basique, tu devras peut-être enrichir avec les fiches réelles via FicheDePaieService
                model.addAttribute("membresEquipe", employeService.getEmployesByDepartement(id));
                // TODO: Ajouter listeFiches si nécessaire
                return "chefDepartement/fichePaieEquipe";
            }
        }
        return "redirect:/departements/mon-departement";
    }

    // ==================== MÉTHODE UTILITAIRE ====================

    private String afficherVueDepartement(Integer deptId, Model model, String viewName) {
        Optional<Departement> dept = departementService.getDepartementById(deptId);
        if (dept.isPresent()) {
            model.addAttribute("departement", dept.get());
            List<Employe> membres = employeService.getEmployesByDepartement(deptId);
            model.addAttribute("membres", membres);
            return viewName;
        }
        return "redirect:/departements?erreur=introuvable";
    }
}