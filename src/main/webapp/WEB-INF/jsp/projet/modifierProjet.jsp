<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="java.util.List" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    Integer chefActuelId = (projet.getChefDeProjet() != null) ? projet.getChefDeProjet().getId() : null;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier <%= projet.getNom() %></title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>✏️ Modifier le Projet</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions" style="margin-bottom: 20px;">
                <a href="<%=ctx%>/projets/detail?id=<%=projet.getId()%>" class="btn btn-secondary">← Retour</a>
            </div>

            <form action="<%=ctx%>/projets/modifier" method="post" style="max-width: 800px; margin: 0 auto; background: var(--dark-light); padding: 30px; border-radius: 12px;">
                <input type="hidden" name="id" value="<%= projet.getId() %>">

                <div class="form-group">
                    <label>Nom du Projet *</label>
                    <input type="text" name="nom" value="<%= projet.getNom() %>" required style="width: 100%;">
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4" style="width: 100%;"><%= projet.getDescription() != null ? projet.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label>Chef de Projet</label>
                    <select name="chefProjetId" style="width: 100%;">
                        <option value="">-- Non assigné --</option>
                        <% if (listeEmployes != null) { for (Employe emp : listeEmployes) { %>
                            <option value="<%= emp.getId() %>" <%= (chefActuelId != null && chefActuelId.equals(emp.getId())) ? "selected" : "" %>>
                                <%= emp.getPrenom() %> <%= emp.getNom() %>
                            </option>
                        <% }} %>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group"><label>Début</label><input type="date" name="dateDebutStr" value="<%= projet.getDateDebut() %>"></div>
                    <div class="form-group"><label>Fin</label><input type="date" name="dateFinStr" value="<%= projet.getDateFin() %>"></div>
                </div>

                <div class="form-group">
                    <label>État</label>
                    <select name="etat" style="width: 100%;">
                        <option value="EN_COURS" <%= "EN_COURS".equals(projet.getEtat()) ? "selected" : "" %>>En Cours</option>
                        <option value="TERMINE" <%= "TERMINE".equals(projet.getEtat()) ? "selected" : "" %>>Terminé</option>
                        <option value="ANNULE" <%= "ANNULE".equals(projet.getEtat()) ? "selected" : "" %>>Annulé</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary" style="margin-top: 20px; width: 100%;">💾 Enregistrer</button>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>