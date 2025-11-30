package com.rsv.ProjetSpringBoot.util;

import jakarta.servlet.http.HttpSession;

/**
 * Classe utilitaire pour gérer les permissions selon les rôles
 */
public class RoleHelper {
    
    // Constantes pour les rôles
    public static final String ROLE_ADMIN = "ADMINISTRATEUR";
    public static final String ROLE_CHEF_DEPT = "CHEF_DEPARTEMENT";
    public static final String ROLE_CHEF_PROJET = "CHEF_PROJET";
    public static final String ROLE_EMPLOYE = "EMPLOYE";
    
    /**
     * Vérifie si l'utilisateur est administrateur
     */
    public static boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_ADMIN.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est chef de département
     */
    public static boolean isChefDepartement(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_CHEF_DEPT.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est chef de projet
     */
    public static boolean isChefProjet(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_CHEF_PROJET.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est employé
     */
    public static boolean isEmploye(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_EMPLOYE.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur peut gérer les employés
     */
    public static boolean canManageEmployes(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut gérer les départements
     */
    public static boolean canManageDepartements(HttpSession session) {
        return isAdmin(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut gérer les projets
     */
    public static boolean canManageProjets(HttpSession session) {
        return isAdmin(session) || isChefProjet(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut créer des fiches de paie
     */
    public static boolean canCreateFichesPaie(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir toutes les fiches de paie
     */
    public static boolean canViewAllFichesPaie(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir les statistiques
     */
    public static boolean canViewStatistics(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session) || isChefProjet(session);
    }
}