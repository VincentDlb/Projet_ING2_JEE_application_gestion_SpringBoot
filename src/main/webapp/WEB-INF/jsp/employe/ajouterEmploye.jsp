<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("departements"); // Note: variable 'departements' dans controller
    List<String> erreurs = (List<String>) request.getAttribute("erreurs");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Employé</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>👥 Ajouter un Employé</h1>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Nouvel Employé</h2>

            <% if (erreurs != null && !erreurs.isEmpty()) { %>
                <div class="alert alert-danger">
                    <ul><% for (String err : erreurs) { %><li><%= err %></li><% } %></ul>
                </div>
            <% } %>

            <form action="<%=ctx%>/employes/ajouter" method="post" style="max-width: 800px; margin: 20px auto;">
                
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend>Informations personnelles</legend>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Nom *</label>
                            <input type="text" name="nom" required>
                        </div>
                        <div class="form-group">
                            <label>Prénom *</label>
                            <input type="text" name="prenom" required>
                        </div>
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="text" name="telephone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Adresse</label>
                        <textarea name="adresse" rows="2"></textarea>
                    </div>
                </fieldset>

                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend>Informations professionnelles</legend>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Matricule *</label>
                            <input type="text" name="matricule" required>
                        </div>
                        <div class="form-group">
                            <label>Poste *</label>
                            <input type="text" name="poste" required>
                        </div>
                        <div class="form-group">
                            <label>Grade *</label>
                            <select name="grade" required>
                                <option value="JUNIOR">Junior</option>
                                <option value="CONFIRME">Confirmé</option>
                                <option value="SENIOR">Senior</option>
                                <option value="EXPERT">Expert</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Salaire (€) *</label>
                            <input type="number" name="salaire" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label>Date d'embauche *</label>
                            <input type="date" name="dateEmbauche" required>
                        </div>
                        <div class="form-group">
                            <label>Département</label>
                            <select name="departementId">
							    <option value="">-- Aucun département --</option>
							    <% if (listeDepartements != null) {
							            for (Departement dept : listeDepartements) { %>
							                <option value="<%= dept.getId() %>">
							                    <%= dept.getNom() %>
							                </option>
							    <%  }
							    } %>
							</select>
                        </div>
                    </div>
                </fieldset>

                <div style="display: flex; gap: 10px; justify-content: center;">
                    <button type="submit" class="btn btn-primary">➕ Ajouter</button>
                    <a href="<%=ctx%>/employes" class="btn btn-secondary">❌ Annuler</a>
                </div>
            </form>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>