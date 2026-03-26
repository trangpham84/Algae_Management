package controller;

import model.AlgaeRecord;
import service.AlgaeRecordService;
import service.AlgaeRecordServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * ExportServlet — Exports algae data as CSV or XLSX.
 * Exports ALL records matching the current search filters (not paginated).
 * Public endpoint — no authentication required.
 */
@WebServlet(urlPatterns = {"/export"})
public class ExportServlet extends HttpServlet {

    private final AlgaeRecordService algaeService = new AlgaeRecordServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String seqKeyword = request.getParameter("seqKeyword");
        String minLenStr = request.getParameter("minLen");
        String maxLenStr = request.getParameter("maxLen");
        String format = request.getParameter("format"); // "csv" or "xlsx"

        Integer minLen = null;
        Integer maxLen = null;
        try {
            if (minLenStr != null && !minLenStr.trim().isEmpty()) minLen = Integer.parseInt(minLenStr.trim());
        } catch (NumberFormatException ignored) {}
        try {
            if (maxLenStr != null && !maxLenStr.trim().isEmpty()) maxLen = Integer.parseInt(maxLenStr.trim());
        } catch (NumberFormatException ignored) {}

        // Get ALL matching records (no pagination) for export
        List<AlgaeRecord> records = algaeService.search(keyword, seqKeyword, minLen, maxLen);

        if ("xlsx".equalsIgnoreCase(format)) {
            exportXlsx(response, records);
        } else {
            exportCsv(response, records);
        }
    }

    private void exportCsv(HttpServletResponse response, List<AlgaeRecord> records) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"algae_data.csv\"");
        response.setCharacterEncoding("UTF-8");

        PrintWriter writer = response.getWriter();
        // BOM for Excel UTF-8 compatibility
        writer.print("\uFEFF");
        writer.println("RecordID,SpeciesGroup,SignatureSequence,Nucleotides");

        for (AlgaeRecord r : records) {
            writer.printf("%d,\"%s\",\"%s\",%d%n",
                    r.getRecordID(),
                    r.getSpeciesGroup().replace("\"", "\"\""),
                    r.getSignatureSequence().replace("\"", "\"\""),
                    r.getNucleotides());
        }
        writer.flush();
    }

    private void exportXlsx(HttpServletResponse response, List<AlgaeRecord> records) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"algae_data.xlsx\"");

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Algae Data");

            // Header style
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"RecordID", "SpeciesGroup", "SignatureSequence", "Nucleotides"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Data rows
            int rowIdx = 1;
            for (AlgaeRecord r : records) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(r.getRecordID());
                row.createCell(1).setCellValue(r.getSpeciesGroup());
                row.createCell(2).setCellValue(r.getSignatureSequence());
                row.createCell(3).setCellValue(r.getNucleotides());
            }

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());
        }
    }
}
