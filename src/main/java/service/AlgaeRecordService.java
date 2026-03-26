package service;

import model.AlgaeRecord;
import java.io.InputStream;
import java.util.List;

public interface AlgaeRecordService {

    List<AlgaeRecord> getAllRecords();

    AlgaeRecord getById(int id);

    List<AlgaeRecord> search(String keyword, String seqKeyword, Integer minLen, Integer maxLen);

    List<AlgaeRecord> searchPaginated(String keyword, String seqKeyword, Integer minLen, Integer maxLen, int page, int pageSize);

    long countSearch(String keyword, String seqKeyword, Integer minLen, Integer maxLen);

    boolean create(String speciesGroup, String signatureSequence);

    boolean update(int id, String speciesGroup, String signatureSequence);

    boolean delete(int id);

    /**
     * Import records from an xlsx or csv file.
     * Returns an int array: [inserted, skipped (duplicates)]
     */
    int[] importFromFile(InputStream inputStream, String fileName);

    int getTotalCount();

    double getAverageNucleotides();
}
