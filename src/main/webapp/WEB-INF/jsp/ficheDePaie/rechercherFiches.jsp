<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.FicheDePaie" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    List<FicheDePaie> resultats = (List<FicheDePaie>) request.getAttribute("resultats");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rechercher Fiches</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>🔍 Rechercher des Fiches de Paie</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="search-form" style="background: var(--card-bg); padding: 30px; border-radius: 16px;">
                <h3>Critères de recherche</h3>
                
                <form action="<%=ctx%>/fiches/rechercher" method="get">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                        <div class="form-group">
                            <label>👤 Employé</label>
                            <select name="employeId">
                                <option value="">-- Tous --</option>
                                <% if (listeEmployes != null) { for (Employe emp : listeEmployes) { %>
                                    <option value="<%= emp.getId() %>"><%= emp.getMatricule() %> - <%= emp.getNom() %></option>
                                <% }} %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>📅 Mois</label>
                            <select name="mois">
                                <option value="">-- Tous --</option>
                                <% for(int i=1; i<=12; i++) { %><option value="<%=i%>"><%=i%></option><% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>📆 Année</label>
                            <input type="number" name="annee" placeholder="Ex: 2025">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="margin-top: 20px;">🔍 Rechercher</button>
                </form>
            </div>

            <% if (resultats != null) { %>
                <h3>Résultats : <%= resultats.size() %> fiche(s)</h3>
                <ul>
                    <% for (FicheDePaie f : resultats) { %>
                        <li>
                            <%= f.getEmploye().getNom() %> - <%= f.getMois() %>/<%= f.getAnnee() %> 
                            - <a href="<%=ctx%>/fiches/voir?id=<%= f.getId() %>">Voir</a>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>