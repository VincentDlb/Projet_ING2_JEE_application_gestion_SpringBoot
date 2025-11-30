<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier Mon Projet</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>✏️ Modifier Mon Projet</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Modifier : <%= projet.getNom() %></h2>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <form action="<%=ctx%>/projets/modifier" method="post" style="max-width: 700px; margin: 0 auto;">
                <input type="hidden" name="id" value="<%= projet.getId() %>">
                <input type="hidden" name="chefProjetId" value="<%= projet.getChefDeProjet().getId() %>">

                <div class="form-group">
                    <label>Nom *</label>
                    <input type="text" name="nom" value="<%= projet.getNom() %>" required style="width: 100%;">
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4" style="width: 100%;"><%= (projet.getDescription()!=null)?projet.getDescription():"" %></textarea>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group"><label>Début</label><input type="date" name="dateDebutStr" value="<%= projet.getDateDebut() %>"></div>
                    <div class="form-group"><label>Fin</label><input type="date" name="dateFinStr" value="<%= projet.getDateFin() %>"></div>
                </div>
                <div class="form-group">
                    <label>État</label>
                    <select name="etat" style="width: 100%;">
                        <option value="EN_COURS" <%= "EN_COURS".equals(projet.getEtat())?"selected":"" %>>En cours</option>
                        <option value="TERMINE" <%= "TERMINE".equals(projet.getEtat())?"selected":"" %>>Terminé</option>
                        <option value="ANNULE" <%= "ANNULE".equals(projet.getEtat())?"selected":"" %>>Annulé</option>
                    </select>
                </div>

                <div style="margin-top: 20px; display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                    <a href="<%=ctx%>/projets/mes-projets" class="btn btn-secondary">Annuler</a>
                </div>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>