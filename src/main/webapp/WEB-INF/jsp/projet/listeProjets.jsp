<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    List<Projet> listeProjets = (List<Projet>) request.getAttribute("listeProjets");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Projets - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>Gestion des Projets</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <% if (message != null) { %><div class="alert alert-success">✅ Opération réussie !</div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <div class="actions" style="margin-bottom: 20px; display: flex; justify-content: space-between;">
                <h2 class="page-title">📁 Liste des Projets</h2>
                <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                    <a href="<%=ctx%>/projets/nouveau" class="btn btn-primary">Nouveau Projet</a>
                <% } %>
            </div>

            <% if (listeProjets != null && !listeProjets.isEmpty()) { %>
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>NOM</th><th>DESCRIPTION</th><th>ÉTAT</th><th>CHEF</th><th>ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Projet projet : listeProjets) { 
                            String etat = (projet.getEtat() != null) ? projet.getEtat() : "EN_COURS";
                            String badgeClass = "EN_COURS".equals(etat) ? "badge-primary" : ("TERMINE".equals(etat) ? "badge-success" : "badge-danger");
                        %>
                        <tr>
                            <td><strong><%= projet.getNom() %></strong></td>
                            <td><%= (projet.getDescription() != null && projet.getDescription().length() > 50) ? projet.getDescription().substring(0, 50) + "..." : projet.getDescription() %></td>
                            <td><span class="badge <%=badgeClass%>"><%= etat %></span></td>
                            <td><%= (projet.getChefDeProjet() != null) ? "👤 " + projet.getChefDeProjet().getNom() : "Non assigné" %></td>
                            <td>
                                <div style="display: flex; gap: 5px;">
                                    <a href="<%=ctx%>/projets/detail?id=<%= projet.getId() %>" class="btn btn-secondary">Détails</a>
                                    <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                                        <a href="<%=ctx%>/projets/modifier?id=<%= projet.getId() %>" class="btn btn-warning">✏️</a>
                                        <a href="<%=ctx%>/projets/gerer-equipe?id=<%= projet.getId() %>" class="btn btn-primary">👥</a>
                                    <% } %>
                                    <% if (RoleHelper.isAdmin(session)) { %>
                                        <a href="<%=ctx%>/projets/supprimer?id=<%= projet.getId() %>" class="btn btn-danger" onclick="return confirm('Supprimer ?');">🗑️</a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
                <div style="text-align: center; padding: 40px;"><p>Aucun projet trouvé</p></div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>