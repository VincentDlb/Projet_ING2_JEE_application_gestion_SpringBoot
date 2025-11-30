<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.FicheDePaie" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<FicheDePaie> fichesDePaie = (List<FicheDePaie>) request.getAttribute("fichesDePaie");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Fiches de Paie - Équipe <%= departement.getNom() %></title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>💰 Fiches de Paie - <%= departement.getNom() %></h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions" style="margin-bottom: 20px;">
                <a href="<%=ctx%>/departements/mon-departement" class="btn btn-secondary">← Retour</a>
            </div>

            <% if (fichesDePaie != null && !fichesDePaie.isEmpty()) { %>
                <div class="table-container">
                    <table>
                        <thead><tr><th>Employé</th><th>Période</th><th>Net à Payer</th><th>Actions</th></tr></thead>
                        <tbody>
                            <% for (FicheDePaie f : fichesDePaie) { %>
                                <tr>
                                    <td><%= f.getEmploye().getPrenom() %> <%= f.getEmploye().getNom() %></td>
                                    <td><%= f.getMois() %>/<%= f.getAnnee() %></td>
                                    <td><strong><%= String.format("%.2f €", f.getNetAPayer()) %></strong></td>
                                    <td>
                                        <a href="<%=ctx%>/fiches/voir?id=<%= f.getId() %>" class="btn btn-primary btn-sm">Voir</a>
                                        <a href="<%=ctx%>/fiches/pdf?id=<%= f.getId() %>" class="btn btn-danger btn-sm">PDF</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state"><p>Aucune fiche de paie pour ce département.</p></div>
            <% } %>
        </div>
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>