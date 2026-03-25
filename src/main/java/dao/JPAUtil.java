package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

public class JPAUtil {

    private static final Logger log = Logger.getLogger(JPAUtil.class.getName());
    private static final EntityManagerFactory emf;

    static {
        try {
            // Override persistence.xml values with environment variables if present
            Map<String, Object> props = new HashMap<>();

            String dbUrl  = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASSWORD");

            // Hardcoded defaults (provided by user for easy deployment)
            String defaultUrl = "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require";
            String defaultUser = "postgres.sorfuoklzuphrpzzqqcm";
            String defaultPass = "Nmly@123##@@";

            props.put("jakarta.persistence.jdbc.url",      (dbUrl  != null && !dbUrl.isBlank())  ? dbUrl  : defaultUrl);
            props.put("jakarta.persistence.jdbc.user",     (dbUser != null && !dbUser.isBlank()) ? dbUser : defaultUser);
            props.put("jakarta.persistence.jdbc.password", (dbPass != null && !dbPass.isBlank()) ? dbPass : defaultPass);

            if (!props.isEmpty()) {
                log.info("[JPAUtil] Using DB credentials from environment variables.");
            }

            emf = Persistence.createEntityManagerFactory("AlgaeDNAPU", props);
        } catch (Throwable ex) {
            System.err.println("[JPAUtil] EntityManagerFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
