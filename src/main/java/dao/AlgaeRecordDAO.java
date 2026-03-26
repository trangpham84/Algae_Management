package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.AlgaeRecord;

import java.util.ArrayList;
import java.util.List;

public class AlgaeRecordDAO extends BaseDAO {

    public List<AlgaeRecord> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT a FROM AlgaeRecord a ORDER BY a.recordID", AlgaeRecord.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public AlgaeRecord findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(AlgaeRecord.class, id);
        } finally {
            em.close();
        }
    }

    public List<AlgaeRecord> search(String keyword, String seqKeyword, Integer minLen, Integer maxLen) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT a FROM AlgaeRecord a WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append(" AND LOWER(a.speciesGroup) LIKE :keyword");
            }
            if (seqKeyword != null && !seqKeyword.trim().isEmpty()) {
                jpql.append(" AND UPPER(a.signatureSequence) LIKE :seqKeyword");
            }
            if (minLen != null) {
                jpql.append(" AND a.nucleotides >= :minLen");
            }
            if (maxLen != null) {
                jpql.append(" AND a.nucleotides <= :maxLen");
            }
            jpql.append(" ORDER BY a.recordID");

            TypedQuery<AlgaeRecord> q = em.createQuery(jpql.toString(), AlgaeRecord.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                q.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (seqKeyword != null && !seqKeyword.trim().isEmpty()) {
                q.setParameter("seqKeyword", "%" + seqKeyword.trim().toUpperCase() + "%");
            }
            if (minLen != null) {
                q.setParameter("minLen", minLen);
            }
            if (maxLen != null) {
                q.setParameter("maxLen", maxLen);
            }

            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Server-side paginated search. Returns only the records for the given page.
     */
    public List<AlgaeRecord> searchPaginated(String keyword, String seqKeyword,
            Integer minLen, Integer maxLen, int offset, int limit) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT a FROM AlgaeRecord a WHERE 1=1");
            appendSearchConditions(jpql, keyword, seqKeyword, minLen, maxLen);
            jpql.append(" ORDER BY a.recordID");

            TypedQuery<AlgaeRecord> q = em.createQuery(jpql.toString(), AlgaeRecord.class);
            setSearchParameters(q, keyword, seqKeyword, minLen, maxLen);
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Count total records matching the search criteria (for pagination).
     */
    public long countSearch(String keyword, String seqKeyword, Integer minLen, Integer maxLen) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(a) FROM AlgaeRecord a WHERE 1=1");
            appendSearchConditions(jpql, keyword, seqKeyword, minLen, maxLen);

            TypedQuery<Long> q = em.createQuery(jpql.toString(), Long.class);
            setSearchParameters(q, keyword, seqKeyword, minLen, maxLen);
            return q.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    private void appendSearchConditions(StringBuilder jpql, String keyword, String seqKeyword,
            Integer minLen, Integer maxLen) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            jpql.append(" AND LOWER(a.speciesGroup) LIKE :keyword");
        }
        if (seqKeyword != null && !seqKeyword.trim().isEmpty()) {
            jpql.append(" AND UPPER(a.signatureSequence) LIKE :seqKeyword");
        }
        if (minLen != null) {
            jpql.append(" AND a.nucleotides >= :minLen");
        }
        if (maxLen != null) {
            jpql.append(" AND a.nucleotides <= :maxLen");
        }
    }

    private void setSearchParameters(TypedQuery<?> q, String keyword, String seqKeyword,
            Integer minLen, Integer maxLen) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            q.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
        if (seqKeyword != null && !seqKeyword.trim().isEmpty()) {
            q.setParameter("seqKeyword", "%" + seqKeyword.trim().toUpperCase() + "%");
        }
        if (minLen != null) {
            q.setParameter("minLen", minLen);
        }
        if (maxLen != null) {
            q.setParameter("maxLen", maxLen);
        }
    }

    public boolean create(AlgaeRecord record) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(record);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean update(AlgaeRecord record) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AlgaeRecord existing = em.find(AlgaeRecord.class, record.getRecordID());
            if (existing == null) return false;
            existing.setSpeciesGroup(record.getSpeciesGroup());
            existing.setSignatureSequence(record.getSignatureSequence());
            existing.setNucleotides(record.getNucleotides());
            em.merge(existing);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean delete(int id) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AlgaeRecord record = em.find(AlgaeRecord.class, id);
            if (record != null) {
                em.remove(record);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Check if an exact duplicate exists (all 3 fields match exactly).
     * Returns true if a duplicate exists.
     * Tối ưu: Dùng SELECT 1 + setMaxResults(1) thay vì COUNT
     * để DB dừng ngay khi tìm thấy bản ghi đầu tiên, không cần đếm hết.
     */
    public boolean findExactDuplicate(String speciesGroup, String signatureSequence, int nucleotides) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Integer> q = em.createQuery(
                    "SELECT 1 FROM AlgaeRecord a WHERE a.speciesGroup = :sp AND a.signatureSequence = :seq AND a.nucleotides = :nt",
                    Integer.class);
            q.setParameter("sp", speciesGroup);
            q.setParameter("seq", signatureSequence);
            q.setParameter("nt", nucleotides);
            q.setMaxResults(1); // Tìm thấy 1 cái là dừng ngay, không quét tiếp
            return !q.getResultList().isEmpty();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public int getTotalCount() {
        EntityManager em = getEntityManager();
        try {
            return ((Long) em.createQuery("SELECT COUNT(a) FROM AlgaeRecord a").getSingleResult()).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public double getAverageNucleotides() {
        EntityManager em = getEntityManager();
        try {
            Double avg = (Double) em.createQuery("SELECT AVG(a.nucleotides) FROM AlgaeRecord a").getSingleResult();
            return avg != null ? avg : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        } finally {
            em.close();
        }
    }
}
