/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import Entity.Project;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author yemin
 */
public class SalesGraph extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String selectedYear = request.getParameter("year");
//        System.out.println("SalesGraph servlet:======================================: "+selectedYear);
        Double[] salesList = ProjectDAO.getSales(selectedYear);
        Double[] costList = ProjectDAO.getActualCost(selectedYear);
        Double[] profitList = ProjectDAO.getProfit(selectedYear);
        
        ArrayList<Double> sales = new ArrayList();
        ArrayList<Double> cost = new ArrayList();
        ArrayList<Double> profit = new ArrayList();
        
        DecimalFormat decimal = new DecimalFormat("#.##");
        
        for(int i = 0; i < 12; i++) {
            double value = salesList[i];
            
            value = Double.valueOf(decimal.format(value));
            sales.add(value);
        }
        
        for(int i = 0; i < 12; i++) {
            double value = costList[i];
            
            value = Double.valueOf(decimal.format(value));
            cost.add(value);
        }
        
        for(int i = 0; i < 12; i++) {
            double value = profitList[i];
            
            value = Double.valueOf(decimal.format(value));
            profit.add(value);
        }
        //Overdue,Ontime, Completed Projects
        int[] overdueList = new int[12];
        int[] ontimeList = ProjectDAO.getOnTimeProjectPerYear(selectedYear);
        int[] completedList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        overdueList = ProjectDAO.getOverdueProjectPerYear(selectedYear);
        
        ArrayList<Integer> overdue = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = overdueList[i];
            overdue.add(value);
        }
        
         ArrayList<Integer> ontime = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = ontimeList[i];
            ontime.add(value);
        }
        
         ArrayList<Integer> completed = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = completedList[i];
            completed.add(value);
        }
        
        //CompletedProjectMonthlyProfitability
        ArrayList<ArrayList<Integer>> profitabilityList = new ArrayList();

        profitabilityList = ProjectDAO.getCompletedProjectMonthlyProfitability(selectedYear);
        int[] completedProjectsList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        
        ArrayList<Integer> completedProjects = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = completedProjectsList[i];
            completedProjects.add(value);
        }
        
        ArrayList<Integer> yearProfitList = profitabilityList.get(0);
        ArrayList<Integer> yearLossList = profitabilityList.get(1);
        
        ArrayList<Project> projectsForTable = ProjectDAO.getProjectsWithinSelectedYear(selectedYear);
        
        
//        System.out.println("Sales Graph - Sales: "+sales);
//        System.out.println("Sales Graph - Cost: "+cost);
//        System.out.println("Profit Graph - Profit: "+profit);
        
        request.getSession().setAttribute("sales", sales);
        request.getSession().setAttribute("cost", cost);
        request.getSession().setAttribute("profit", profit);
        request.getSession().setAttribute("overdueProject", overdue);
        request.getSession().setAttribute("ontimeProject", ontime);
        request.getSession().setAttribute("completedProject", completed);
        request.getSession().setAttribute("yearProfit", yearProfitList);
        request.getSession().setAttribute("yearLoss", yearLossList);
        request.getSession().setAttribute("totalCompletedList", completedProjects);
        request.getSession().setAttribute("projectsForTable", projectsForTable);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
