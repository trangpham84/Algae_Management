<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Verify Login — AlgaeDB</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
    <header class="navbar"><div class="navbar-inner"><a href="${pageContext.request.contextPath}/" class="navbar-brand"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg> AlgaeDB</a></div></header>
    <div class="auth-wrapper"><div class="auth-card animate-scale-in">
        <div class="auth-logo animate-fade-in">
            <div class="auth-logo-icon" style="background:hsla(250,76%,57%,0.1);"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="hsl(250,76%,57%)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
            <h1 class="auth-title">Login Verification</h1>
            <p class="auth-subtitle">Enter the OTP sent to your email</p>
        </div>
        <div class="auth-form animate-slide-up" style="animation-delay:0.1s;animation-fill-mode:both;">
            <c:if test="${not empty error}"><div class="alert alert-error animate-shake">${error}</div></c:if>
            <form method="POST" action="${pageContext.request.contextPath}/auth">
                <input type="hidden" name="action" value="verifyLoginOtp">
                <div class="form-group">
                    <label for="otp" class="form-label">Verification Code</label>
                    <input type="text" id="otp" name="otp" class="form-input" style="text-align:center;font-size:1.5rem;letter-spacing:0.3em;font-family:var(--font-mono);" placeholder="000000" maxlength="6" required pattern="[0-9]{6}">
                </div>
                <button type="submit" class="btn btn-primary w-full">Verify & Login</button>
            </form>
            <p style="text-align:center;margin-top:1rem;font-size:0.75rem;color:var(--muted-foreground);">Code is valid for 10 minutes.</p>
        </div>
    </div></div>
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
</body>
</html>
