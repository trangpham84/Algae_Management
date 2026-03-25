package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.UserService;
import service.UserServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = {"/ProfileServlet", "/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"result\":\"not_logged_in\"}");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");

        if ("updateAvatar".equals(action)) {
            String imageUrl = request.getParameter("imageUrl");

            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = null;
            } else {
                imageUrl = imageUrl.trim();
                if (imageUrl.length() > 500) {
                    out.print("{\"result\":\"error\",\"msg\":\"URL too long (max 500 characters)\"}");
                    return;
                }
            }

            try {
                boolean updated = userService.updateProfileImage(user.getUserID(), imageUrl);
                if (updated) {
                    user.setProfileImage(imageUrl);
                    session.setAttribute("user", user);
                    out.print("{\"result\":\"success\",\"imageUrl\":\"" + (imageUrl != null ? imageUrl : "") + "\"}");
                } else {
                    out.print("{\"result\":\"error\",\"msg\":\"Could not update database\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("{\"result\":\"error\",\"msg\":\"" + e.getMessage() + "\"}");
            }
            return;
        }

        // --- Standard Form Actions (with redirect) ---
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.trim().isEmpty()) {
            redirect = "profile.jsp";
        }

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            try {
                boolean updated = userService.updateUserProfile(user.getUserID(), fullName, email, phone);
                if (updated) {
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhone(phone);
                    session.setAttribute("user", user);
                    request.setAttribute("successMessage", "Profile updated successfully!");
                } else {
                    request.setAttribute("errorMessage", "Update failed.");
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error: " + e.getMessage());
            }
        }
        else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword == null || !newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match.");
            } else {
                try {
                    boolean success = userService.changePassword(user.getUserID(), currentPassword, newPassword);
                    if (success) {
                        request.setAttribute("successMessage", "Password changed successfully!");
                    } else {
                        request.setAttribute("errorMessage", "Current password is incorrect.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error: " + e.getMessage());
                }
            }
        } else {
            request.setAttribute("errorMessage", "Invalid action.");
        }

        request.getRequestDispatcher(redirect).forward(request, response);
    }
}
