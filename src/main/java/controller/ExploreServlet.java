package controller;

import model.AlgaeRecord;
import service.AlgaeRecordService;
import service.AlgaeRecordServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * ExploreServlet — User-facing page for browsing and searching algae data.
 * Supports server-side pagination (50 records/page) and full-text search
 * across ALL records regardless of current page.
 */
@WebServlet(urlPatterns = {"/explore"})
public class ExploreServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;
    private final AlgaeRecordService algaeService = new AlgaeRecordServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String seqKeyword = request.getParameter("seqKeyword");
        String minLenStr = request.getParameter("minLen");
        String maxLenStr = request.getParameter("maxLen");
        String pageStr = request.getParameter("page");

        Integer minLen = null;
        Integer maxLen = null;
        try {
            if (minLenStr != null && !minLenStr.trim().isEmpty()) minLen = Integer.parseInt(minLenStr.trim());
        } catch (NumberFormatException ignored) {}
        try {
            if (maxLenStr != null && !maxLenStr.trim().isEmpty()) maxLen = Integer.parseInt(maxLenStr.trim());
        } catch (NumberFormatException ignored) {}

        int page = 1;
        try {
            if (pageStr != null && !pageStr.trim().isEmpty()) page = Integer.parseInt(pageStr.trim());
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {}

        // Count total matching records (search applies to ALL records in DB)
        long totalRecords = algaeService.countSearch(keyword, seqKeyword, minLen, maxLen);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        // Fetch only the records for the current page
        List<AlgaeRecord> records = algaeService.searchPaginated(keyword, seqKeyword, minLen, maxLen, page, PAGE_SIZE);

        request.setAttribute("records", records);
        request.setAttribute("keyword", keyword);
        request.setAttribute("seqKeyword", seqKeyword);
        request.setAttribute("minLen", minLenStr);
        request.setAttribute("maxLen", maxLenStr);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/explore.jsp").forward(request, response);
    }
}
