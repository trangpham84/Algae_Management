<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — AlgaeDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <header class="navbar">
        <div class="navbar-inner">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
                AlgaeDB
            </a>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
                <a href="${pageContext.request.contextPath}/explore" class="nav-link">Explore</a>
            </nav>
        </div>
    </header>

    <div class="auth-wrapper">
        <div class="auth-card animate-scale-in">
            <!-- Logo -->
            <div class="auth-logo animate-fade-in">
                <div class="auth-logo-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
                </div>
                <h1 class="auth-title">Welcome back</h1>
                <p class="auth-subtitle">Sign in to access AlgaeDB</p>
            </div>

            <!-- Form -->
            <div class="auth-form animate-slide-up" style="animation-delay:0.1s;animation-fill-mode:both;">
                <c:if test="${not empty error}">
                    <div class="alert alert-error animate-shake">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/auth" id="loginForm">
                    <input type="hidden" name="action" value="login">

                    <div class="form-group">
                        <label for="username" class="form-label">Username</label>
                        <div class="relative">
                            <svg class="form-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            <input type="text" id="username" name="username" class="form-input form-input-icon" placeholder="Enter your username" value="${username}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <div class="relative">
                            <svg class="form-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            <input type="password" id="password" name="password" class="form-input form-input-icon form-input-right-icon" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required>
                            <button type="button" class="form-icon-right" onclick="togglePassword()">
                                <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="rememberMe" class="checkbox-input">
                            Remember me for 30 days
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary w-full" id="loginBtn">Sign In</button>
                </form>

                <div style="text-align:center;margin-top:1rem;">
                    <a href="${pageContext.request.contextPath}/auth?action=forgotPage" style="font-size:0.875rem;color:var(--primary);">Forgot password?</a>
                </div>
                <div style="text-align:center;margin-top:0.5rem;">
                    <span style="font-size:0.875rem;color:var(--muted-foreground);">Don't have an account? </span>
                    <a href="${pageContext.request.contextPath}/auth?action=registerPage" style="font-size:0.875rem;color:var(--primary);font-weight:500;">Register</a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        function togglePassword() {
            var pw = document.getElementById('password');
            pw.type = pw.type === 'password' ? 'text' : 'password';
        }

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            var u = document.getElementById('username').value.trim();
            var p = document.getElementById('password').value.trim();
            if (!u || !p) {
                e.preventDefault();
                showToast('Please fill in all fields.', 'error');
            }
        });
    </script>
</body>
</html>
