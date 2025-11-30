<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    List<Employe> resultats = (List<Employe>) request.getAttribute("resultats");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recherche Employés</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🔍 Recherche d'Employés</h1>
        </header>

        <div class="content">
            <h2 class="page-title">Recherche Avancée</h2>

            <div style="background: var(--card-bg); padding: 25px; border-radius: 10px; margin-bottom: 30px; border: 1px solid var(--border);">
                <form action="<%=ctx%>/employes/rechercher" method="get">
                    <div style="display: grid; grid-template-columns: 200px 1fr auto; gap: 15px; align-items: end;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label>Rechercher par</label>
                            <select name="critere">
                                <option value="nom">Nom</option>
                                <option value="prenom">Prénom</option>
                                <option value="matricule">Matricule</option>
                                <option value="poste">Poste</option>
                                <option value="grade">Grade</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label>Valeur</label>
                            <input type="text" name="valeur" placeholder="Entrez votre recherche..." required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="height: 45px;">🔍 Rechercher</button>
                    </div>
                </form>
            </div>

            <% if (resultats != null) { %>
                <h3 style="color: var(--primary); margin-bottom: 20px;">
                    📊 Résultats : <%= resultats.size() %> employé(s) trouvé(s)
                </h3>
                
                <% if (!resultats.isEmpty()) { %>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Matricule</th><th>Nom</th><th>Prénom</th><th>Poste</th><th>Grade</th><th>Département</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Employe emp : resultats) { %>
                                    <tr>
                                        <td><strong><%= emp.getMatricule() %></strong></td>
                                        <td><%= emp.getNom() %></td>
                                        <td><%= emp.getPrenom() %></td>
                                        <td><%= emp.getPoste() %></td>
                                        <td><%= emp.getGrade() %></td>
                                        <td><%= (emp.getDepartement() != null) ? emp.getDepartement().getNom() : "N/A" %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p>Aucun résultat.</p>
                <% } %>
            <% } %>

            <div style="margin-top: 30px;">
                <a href="<%=ctx%>/employes" class="btn btn-secondary">← Retour à la liste</a>
            </div>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>