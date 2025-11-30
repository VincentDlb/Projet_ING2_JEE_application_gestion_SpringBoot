<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="java.util.List" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    boolean modeModification = (departement != null);
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    
    String nom = modeModification ? departement.getNom() : "";
    String description = modeModification ? (departement.getDescription() != null ? departement.getDescription() : "") : "";
    Integer chefId = modeModification && departement.getChefDepartement() != null ? departement.getChefDepartement().getId() : null;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><%= modeModification ? "Modifier" : "Nouveau" %> Département</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏛️ <%= modeModification ? "Modifier" : "Nouveau" %> Département</h1>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title"><%= modeModification ? "✏️ Modifier" : "➕ Créer" %> un Département</h2>

            <form action="<%=ctx%>/departements/ajouter" method="post" style="max-width: 700px; margin: 0 auto;">

				<% if (modeModification && departement.getId() != null) { %>
				    <input type="hidden" name="id" value="<%= departement.getId() %>">
				<% } %>
                
                <div class="form-group">
                    <label for="nom">Nom du département *</label>
                    <input type="text" id="nom" name="nom" value="<%= nom %>" required autofocus>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="4"><%= description %></textarea>
                </div>

                <div class="form-group" style="background: rgba(99, 102, 241, 0.05); padding: 20px; border-radius: 12px; border: 2px solid rgba(99, 102, 241, 0.2);">
                    <label for="chefDepartementId">👨‍💼 Chef de département</label>
                    <select id="chefDepartementId" name="chefDepartementId" style="margin-top: 10px;">
                        <option value="">-- Aucun chef désigné --</option>
                        <% if (listeEmployes != null) {
                            for (Employe emp : listeEmployes) {
                                boolean estChef = modeModification && chefId != null && chefId.equals(emp.getId());
                        %>
                            <option value="<%= emp.getId() %>" <%= estChef ? "selected" : "" %>>
                                <%= emp.getPrenom() %> <%= emp.getNom() %> 
                                <% if (emp.getPoste() != null) { %> - <%= emp.getPoste() %> <% } %>
                            </option>
                        <% }} %>
                    </select>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                        <%= modeModification ? "💾 Enregistrer" : "✅ Créer" %>
                    </button>
                    <a href="<%=ctx%>/departements" class="btn btn-secondary" style="flex: 1;">❌ Annuler</a>
                </div>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>