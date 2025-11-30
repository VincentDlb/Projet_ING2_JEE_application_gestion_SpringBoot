<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> employesDisponibles = (List<Employe>) request.getAttribute("employesDisponibles");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gérer l'Équipe</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>👥 Gérer l'Équipe - <%= projet.getNom() %></h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions" style="margin-bottom: 20px;">
                <a href="<%=ctx%>/projets/mes-projets" class="btn btn-secondary">← Retour</a>
            </div>

            <% if (message != null) { %><div class="alert alert-success">✅ <%= message %></div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                <div class="card">
                    <h3>Membres Actuels (<%= projet.getEmployes().size() %>)</h3>
                    <ul>
                        <% for (Employe m : projet.getEmployes()) { %>
                            <li style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <span><%= m.getPrenom() %> <%= m.getNom() %></span>
                                <% if (projet.getChefDeProjet() != null && m.getId().equals(projet.getChefDeProjet().getId())) { %>
                                    <span class="badge badge-warning">Chef</span>
                                <% } else { %>
                                    <form action="<%=ctx%>/projets/retirer-membre" method="post" style="margin:0;">
                                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                                        <input type="hidden" name="employeId" value="<%= m.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Retirer ?');">Retirer</button>
                                    </form>
                                <% } %>
                            </li>
                        <% } %>
                    </ul>
                </div>

                <div class="card">
                    <h3>Ajouter un membre</h3>
                    <form action="<%=ctx%>/projets/ajouter-membre" method="post">
                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                        <div class="form-group">
                            <select name="employeId" required style="width: 100%; padding: 10px;">
                                <option value="">-- Sélectionner --</option>
                                <% if (employesDisponibles != null) { for (Employe e : employesDisponibles) { 
                                    // On n'affiche pas ceux qui sont déjà dans le projet (logique simple)
                                    boolean dejaMembre = projet.getEmployes().contains(e);
                                    if (!dejaMembre) {
                                %>
                                    <option value="<%= e.getId() %>"><%= e.getPrenom() %> <%= e.getNom() %></option>
                                <%  } } } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success" style="margin-top: 10px;">➕ Ajouter</button>
                    </form>
                </div>
            </div>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>