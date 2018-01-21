<%-- 
    Document   : FinalDashboard
    Created on : Jan 3, 2018, 3:02:57 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Employee"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DAO.DashboardDAO"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <style>
            body {font-family: Arial;}

            /* Style the tab */
            .tab {
                overflow: hidden;
                border: 1px solid #F0F8FF;
                background-color: #f1f1f1;
            }

            /* Style the buttons inside the tab */
            .tab button {
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 14px 16px;
                transition: 0.3s;
                font-size: 15px;
                font-weight: bold;
            }

            /* Change background color of buttons on hover */
            .tab button:hover {
                background-color: #ddd;
            }

            /* Create an active/current tablink class */
            .tab button.active {
                background-color: RGB(68, 114, 196);
                color: #ffffff;
                font-weight: bold;
            }

            /* Style the tab content */
            .tabcontent {
                display: none;
                padding: auto;
                -webkit-animation: fadeEffect 1s;
                animation: fadeEffect 1s;
            }

            /* Fade in tabs */
            @-webkit-keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            @keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            /* Styling for month date fields in dashboard */

            .dashboardSelect {
                display:flex;
                flex-direction: column;
                position:relative;
                width:250px;
                height:30px;
                white-space: nowrap;
                background-color: #666;
            }

            .clientDashboard{
                padding:0 30px 0 10px;
                min-height:30px;
                display:flex;
                align-items:center;
                background:#333;
                position:absolute;
                top:0;
                width: 100%;
                transition:background .1s ease-in-out;
                box-sizing:border-box;
                overflow:hidden;
                white-space:nowrap;
                background-color: #666;
                color: white;
            }

            .clientDashboardOption{
                background-color: #666;
                color: white;
            }

            .dashboardSelect:focus .clientDashboardOption {
                position:relative;
                pointer-events:all;
            }

            /* end of styling for month date field in dashboard */


            /* this section is for the selecting charts and making the datatables appear*/
            #revenueTable {
                display:none;
                cursor:pointer;
            }
            #ProfitAndLossTable {
                display:none;
                cursor:pointer;
            }
            #ProjectsOverdueChartTable {
                display:none;
                cursor:pointer;
            }
            .activePerformanceChart {
                border: 2px solid blue;
            }
            /* end of section */
        </style>
        <%            
            DecimalFormat df = new DecimalFormat("#.00");
        %>
        <script>
            $(document).ready(function () {
                $('#datatable1').DataTable();
            })
        </script>
    </head>
    <script src="js/Chart.min.js"></script>
    <script src="js/Chart.bundle.min.js"></script>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>Your Dashboard</h1><br/>
                </div>
                <!-- ############################################### START OF EMPLOYEE PERFORMANCE SECTION ###############################################-->
                <div class="container-fluid" style="text-align: center;">
                    <br/>
                    <div class="row">
                        <div class="col-xs-1">&nbsp;</div>
                        <div class="col-xs-5" style="text-align: center;" align="center;">
                            <h2>Project Overdue</h2>
                            <canvas id="employeeRevenueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                        </div>
                        <div class="col-xs-1">&nbsp;</div>
                        <div class="col-xs-5" style="text-align: center;" align="center;">
                            <h2>Project Time</h2>
                            <canvas id="employeeProfitAndLossChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                        </div>
                    </div>
                    <div class="row">
                        <br/><br/>
                        <div class="col-xs-12" id="employeeProjectOverdueTable">
                            <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                                <table id='datatable1' align="center" style="text-align: left;">
                                    <thead>
                                        <tr>
                                            <th width="16.66%">Company Name</th>
                                            <th width="16.66%">Project Name</th>
                                            <th width="16.66%">Hours Assigned</th>
                                            <th width="16.66%">Hours Actual</th>
                                            <th width="16.66%">Difference</th>
                                            <th width="16.66%">Cost</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (request.getSession().getAttribute("year") != null) {
                                                String employeeName = (String) request.getSession().getAttribute("employeeName");
                                                String year = (String) request.getParameter("year");
                                                
                                                ArrayList<Project> employeeProjectList = ProjectDAO.getSpecificStaffReport(employeeName,year);
                                                
                                                if (employeeProjectList != null && !employeeProjectList.isEmpty()) {
                                                    for (int i = 0; i < employeeProjectList.size(); i++) {
                                                        Project p = employeeProjectList.get(i);
                                        %>
                                        <tr>
                                            <td>
                                                <%=p.getCompanyName()%>
                                            </td>
                                            <td>
                                                <%=p.getProjectTitle()%>
                                            </td>
                                            <td>
                                                <%=p.getPlannedHours()%>
                                            </td>
                                            <td>
                                                <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                            </td>
                                            <td>
                                                <%=p.getPlannedHours() - p.getEmployee1Hours() - p.getEmployee2Hours()%>
                                            </td>
                                            <td>
                                                <%=ProjectDAO.getTotalActualCost(p)%>
                                            </td>
                                        </tr>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <br/><br/>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</body>
<jsp:include page="Footer.html"/>
</html>