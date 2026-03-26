<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users — AlgaeDB</title>
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
                <a href="${pageContext.request.contextPath}/admin?action=manage" class="sidebar-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
                    Manage Data
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="sidebar-link active">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    Manage Users
                </a>
            </nav>
        </aside>

        <!-- Content -->
        <main class="admin-content">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;" class="animate-fade-in">
                <h1 style="font-size:1.5rem;font-weight:700;color:var(--foreground);">Manage Users</h1>
                <div style="display:flex;gap:0.75rem;align-items:center;">
                    <!-- Search Input -->
                    <div style="position:relative;width:260px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="form-icon"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                        <input type="text" id="searchInput" class="form-input form-input-icon" placeholder="Search user, email, role..." onkeyup="filterTable()">
                    </div>
                    <button onclick="openAddModal()" class="btn btn-success hover-lift">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                        Add User
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
                                <th>Username</th>
                                <th>Email</th>
                                <th>Full Name</th>
                                <th>Role</th>
                                <th>Logins</th>
                                <th class="text-right col-actions">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}" varStatus="s">
                                <tr class="animate-fade-in" style="animation-delay:${s.index * 40}ms">
                                    <td style="color:var(--muted-foreground);font-family:var(--font-mono);">${u.userID}</td>
                                    <td class="font-medium">${fn:escapeXml(u.username)}</td>
                                    <td style="color:var(--muted-foreground);">${fn:escapeXml(u.email)}</td>
                                    <td>${fn:escapeXml(u.fullName)}</td>
                                    <td>
                                        <span class="role-badge role-${fn:toLowerCase(u.role)}">${u.role}</span>
                                    </td>
                                    <td style="font-family:var(--font-mono);">${u.loginCount}</td>
                                    <td class="text-right col-actions">
                                        <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
                                            <button onclick="openEditModal(${u.userID}, '${fn:escapeXml(u.username)}', '${fn:escapeXml(u.email)}', '${fn:escapeXml(u.role)}')" class="btn-icon-sm btn-edit">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></svg>
                                                Edit
                                            </button>
                                            <c:if test="${u.userID != sessionScope.user.userID}">
                                                <button onclick="openDeleteModal(${u.userID}, '${fn:escapeXml(u.username)}')" class="btn-icon-sm btn-delete">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                                    Delete
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr><td colspan="7" style="text-align:center;padding:3rem;color:var(--muted-foreground);">No users found.</td></tr>
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
                <h2 class="modal-title" id="formModalTitle">Add New User</h2>
                <button class="modal-close" onclick="closeFormModal()"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin" id="userForm">
                <input type="hidden" name="action" id="formAction" value="createUser">
                <input type="hidden" name="userId" id="formUserId" value="">

                <div class="form-group animate-fade-in">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="e.g., john_doe">
                    <div id="usernameError" class="form-error hidden"></div>
                </div>
                <div id="passwordGroup" class="form-group animate-fade-in delay-100">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Min. 3 characters">
                    <div id="passwordError" class="form-error hidden"></div>
                </div>
                <div class="form-group animate-fade-in delay-200">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="user@example.com">
                    <div id="emailError" class="form-error hidden"></div>
                </div>
                <div class="form-group animate-fade-in delay-300">
                    <label for="role" class="form-label">Role</label>
                    <select id="role" name="role" class="form-input">
                        <option value="User">User</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeFormModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="formSubmitBtn">Add User</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Modal -->
    <div id="deleteModal" class="modal-overlay hidden" onclick="closeDeleteModal()">
        <div class="modal-content" style="max-width:24rem;" onclick="event.stopPropagation()">
            <h2 class="modal-title" style="margin-bottom:0.75rem;">Confirm Delete</h2>
            <p style="font-size:0.875rem;color:var(--muted-foreground);margin-bottom:1.5rem;">
                Delete user <strong id="deleteUsername" style="color:var(--foreground);"></strong>? This cannot be undone.
            </p>
            <form method="POST" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="deleteUser">
                <input type="hidden" name="userId" id="deleteUserId">
                <div style="display:flex;justify-content:flex-end;gap:0.75rem;">
                    <button type="button" class="btn btn-outline" onclick="closeDeleteModal()">Cancel</button>
                    <button type="submit" class="btn btn-destructive">Delete</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/toast.js"></script>
    <script>
        <c:if test="${not empty sessionScope.successMessage}">
            showToast('${fn:escapeXml(sessionScope.successMessage)}', 'success');
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            showToast('${fn:escapeXml(sessionScope.errorMessage)}', 'error');
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        function openAddModal() {
            document.getElementById('formModalTitle').textContent = 'Add New User';
            document.getElementById('formAction').value = 'createUser';
            document.getElementById('formUserId').value = '';
            document.getElementById('username').value = '';
            document.getElementById('username').disabled = false;
            document.getElementById('password').value = '';
            document.getElementById('email').value = '';
            document.getElementById('role').value = 'User';
            document.getElementById('passwordGroup').style.display = '';
            document.getElementById('formSubmitBtn').textContent = 'Add User';
            document.getElementById('formModal').classList.remove('hidden');
        }

        function openEditModal(id, username, email, role) {
            document.getElementById('formModalTitle').textContent = 'Edit User';
            document.getElementById('formAction').value = 'updateUser';
            document.getElementById('formUserId').value = id;
            document.getElementById('username').value = username;
            document.getElementById('username').disabled = true;
            document.getElementById('email').value = email;
            document.getElementById('role').value = role;
            document.getElementById('passwordGroup').style.display = 'none';
            document.getElementById('formSubmitBtn').textContent = 'Save Changes';
            document.getElementById('formModal').classList.remove('hidden');
        }

        function closeFormModal() { document.getElementById('formModal').classList.add('hidden'); }

        function openDeleteModal(id, username) {
            document.getElementById('deleteUserId').value = id;
            document.getElementById('deleteUsername').textContent = username;
            document.getElementById('deleteModal').classList.remove('hidden');
        }
        function closeDeleteModal() { document.getElementById('deleteModal').classList.add('hidden'); }

        document.getElementById('userForm').addEventListener('submit', function(e) {
            var isCreate = document.getElementById('formAction').value === 'createUser';
            var hasError = false;

            if (isCreate) {
                var u = document.getElementById('username').value.trim();
                if (!u) {
                    document.getElementById('usernameError').textContent = 'Username is required.';
                    document.getElementById('usernameError').classList.remove('hidden');
                    hasError = true;
                } else { document.getElementById('usernameError').classList.add('hidden'); }

                var p = document.getElementById('password').value;
                if (p.length < 3) {
                    document.getElementById('passwordError').textContent = 'Password must be at least 3 characters.';
                    document.getElementById('passwordError').classList.remove('hidden');
                    hasError = true;
                } else { document.getElementById('passwordError').classList.add('hidden'); }
            }

            var em = document.getElementById('email').value.trim();
            if (!em || !em.includes('@')) {
                document.getElementById('emailError').textContent = 'A valid email is required.';
                document.getElementById('emailError').classList.remove('hidden');
                hasError = true;
            } else { document.getElementById('emailError').classList.add('hidden'); }

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

    <style>
        .role-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.2rem 0.6rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.02em;
        }
        .role-admin {
            background: hsla(217, 91%, 60%, 0.15);
            color: hsl(217, 91%, 65%);
        }
        .role-user {
            background: hsla(142, 76%, 36%, 0.12);
            color: hsl(142, 76%, 45%);
        }
    </style>
</body>
</html>
