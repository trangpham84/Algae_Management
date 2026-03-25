<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Verify Email — AlgaeDB</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
    <header class="navbar"><div class="navbar-inner"><a href="${pageContext.request.contextPath}/" class="navbar-brand"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg> AlgaeDB</a></div></header>
    <div class="auth-wrapper"><div class="auth-card animate-scale-in">
        <div class="auth-logo animate-fade-in">
            <div class="auth-logo-icon" style="background:hsla(142,71%,45%,0.1);"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
            <h1 class="auth-title">Verify Your Email</h1>
            <p class="auth-subtitle">We sent a 6-digit OTP to your email address</p>
        </div>
        <div class="auth-form animate-slide-up" style="animation-delay:0.1s;animation-fill-mode:both;">
            <c:if test="${not empty error}"><div class="alert alert-error animate-shake">${error}</div></c:if>
            <form method="POST" action="${pageContext.request.contextPath}/auth">
                <input type="hidden" name="action" value="verifyRegistration">
                <div class="form-group">
                    <label for="otp" class="form-label">Verification Code</label>
                    <input type="text" id="otp" name="otp" class="form-input" style="text-align:center;font-size:1.5rem;letter-spacing:0.3em;font-family:var(--font-mono);" placeholder="000000" maxlength="6" required pattern="[0-9]{6}">
                </div>
                <button type="submit" class="btn btn-success w-full">Verify & Create Account</button>
            </form>
            <p style="text-align:center;margin-top:1rem;font-size:0.75rem;color:var(--muted-foreground);">Code is valid for 10 minutes.</p>
        </div>
    </div></div>
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
</body>
</html>
