package com.rsv.ProjetSpringBoot.controller;

import com.rsv.ProjetSpringBoot.model.User;
import com.rsv.ProjetSpringBoot.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // Page de connexion (GET)
    @GetMapping("/auth")
    public String loginPage() {
        return "auth"; // auth.jsp
    }

    // Traitement connexion (POST)
    @PostMapping("/auth/login")
    public String login(@RequestParam String username, @RequestParam String password, HttpSession session) {
        User user = userService.login(username, password);
        if (user != null) {
            // Création de session manuelle (comme dans ton Servlet)
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("nomComplet", user.getNomComplet());
            return "redirect:/accueil"; // accueil.jsp (à renommer ou mapper)
        }
        return "redirect:/auth?erreur=identifiants_invalides";
    }

    // Déconnexion
    @GetMapping("/auth/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth?message=deconnexion_ok";
    }

    // Page Inscription
    @GetMapping("/inscription")
    public String inscriptionPage() {
        return "inscription"; // inscription.jsp
    }

 // Traitement Inscription
    @PostMapping("/inscription")
    public String inscription(@ModelAttribute User user, 
                              @RequestParam String confirmPassword, 
                              @RequestParam String matricule, // On récupère le matricule ici
                              Model model) {
        
        // 1. Validation mot de passe
        if (!user.getPassword().equals(confirmPassword)) {
            model.addAttribute("erreur", "Les mots de passe ne correspondent pas");
            return "inscription";
        }

        try {
            // 2. Appel du service avec le matricule
            userService.inscription(user, matricule);
            return "redirect:/auth?succes=Compte cree avec succes ! Connectez-vous.";
            
        } catch (Exception e) {
            // Gestion des erreurs (Matricule inconnu, User déjà pris...)
            model.addAttribute("erreur", e.getMessage());
            return "inscription";
        }
    }
    
    // Page d'accueil (nécessaire si tu n'as pas de HomeController)
    @GetMapping("/accueil")
    public String accueil() {
        return "accueil"; // accueil.jsp
    }
}