<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Employe" %>
<%@ page import="com.rsv.ProjetSpringBoot.model.Departement" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
   List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
   List<Departement> departements = (List<Departement>) request.getAttribute("departements");
   String nomComplet = (String) session.getAttribute("nomComplet");
   String userRole = (String) session.getAttribute("userRole");
   String message = request.getParameter("message");
   String erreur = request.getParameter("erreur");
   String ctx = request.getContextPath(); // Raccourci pour le contexte
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>Gestion des Employés - RowTech</title>
   <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
   <div class="app-container">
       <header class="app-header">
           <h1>👥 Gestion des Employés</h1>
           <p>RowTech - Système de Gestion RH</p>
       </header>

       <jsp:include page="/WEB-INF/jsp/navigation.jsp" />
       
       <div class="content">
           <h2 class="page-title">Liste des Employés</h2>

           <% if (message != null) { %>
               <div class="alert alert-success">
                   <% if ("ajout_ok".equals(message)) { %> ✅ Employé ajouté avec succès !
                   <% } else if ("modif_ok".equals(message)) { %> ✅ Employé modifié avec succès !
                   <% } else if ("suppression_ok".equals(message)) { %> ✅ Employé supprimé avec succès !
                   <% } %>
               </div>
           <% } %>

           <div style="background: var(--card-bg); padding: 20px; border-radius: 10px; margin-bottom: 25px; border: 1px solid var(--border);">
               <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                   <div style="display: flex; gap: 10px;">
                       <a href="<%=ctx%>/employes/nouveau" class="btn btn-primary">Ajouter un employé</a>
                       <a href="<%=ctx%>/employes/rechercher" class="btn btn-success">Recherche avancée</a>
                   </div>
               </div>

               <div style="border-top: 1px solid var(--border); padding-top: 20px;">
                   <h3 style="margin-bottom: 15px; color: var(--primary); font-size: 1rem;">Filtres rapides</h3>
                   <form action="<%=ctx%>/employes" method="get">
                       <div style="display: grid; grid-template-columns: repeat(3, 1fr) auto; gap: 15px; align-items: end;">
                           <div class="form-group" style="margin-bottom: 0;">
                               <label>Département</label>
                               <select name="departement">
                                   <option value="">-- Tous --</option>
                                   <% if (departements != null) { for (Departement dept : departements) { %>
                                       <option value="<%= dept.getId() %>"><%= dept.getNom() %></option>
                                   <% }} %>
                               </select>
                           </div>
                           <button type="submit" class="btn btn-primary" style="height: 45px;">✓ Filtrer</button>
                       </div>
                   </form>
               </div>

               <% if (listeEmployes != null && !listeEmployes.isEmpty()) { %>
               <div class="table-container">
                   <table class="data-table">
                       <thead>
                           <tr>
                               <th>Matricule</th>
                               <th>Nom</th>
                               <th>Prénom</th>
                               <th>Poste</th>
                               <th>Département</th>
                               <th>Actions</th>
                           </tr>
                       </thead>
                       <tbody>
                           <% for (Employe employe : listeEmployes) { %>
                               <tr>
                                   <td><strong><%= employe.getMatricule() %></strong></td>
                                   <td><%= employe.getNom() %></td>
                                   <td><%= employe.getPrenom() %></td>
                                   <td><%= employe.getPoste() %></td>
                                   <td><%= (employe.getDepartement() != null) ? employe.getDepartement().getNom() : "Non assigné" %></td>
                                   <td>
                                       <div style="display: flex; gap: 5px;">
                                           <a href="<%=ctx%>/employes/modifier?id=<%= employe.getId() %>" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">✏️</a>
                                           <a href="<%=ctx%>/employes/supprimer?id=<%= employe.getId() %>" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="return confirm('Supprimer ?');">🗑️</a>
                                       </div>
                                   </td>
                               </tr>
                           <% } %>
                       </tbody>
                   </table>
               </div>
               <% } else { %>
                   <div style="padding: 40px; text-align: center;"><p>Aucun employé trouvé</p></div>
               <% } %>
           </div>
       </div>
       <footer><p>© 2025 RowTech</p></footer>
   </div>
</body>
</html>