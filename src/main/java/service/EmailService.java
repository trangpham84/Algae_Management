package service;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

/**
 * Sends emails via Google Apps Script Web App (HTTP POST).
 *
 * Set the environment variable APPS_SCRIPT_EMAIL_URL to the deployed
 * Apps Script Web App URL before starting the server.
 *
 * Google Apps Script handles all SMTP details; Render never touches port 587.
 */
public class EmailService {

    private static final Logger log = Logger.getLogger(EmailService.class.getName());

    /** Reads the Google Apps Script Web App URL from env var or uses the user's default URL. */
    private String getScriptUrl() {
        String url = System.getenv("APPS_SCRIPT_EMAIL_URL");
        if (url == null || url.isBlank()) {
            return "https://script.google.com/macros/s/AKfycbzg5JOYOIWCuV0Apj-9BLarbx_jKD_ythuF4VJ_hfi1lmgozvfLZv3A1oQxlNlD7jBxxQ/exec";
        }
        return url;
    }

    /**
     * Sends an HTML email by POSTing JSON to the Google Apps Script Web App.
     * JSON body: {"to":"...","subject":"...","html":"..."}
     */
    public void sendHtml(String toEmail, String subject, String htmlBody) throws Exception {
        String scriptUrl = getScriptUrl();
        if (scriptUrl == null || scriptUrl.isBlank()) {
            throw new IllegalStateException("APPS_SCRIPT_EMAIL_URL is not configured.");
        }

        // Escape content for JSON (Gson is available in pom.xml)
        com.google.gson.JsonObject json = new com.google.gson.JsonObject();
        json.addProperty("to", toEmail);
        json.addProperty("subject", subject);
        json.addProperty("html", htmlBody);
        byte[] body = json.toString().getBytes(StandardCharsets.UTF_8);

        HttpURLConnection conn = (HttpURLConnection) java.net.URI.create(scriptUrl).toURL().openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(15_000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body);
        }

        int status = conn.getResponseCode();
        if (status < 200 || status >= 300) {
            throw new RuntimeException("Apps Script email failed with HTTP " + status);
        }
        log.info("[EmailService] Email sent to " + toEmail + " via Apps Script (HTTP " + status + ")");
    }

    /** Sends a password reset OTP email. */
    public void sendPasswordResetOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#1e293b,#0f172a);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>&#128274; Password Reset</h1>"
                + "<p style='margin:6px 0 0;color:#94a3b8;font-size:13px;'>AlgaeDB System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>We received a request to reset your password. Use the code below:</p>"
                + "<div style='background:#f0f7ff;border:2px dashed #0284c7;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#0b6cb3;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Valid for <strong>10 minutes</strong></p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>If you did not request a password reset, please ignore this email.<br>Your account remains secure.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>&copy; 2026 AlgaeDB System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "&#128274; Password Reset — Verification Code", html);
    }

    /** Sends a login verification OTP email when session has expired. */
    public void sendLoginOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#4f46e5,#7c3aed);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>&#128274; Login Verification</h1>"
                + "<p style='margin:6px 0 0;color:#c4b5fd;font-size:13px;'>AlgaeDB System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>Your login session has expired. Please enter the code below to verify your identity:</p>"
                + "<div style='background:#f5f3ff;border:2px dashed #7c3aed;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#4f46e5;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Valid for <strong>10 minutes</strong></p></div>"
                + "<div style='background:#fef3c7;border-left:4px solid #f59e0b;border-radius:6px;padding:12px 16px;margin-bottom:16px;'>"
                + "<p style='margin:0;color:#92400e;font-size:13px;'>&#9888;&#65039; If you did not initiate this login, please change your password immediately.</p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>For security reasons, this code can only be used once and expires after 10 minutes.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>&copy; 2026 AlgaeDB System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "&#128274; Login Verification — AlgaeDB", html);
    }

    /** Sends a registration OTP email to verify the user's email address. */
    public void sendRegistrationOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#0b6cb3,#0284c7);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>&#9989; Account Verification</h1>"
                + "<p style='margin:6px 0 0;color:#bae6fd;font-size:13px;'>AlgaeDB System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>Thank you for registering! Please enter the verification code below to activate your account:</p>"
                + "<div style='background:#f0fdf4;border:2px dashed #16a34a;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#15803d;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Valid for <strong>10 minutes</strong></p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>If you did not register an account, please ignore this email.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>&copy; 2026 AlgaeDB System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "&#9989; Account Registration — AlgaeDB", html);
    }
}
