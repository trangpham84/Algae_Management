<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found — AlgaeDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="navbar"><div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
            AlgaeDB
        </a>
    </div></header>
    <div class="auth-wrapper">
        <div style="text-align:center;" class="animate-scale-in">
            <div style="font-size:6rem;font-weight:800;color:var(--primary);line-height:1;margin-bottom:0.5rem;">404</div>
            <h1 style="font-size:1.5rem;font-weight:700;margin-bottom:0.5rem;">Page Not Found</h1>
            <p style="color:var(--muted-foreground);margin-bottom:2rem;">The page you're looking for doesn't exist or has been moved.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Back to Home</a>
        </div>
    </div>
</body>
</html>
