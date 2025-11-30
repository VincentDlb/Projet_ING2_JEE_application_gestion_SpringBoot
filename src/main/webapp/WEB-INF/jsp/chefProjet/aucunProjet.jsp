<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aucun Projet</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>Mes Projets</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content" style="text-align:center; padding: 50px;">
            <h2>🚫 Vous ne participez à aucun projet</h2>
            <p>Contactez un administrateur pour être affecté à un projet.</p>
            <a href="<%=request.getContextPath()%>/accueil.jsp" class="btn btn-primary">← Retour Accueil</a>
        </div>
        
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>