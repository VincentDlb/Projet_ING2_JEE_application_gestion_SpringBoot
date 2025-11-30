<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membres = (List<Employe>) request.getAttribute("membres");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Membres du Département</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        .dept-info-box { background: rgba(139, 92, 246, 0.1); border: 2px solid var(--primary); border-radius: 15px; padding: 25px; margin-bottom: 30px; }
        .dept-info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .dept-info-item { background: var(--card-bg); padding: 15px; border-radius: 10px; border: 1px solid var(--border); }
        .grade-badge { padding: 6px 12px; border-radius: 8px; font-weight: 700; color: white; display: inline-block; }
        .grade-junior { background: #06b6d4; }
        .grade-confirme { background: #8b5cf6; }
        .grade-senior { background: #10b981; }
        .grade-expert { background: #f59e0b; }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏛️ Membres du Département</h1>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Membres : <span style="color: var(--primary);"><%= (departement != null) ? departement.getNom() : "" %></span></h2>

            <% if (departement != null) { %>
                <div class="dept-info-box">
                    <h3>📋 Informations</h3>
                    <div class="dept-info-grid">
                        <div class="dept-info-item">
                            <div>Nom</div>
                            <strong><%= departement.getNom() %></strong>
                        </div>
                        <div class="dept-info-item">
                            <div>Membres</div>
                            <strong><%= (membres != null) ? membres.size() : 0 %></strong>
                        </div>
                        <% if (departement.getChefDepartement() != null) { %>
                        <div class="dept-info-item">
                            <div>Chef</div>
                            <strong><%= departement.getChefDepartement().getPrenom() %> <%= departement.getChefDepartement().getNom() %></strong>
                        </div>
                        <% } %>
                    </div>
                    <div style="margin-top: 20px;">
                        <a href="<%=ctx%>/departements" class="btn btn-secondary">← Retour liste</a>
                    </div>
                </div>
            <% } %>

            <% if (membres != null && !membres.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr><th>Matricule</th><th>Nom</th><th>Poste</th><th>Grade</th><th>Email</th><th>Salaire</th></tr>
                        </thead>
                        <tbody>
                            <% for (Employe membre : membres) { 
                                String grade = (membre.getGrade() != null) ? membre.getGrade() : "INCONNU";
                                String gradeClass = "grade-junior";
                                if ("CONFIRME".equals(grade)) gradeClass = "grade-confirme";
                                else if ("SENIOR".equals(grade)) gradeClass = "grade-senior";
                                else if ("EXPERT".equals(grade)) gradeClass = "grade-expert";
                            %>
                                <tr>
                                    <td><strong><%= membre.getMatricule() %></strong></td>
                                    <td><%= membre.getPrenom() %> <%= membre.getNom() %></td>
                                    <td><%= membre.getPoste() %></td>
                                    <td><span class="grade-badge <%= gradeClass %>"><%= grade %></span></td>
                                    <td><%= membre.getEmail() %></td>
                                    <td><strong><%= String.format("%.2f", membre.getSalaire()) %> €</strong></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 60px;">
                    <h3>Aucun Membre</h3>
                    <p>Ce département est vide.</p>
                </div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>