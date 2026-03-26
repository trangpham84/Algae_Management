package listener;

import dao.JPAUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.logging.Logger;

/**
 * AppStartupListener — initializes JPA on application startup.
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    private static final Logger log = Logger.getLogger(AppStartupListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        log.info("[AppStartupListener] Initializing JPA...");
        try {
            // Force EMF initialization
            JPAUtil.getEntityManager().close();
            log.info("[AppStartupListener] JPA initialized OK.");

            ctx.setAttribute("appName", "AlgaeDB System");
            ctx.setAttribute("appVersion", "1.0");
            log.info("[AppStartupListener] Application context attributes set.");
        } catch (Exception ex) {
            log.severe("[AppStartupListener] Startup failed: " + ex.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("[AppStartupListener] Shutting down JPA...");
        JPAUtil.close();
    }
}
