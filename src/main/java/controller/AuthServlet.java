package controller;

import model.User;
import service.UserService;
import service.UserServiceImpl;
import service.EmailService;
import service.ValidationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Random;

/**
 * AuthServlet — Handles login, register, logout, forgot password, OTP verification.
 */
@WebServlet(urlPatterns = {"/auth", "/auth/*"})
public class AuthServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final EmailService emailService = new EmailService();
    private final Random random = new Random();

    private String generateOtp() {
        return String.format("%06d", random.nextInt(1000000));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "loginPage";

        switch (action) {
            case "loginPage":
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
            case "registerPage":
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
            case "forgotPage":
                request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
                break;
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) session.invalidate();
                // Remove remember-me cookie
                Cookie cookie = new Cookie("rememberUser", "");
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                break;
            default:
                request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                handleRegister(request, response);
                break;
            case "verifyRegistration":
                handleVerifyRegistration(request, response);
                break;
            case "verifyLoginOtp":
                handleVerifyLoginOtp(request, response);
                break;
            case "forgotPassword":
                handleForgotPassword(request, response);
                break;
            case "verifyResetOtp":
                handleVerifyResetOtp(request, response);
                break;
            case "doResetPassword":
                handleDoResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Backend validation
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userService.login(username.trim(), password);
        if (user == null) {
            request.setAttribute("error", "Invalid username or password.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if user has email for OTP
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            // Generate OTP and send email
            String otp = generateOtp();
            HttpSession session = request.getSession(true);
            session.setAttribute("loginOtp", otp);
            session.setAttribute("loginOtpTime", System.currentTimeMillis());
            session.setAttribute("pendingLoginUser", user);

            try {
                emailService.sendLoginOtp(user.getEmail(), user.getUsername(), otp);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Handle remember me
            if ("on".equals(rememberMe)) {
                session.setAttribute("pendingRememberMe", true);
            }

            request.getRequestDispatcher("/verifyLoginOtp.jsp").forward(request, response);
        } else {
            // No email — direct login
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(86400); // 1 day

            if ("on".equals(rememberMe)) {
                Cookie cookie = new Cookie("rememberUser", username.trim());
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            String redirect = (String) session.getAttribute("redirectAfterLogin");
            session.removeAttribute("redirectAfterLogin");
            response.sendRedirect(redirect != null ? redirect : request.getContextPath() + "/");
        }
    }

    private void handleVerifyLoginOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String enteredOtp = request.getParameter("otp");
        String storedOtp = (String) session.getAttribute("loginOtp");
        Long otpTime = (Long) session.getAttribute("loginOtpTime");
        User user = (User) session.getAttribute("pendingLoginUser");

        if (storedOtp == null || user == null || otpTime == null) {
            request.setAttribute("error", "Session expired. Please login again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check OTP expiry (10 minutes)
        if (System.currentTimeMillis() - otpTime > 600000) {
            session.removeAttribute("loginOtp");
            session.removeAttribute("loginOtpTime");
            session.removeAttribute("pendingLoginUser");
            request.setAttribute("error", "OTP has expired. Please login again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!storedOtp.equals(enteredOtp)) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("/verifyLoginOtp.jsp").forward(request, response);
            return;
        }

        // OTP valid — complete login
        session.removeAttribute("loginOtp");
        session.removeAttribute("loginOtpTime");
        session.removeAttribute("pendingLoginUser");
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(86400);

        Boolean rememberMe = (Boolean) session.getAttribute("pendingRememberMe");
        if (Boolean.TRUE.equals(rememberMe)) {
            Cookie cookie = new Cookie("rememberUser", user.getUsername());
            cookie.setMaxAge(30 * 24 * 60 * 60);
            cookie.setPath("/");
            response.addCookie(cookie);
            session.removeAttribute("pendingRememberMe");
        }

        String redirect = (String) session.getAttribute("redirectAfterLogin");
        session.removeAttribute("redirectAfterLogin");
        response.sendRedirect(redirect != null ? redirect : request.getContextPath() + "/");
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Backend validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("error", "A valid email is required.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 3) {
            request.setAttribute("error", "Password must be at least 3 characters.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if username already exists
        if (userService.findByUsername(username.trim()) != null) {
            request.setAttribute("error", "Username already exists.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userService.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "Email already registered.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Generate OTP and store pending registration
        String otp = generateOtp();
        HttpSession session = request.getSession(true);
        session.setAttribute("regOtp", otp);
        session.setAttribute("regOtpTime", System.currentTimeMillis());
        session.setAttribute("regUsername", username.trim());
        session.setAttribute("regEmail", email.trim());
        session.setAttribute("regPassword", password);

        try {
            emailService.sendRegistrationOtp(email.trim(), username.trim(), otp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send verification email. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/verifyEmail.jsp").forward(request, response);
    }

    private void handleVerifyRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp");
            return;
        }

        String enteredOtp = request.getParameter("otp");
        String storedOtp = (String) session.getAttribute("regOtp");
        Long otpTime = (Long) session.getAttribute("regOtpTime");

        if (storedOtp == null || otpTime == null) {
            request.setAttribute("error", "Session expired. Please register again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() - otpTime > 600000) {
            session.removeAttribute("regOtp");
            request.setAttribute("error", "OTP has expired. Please register again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!storedOtp.equals(enteredOtp)) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("/verifyEmail.jsp").forward(request, response);
            return;
        }

        // OTP valid — persist user
        String username = (String) session.getAttribute("regUsername");
        String email = (String) session.getAttribute("regEmail");
        String password = (String) session.getAttribute("regPassword");

        try {
            boolean success = userService.register(username, password, email);
            if (success) {
                // Clear registration session data
                session.removeAttribute("regOtp");
                session.removeAttribute("regOtpTime");
                session.removeAttribute("regUsername");
                session.removeAttribute("regEmail");
                session.removeAttribute("regPassword");

                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (ValidationException ve) {
            request.setAttribute("error", ve.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        User user = userService.findByEmail(email.trim());
        if (user == null) {
            request.setAttribute("error", "No account found with this email.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        String otp = generateOtp();
        HttpSession session = request.getSession(true);
        session.setAttribute("resetOtp", otp);
        session.setAttribute("resetOtpTime", System.currentTimeMillis());
        session.setAttribute("resetUserId", user.getUserID());
        session.setAttribute("resetUsername", user.getUsername());
        session.setAttribute("resetEmail", email.trim());

        try {
            emailService.sendPasswordResetOtp(email.trim(), user.getUsername(), otp);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("emailSent", true);
        request.setAttribute("email", email.trim());
        request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
    }

    private void handleVerifyResetOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot_password.jsp");
            return;
        }

        String enteredOtp = request.getParameter("otp");
        String storedOtp = (String) session.getAttribute("resetOtp");
        Long otpTime = (Long) session.getAttribute("resetOtpTime");
        String resetUsername = (String) session.getAttribute("resetUsername");

        if (storedOtp == null || otpTime == null) {
            request.setAttribute("error", "Session expired. Please try again.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() - otpTime > 600000) {
            request.setAttribute("error", "OTP has expired. Please request a new one.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        if (!storedOtp.equals(enteredOtp)) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.setAttribute("emailSent", true);
            request.setAttribute("email", session.getAttribute("resetEmail"));
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        // OTP valid — show reset password form with greyed-out nickname
        session.setAttribute("resetOtpVerified", true);
        request.setAttribute("resetUsername", resetUsername);
        request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
    }

    private void handleDoResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("resetOtpVerified"))) {
            response.sendRedirect(request.getContextPath() + "/forgot_password.jsp");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        Integer userId = (Integer) session.getAttribute("resetUserId");
        String resetUsername = (String) session.getAttribute("resetUsername");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/forgot_password.jsp");
            return;
        }

        if (newPassword == null || newPassword.length() < 3) {
            request.setAttribute("error", "Password must be at least 3 characters.");
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }

        boolean success = userService.updatePassword(userId, newPassword);
        // Clear reset session data
        session.removeAttribute("resetOtp");
        session.removeAttribute("resetOtpTime");
        session.removeAttribute("resetUserId");
        session.removeAttribute("resetUsername");
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetOtpVerified");

        if (success) {
            request.setAttribute("success", "Password reset successfully! Please login with your new password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
        }
    }
}
