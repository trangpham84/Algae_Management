package listener;

import dao.UserDAO;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.*;
import model.User;

import java.sql.Timestamp;
import java.util.logging.Logger;

/**
 * SessionActivityListener — tracks active sessions and records login stats.
 */
@WebListener
public class SessionActivityListener implements HttpSessionListener, HttpSessionAttributeListener {

    private static final Logger log = Logger.getLogger(SessionActivityListener.class.getName());
    private static volatile int activeSessions = 0;

    private final UserDAO userDAO = new UserDAO();

    // ── SessionListener ──────────────────────────────────────────────────────

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions++;
        log.fine("[SessionListener] Session created. Active sessions: " + activeSessions);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        activeSessions = Math.max(0, activeSessions - 1);
        log.fine("[SessionListener] Session destroyed. Active sessions: " + activeSessions);
    }

    // ── SessionAttributeListener ─────────────────────────────────────────────

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        if ("user".equals(event.getName())) {
            User user = (User) event.getValue();
            if (user != null) {
                try {
                    user.setLastLoginAt(new Timestamp(System.currentTimeMillis()));
                    user.setLoginCount(user.getLoginCount() + 1);
                    userDAO.update(user);
                    event.getSession().setAttribute("user", user);
                    log.info("[SessionListener] Login recorded for: " + user.getUsername()
                            + " | loginCount=" + user.getLoginCount());
                } catch (Exception ex) {
                    log.warning("[SessionListener] Could not update login stats: " + ex.getMessage());
                }
            }
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) { /* no-op */ }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) { /* no-op */ }

    /** Exposes active session count for admin dashboard */
    public static int getActiveSessions() {
        return activeSessions;
    }
}
