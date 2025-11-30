<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> employesDisponibles = (List<Employe>) request.getAttribute("employesDisponibles");
    Set<Employe> membresActuels = projet.getEmployes();
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
                <a href="<%=ctx%>/projets/detail?id=<%=projet.getId()%>" class="btn btn-secondary">← Retour</a>
            </div>

            <div class="team-section" style="background: var(--dark-light); padding: 20px; border-radius: 12px; margin-bottom: 20px;">
                <h3>➕ Ajouter un membre</h3>
                <form action="<%=ctx%>/projets/ajouter-membre" method="post" style="display: flex; gap: 10px;">
                    <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                    <select name="employeId" style="flex: 1;">
                        <option value="">-- Sélectionner un employé --</option>
                        <% if (employesDisponibles != null) { for (Employe emp : employesDisponibles) { %>
                            <option value="<%= emp.getId() %>"><%= emp.getPrenom() %> <%= emp.getNom() %> (<%= emp.getPoste() %>)</option>
                        <% }} %>
                    </select>
                    <button type="submit" class="btn btn-success">Ajouter</button>
                </form>
            </div>

            <div class="team-section">
                <h3>Membres actuels</h3>
                <table class="data-table">
                    <thead><tr><th>Nom</th><th>Poste</th><th>Action</th></tr></thead>
                    <tbody>
                        <% for (Employe m : membresActuels) { %>
                            <tr>
                                <td><%= m.getPrenom() %> <%= m.getNom() %></td>
                                <td><%= m.getPoste() %></td>
                                <td>
                                    <form action="<%=ctx%>/projets/retirer-membre" method="post" style="display:inline;">
                                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                                        <input type="hidden" name="employeId" value="<%= m.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Retirer ?');">Retirer</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>