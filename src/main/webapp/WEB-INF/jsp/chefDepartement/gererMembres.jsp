<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="java.util.List" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membresActuels = (List<Employe>) request.getAttribute("membresActuels");
    List<Employe> employesDisponibles = (List<Employe>) request.getAttribute("employesDisponibles");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gérer les Membres</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>👥 Gérer les Membres - <%= departement.getNom() %></h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions" style="margin-bottom: 20px;">
                <a href="<%=ctx%>/departements/mon-departement" class="btn btn-secondary">← Retour</a>
            </div>

            <% if (message != null) { %><div class="alert alert-success">✅ <%= message %></div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                <div class="card">
                    <h3>Membres actuels (<%= membresActuels.size() %>)</h3>
                    <ul>
                        <% for (Employe m : membresActuels) { %>
                            <li style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <span><%= m.getPrenom() %> <%= m.getNom() %></span>
                                <% if (!m.getId().equals(departement.getChefDepartement().getId())) { %>
                                    <form action="<%=ctx%>/departements/retirer-membre" method="post" style="margin:0;">
                                        <input type="hidden" name="departementId" value="<%= departement.getId() %>">
                                        <input type="hidden" name="employeId" value="<%= m.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Retirer ?');">Retirer</button>
                                    </form>
                                <% } else { %>
                                    <span class="badge badge-warning">Chef</span>
                                <% } %>
                            </li>
                        <% } %>
                    </ul>
                </div>

                <div class="card">
                    <h3>Ajouter un employé disponible</h3>
                    <% if (employesDisponibles != null && !employesDisponibles.isEmpty()) { %>
                        <form action="<%=ctx%>/departements/ajouter-membre" method="post">
                            <input type="hidden" name="departementId" value="<%= departement.getId() %>">
                            <div class="form-group">
                                <select name="employeId" style="width: 100%; padding: 10px;">
                                    <% for (Employe e : employesDisponibles) { %>
                                        <option value="<%= e.getId() %>"><%= e.getPrenom() %> <%= e.getNom() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success" style="margin-top: 10px;">➕ Ajouter</button>
                        </form>
                    <% } else { %>
                        <p>Aucun employé disponible (tous ont déjà un département).</p>
                    <% } %>
                </div>
            </div>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>