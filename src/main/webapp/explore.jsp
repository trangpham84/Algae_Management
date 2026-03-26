<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore — AlgaeDB</title>
    <meta name="description" content="Search and explore microalgae DNA sequences.">
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
            <nav class="nav-links" id="navLinks">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
                <a href="${pageContext.request.contextPath}/explore" class="nav-link active">Explore</a>
                <c:if test="${sessionScope.user != null && sessionScope.user.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/admin" class="nav-link">Admin</a>
                </c:if>
                <div class="nav-divider">
                    <button class="theme-toggle" id="themeToggle" onclick="toggleTheme()" title="Toggle theme">
                        <svg class="theme-icon-light" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
                        <svg class="theme-icon-dark" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                    </button>
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
            <button class="hamburger" id="hamburgerBtn" onclick="toggleMobileMenu()">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
        </div>
    </header>

    <div class="container" style="padding-top:2rem;padding-bottom:3rem;">
        <h1 style="font-size:1.5rem;font-weight:700;color:var(--foreground);margin-bottom:0.25rem;" class="animate-fade-in">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline;vertical-align:middle;margin-right:0.5rem;"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            Explore Algae Data
        </h1>
        <p style="font-size:0.875rem;color:var(--muted-foreground);margin-bottom:1.5rem;" class="animate-fade-in delay-100">Search and filter signature DNA sequences across species.</p>

        <!-- Search Filters -->
        <form method="GET" action="${pageContext.request.contextPath}/explore" class="card-animate scroll-reveal" style="padding:1.25rem;margin-bottom:1.5rem;" id="searchForm">
            <div class="search-grid">
                <div>
                    <label class="form-label" style="font-size:0.75rem;">Species Name</label>
                    <input type="text" name="keyword" class="form-input" placeholder="e.g., Chlorella" value="${keyword}">
                </div>
                <div>
                    <label class="form-label" style="font-size:0.75rem;">DNA Sequence</label>
                    <input type="text" name="seqKeyword" class="form-input form-input-mono" placeholder="e.g., ATGC" value="${seqKeyword}" style="text-transform:uppercase;">
                </div>
                <div>
                    <label class="form-label" style="font-size:0.75rem;">Min Length</label>
                    <input type="number" name="minLen" class="form-input" placeholder="0" value="${minLen}" min="0">
                </div>
                <div>
                    <label class="form-label" style="font-size:0.75rem;">Max Length</label>
                    <input type="number" name="maxLen" class="form-input" placeholder="999" value="${maxLen}" min="0">
                </div>
                <div class="search-actions">
                    <button type="submit" class="btn btn-primary" style="padding:0.625rem 1.25rem;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/explore" class="btn btn-outline" style="padding:0.625rem 1rem;">Clear</a>
                </div>
            </div>
        </form>

        <!-- Export + Results Header -->
        <div class="card-animate overflow-hidden scroll-reveal" id="resultsCard">
            <div style="display:flex;align-items:center;justify-content:space-between;padding:1rem 1.25rem;border-bottom:1px solid var(--border);flex-wrap:wrap;gap:0.5rem;">
                <span style="font-size:0.875rem;color:var(--muted-foreground);">
                    <c:choose>
                        <c:when test="${totalRecords > 0}">${totalRecords} record(s) found &#8212; Page ${currentPage} of ${totalPages}</c:when>
                        <c:otherwise>No records found</c:otherwise>
                    </c:choose>
                </span>
                <c:if test="${totalRecords > 0}">
                    <div style="display:flex;gap:0.5rem;">
                        <a href="${pageContext.request.contextPath}/export?format=csv&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}"
                           class="btn btn-outline btn-sm" title="Export as CSV">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                            CSV
                        </a>
                        <a href="${pageContext.request.contextPath}/export?format=xlsx&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}"
                           class="btn btn-outline btn-sm" title="Export as XLSX">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                            XLSX
                        </a>
                    </div>
                </c:if>
            </div>
            <div class="overflow-x-auto">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Species / Group</th>
                            <th class="col-sequence">Signature Sequence</th>
                            <th>Nucleotides</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:forEach var="r" items="${records}" varStatus="s">
                            <tr class="animate-fade-in" style="animation-delay:${s.index * 40}ms;cursor:pointer;"
                                data-id="${r.recordID}"
                                data-species="${fn:escapeXml(r.speciesGroup)}"
                                data-seq="${fn:escapeXml(r.signatureSequence)}"
                                data-len="${r.nucleotides}"
                                onclick="showDetailFromRow(this)">
                                <td style="font-family:var(--font-mono);font-size:0.75rem;color:var(--muted-foreground);">${r.recordID}</td>
                                <td class="font-medium">${fn:escapeXml(r.speciesGroup)}</td>
                                <td class="col-sequence"><span class="dna-sequence" id="seq-${r.recordID}"></span></td>
                                <td style="font-family:var(--font-mono);">${r.nucleotides}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty records}">
                            <tr><td colspan="4" style="text-align:center;padding:3rem;color:var(--muted-foreground);">No data available. Try adjusting your search filters.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <div class="pagination-info">
                        Showing ${(currentPage - 1) * pageSize + 1}&#8211;<c:choose><c:when test="${currentPage * pageSize > totalRecords}">${totalRecords}</c:when><c:otherwise>${currentPage * pageSize}</c:otherwise></c:choose> of ${totalRecords}
                    </div>
                    <div style="display:flex;align-items:center;gap:0.25rem;">
                        <%-- First page --%>
                        <c:choose>
                            <c:when test="${currentPage == 1}">
                                <span class="pagination-btn disabled">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="11 17 6 12 11 7"/><polyline points="18 17 13 12 18 7"/></svg>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/explore?page=1&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}" class="pagination-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="11 17 6 12 11 7"/><polyline points="18 17 13 12 18 7"/></svg>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <%-- Previous page --%>
                        <c:choose>
                            <c:when test="${currentPage == 1}">
                                <span class="pagination-btn disabled">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/explore?page=${currentPage - 1}&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}" class="pagination-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <%-- Page numbers --%>
                        <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
                        <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}">
                                    <span class="pagination-num active">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/explore?page=${p}&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}" class="pagination-num">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <%-- Next page --%>
                        <c:choose>
                            <c:when test="${currentPage == totalPages}">
                                <span class="pagination-btn disabled">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/explore?page=${currentPage + 1}&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}" class="pagination-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <%-- Last page --%>
                        <c:choose>
                            <c:when test="${currentPage == totalPages}">
                                <span class="pagination-btn disabled">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 17 18 12 13 7"/><polyline points="6 17 11 12 6 7"/></svg>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/explore?page=${totalPages}&keyword=${keyword}&seqKeyword=${seqKeyword}&minLen=${minLen}&maxLen=${maxLen}" class="pagination-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 17 18 12 13 7"/><polyline points="6 17 11 12 6 7"/></svg>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Detail Modal -->
    <div id="detailModal" class="modal-overlay hidden" onclick="closeDetail()">
        <div class="modal-content" onclick="event.stopPropagation()" style="max-width:36rem;">
            <div class="modal-header">
                <h2 class="modal-title">Sequence Details</h2>
                <button class="modal-close" onclick="closeDetail()"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button>
            </div>
            <div>
                <div class="form-group">
                    <label class="form-label-muted">ID</label>
                    <div id="detailId" class="form-auto-value"></div>
                </div>
                <div class="form-group">
                    <label class="form-label-muted">Species / Group</label>
                    <div id="detailSpecies" style="font-weight:600;color:var(--foreground);font-size:1rem;"></div>
                </div>
                <div class="form-group">
                    <label class="form-label-muted">DNA Sequence <span style="font-weight:400;color:var(--muted-foreground);">(full)</span></label>
                    <div id="detailSeq" class="dna-sequence" style="padding:1rem;background:var(--accent);border-radius:0.5rem;line-height:1.8;"></div>
                </div>
                <div class="form-group">
                    <label class="form-label-muted">Nucleotide Length</label>
                    <div id="detailLen" style="font-family:var(--font-mono);font-weight:600;font-size:1.25rem;color:var(--foreground);"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        // Render all DNA sequences with color coding
        <c:forEach var="r" items="${records}">
            document.getElementById('seq-${r.recordID}').innerHTML = renderDnaSequence('${fn:escapeXml(r.signatureSequence)}', 25);
        </c:forEach>

        // Show detail using data attributes (safe from XSS / quote issues)
        function showDetailFromRow(tr) {
            document.getElementById('detailId').textContent = tr.getAttribute('data-id');
            document.getElementById('detailSpecies').textContent = tr.getAttribute('data-species');
            document.getElementById('detailSeq').innerHTML = renderDnaSequence(tr.getAttribute('data-seq'));
            document.getElementById('detailLen').textContent = tr.getAttribute('data-len');
            document.getElementById('detailModal').classList.remove('hidden');
        }
        function closeDetail() {
            document.getElementById('detailModal').classList.add('hidden');
        }
        document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeDetail(); });

        // Theme toggle
        function toggleTheme() {
            var html = document.documentElement;
            var current = html.getAttribute('data-theme');
            var next = current === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
        }
        (function() {
            var saved = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', saved);
        })();

        // Mobile menu toggle
        function toggleMobileMenu() {
            document.getElementById('navLinks').classList.toggle('open');
        }
        // Scroll-reveal Intersection Observer
        (function() {
            var els = document.querySelectorAll('.scroll-reveal, .scroll-reveal-stagger');
            if ('IntersectionObserver' in window) {
                var obs = new IntersectionObserver(function(entries) {
                    entries.forEach(function(e) {
                        if (e.isIntersecting) {
                            e.target.classList.add('revealed');
                            obs.unobserve(e.target);
                        }
                    });
                }, { threshold: 0.1 });
                els.forEach(function(el) { obs.observe(el); });
            } else {
                els.forEach(function(el) { el.classList.add('revealed'); });
            }
        })();
    </script>
</body>
</html>
