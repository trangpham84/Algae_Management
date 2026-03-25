package service;

import dao.AlgaeRecordDAO;
import model.AlgaeRecord;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

public class AlgaeRecordServiceImpl implements AlgaeRecordService {

    private final AlgaeRecordDAO dao;

    public AlgaeRecordServiceImpl() {
        this.dao = new AlgaeRecordDAO();
    }

    private void validateRecord(String speciesGroup, String signatureSequence) {
        if (speciesGroup == null || speciesGroup.trim().isEmpty()) {
            throw new ValidationException("Species/Group name cannot be empty");
        }
        if (signatureSequence == null || signatureSequence.trim().isEmpty()) {
            throw new ValidationException("DNA sequence cannot be empty");
        }
        String seq = signatureSequence.trim().toUpperCase();
        if (!seq.matches("^[ATGC]+$")) {
            throw new ValidationException("DNA sequence must contain only A, T, G, C characters");
        }
    }

    @Override
    public List<AlgaeRecord> getAllRecords() {
        return dao.findAll();
    }

    @Override
    public AlgaeRecord getById(int id) {
        return dao.findById(id);
    }

    @Override
    public List<AlgaeRecord> search(String keyword, String seqKeyword, Integer minLen, Integer maxLen) {
        return dao.search(keyword, seqKeyword, minLen, maxLen);
    }

    @Override
    public boolean create(String speciesGroup, String signatureSequence) {
        validateRecord(speciesGroup, signatureSequence);
        String seq = signatureSequence.trim().toUpperCase();
        AlgaeRecord record = new AlgaeRecord(speciesGroup.trim(), seq, seq.length());
        return dao.create(record);
    }

    @Override
    public boolean update(int id, String speciesGroup, String signatureSequence) {
        validateRecord(speciesGroup, signatureSequence);
        String seq = signatureSequence.trim().toUpperCase();
        AlgaeRecord record = new AlgaeRecord(speciesGroup.trim(), seq, seq.length());
        record.setRecordID(id);
        return dao.update(record);
    }

    @Override
    public boolean delete(int id) {
        return dao.delete(id);
    }

    @Override
    public int[] importFromFile(InputStream inputStream, String fileName) {
        int inserted = 0;
        int skipped = 0;

        try {
            if (fileName.endsWith(".xlsx") || fileName.endsWith(".xls")) {
                // Parse Excel
                Workbook workbook = new XSSFWorkbook(inputStream);
                Sheet sheet = workbook.getSheetAt(0);
                boolean isHeader = true;

                for (Row row : sheet) {
                    if (isHeader) {
                        isHeader = false;
                        continue; // skip header row
                    }

                    String species = getCellStringValue(row.getCell(0));
                    String sequence = getCellStringValue(row.getCell(1));
                    int nucleotides;

                    Cell ntCell = row.getCell(2);
                    if (ntCell != null && ntCell.getCellType() == CellType.NUMERIC) {
                        nucleotides = (int) ntCell.getNumericCellValue();
                    } else {
                        // auto-calc from sequence length
                        nucleotides = sequence != null ? sequence.replaceAll("[^ATGCatgc]", "").length() : 0;
                    }

                    if (species == null || species.trim().isEmpty() || sequence == null || sequence.trim().isEmpty()) {
                        skipped++;
                        continue;
                    }

                    String seq = sequence.trim().toUpperCase();
                    if (!seq.matches("^[ATGC]+$")) {
                        skipped++;
                        continue;
                    }

                    // Check for exact duplicate
                    if (dao.findExactDuplicate(species.trim(), seq, nucleotides)) {
                        skipped++;
                        continue;
                    }

                    AlgaeRecord record = new AlgaeRecord(species.trim(), seq, nucleotides);
                    if (dao.create(record)) {
                        inserted++;
                    } else {
                        skipped++;
                    }
                }
                workbook.close();

            } else if (fileName.endsWith(".csv")) {
                // Parse CSV
                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
                String line;
                boolean isHeader = true;

                while ((line = reader.readLine()) != null) {
                    if (isHeader) {
                        isHeader = false;
                        continue;
                    }

                    String[] parts = line.split(",", -1);
                    if (parts.length < 2) {
                        skipped++;
                        continue;
                    }

                    String species = parts[0].trim();
                    String sequence = parts[1].trim().toUpperCase();
                    int nucleotides;

                    if (parts.length >= 3 && !parts[2].trim().isEmpty()) {
                        try {
                            nucleotides = Integer.parseInt(parts[2].trim());
                        } catch (NumberFormatException e) {
                            nucleotides = sequence.replaceAll("[^ATGC]", "").length();
                        }
                    } else {
                        nucleotides = sequence.replaceAll("[^ATGC]", "").length();
                    }

                    if (species.isEmpty() || sequence.isEmpty()) {
                        skipped++;
                        continue;
                    }

                    if (!sequence.matches("^[ATGC]+$")) {
                        skipped++;
                        continue;
                    }

                    if (dao.findExactDuplicate(species, sequence, nucleotides)) {
                        skipped++;
                        continue;
                    }

                    AlgaeRecord record = new AlgaeRecord(species, sequence, nucleotides);
                    if (dao.create(record)) {
                        inserted++;
                    } else {
                        skipped++;
                    }
                }
                reader.close();
            } else {
                throw new ValidationException("Unsupported file format. Please upload .xlsx, .xls, or .csv files.");
            }
        } catch (ValidationException ve) {
            throw ve;
        } catch (Exception e) {
            e.printStackTrace();
            throw new ValidationException("Error processing file: " + e.getMessage());
        }

        return new int[]{inserted, skipped};
    }

    private String getCellStringValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                return String.valueOf((int) cell.getNumericCellValue());
            default:
                return null;
        }
    }

    @Override
    public int getTotalCount() {
        return dao.getTotalCount();
    }

    @Override
    public double getAverageNucleotides() {
        return dao.getAverageNucleotides();
    }
}
