<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.FicheDePaie" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    List<FicheDePaie> listeFiches = (List<FicheDePaie>) request.getAttribute("listeFiches");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    
    boolean canCreateFiches = RoleHelper.canCreateFichesPaie(session);
    boolean canViewAll = RoleHelper.canViewAllFichesPaie(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    boolean isAdmin = RoleHelper.isAdmin(session);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fiches de Paie</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>.btn-pdf { background: #dc2626; color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 0.8rem; }</style>
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>Fiches de Paie</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title"><%= isEmploye ? "📄 Mes Fiches de Paie" : "💰 Liste des Fiches de Paie" %></h2>

            <% if (message != null) { %><div class="alert alert-success">✅ Opération réussie !</div><% } %>
            <% if (erreur != null) { %><div class="alert alert-danger">⚠️ <%= erreur %></div><% } %>

            <div class="actions" style="margin-bottom: 20px;">
                <% if (canCreateFiches) { %>
                    <a href="<%=ctx%>/fiches/nouvelle" class="btn btn-primary">Créer une fiche</a>
                <% } %>
                <% if (canViewAll) { %>
                    <a href="<%=ctx%>/fiches/rechercher" class="btn btn-success">Rechercher</a>
                <% } %>
            </div>

            <% if (listeFiches != null && !listeFiches.isEmpty()) { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <% if (!isEmploye) { %><th>EMPLOYÉ</th><% } %>
                                <th>PÉRIODE</th><th>SALAIRE BASE</th><th>NET À PAYER</th><th>ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (FicheDePaie fiche : listeFiches) { %>
                            <tr>
                                <% if (!isEmploye) { %>
                                <td><strong><%= fiche.getEmploye().getPrenom() %> <%= fiche.getEmploye().getNom() %></strong></td>
                                <% } %>
                                <td><span class="badge badge-primary"><%= fiche.getMois() %> / <%= fiche.getAnnee() %></span></td>
                                <td><%= String.format("%.2f", fiche.getSalaireDeBase()) %> €</td>
                                <td style="font-weight: 800; color: var(--accent-light);"><%= String.format("%.2f", fiche.getNetAPayer()) %> €</td>
                                <td>
                                    <div style="display: flex; gap: 5px;">
                                        <a href="<%=ctx%>/fiches/voir?id=<%= fiche.getId() %>" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">👁️ Voir</a>
                                        <a href="<%=ctx%>/fiches/pdf?id=<%= fiche.getId() %>" class="btn-pdf">📥 PDF</a>
                                        <% if (isAdmin) { %>
                                            <a href="<%=ctx%>/fiches/supprimer?id=<%= fiche.getId() %>" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="return confirm('Supprimer ?');">🗑️</a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 40px; background: var(--dark-light); border-radius: 16px;">
                    <h3>Aucune fiche de paie</h3>
                </div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>