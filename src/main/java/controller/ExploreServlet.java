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
 */
@WebServlet(urlPatterns = {"/explore"})
public class ExploreServlet extends HttpServlet {

    private final AlgaeRecordService algaeService = new AlgaeRecordServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String seqKeyword = request.getParameter("seqKeyword");
        String minLenStr = request.getParameter("minLen");
        String maxLenStr = request.getParameter("maxLen");

        Integer minLen = null;
        Integer maxLen = null;
        try {
            if (minLenStr != null && !minLenStr.trim().isEmpty()) minLen = Integer.parseInt(minLenStr.trim());
        } catch (NumberFormatException ignored) {}
        try {
            if (maxLenStr != null && !maxLenStr.trim().isEmpty()) maxLen = Integer.parseInt(maxLenStr.trim());
        } catch (NumberFormatException ignored) {}

        List<AlgaeRecord> records;
        boolean hasFilters = (keyword != null && !keyword.trim().isEmpty())
                || (seqKeyword != null && !seqKeyword.trim().isEmpty())
                || minLen != null || maxLen != null;

        if (hasFilters) {
            records = algaeService.search(keyword, seqKeyword, minLen, maxLen);
        } else {
            records = algaeService.getAllRecords();
        }

        request.setAttribute("records", records);
        request.setAttribute("keyword", keyword);
        request.setAttribute("seqKeyword", seqKeyword);
        request.setAttribute("minLen", minLenStr);
        request.setAttribute("maxLen", maxLenStr);

        request.getRequestDispatcher("/explore.jsp").forward(request, response);
    }
}
