<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Data — AlgaeDB</title>
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
                <a href="${pageContext.request.contextPath}/admin" class="sidebar-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=manage" class="sidebar-link active">
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
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;" class="animate-fade-in">
                <h1 style="font-size:1.5rem;font-weight:700;color:var(--foreground);">Manage Data</h1>
                <div style="display:flex;gap:0.75rem;align-items:center;">
                    <!-- Search Input -->
                    <div style="position:relative;width:260px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="form-icon"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                        <input type="text" id="searchInput" class="form-input form-input-icon" placeholder="Search sequence, species..." onkeyup="filterTable()">
                    </div>
                    <!-- File Upload -->
                    <form method="POST" action="${pageContext.request.contextPath}/admin" enctype="multipart/form-data" style="display:inline-flex;align-items:center;gap:0.5rem;" id="uploadForm">
                        <input type="hidden" name="action" value="upload">
                        <label class="btn btn-outline hover-lift" style="cursor:pointer;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            Upload File
                            <input type="file" name="file" accept=".xlsx,.xls,.csv" style="display:none" onchange="this.form.submit()">
                        </label>
                    </form>
                    <!-- Add Button -->
                    <button onclick="openAddModal()" class="btn btn-success hover-lift">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                        Add Sequence
                    </button>
                </div>
            </div>

            <!-- Table -->
            <div class="card-animate overflow-hidden animate-slide-up delay-100">
                <div class="overflow-x-auto">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Species</th>
                                <th class="col-sequence">Sequence</th>
                                <th>Length</th>
                                <th class="text-right col-actions">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${records}" varStatus="s">
                                <tr class="animate-fade-in" style="animation-delay:${s.index * 40}ms">
                                    <td style="color:var(--muted-foreground);font-family:var(--font-mono);">${r.recordID}</td>
                                    <td class="font-medium">${fn:escapeXml(r.speciesGroup)}</td>
                                    <td class="col-sequence"><span class="dna-sequence" id="mgr-seq-${r.recordID}"></span></td>
                                    <td style="font-family:var(--font-mono);">${r.nucleotides}</td>
                                    <td class="text-right col-actions">
                                        <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
                                            <button onclick="openEditModal(${r.recordID}, '${fn:escapeXml(r.speciesGroup)}', '${fn:escapeXml(r.signatureSequence)}')" class="btn-icon-sm btn-edit">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></svg>
                                                Edit
                                            </button>
                                            <button onclick="openDeleteModal(${r.recordID}, '${fn:escapeXml(r.speciesGroup)}')" class="btn-icon-sm btn-delete">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                                Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty records}">
                                <tr><td colspan="5" style="text-align:center;padding:3rem;color:var(--muted-foreground);">No records. Click "Add Sequence" to create one.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Add/Edit Modal -->
    <div id="formModal" class="modal-overlay hidden" onclick="closeFormModal()">
        <div class="modal-content" onclick="event.stopPropagation()">
            <div class="modal-header">
                <h2 class="modal-title" id="formModalTitle">Add New Sequence</h2>
                <button class="modal-close" onclick="closeFormModal()"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin" id="formModalForm">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="recordId" id="formRecordId" value="">

                <div class="form-group animate-fade-in">
                    <label for="speciesGroup" class="form-label">Species / Group</label>
                    <input type="text" id="speciesGroup" name="speciesGroup" class="form-input" placeholder="e.g., Chlorella_vulgaris" required>
                    <div id="speciesError" class="form-error hidden"></div>
                </div>
                <div class="form-group animate-fade-in delay-100">
                    <label for="signatureSequence" class="form-label">DNA Sequence</label>
                    <textarea id="signatureSequence" name="signatureSequence" rows="4" class="form-textarea" placeholder="Only A, T, G, C characters..." required oninput="filterDna(this); updateLength();"></textarea>
                    <div id="seqError" class="form-error hidden"></div>
                </div>
                <div class="form-group animate-fade-in delay-200">
                    <label class="form-label-muted">Nucleotide Length (auto)</label>
                    <div id="autoLength" class="form-auto-value">0</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeFormModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="formSubmitBtn">Add Sequence</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal-overlay hidden" onclick="closeDeleteModal()">
        <div class="modal-content" style="max-width:24rem;" onclick="event.stopPropagation()">
            <h2 class="modal-title" style="margin-bottom:0.75rem;">Confirm Delete</h2>
            <p style="font-size:0.875rem;color:var(--muted-foreground);margin-bottom:1.5rem;">
                Are you sure you want to delete <strong id="deleteSpeciesName" style="color:var(--foreground);"></strong>? This cannot be undone.
            </p>
            <form method="POST" action="${pageContext.request.contextPath}/admin" id="deleteForm">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="recordId" id="deleteRecordId" value="">
                <div style="display:flex;justify-content:flex-end;gap:0.75rem;">
                    <button type="button" class="btn btn-outline" onclick="closeDeleteModal()">Cancel</button>
                    <button type="submit" class="btn btn-destructive">Delete</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        // Render DNA in table
        <c:forEach var="r" items="${records}">
            document.getElementById('mgr-seq-${r.recordID}').innerHTML = renderDnaSequence('${fn:escapeXml(r.signatureSequence)}', 25);
        </c:forEach>

        // Show session messages as toast
        <c:if test="${not empty sessionScope.successMessage}">
            showToast('${fn:escapeXml(sessionScope.successMessage)}', 'success');
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            showToast('${fn:escapeXml(sessionScope.errorMessage)}', 'error');
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        function filterDna(el) {
            el.value = el.value.replace(/[^ATGCatgc]/g, '');
        }
        function updateLength() {
            var seq = document.getElementById('signatureSequence').value.replace(/[^ATGCatgc]/g, '');
            document.getElementById('autoLength').textContent = seq.length;
        }

        function openAddModal() {
            document.getElementById('formModalTitle').textContent = 'Add New Sequence';
            document.getElementById('formAction').value = 'create';
            document.getElementById('formRecordId').value = '';
            document.getElementById('speciesGroup').value = '';
            document.getElementById('signatureSequence').value = '';
            document.getElementById('autoLength').textContent = '0';
            document.getElementById('formSubmitBtn').textContent = 'Add Sequence';
            document.getElementById('speciesError').classList.add('hidden');
            document.getElementById('seqError').classList.add('hidden');
            document.getElementById('formModal').classList.remove('hidden');
        }

        function openEditModal(id, species, seq) {
            document.getElementById('formModalTitle').textContent = 'Edit Sequence';
            document.getElementById('formAction').value = 'update';
            document.getElementById('formRecordId').value = id;
            document.getElementById('speciesGroup').value = species;
            document.getElementById('signatureSequence').value = seq;
            document.getElementById('autoLength').textContent = seq.replace(/[^ATGCatgc]/g, '').length;
            document.getElementById('formSubmitBtn').textContent = 'Save Changes';
            document.getElementById('speciesError').classList.add('hidden');
            document.getElementById('seqError').classList.add('hidden');
            document.getElementById('formModal').classList.remove('hidden');
        }

        function closeFormModal() { document.getElementById('formModal').classList.add('hidden'); }

        function openDeleteModal(id, species) {
            document.getElementById('deleteRecordId').value = id;
            document.getElementById('deleteSpeciesName').textContent = species;
            document.getElementById('deleteModal').classList.remove('hidden');
        }
        function closeDeleteModal() { document.getElementById('deleteModal').classList.add('hidden'); }

        // Frontend validation
        document.getElementById('formModalForm').addEventListener('submit', function(e) {
            var species = document.getElementById('speciesGroup').value.trim();
            var seq = document.getElementById('signatureSequence').value.trim();
            var hasError = false;

            if (!species) {
                document.getElementById('speciesError').textContent = 'Species name is required.';
                document.getElementById('speciesError').classList.remove('hidden');
                document.getElementById('speciesError').classList.add('animate-shake');
                hasError = true;
            } else {
                document.getElementById('speciesError').classList.add('hidden');
            }

            if (!seq) {
                document.getElementById('seqError').textContent = 'DNA sequence is required.';
                document.getElementById('seqError').classList.remove('hidden');
                document.getElementById('seqError').classList.add('animate-shake');
                hasError = true;
            } else if (!/^[ATGCatgc]+$/.test(seq)) {
                document.getElementById('seqError').textContent = 'Only A, T, G, C characters allowed.';
                document.getElementById('seqError').classList.remove('hidden');
                document.getElementById('seqError').classList.add('animate-shake');
                hasError = true;
            } else {
                document.getElementById('seqError').classList.add('hidden');
            }

            if (hasError) e.preventDefault();
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') { closeFormModal(); closeDeleteModal(); }
        });

        function filterTable() {
            var input = document.getElementById("searchInput").value.toLowerCase();
            var rows = document.querySelectorAll(".data-table tbody tr");
            rows.forEach(function(row) {
                if (row.getElementsByTagName("td").length > 1) {
                    var text = row.textContent.toLowerCase();
                    row.style.display = text.includes(input) ? "" : "none";
                }
            });
        }
        function toggleTheme(){var h=document.documentElement,c=h.getAttribute('data-theme'),n=c==='dark'?'light':'dark';h.setAttribute('data-theme',n);localStorage.setItem('theme',n);}
        function toggleMobileMenu(){document.getElementById('navLinks').classList.toggle('open');}
    </script>
</body>
</html>
