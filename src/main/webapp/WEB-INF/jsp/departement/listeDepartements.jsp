<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Départements - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        .dept-card { background: var(--card-bg); border-radius: 15px; padding: 25px; border: 1px solid var(--border); transition: all 0.3s ease; height: 100%; display: flex; flex-direction: column; }
        .dept-card:hover { transform: translateY(-8px); box-shadow: 0 12px 30px rgba(139, 92, 246, 0.2); border-color: var(--primary); }
        .dept-card-header { display: flex; justify-content: space-between; margin-bottom: 20px; border-bottom: 2px solid var(--border); padding-bottom: 15px; }
        .dept-name { font-size: 1.3rem; font-weight: 700; color: var(--text-primary); margin: 0; }
        .dept-id-badge { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; padding: 5px 12px; border-radius: 20px; font-weight: 700; }
        .dept-chef-badge { background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 10px 15px; border-radius: 10px; font-weight: 600; display: inline-flex; gap: 8px; }
        .dept-no-chef { background: #64748b; color: white; padding: 10px 15px; border-radius: 10px; font-weight: 600; }
        .dept-description { color: var(--text-secondary); margin: 15px 0; flex-grow: 1; font-style: italic; }
        .dept-actions { display: flex; gap: 10px; margin-top: 20px; border-top: 1px solid var(--border); padding-top: 15px; }
        .grid-departments { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 25px; }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏛️ Gestion des Départements</h1>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Liste des Départements (<%= listeDepartements != null ? listeDepartements.size() : 0 %>)</h2>

            <% if (message != null) { %>
                <div class="alert alert-success">✅ Opération réussie !</div>
            <% } %>
            <% if (erreur != null) { %>
                <div class="alert alert-error">❌ <%= erreur %></div>
            <% } %>

            <div class="actions" style="margin-bottom: 30px;">
                <a href="<%=ctx%>/departements/nouveau" class="btn btn-primary">Ajouter un département</a>
            </div>

            <% if (listeDepartements != null && !listeDepartements.isEmpty()) { %>
                <div class="grid-departments">
                    <% for (Departement dept : listeDepartements) { 
                        Employe chef = dept.getChefDepartement();
                    %>
                    <div class="dept-card">
                        <div class="dept-card-header">
                            <h3 class="dept-name">🏛️ <%= dept.getNom() %></h3>
                            <span class="dept-id-badge">#<%= dept.getId() %></span>
                        </div>

                        <% if (chef != null) { %>
                            <div class="dept-chef-badge">👨‍💼 Chef : <%= chef.getPrenom() %> <%= chef.getNom() %></div>
                        <% } else { %>
                            <div class="dept-no-chef">😟 Aucun chef désigné</div>
                        <% } %>

                        <div class="dept-description">
                            <%= (dept.getDescription() != null && !dept.getDescription().trim().isEmpty()) ? dept.getDescription() : "Aucune description" %>
                        </div>

                        <div class="dept-actions">
                            <a href="<%=ctx%>/departements/mon-departement?id=<%= dept.getId() %>" class="btn btn-primary" style="flex: 1; text-align: center;">Membres</a>
                            
                            <a href="<%=ctx%>/departements/modifier?id=<%= dept.getId() %>" class="btn btn-warning btn-icon">✏️</a>
                            
                            <a href="<%=ctx%>/departements/supprimer?id=<%= dept.getId() %>" class="btn btn-danger btn-icon" onclick="return confirm('⚠️ Supprimer ce département ?');">🗑️</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 80px;">
                    <h3>Aucun Département</h3>
                    <a href="<%=ctx%>/departements/nouveau" class="btn btn-primary">➕ Créer le premier département</a>
                </div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>