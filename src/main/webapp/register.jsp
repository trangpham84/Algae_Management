<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — AlgaeDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header class="navbar"><div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
            AlgaeDB
        </a>
        <nav class="nav-links"><a href="${pageContext.request.contextPath}/" class="nav-link">Home</a></nav>
    </div></header>

    <div class="auth-wrapper">
        <div class="auth-card animate-scale-in">
            <div class="auth-logo animate-fade-in">
                <div class="auth-logo-icon"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg></div>
                <h1 class="auth-title">Create Account</h1>
                <p class="auth-subtitle">Join AlgaeDB to explore algae data</p>
            </div>
            <div class="auth-form animate-slide-up" style="animation-delay:0.1s;animation-fill-mode:both;">
                <c:if test="${not empty error}"><div class="alert alert-error animate-shake">${error}</div></c:if>
                <form method="POST" action="${pageContext.request.contextPath}/auth" id="registerForm">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" id="username" name="username" class="form-input" placeholder="Choose a username" value="${username}" required minlength="1">
                    </div>
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="your@email.com" value="${email}" required>
                    </div>
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" id="password" name="password" class="form-input" placeholder="At least 3 characters" required minlength="3">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-full">Create Account</button>
                </form>
                <div style="text-align:center;margin-top:1rem;">
                    <span style="font-size:0.875rem;color:var(--muted-foreground);">Already have an account? </span>
                    <a href="${pageContext.request.contextPath}/login.jsp" style="font-size:0.875rem;color:var(--primary);font-weight:500;">Sign In</a>
                </div>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var pw = document.getElementById('password').value;
            var cpw = document.getElementById('confirmPassword').value;
            if (pw.length < 3) { e.preventDefault(); showToast('Password must be at least 3 characters.', 'error'); return; }
            if (pw !== cpw) { e.preventDefault(); showToast('Passwords do not match.', 'error'); }
        });
    </script>
</body>
</html>
