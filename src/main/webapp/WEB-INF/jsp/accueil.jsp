<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    String ctx = request.getContextPath(); // Raccourci pour les liens
    
    if (nomComplet == null) {
        response.sendRedirect("auth"); // Redirection propre vers le controller
        return;
    }
    
    // Vérifier les permissions
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        /* Rendre les cartes plus interactives */
        .card {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏢 RowTech - Gestion RH</h1>
            <p>Système de Gestion des Ressources Humaines</p>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <h2 class="page-title">Bienvenue, <%= nomComplet %> !</h2>

            <div style="text-align: center; margin: 40px 0;">
                <p style="font-size: 1.2rem; color: var(--text-secondary);">
                    Vous êtes connecté en tant que : <strong style="color: var(--accent-light);"><%= userRole %></strong>
                </p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-top: 40px;">
                
                <%-- ============================================= --%>
                <%-- MODULES ADMIN --%>
                <%-- ============================================= --%>
                <% if (isAdmin) { %>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">👥</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Employés</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Ajouter, modifier, consulter les employés
                    </p>
                    <a href="<%=ctx%>/employes" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Départements</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Créer, gérer les départements
                    </p>
                    <a href="<%=ctx%>/departements" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Créer, suivre les projets internes
                    </p>
                    <a href="<%=ctx%>/projets" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Générer, consulter toutes les fiches de paie
                    </p>
                    <a href="<%=ctx%>/fiches" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports et analyses
                    </p>
                    <a href="<%=ctx%>/statistiques" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES CHEF DE DÉPARTEMENT --%>
                <%-- ============================================= --%>
                <% if (isChefDept) { %>
                
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer votre département et ses membres
                    </p>
                    <a href="<%=ctx%>/departements/mon-departement" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les projets auxquels vous participez
                    </p>
                    <a href="<%=ctx%>/projets/mes-projets" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Consulter vos fiches et celles de votre équipe
                    </p>
                    <a href="<%=ctx%>/fiches/mes-fiches" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports
                    </p>
                    <a href="<%=ctx%>/statistiques" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES CHEF DE PROJET --%>
                <%-- ============================================= --%>
                <% if (isChefProjet) { %>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir votre département
                    </p>
                    <a href="<%=ctx%>/departements/mon-departement" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer vos projets et leurs membres
                    </p>
                    <a href="<%=ctx%>/projets/mes-projets" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer les fiches de vos projets
                    </p>
                    <a href="<%=ctx%>/fiches/mes-fiches" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports de vos projets
                    </p>
                    <a href="<%=ctx%>/statistiques" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES EMPLOYÉ SIMPLE --%>
                <%-- ============================================= --%>
                <% if (isEmploye) { %>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir votre département et collègues
                    </p>
                    <a href="<%=ctx%>/departements/mon-departement" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les projets auxquels vous participez
                    </p>
                    <a href="<%=ctx%>/projets/mes-projets" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Consulter vos fiches de paie
                    </p>
                    <a href="<%=ctx%>/fiches/mes-fiches" class="btn btn-primary" style="width: 100%;">Accéder</a>
                </div>
                
                <% } %>
                
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>