<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    List<String> erreurs = (List<String>) request.getAttribute("erreurs");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Créer Fiche de Paie</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <script src="<%=ctx%>/js/validation.js"></script>
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>💰Créer une Fiche de Paie</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Nouvelle Fiche de Paie</h2>

            <% if (erreur != null) { %> <div class="alert alert-danger">⚠️ <%= erreur %></div> <% } %>

            <% if (listeEmployes == null || listeEmployes.isEmpty()) { %>
                <div class="alert alert-danger">⚠️ Aucun employé disponible.</div>
            <% } else { %>

            <form id="formFichePaie" action="<%=ctx%>/fiches/ajouter" method="post" style="max-width: 700px; margin: 20px auto;">
                
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend>Employé et Période</legend>
                    <div class="form-group">
                        <label>Employé *</label>
                        <select name="employeId" required>
                            <option value="">-- Sélectionner --</option>
                            <% for (Employe emp : listeEmployes) { %>
                                <option value="<%= emp.getId() %>"><%= emp.getMatricule() %> - <%= emp.getPrenom() %> <%= emp.getNom() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Mois *</label>
                            <select name="mois" required>
                                <% for(int i=1; i<=12; i++) { %><option value="<%=i%>"><%=i%></option><% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Année *</label>
                            <input type="number" name="annee" value="2025" required>
                        </div>
                    </div>
                </fieldset>

                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px;">
                    <legend>Rémunération</legend>
                    <div class="form-group"><label>Salaire de base (€) *</label><input type="number" name="salaireDeBase" step="0.01" required></div>
                    <div class="form-group"><label>Primes (€)</label><input type="number" name="primes" step="0.01" value="0"></div>
                    <div class="form-group"><label>Heures Sup (€)</label><input type="number" name="heuresSupp" step="0.01" value="0"></div>
                    <div class="form-group"><label>Déductions (€)</label><input type="number" name="deductions" step="0.01" value="0"></div>
                    <div class="form-group"><label>Jours Absence</label><input type="number" name="joursAbsence" value="0"></div>
                </fieldset>

                <div style="margin-top: 30px; display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">✅ Créer</button>
                    <a href="<%=ctx%>/fiches" class="btn btn-secondary">❌ Annuler</a>
                </div>
            </form>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>