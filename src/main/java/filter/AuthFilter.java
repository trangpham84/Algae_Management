package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.User;

import java.io.IOException;

/**
 * AuthFilter — Intercepts all protected URLs.
 * Redirects unauthenticated users to /login.jsp.
 */
@WebFilter(urlPatterns = {
        "/explore", "/profile",
        "/admin", "/admin/*"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Save the original URL so we can redirect back after login
            String targetURL = req.getRequestURI();
            if (req.getQueryString() != null)
                targetURL += "?" + req.getQueryString();
            session = req.getSession(true);
            session.setAttribute("redirectAfterLogin", targetURL);

            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
