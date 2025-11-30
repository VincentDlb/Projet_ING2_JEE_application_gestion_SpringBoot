<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Projet" %>
<%
    List<Projet> tousMesProjets = (List<Projet>) request.getAttribute("mesProjets"); // Note: variable 'mesProjets' dans Controller
    if (tousMesProjets == null) tousMesProjets = (List<Projet>) request.getAttribute("tousMesProjets"); // Fallback
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tous Mes Projets</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        .badge-chef { background: #10b981; color: white; padding: 4px 12px; border-radius: 12px; }
        .badge-membre { background: #3b82f6; color: white; padding: 4px 12px; border-radius: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />
        
        <div class="header" style="padding: 20px;">
            <h1>📊 Mes Projets</h1>
        </div>

        <div class="content-section" style="padding: 20px;">
            <% if (tousMesProjets != null && !tousMesProjets.isEmpty()) { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Nom</th><th>Description</th><th>État</th><th>Rôle</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Projet projet : tousMesProjets) { 
                             // Logique simple pour l'exemple (tu peux améliorer avec RoleHelper si besoin)
                             // Ici on suppose que le contrôleur a déjà filtré ou qu'on affiche tout
                        %>
                            <tr>
                                <td><strong><%=projet.getNom()%></strong></td>
                                <td><%=projet.getDescription()%></td>
                                <td><span class="badge"><%=projet.getEtat()%></span></td>
                                <td>
                                    <span class="badge-membre">Associé</span>
                                </td>
                                <td>
                                    <a href="<%=ctx%>/projets/detail?id=<%=projet.getId()%>" class="btn btn-info btn-sm">📋 Détails</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="alert alert-info">ℹ️ Vous n'appartenez à aucun projet.</div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>