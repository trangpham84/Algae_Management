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
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
                <a href="${pageContext.request.contextPath}/explore" class="nav-link active">Explore</a>
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

    <div class="container" style="padding-top:2rem;padding-bottom:3rem;">
        <h1 style="font-size:1.5rem;font-weight:700;color:var(--foreground);margin-bottom:0.25rem;" class="animate-fade-in">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline;vertical-align:middle;margin-right:0.5rem;"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            Explore Algae Data
        </h1>
        <p style="font-size:0.875rem;color:var(--muted-foreground);margin-bottom:1.5rem;" class="animate-fade-in delay-100">Search and filter signature DNA sequences across species.</p>

        <!-- Search Filters -->
        <form method="GET" action="${pageContext.request.contextPath}/explore" class="card-animate animate-slide-up delay-200" style="padding:1.25rem;margin-bottom:1.5rem;" id="searchForm">
            <div style="display:grid;grid-template-columns:1fr 1fr 0.5fr 0.5fr auto;gap:0.75rem;align-items:end;">
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
                <div style="display:flex;gap:0.5rem;">
                    <button type="submit" class="btn btn-primary" style="padding:0.625rem 1.25rem;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/explore" class="btn btn-outline" style="padding:0.625rem 1rem;">Clear</a>
                </div>
            </div>
        </form>

        <!-- Results -->
        <div class="card-animate overflow-hidden animate-slide-up delay-300" id="resultsCard">
            <div style="display:flex;align-items:center;justify-content:space-between;padding:1rem 1.25rem;border-bottom:1px solid var(--border);">
                <span style="font-size:0.875rem;color:var(--muted-foreground);">
                    <c:choose>
                        <c:when test="${not empty records}">${fn:length(records)} record(s) found</c:when>
                        <c:otherwise>No records found</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="overflow-x-auto">
                <table class="data-table">
                    <thead>
                            <th>ID</th>
                            <th>Species / Group</th>
                            <th class="col-sequence">Signature Sequence</th>
                            <th>Nucleotides</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:forEach var="r" items="${records}" varStatus="s">
                            <tr class="animate-fade-in" style="animation-delay:${s.index * 40}ms;cursor:pointer;" onclick="showDetail(${r.recordID}, '${fn:escapeXml(r.speciesGroup)}', '${fn:escapeXml(r.signatureSequence)}', ${r.nucleotides})">
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

        function showDetail(id, species, seq, len) {
            document.getElementById('detailId').textContent = id;
            document.getElementById('detailSpecies').textContent = species;
            document.getElementById('detailSeq').innerHTML = renderDnaSequence(seq);
            document.getElementById('detailLen').textContent = len;
            document.getElementById('detailModal').classList.remove('hidden');
        }
        function closeDetail() {
            document.getElementById('detailModal').classList.add('hidden');
        }
        document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeDetail(); });
    </script>
</body>
</html>
