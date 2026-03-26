<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile — AlgaeDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>(function(){var t=localStorage.getItem('theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
</head>
<body>
    <header class="navbar"><div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
            AlgaeDB
        </a>
        <nav class="nav-links" id="navLinks">
            <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
            <a href="${pageContext.request.contextPath}/explore" class="nav-link">Explore</a>
            <c:if test="${sessionScope.user != null && sessionScope.user.role == 'Admin'}">
                <a href="${pageContext.request.contextPath}/admin" class="nav-link">Admin</a>
            </c:if>
            <div class="nav-divider">
                <button class="theme-toggle" onclick="toggleTheme()" title="Toggle theme">
                    <svg class="theme-icon-light" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
                    <svg class="theme-icon-dark" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                </button>
                <a href="${pageContext.request.contextPath}/profile" class="nav-profile-link">
                    <div id="navAvatar" class="nav-avatar" style="overflow:hidden;padding:0;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profileImage}">
                                <img src="${sessionScope.user.profileImage}" style="width:100%;height:100%;object-fit:cover;" alt="avatar">
                            </c:when>
                            <c:otherwise>${sessionScope.user.username.substring(0,1).toUpperCase()}</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="nav-username">${sessionScope.user.username}</span>
                </a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-logout" title="Logout">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                </a>
            </div>
        </nav>
        <button class="hamburger" onclick="toggleMobileMenu()">
            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
        </button>
    </div></header>

    <div class="container" style="padding:2rem 1.5rem;max-width:40rem;">
        <h1 style="font-size:1.5rem;font-weight:700;margin-bottom:1.5rem;" class="animate-fade-in">My Profile</h1>

        <c:if test="${not empty successMessage}"><div class="alert alert-success animate-fade-in">${successMessage}</div></c:if>
        <c:if test="${not empty errorMessage}"><div class="alert alert-error animate-shake">${errorMessage}</div></c:if>

        <!-- Profile Info -->
        <div class="card-animate animate-slide-up" style="padding:1.5rem;margin-bottom:1.5rem;">
            <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1.5rem;">
                <!-- Avatar with camera button -->
                <div style="position:relative;width:5rem;height:5rem;flex-shrink:0;">
                    <div id="avatarCircle" style="width:5rem;height:5rem;border-radius:50%;background:hsla(217,91%,60%,0.1);display:flex;align-items:center;justify-content:center;font-size:1.75rem;font-weight:700;color:var(--primary);overflow:hidden;border:2px solid var(--border);">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profileImage}">
                                <img id="avatarImg" src="${sessionScope.user.profileImage}" alt="avatar" style="width:100%;height:100%;object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <span id="avatarInitial">${sessionScope.user.username.substring(0,1).toUpperCase()}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Camera button -->
                    <button onclick="openAvatarModal()" title="Change avatar"
                        style="position:absolute;bottom:0;right:0;width:1.75rem;height:1.75rem;border-radius:50%;background:var(--primary);border:2px solid var(--background);cursor:pointer;display:flex;align-items:center;justify-content:center;transition:transform 0.15s,opacity 0.15s;opacity:0.9;"
                        onmouseover="this.style.transform='scale(1.1)';this.style.opacity='1'"
                        onmouseout="this.style.transform='scale(1)';this.style.opacity='0.9'">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/></svg>
                    </button>
                </div>
                <div>
                    <div style="font-size:1.125rem;font-weight:600;">${sessionScope.user.username}</div>
                    <div style="font-size:0.875rem;color:var(--muted-foreground);">${sessionScope.user.role}</div>
                </div>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/ProfileServlet">
                <input type="hidden" name="action" value="updateProfile">
                <input type="hidden" name="redirect" value="profile.jsp">
                <div class="form-group">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" value="${sessionScope.user.fullName}" placeholder="Your full name">
                </div>
                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-input" value="${sessionScope.user.email}" placeholder="your@email.com">
                </div>
                <div class="form-group">
                    <label for="phone" class="form-label">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-input" value="${sessionScope.user.phone}" placeholder="Phone number">
                </div>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </form>
        </div>

        <!-- Change Password -->
        <div class="card-animate animate-slide-up delay-200" style="padding:1.5rem;">
            <h2 style="font-size:1.125rem;font-weight:600;margin-bottom:1rem;">Change Password</h2>
            <form method="POST" action="${pageContext.request.contextPath}/ProfileServlet" id="changePwForm">
                <input type="hidden" name="action" value="changePassword">
                <input type="hidden" name="redirect" value="profile.jsp">
                <div class="form-group">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-input" required minlength="3">
                </div>
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                </div>
                <button type="submit" class="btn btn-primary">Change Password</button>
            </form>
        </div>
    </div>

    <!-- Avatar URL Modal -->
    <div id="avatarModal" class="modal-overlay hidden" onclick="closeAvatarModal()">
        <div class="modal-content" style="max-width:22rem;" onclick="event.stopPropagation()">
            <div class="modal-header">
                <h2 class="modal-title">Change Avatar</h2>
                <button class="modal-close" onclick="closeAvatarModal()">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
                </button>
            </div>
            <div class="form-group" style="margin-bottom:1rem;">
                <label for="avatarUrlInput" class="form-label">Image URL</label>
                <input type="url" id="avatarUrlInput" class="form-input" placeholder="https://example.com/photo.jpg">
                <div style="font-size:0.75rem;color:var(--muted-foreground);margin-top:0.375rem;">Paste a direct link to your photo.</div>
            </div>
            <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
                <button id="avatarRemoveBtn" class="btn btn-destructive" type="button">Remove</button>
                <button id="avatarConfirmBtn" class="btn btn-primary" type="button">Confirm</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        document.getElementById('changePwForm').addEventListener('submit', function(e) {
            var n = document.getElementById('newPassword').value;
            var c = document.getElementById('confirmPassword').value;
            if (n !== c) { e.preventDefault(); showToast('Passwords do not match.', 'error'); }
        });

        // ── Avatar Modal ────────────────────────────────────────────────────────
        function openAvatarModal() {
            var current = document.getElementById('avatarImg') ? document.getElementById('avatarImg').src : '';
            document.getElementById('avatarUrlInput').value = (current && !current.endsWith('/') ? current : '');
            document.getElementById('avatarModal').classList.remove('hidden');
            document.getElementById('avatarUrlInput').focus();
        }
        function closeAvatarModal() { document.getElementById('avatarModal').classList.add('hidden'); }

        function submitAvatar(url) {
            fetch('${pageContext.request.contextPath}/ProfileServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=updateAvatar&imageUrl=' + encodeURIComponent(url)
            })
            .then(r => r.json())
            .then(data => {
                if (data.result === 'success') {
                    var initial = '${sessionScope.user.username.substring(0,1).toUpperCase()}';
                    // Update big avatar (profile card)
                    var circle = document.getElementById('avatarCircle');
                    // Update small avatar (navbar)
                    var navAvatar = document.getElementById('navAvatar');
                    if (url) {
                        var img = '<img src="' + url + '" style="width:100%;height:100%;object-fit:cover;" alt="avatar">';
                        circle.innerHTML = img;
                        if (navAvatar) navAvatar.innerHTML = img;
                    } else {
                        circle.innerHTML = '<span id="avatarInitial">' + initial + '</span>';
                        if (navAvatar) navAvatar.innerHTML = initial;
                    }
                    showToast(url ? 'Avatar updated!' : 'Avatar removed.', 'success');
                    closeAvatarModal();
                } else {
                    showToast(data.msg || 'Failed to update avatar.', 'error');
                }
            })
            .catch(() => showToast('Network error.', 'error'));
        }

        document.getElementById('avatarConfirmBtn').addEventListener('click', function() {
            var url = document.getElementById('avatarUrlInput').value.trim();
            if (url && !url.startsWith('http')) { showToast('Please enter a valid URL starting with http.', 'error'); return; }
            submitAvatar(url);
        });
        document.getElementById('avatarRemoveBtn').addEventListener('click', function() {
            submitAvatar('');
        });
        document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeAvatarModal(); });
        function toggleTheme(){var h=document.documentElement,c=h.getAttribute('data-theme'),n=c==='dark'?'light':'dark';h.setAttribute('data-theme',n);localStorage.setItem('theme',n);}
        function toggleMobileMenu(){document.getElementById('navLinks').classList.toggle('open');}
    </script>
</body>
</html>

