<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    List<Projet> mesProjets = (List<Projet>) request.getAttribute("mesProjets");
    // Dans le contrôleur Spring, on peut passer directement un boolean "isChef" ou une liste d'IDs
    // Ici on suppose que le contrôleur a fait le travail ou qu'on garde la logique existante
    // Pour simplifier, on va dire que si l'employé est le chef du projet dans l'objet Projet, c'est bon.
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    Employe employeConnecte = (Employe) request.getAttribute("employeConnecte"); // Passé par le contrôleur
    
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Projets - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        /* (Garde tes styles CSS ici, je les raccourcis pour la lisibilité) */
        .projet-card { border: 1px solid #ddd; padding: 20px; margin-bottom: 20px; border-radius: 8px; }
        .chef-mode { border-left: 5px solid #f59e0b; }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>📁 Mes Projets</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <% if (message != null) { %><div class="alert alert-success">✅ <%= message %></div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <h2 class="page-title">📁 Mes Projets</h2>

            <% if (mesProjets != null && !mesProjets.isEmpty()) { %>
                <% for (Projet projet : mesProjets) {
                    boolean estChef = employeConnecte != null && projet.getChefDeProjet() != null && 
                                      projet.getChefDeProjet().getId().equals(employeConnecte.getId());
                    String etat = (projet.getEtat() != null) ? projet.getEtat() : "EN_COURS";
                %>
                <div class="projet-card <%= estChef ? "chef-mode" : "" %>">
                    <div class="projet-header">
                        <h3><%= projet.getNom() %> <span class="badge"><%= etat %></span></h3>
                        <% if (estChef) { %><span class="badge badge-warning">👑 Chef de Projet</span><% } %>
                    </div>
                    
                    <p><%= (projet.getDescription() != null) ? projet.getDescription() : "Pas de description" %></p>
                    <p>📅 <%= projet.getDateDebut() %> ➔ <%= projet.getDateFin() %></p>
                    <p>👥 <%= projet.getEmployes().size() %> membre(s)</p>

                    <div class="projet-actions" style="margin-top: 15px; display: flex; gap: 10px;">
                        <a href="<%=ctx%>/projets/detail?id=<%= projet.getId() %>" class="btn btn-secondary">📋 Détails</a>
                        
                        <% if (estChef) { %>
                            <a href="<%=ctx%>/projets/modifier?id=<%= projet.getId() %>" class="btn btn-primary">✏️ Modifier</a>
                            <a href="<%=ctx%>/projets/gerer-equipe?id=<%= projet.getId() %>" class="btn btn-info">👥 Équipe</a>
                            <% } %>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <div class="empty-state">
                    <h3>Aucun projet</h3>
                    <p>Vous ne participez à aucun projet pour le moment.</p>
                </div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>