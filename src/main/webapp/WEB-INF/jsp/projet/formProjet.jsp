<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    Projet projet = (Projet) request.getAttribute("projet"); // Objet vide pour création
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouveau Projet</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>➕ Nouveau Projet</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions" style="margin-bottom: 20px;">
                <a href="<%=ctx%>/projets" class="btn btn-secondary">← Retour</a>
            </div>

            <form action="<%=ctx%>/projets/creer" method="post" style="max-width: 800px; margin: 0 auto; background: var(--dark-light); padding: 30px; border-radius: 12px;">
                
                <div class="form-group">
                    <label>Nom du Projet *</label>
                    <input type="text" name="nom" required style="width: 100%;">
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4" style="width: 100%;"></textarea>
                </div>

                <div class="form-group">
                    <label>Chef de Projet</label>
                    <select name="chefProjetId" style="width: 100%;">
                        <option value="">-- Non assigné --</option>
                        <% if (listeEmployes != null) { for (Employe emp : listeEmployes) { %>
                            <option value="<%= emp.getId() %>"><%= emp.getPrenom() %> <%= emp.getNom() %></option>
                        <% }} %>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group"><label>Début</label><input type="date" name="dateDebutStr"></div>
                    <div class="form-group"><label>Fin</label><input type="date" name="dateFinStr"></div>
                </div>

                <div class="form-group">
                    <label>État</label>
                    <select name="etat" style="width: 100%;">
                        <option value="EN_COURS">En Cours</option>
                        <option value="TERMINE">Terminé</option>
                        <option value="ANNULE">Annulé</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary" style="margin-top: 20px; width: 100%;">✅ Créer le projet</button>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>