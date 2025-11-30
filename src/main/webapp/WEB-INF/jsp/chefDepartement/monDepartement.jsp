<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membres = (List<Employe>) request.getAttribute("membres");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Département - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>🏛️ Mon Département</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <% if (message != null) { %><div class="alert alert-success">✅ <%= message %></div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 class="page-title">🏛️ <%= departement.getNom() %></h2>
                <span class="badge badge-warning">👑 Vous êtes Chef de ce Département</span>
            </div>

            <div class="info-card" style="background: var(--dark-light); padding: 25px; border-radius: 12px; margin-bottom: 20px;">
                <h3>📋 Informations</h3>
                <p><strong>Description :</strong> <%= (departement.getDescription() != null) ? departement.getDescription() : "Aucune description" %></p>
                <p><strong>Effectif :</strong> <%= (membres != null) ? membres.size() : 0 %> membre(s)</p>
                
                <div class="actions" style="margin-top: 15px; display: flex; gap: 10px;">
                    <a href="<%=ctx%>/departements/modifier?id=<%= departement.getId() %>" class="btn btn-primary">✏️ Modifier infos</a>
                    <a href="<%=ctx%>/departements/mon-departement/gerer-membres?id=<%= departement.getId() %>" class="btn btn-info">👥 Gérer les membres</a>
                    </div>
            </div>

            <div class="info-card">
                <h3>👥 Membres du département</h3>
                <% if (membres != null && !membres.isEmpty()) { %>
                    <ul>
                        <% for (Employe m : membres) { 
                            boolean isMe = m.getId().equals(departement.getChefDepartement().getId());
                        %>
                            <li style="padding: 10px; border-bottom: 1px solid #ddd;">
                                <strong><%= m.getPrenom() %> <%= m.getNom() %></strong> - <%= m.getPoste() %>
                                <% if (isMe) { %> <span class="badge badge-warning">Chef (Vous)</span> <% } %>
                            </li>
                        <% } %>
                    </ul>
                <% } else { %>
                    <p>Aucun autre membre dans ce département.</p>
                <% } %>
            </div>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>