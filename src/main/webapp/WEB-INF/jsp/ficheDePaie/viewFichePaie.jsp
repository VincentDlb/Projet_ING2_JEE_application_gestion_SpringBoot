<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.FicheDePaie" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    FicheDePaie fiche = (FicheDePaie) request.getAttribute("fiche");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Fiche de Paie</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>@media print { .no-print { display: none !important; } }</style>
</head>
<body>
    <div class="app-container">
        <header class="app-header no-print"><h1>💰 Fiche de Paie</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <% if (fiche != null) { %>
                <div class="action-bar no-print" style="margin-bottom: 20px;">
                    <button onclick="window.print()" class="btn btn-success">🖨️ Imprimer</button>
                    <a href="<%=ctx%>/fiches/pdf?id=<%= fiche.getId() %>" class="btn btn-danger">📥 Télécharger PDF</a>
                    <a href="<%=ctx%>/fiches" class="btn btn-secondary">← Retour</a>
                </div>

                <div class="fiche-paie" style="background: white; padding: 40px; border: 1px solid #ddd; max-width: 800px; margin: 0 auto;">
                    <h1 style="text-align: center; color: #6366f1;">BULLETIN DE PAIE</h1>
                    <p style="text-align: center;">Période : <%= fiche.getMois() %> / <%= fiche.getAnnee() %></p>
                    
                    <hr>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
                        <div>
                            <h3>Employeur</h3>
                            <p>RowTech SAS<br>123 Avenue de l'Innovation</p>
                        </div>
                        <div>
                            <h3>Salarié</h3>
                            <p><strong><%= fiche.getEmploye().getNom() %> <%= fiche.getEmploye().getPrenom() %></strong><br>
                            Matricule : <%= fiche.getEmploye().getMatricule() %></p>
                        </div>
                    </div>
                    <hr>

                    <table style="width: 100%; border-collapse: collapse;">
                        <tr style="background: #f3f4f6;">
                            <th style="padding: 10px; text-align: left;">Libellé</th>
                            <th style="padding: 10px; text-align: right;">Montant</th>
                        </tr>
                        <tr>
                            <td style="padding: 10px;">Salaire de base</td>
                            <td style="padding: 10px; text-align: right;"><%= String.format("%.2f", fiche.getSalaireDeBase()) %> €</td>
                        </tr>
                        <tr>
                            <td style="padding: 10px;">Primes</td>
                            <td style="padding: 10px; text-align: right;">+ <%= String.format("%.2f", fiche.getPrimes()) %> €</td>
                        </tr>
                        <tr>
                            <td style="padding: 10px; color: #f59e0b;">Total Cotisations</td>
                            <td style="padding: 10px; text-align: right; color: #f59e0b;">- <%= String.format("%.2f", fiche.getTotalCotisations()) %> €</td>
                        </tr>
                        <tr style="font-weight: bold; background: #e0e7ff; font-size: 1.2em;">
                            <td style="padding: 15px;">NET À PAYER</td>
                            <td style="padding: 15px; text-align: right; color: #4338ca;"><%= String.format("%.2f", fiche.getNetAPayer()) %> €</td>
                        </tr>
                    </table>
                </div>
            <% } else { %>
                <div class="alert alert-danger">⚠️ Fiche introuvable</div>
            <% } %>
        </div>
        <footer class="no-print"><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>