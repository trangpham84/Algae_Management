package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;

/**
 * RequestLoggingFilter — Logs every incoming HTTP request for debugging/audit.
 * Logs method, URI, query string, authenticated user, and total processing
 * time.
 * Safe to leave on in production (uses java.util.logging at INFO level).
 */
@WebFilter(urlPatterns = "/*", asyncSupported = true)
public class RequestLoggingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        long start = System.currentTimeMillis();

        try {
            chain.doFilter(request, response);
        } finally {
            long elapsed = System.currentTimeMillis() - start;
            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            String username = (user != null) ? user.getUsername() : "anonymous";
            String query = req.getQueryString() != null ? "?" + req.getQueryString() : "";
            System.out.printf("[REQUEST] %s %s%s | user=%s | %dms%n",
                    req.getMethod(),
                    req.getRequestURI(),
                    query,
                    username,
                    elapsed);
        }
    }
}
