<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier Mon Département</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>✏️ Modifier Mon Département</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Modifier : <%= departement.getNom() %></h2>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <form action="<%=ctx%>/departements/ajouter" method="post" style="max-width: 600px; margin: 0 auto;">
                <input type="hidden" name="id" value="<%= departement.getId() %>">
                <input type="hidden" name="chefDepartementId" value="<%= departement.getChefDepartement().getId() %>">

                <div class="form-group">
                    <label>Nom du département</label>
                    <input type="text" name="nom" value="<%= departement.getNom() %>" readonly style="background-color: #eee;">
                    <small>Seul un administrateur peut changer le nom.</small>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="5" style="width: 100%;"><%= (departement.getDescription() != null) ? departement.getDescription() : "" %></textarea>
                </div>

                <div style="margin-top: 20px; display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                    <a href="<%=ctx%>/departements/mon-departement" class="btn btn-secondary">Annuler</a>
                </div>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>