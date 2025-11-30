<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%
    List<Projet> tousMesProjets = (List<Projet>) request.getAttribute("tousMesProjets");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Projets</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>📁 Mes Projets</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <% if (tousMesProjets != null && !tousMesProjets.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead><tr><th>NOM</th><th>ÉTAT</th><th>RÔLE</th><th>ACTIONS</th></tr></thead>
                        <tbody>
                            <% for (Projet p : tousMesProjets) { %>
                                <tr>
                                    <td><strong><%= p.getNom() %></strong></td>
                                    <td><span class="badge badge-primary"><%= p.getEtat() %></span></td>
                                    <td>
                                        <span class="badge badge-info">Membre/Chef</span>
                                    </td>
                                    <td>
                                        <a href="<%=ctx%>/projets/detail?id=<%= p.getId() %>" class="btn btn-secondary">📄 Détails</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 40px;"><p>Aucun projet assigné.</p></div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>