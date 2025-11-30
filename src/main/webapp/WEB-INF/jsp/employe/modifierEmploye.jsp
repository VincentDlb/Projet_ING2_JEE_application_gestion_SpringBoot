<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");
    List<Projet> listeProjets = (List<Projet>) request.getAttribute("listeProjets");
    Employe employe = (Employe) request.getAttribute("employe");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier Employé</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Modifier : <%= employe.getPrenom() %> <%= employe.getNom() %></h2>

            <form action="<%=ctx%>/employes/modifier" method="post" style="max-width: 800px; margin: 20px auto;">
                
                <input type="hidden" name="id" value="<%= employe.getId() %>">

                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend>Informations personnelles</legend>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Nom *</label>
                            <input type="text" name="nom" value="<%= employe.getNom() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Prénom *</label>
                            <input type="text" name="prenom" value="<%= employe.getPrenom() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" value="<%= employe.getEmail() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="text" name="telephone" value="<%= employe.getTelephone() != null ? employe.getTelephone() : "" %>">
                        </div>
                    </div>
                </fieldset>

                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend>Informations professionnelles</legend>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Matricule (Lecture seule)</label>
                            <input type="text" name="matricule" value="<%= employe.getMatricule() %>" readonly style="background-color: var(--dark-light);">
                        </div>
                        <div class="form-group">
                            <label>Poste *</label>
                            <input type="text" name="poste" value="<%= employe.getPoste() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Grade *</label>
                            <select name="grade" required>
                                <option value="JUNIOR" <%= "JUNIOR".equals(employe.getGrade()) ? "selected" : "" %>>Junior</option>
                                <option value="CONFIRME" <%= "CONFIRME".equals(employe.getGrade()) ? "selected" : "" %>>Confirmé</option>
                                <option value="SENIOR" <%= "SENIOR".equals(employe.getGrade()) ? "selected" : "" %>>Senior</option>
                                <option value="EXPERT" <%= "EXPERT".equals(employe.getGrade()) ? "selected" : "" %>>Expert</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Salaire (€) *</label>
                            <input type="number" name="salaire" step="0.01" value="<%= employe.getSalaire() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Date d'embauche *</label>
                            <input type="date" name="dateEmbauche" value="<%= employe.getDateEmbauche() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Département</label>
                            <select name="departementIdStr">
                                <option value="">-- Aucun --</option>
                                <% if (listeDepartements != null) { for (Departement dept : listeDepartements) { %>
                                    <option value="<%= dept.getId() %>" <%= employe.getDepartement() != null && employe.getDepartement().getId().equals(dept.getId()) ? "selected" : "" %>>
                                        <%= dept.getNom() %>
                                    </option>
                                <% }} %>
                            </select>
                        </div>
                    </div>
                </fieldset>

                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px;">
                    <legend>Affecter à des projets</legend>
                    <% if (listeProjets != null && !listeProjets.isEmpty()) { %>
                        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 10px;">
                            <% for (Projet projet : listeProjets) { 
                                boolean estAffecte = employe.getProjets() != null && employe.getProjets().stream().anyMatch(p -> p.getId().equals(projet.getId()));
                            %>
                                <div>
                                    <label>
                                        <input type="checkbox" name="projetIds" value="<%= projet.getId() %>" <%= estAffecte ? "checked" : "" %>>
                                        <%= projet.getNom() %>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p>Aucun projet disponible.</p>
                    <% } %>
                </fieldset>

                <div style="display: flex; gap: 10px; justify-content: center; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                    <a href="<%=ctx%>/employes" class="btn btn-secondary">❌ Annuler</a>
                </div>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>