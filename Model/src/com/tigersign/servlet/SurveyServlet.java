package com.tigersign.servlet;

import com.tigersign.dao.Survey;
import com.tigersign.dao.SurveyDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitSurvey")
public class SurveyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private SurveyDAO surveyDAO;

    @Override
    public void init() throws ServletException {
        surveyDAO = new SurveyDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Survey survey = new Survey();
        
        String name = request.getParameter("field-name");
        if (name == null || name.trim().isEmpty()) {
            survey.setName("Anonymous"); // Default value when name is missing
        } else {
            survey.setName(name);
        }
        
        survey.setDate(request.getParameter("field-date"));
        survey.setEmail(request.getParameter("field-email"));

        String service = request.getParameter("service");
        if ("other".equalsIgnoreCase(service)) {
            survey.setService(request.getParameter("other-service"));
        } else {
            survey.setService(service);
        }

        survey.setRating(Integer.parseInt(request.getParameter("rating")));

        String standout = request.getParameter("standout");
        if ("other".equalsIgnoreCase(standout)) {
            survey.setStandout(request.getParameter("standout-other"));
        } else {
            survey.setStandout(standout);
        }

        survey.setFeedback(request.getParameter("feedback"));

        boolean isSuccess = surveyDAO.submitSurvey(survey);

        if (isSuccess) {
            response.sendRedirect(request.getContextPath() + "/pages/success_claimer.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
