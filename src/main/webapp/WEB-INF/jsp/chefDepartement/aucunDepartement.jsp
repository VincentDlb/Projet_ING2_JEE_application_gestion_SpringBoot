<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aucun Département</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header"><h1>Mon Département</h1></header>
        <jsp:include page="/WEB-INF/jsp/navigation.jsp" />

        <div class="content" style="text-align:center; padding: 80px;">
            <h2 style="color: #64748b;">Aucun département assigné</h2>
            <p>Vous n'êtes actuellement assigné à aucun département.</p>
            <p>Veuillez contacter votre administrateur RH.</p>
            <a href="<%=request.getContextPath()%>/accueil.jsp" class="btn btn-primary">← Accueil</a>
        </div>
        
        <footer><p>© 2025 RowTech</p></footer>
    </div>
</body>
</html>