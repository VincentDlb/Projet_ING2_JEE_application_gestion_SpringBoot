<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.ProjetSpringBoot.model.Statistiques" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.rsv.ProjetSpringBoot.util.RoleHelper" %>
<%
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    
    // Récupération de l'attribut passé par le contrôleur
    Statistiques stats = (Statistiques) request.getAttribute("statistiques");
    
    // Formatters pour l'affichage
    DecimalFormat dfMoney = new DecimalFormat("#,##0.00 €");
    DecimalFormat dfNumber = new DecimalFormat("#,##0");
    
    String ctx = request.getContextPath(); // Raccourci pour les liens
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--spacing-lg); margin: var(--spacing-xl) 0; }
        .stat-card { background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border); text-align: center; transition: all 0.3s ease; position: relative; overflow: hidden; }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: linear-gradient(90deg, var(--primary), var(--accent)); }
        .stat-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-xl); border-color: var(--primary); }
        .stat-icon { font-size: 3rem; margin-bottom: var(--spacing-sm); }
        .stat-value { font-size: 2.5rem; font-weight: 800; color: var(--primary-light); margin-bottom: var(--spacing-xs); letter-spacing: -0.02em; }
        .stat-label { font-size: 1rem; color: var(--text-secondary); font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; }
        .chart-section { margin: var(--spacing-xl) 0; background: var(--dark-light); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border); }
        .chart-title { font-size: 1.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: var(--spacing-lg); padding-bottom: var(--spacing-sm); border-bottom: 2px solid var(--border); }
        .chart-container { position: relative; height: 400px; margin: 20px 0; }
        .chart-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: var(--spacing-xl); margin: var(--spacing-xl) 0; }
        .empty-state { text-align: center; padding: var(--spacing-xl); color: var(--text-muted); }
        .export-button { display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, var(--danger), #dc2626); color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; border: none; cursor: pointer; box-shadow: 0 4px 6px rgba(239, 68, 68, 0.2); }
        .export-button:hover { transform: translateY(-2px); box-shadow: 0 6px 12px rgba(239, 68, 68, 0.3); }
        .actions-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg); }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>📊 Statistiques & Rapports</h1>
            <p>Vue d'ensemble de l'entreprise RowTech</p>
        </header>

        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content">
            <div class="actions-header">
                <h2 class="page-title">📊 Tableau de Bord Statistiques</h2>
                <a href="<%=ctx%>/statistiques/export-pdf" class="export-button">
                    📄 Exporter en PDF
                </a>
            </div>

            <% if (stats != null) { %>
            
            <h3 style="font-size: 1.3rem; margin-top: var(--spacing-xl); margin-bottom: var(--spacing-md); color: var(--primary-light);">📈 Vue d'Ensemble</h3>
            <div class="stats-grid">
                <div class="stat-card"><div class="stat-icon">👥</div><div class="stat-value"><%= stats.getTotalEmployes() %></div><div class="stat-label">Employés</div></div>
                <div class="stat-card"><div class="stat-icon">🏛️</div><div class="stat-value"><%= stats.getTotalDepartements() %></div><div class="stat-label">Départements</div></div>
                <div class="stat-card"><div class="stat-icon">📁</div><div class="stat-value"><%= stats.getTotalProjets() %></div><div class="stat-label">Projets</div></div>
                <div class="stat-card"><div class="stat-icon">💰</div><div class="stat-value"><%= stats.getTotalFichesDePaie() %></div><div class="stat-label">Fiches de Paie</div></div>
            </div>

            <h3 style="font-size: 1.3rem; margin-top: var(--spacing-xl); margin-bottom: var(--spacing-md); color: var(--success);">💵 Statistiques Salaires</h3>
            <div class="stats-grid">
                <div class="stat-card" style="border-color: var(--success);"><div class="stat-icon">💰</div><div class="stat-value" style="font-size: 1.8rem; color: var(--success);"><%= dfMoney.format(stats.getMasseSalarialeTotal()) %></div><div class="stat-label">Masse Salariale</div></div>
                <div class="stat-card" style="border-color: var(--success);"><div class="stat-icon">📊</div><div class="stat-value" style="font-size: 1.8rem; color: var(--success);"><%= dfMoney.format(stats.getSalaireMoyen()) %></div><div class="stat-label">Salaire Moyen</div></div>
                <div class="stat-card" style="border-color: var(--warning);"><div class="stat-icon">⬇️</div><div class="stat-value" style="font-size: 1.5rem; color: var(--warning);"><%= dfMoney.format(stats.getSalaireMin()) %></div><div class="stat-label">Salaire Minimum</div></div>
                <div class="stat-card" style="border-color: var(--accent);"><div class="stat-icon">⬆️</div><div class="stat-value" style="font-size: 1.5rem; color: var(--accent);"><%= dfMoney.format(stats.getSalaireMax()) %></div><div class="stat-label">Salaire Maximum</div></div>
            </div>

            <div class="chart-grid">
                <div class="chart-section">
                    <h3 class="chart-title">🏛️ Employés par Département</h3>
                    <div class="chart-container"><canvas id="chartDepartements"></canvas></div>
                </div>
                <div class="chart-section">
                    <h3 class="chart-title">📊 Projets par État</h3>
                    <div class="chart-container"><canvas id="chartProjetsEtat"></canvas></div>
                </div>
            </div>

            <div class="chart-grid">
                <div class="chart-section">
                    <h3 class="chart-title">🎓 Employés par Grade</h3>
                    <div class="chart-container"><canvas id="chartGrades"></canvas></div>
                </div>
                <div class="chart-section">
                    <h3 class="chart-title">💼 Employés par Poste</h3>
                    <div class="chart-container"><canvas id="chartPostes"></canvas></div>
                </div>
            </div>

            <div class="chart-section">
                <h3 class="chart-title">📁 Employés par Projet</h3>
                <div class="chart-container" style="height: 500px;"><canvas id="chartProjets"></canvas></div>
            </div>

            <% } else { %>
            <div class="alert alert-danger">⚠️ Impossible de charger les statistiques</div>
            <% } %>
            
            <div class="actions" style="margin-top: var(--spacing-xl);">
                <a href="<%=ctx%>/accueil" class="btn btn-secondary">← Retour à l'accueil</a>
            </div>
        </div>

        <footer><p>© 2025 RowTech - Tous droits réservés</p></footer>
    </div>

    <script>
        <% if (stats != null) { 
            Map<String, Integer> empParDept = stats.getEmployesParDepartement();
            Map<String, Integer> projetsParEtat = stats.getProjetsParEtat();
            Map<String, Integer> empParGrade = stats.getEmployesParGrade();
            Map<String, Integer> empParPoste = stats.getEmployesParPoste();
            Map<String, Integer> empParProjet = stats.getEmployesParProjet();
        %>

        Chart.defaults.color = '#e0e0e0';
        Chart.defaults.borderColor = '#2d2d3d';
        const colors = { primary: ['rgba(99, 102, 241, 0.8)', 'rgba(139, 92, 246, 0.8)', 'rgba(59, 130, 246, 0.8)', 'rgba(14, 165, 233, 0.8)', 'rgba(6, 182, 212, 0.8)', 'rgba(20, 184, 166, 0.8)'] };

        // 1. Départements
        new Chart(document.getElementById('chartDepartements'), {
            type: 'doughnut',
            data: {
                labels: [<% for (Map.Entry<String, Integer> e : empParDept.entrySet()) { %>'<%=e.getKey()%>',<% } %>],
                datasets: [{ data: [<% for (Map.Entry<String, Integer> e : empParDept.entrySet()) { %><%=e.getValue()%>,<% } %>], backgroundColor: colors.primary }]
            }
        });

        // 2. Projets État
        new Chart(document.getElementById('chartProjetsEtat'), {
            type: 'pie',
            data: {
                labels: ['En Cours', 'Terminé', 'Annulé'],
                datasets: [{ 
                    data: [<%=projetsParEtat.getOrDefault("EN_COURS", 0)%>, <%=projetsParEtat.getOrDefault("TERMINE", 0)%>, <%=projetsParEtat.getOrDefault("ANNULE", 0)%>],
                    backgroundColor: ['#3b82f6', '#10b981', '#ef4444']
                }]
            }
        });

        // 3. Grades
        new Chart(document.getElementById('chartGrades'), {
            type: 'bar',
            data: {
                labels: [<% for (Map.Entry<String, Integer> e : empParGrade.entrySet()) { %>'<%=e.getKey()%>',<% } %>],
                datasets: [{ label: 'Employés', data: [<% for (Map.Entry<String, Integer> e : empParGrade.entrySet()) { %><%=e.getValue()%>,<% } %>], backgroundColor: '#10b981' }]
            }
        });

        // 4. Postes
        new Chart(document.getElementById('chartPostes'), {
            type: 'bar',
            data: {
                labels: [<% for (Map.Entry<String, Integer> e : empParPoste.entrySet()) { %>'<%=e.getKey()%>',<% } %>],
                datasets: [{ label: 'Employés', data: [<% for (Map.Entry<String, Integer> e : empParPoste.entrySet()) { %><%=e.getValue()%>,<% } %>], backgroundColor: '#6366f1' }]
            }
        });

        // 5. Projets
        new Chart(document.getElementById('chartProjets'), {
            type: 'bar',
            data: {
                labels: [<% for (Map.Entry<String, Integer> e : empParProjet.entrySet()) { %>'<%=e.getKey()%>',<% } %>],
                datasets: [{ label: 'Employés', data: [<% for (Map.Entry<String, Integer> e : empParProjet.entrySet()) { %><%=e.getValue()%>,<% } %>], backgroundColor: '#8b5cf6' }]
            },
            options: { indexAxis: 'y' }
        });

        <% } %>
    </script>
</body>
</html>