<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>AlgaeDB — Algae DNA Database</title>
            <meta name="description" content="Explore signature DNA sequences for microalgae species classification.">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

    <!-- Navbar -->
    <header class="navbar">
        <div class="navbar-inner">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><path d="M8.5 2h7"/><path d="M7 16h10"/></svg>
                AlgaeDB
            </a>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/" class="nav-link active">Home</a>
                <a href="${pageContext.request.contextPath}/explore" class="nav-link">Explore</a>
                <c:if test="${sessionScope.user != null && sessionScope.user.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/admin" class="nav-link">Admin</a>
                </c:if>
                <div class="nav-divider">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
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
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </div>
    </header>


            <div style="display:flex;flex-direction:column;min-height:calc(100vh - 3.5rem);">
                <!-- Hero -->
                <section class="hero">
                    <div class="hero-blob hero-blob-1 animate-float"></div>
                    <div class="hero-blob hero-blob-2 animate-float" style="animation-delay:0.3s"></div>
                    <div class="hero-content">
                        <div class="hero-badge animate-fade-in">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round" class="animate-pulse">
                                <path d="M2 15c6.667-6 13.333 0 20-6" />
                                <path d="M9 22c1.798-1.998 2.518-3.995 2.807-5.993" />
                                <path d="M15 2c-1.798 1.998-2.518 3.995-2.807 5.993" />
                            </svg>
                            Microalgae Classification System
                        </div>
                        <h1 class="hero-title animate-slide-up delay-100">
                            Algae DNA <span class="hero-title-accent">Database<span
                                    class="hero-title-underline animate-shimmer"></span></span>
                        </h1>
                        <p class="hero-desc animate-slide-up delay-200">
                            Explore signature DNA sequences for microalgae species classification.
                            Search, filter, and analyze nucleotide data for biological research.
                        </p>
                        <div class="hero-actions animate-slide-up delay-300">
                            <a href="${pageContext.request.contextPath}/explore"
                                class="btn btn-primary animate-pulse-glow">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <circle cx="11" cy="11" r="8" />
                                    <path d="m21 21-4.35-4.35" />
                                </svg>
                                Explore Data
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <path d="M5 12h14" />
                                    <path d="m12 5 7 7-7 7" />
                                </svg>
                            </a>

                        </div>
                    </div>
                </section>

                <!-- Features -->
                <section class="features-section">
                    <div style="max-width:64rem;margin:0 auto;">
                        <h2 class="features-title animate-fade-in">Platform Features</h2>
                        <div class="features-grid">
                            <div class="card-animate" style="padding:1.5rem;text-align:center;">
                                <div class="feature-icon stat-icon-primary animate-stagger-in delay-100"
                                    style="margin:0 auto 1rem;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8" />
                                        <path d="m21 21-4.35-4.35" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">Advanced Search</h3>
                                <p class="feature-desc">Search by species name or DNA sequence with real-time filtering.
                                </p>
                            </div>
                            <div class="card-animate" style="padding:1.5rem;text-align:center;">
                                <div class="feature-icon stat-icon-success animate-stagger-in delay-200"
                                    style="margin:0 auto 1rem;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <ellipse cx="12" cy="5" rx="9" ry="3" />
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3" />
                                        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">Rich Dataset</h3>
                                <p class="feature-desc">Multiple catalogued microalgae species with signature sequences.
                                </p>
                            </div>
                            <div class="card-animate" style="padding:1.5rem;text-align:center;">
                                <div class="feature-icon stat-icon-warning animate-stagger-in delay-300"
                                    style="margin:0 auto 1rem;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <path d="M2 15c6.667-6 13.333 0 20-6" />
                                        <path d="M9 22c1.798-1.998 2.518-3.995 2.807-5.993" />
                                        <path d="M15 2c-1.798 1.998-2.518 3.995-2.807 5.993" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">DNA Analysis</h3>
                                <p class="feature-desc">Color-coded nucleotide display for easy visual comparison.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Stats -->
                <section class="stats-section">
                    <div class="stats-grid">
                        <div class="animate-count-up delay-100">
                            <div class="stats-value">12+</div>
                            <div class="stats-label">Species Catalogued</div>
                        </div>
                        <div class="animate-count-up delay-300">
                            <div class="stats-value">29.7</div>
                            <div class="stats-label">Avg. Nucleotide Length</div>
                        </div>
                        <div class="animate-count-up delay-500">
                            <div class="stats-value">4</div>
                            <div class="stats-label">Genera Represented</div>
                        </div>
                    </div>
                </section>
            </div>

            <script src="${pageContext.request.contextPath}/js/toast.js"></script>
        </body>

        </html>