<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — AlgaeDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>(function(){var t=localStorage.getItem('theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
</head>
<body>
    <!-- Navbar -->
    <header class="navbar">
        <div class="navbar-inner">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
                AlgaeDB
            </a>
            <nav class="nav-links" id="navLinks">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
                <a href="${pageContext.request.contextPath}/explore" class="nav-link">Explore</a>
                <a href="${pageContext.request.contextPath}/admin" class="nav-link active">Admin</a>
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
        </div>
    </header>

    <div class="admin-layout">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <nav style="display:flex;flex-direction:column;gap:0.25rem;">
                <a href="${pageContext.request.contextPath}/admin" class="sidebar-link active">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=manage" class="sidebar-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
                    Manage Data
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="sidebar-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    Manage Users
                </a>
            </nav>
        </aside>

        <!-- Content -->
        <main class="admin-content">
            <h1 style="font-size:1.5rem;font-weight:700;color:var(--foreground);margin-bottom:1.5rem;" class="animate-fade-in">Admin Dashboard</h1>

            <!-- Stats -->
            <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:1rem;margin-bottom:2rem;">
                <div class="stat-card flex items-center gap-4 animate-stagger-in delay-100">
                    <div class="stat-icon stat-icon-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
                    </div>
                    <div>
                        <div class="stat-value animate-count-up delay-300">${totalSpecies}</div>
                        <div class="stat-label">Total Species</div>
                    </div>
                </div>
                <div class="stat-card flex items-center gap-4 animate-stagger-in delay-200">
                    <div class="stat-icon stat-icon-success">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4v16"/><path d="M2 8h18a2 2 0 0 1 2 2v10"/><path d="M2 17h20"/><path d="M6 8v9"/></svg>
                    </div>
                    <div>
                        <div class="stat-value animate-count-up delay-400">${avgLength}</div>
                        <div class="stat-label">Avg. Nucleotide Length</div>
                    </div>
                </div>
            </div>

            <!-- Records Table -->
            <div class="card-animate overflow-hidden animate-slide-up delay-300">
                <div class="overflow-x-auto">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Species</th>
                                <th>Sequence</th>
                                <th>Length</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${records}" varStatus="s">
                                <tr class="animate-fade-in" style="animation-delay:${s.index * 40}ms">
                                    <td style="font-family:var(--font-mono);font-size:0.75rem;color:var(--muted-foreground);">${r.recordID}</td>
                                    <td class="font-medium">${fn:escapeXml(r.speciesGroup)}</td>
                                    <td><span class="dna-sequence" id="dash-seq-${r.recordID}"></span></td>
                                    <td style="font-family:var(--font-mono);">${r.nucleotides}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        <c:forEach var="r" items="${records}">
            document.getElementById('dash-seq-${r.recordID}').innerHTML = renderDnaSequence('${fn:escapeXml(r.signatureSequence)}', 25);
        </c:forEach>
    </script>
    <script>
        function toggleTheme(){var h=document.documentElement,c=h.getAttribute('data-theme'),n=c==='dark'?'light':'dark';h.setAttribute('data-theme',n);localStorage.setItem('theme',n);}
        function toggleMobileMenu(){document.getElementById('navLinks').classList.toggle('open');}
    </script>
</body>
</html>
