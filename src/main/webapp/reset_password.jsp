<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Reset Password — AlgaeDB</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
    <header class="navbar"><div class="navbar-inner"><a href="${pageContext.request.contextPath}/" class="navbar-brand"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg> AlgaeDB</a></div></header>
    <div class="auth-wrapper"><div class="auth-card animate-scale-in">
        <div class="auth-logo animate-fade-in">
            <div class="auth-logo-icon"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
            <h1 class="auth-title">Reset Password</h1>
            <p class="auth-subtitle">Set a new password for your account</p>
        </div>
        <div class="auth-form animate-slide-up" style="animation-delay:0.1s;animation-fill-mode:both;">
            <c:if test="${not empty error}"><div class="alert alert-error animate-shake">${error}</div></c:if>
            <form method="POST" action="${pageContext.request.contextPath}/auth" id="resetForm">
                <input type="hidden" name="action" value="doResetPassword">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-input form-input-readonly" value="${resetUsername}" readonly disabled style="background:var(--accent);color:var(--muted-foreground);cursor:not-allowed;">
                </div>
                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="At least 3 characters" required minlength="3">
                </div>
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter new password" required>
                </div>
                <button type="submit" class="btn btn-primary w-full">Reset Password</button>
            </form>
        </div>
    </div></div>
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        document.getElementById('resetForm').addEventListener('submit', function(e) {
            var pw = document.getElementById('newPassword').value;
            var cpw = document.getElementById('confirmPassword').value;
            if (pw.length < 3) { e.preventDefault(); showToast('Password must be at least 3 characters.', 'error'); return; }
            if (pw !== cpw) { e.preventDefault(); showToast('Passwords do not match.', 'error'); }
        });
    </script>
</body>
</html>
