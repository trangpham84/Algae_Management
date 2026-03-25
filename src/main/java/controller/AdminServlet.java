package controller;

import model.AlgaeRecord;

import service.AlgaeRecordService;
import service.AlgaeRecordServiceImpl;
import service.UserService;
import service.UserServiceImpl;
import service.ValidationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * AdminServlet — Admin dashboard and CRUD operations for algae records.
 */
@WebServlet(urlPatterns = {"/admin", "/admin/*"})
@MultipartConfig(maxFileSize = 10485760) // 10MB
public class AdminServlet extends HttpServlet {

    private final AlgaeRecordService algaeService = new AlgaeRecordServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "manage":
                List<AlgaeRecord> records = algaeService.getAllRecords();
                request.setAttribute("records", records);
                request.getRequestDispatcher("/admin_manage.jsp").forward(request, response);
                break;
            case "users":
                request.setAttribute("users", userService.getAllUsers());
                request.getRequestDispatcher("/admin_users.jsp").forward(request, response);
                break;
            default:
                int totalSpecies = algaeService.getTotalCount();
                double avgLength = algaeService.getAverageNucleotides();
                List<AlgaeRecord> recentRecords = algaeService.getAllRecords();
                int totalUsers = userService.getAllUsers().size();

                request.setAttribute("totalSpecies", totalSpecies);
                request.setAttribute("avgLength", String.format("%.1f", avgLength));
                request.setAttribute("records", recentRecords);
                request.setAttribute("totalUsers", totalUsers);
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "upload":
                handleUpload(request, response);
                break;
            case "createUser":
                handleCreateUser(request, response);
                break;
            case "updateUser":
                handleUpdateUser(request, response);
                break;
            case "deleteUser":
                handleDeleteUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin?action=manage");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String species = request.getParameter("speciesGroup");
        String sequence = request.getParameter("signatureSequence");

        try {
            algaeService.create(species, sequence);
            request.getSession().setAttribute("successMessage", "Record created successfully!");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("errorMessage", ve.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to create record: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=manage");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("recordId");
        String species = request.getParameter("speciesGroup");
        String sequence = request.getParameter("signatureSequence");

        try {
            int id = Integer.parseInt(idStr);
            algaeService.update(id, species, sequence);
            request.getSession().setAttribute("successMessage", "Record updated successfully!");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("errorMessage", ve.getMessage());
        } catch (NumberFormatException nfe) {
            request.getSession().setAttribute("errorMessage", "Invalid record ID.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to update record: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=manage");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("recordId");

        try {
            int id = Integer.parseInt(idStr);
            boolean success = algaeService.delete(id);
            if (success) {
                request.getSession().setAttribute("successMessage", "Record deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Record not found.");
            }
        } catch (NumberFormatException nfe) {
            request.getSession().setAttribute("errorMessage", "Invalid record ID.");
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=manage");
    }

    private void handleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("errorMessage", "Please select a file to upload.");
            response.sendRedirect(request.getContextPath() + "/admin?action=manage");
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || (!fileName.endsWith(".xlsx") && !fileName.endsWith(".xls") && !fileName.endsWith(".csv"))) {
            request.getSession().setAttribute("errorMessage", "Unsupported file format. Please upload .xlsx, .xls, or .csv files.");
            response.sendRedirect(request.getContextPath() + "/admin?action=manage");
            return;
        }

        try (InputStream is = filePart.getInputStream()) {
            int[] result = algaeService.importFromFile(is, fileName);
            request.getSession().setAttribute("successMessage",
                    "Import complete: " + result[0] + " records inserted, " + result[1] + " rows skipped (duplicates or invalid).");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("errorMessage", ve.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Upload failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=manage");
    }

    // ── User CRUD ─────────────────────────────────────────────────────────────

    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email    = request.getParameter("email");
        String role     = request.getParameter("role");
        try {
            userService.createUser(username, password, email, role);
            request.getSession().setAttribute("successMessage", "User created successfully!");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("errorMessage", ve.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to create user: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr  = request.getParameter("userId");
        String email  = request.getParameter("email");
        String role   = request.getParameter("role");
        try {
            int id = Integer.parseInt(idStr);
            if (email != null && !email.isBlank()) {
                userService.updateUserProfile(id, null, email, null);
            }
            if (role != null && !role.isBlank()) {
                userService.updateRole(id, role);
            }
            request.getSession().setAttribute("successMessage", "User updated successfully!");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("errorMessage", ve.getMessage());
        } catch (NumberFormatException nfe) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to update user: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("userId");
        // Prevent admin from deleting themselves
        model.User currentUser = (model.User) request.getSession().getAttribute("user");
        try {
            int id = Integer.parseInt(idStr);
            if (currentUser != null && currentUser.getUserID() == id) {
                request.getSession().setAttribute("errorMessage", "You cannot delete your own account.");
            } else {
                boolean ok = userService.deleteUser(id);
                request.getSession().setAttribute(ok ? "successMessage" : "errorMessage",
                        ok ? "User deleted." : "User not found.");
            }
        } catch (NumberFormatException nfe) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID.");
        }
        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }
}
