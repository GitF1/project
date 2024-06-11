<%@page import="model.schedule.DateInfo"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="jakarta.servlet.ServletContext" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@page import="model.schedule.Schedule"%>
<%@page import="java.util.List"%>
<%@page import="DAO.schedule.ScheduleDAO"%>
<%@ page import="java.util.*, java.time.*, java.time.format.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="/movie/page/movie/schedule/styles/Header.css"/>
    </head>
    <%

        int movieID = Integer.parseInt(request.getParameter("movieID"));

        ScheduleDAO scheduleDAO = new ScheduleDAO(getServletContext());

        List<String> cities = scheduleDAO.getListCites();
        System.out.println("cites:" + cities);
        Schedule schedule = (Schedule) session.getAttribute("schedule");
        String citySelected;

        if (schedule == null) {
            citySelected = cities.get(0);
        } else {
            citySelected = schedule.getCity();

            if (citySelected == null || citySelected.isEmpty()) {
                citySelected = cities.get(0);
            }
        }


    %>

    <body>

        <div class="header-movie_schedule">
            <div class="header-title">Lịch chiếu </div>
            <div class="location-selector">
                <div class="location-button selected" onclick="openModal()">
                    <span class="icon"><i class="fa-solid fa-location-dot"></i></span>
                    <span id="selected-city"><%= citySelected%></span>
                    <span class="icon">  <i class="fa-solid fa-caret-down"></i></span>

                </div>
                <div class="location-button">
                    <span class="icon"><i class="fa-solid fa-location-crosshairs"></i></span>
                    <span>Gần bạn</span>
                </div>
            </div>
        </div>

        <!-- The Modal -->
        <div id="cityModal" class="container-modal-select">
            <div class="modal-content-box-select">
                <div class="modal-header-box-select">
                    <h2>Chọn địa điểm</h2>
                    <span class="close" onclick="closeModal()"><i class="fa-solid fa-circle-xmark"></i></span>
                </div>
                <div class="modal-body-box-select">
                    <div class="city-list">
                        <%
                            for (String city : cities) {
                        %>
                        <div class="city <%= city.equals(citySelected) ? "selected" : ""%>" onclick="selectCity('<%= city%>')"><%= city%></div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div class="modal-footer-box-select">
                    <button class="button-close" onclick="closeModal()">Đóng</button>
                </div>
            </div>
        </div>


        <div class="date-selector">
            <div class="dates" id="dates-container">
                <%
                    List<DateInfo> week = new DateInfo().generateWeek();
                    for (DateInfo dateInfo : week) {
                %>
                <div class="date-box" onclick="selectDate('<%= dateInfo.getTime()%>')">
                    <div class="date__header-movie-schedule"><strong><%= dateInfo.getDate()%></strong></div>
                    <div class="date-of-week__header-movie-schedule"><%= dateInfo.getDayOfWeek()%></div>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById("cityModal").style.display = "block";
            }

            function closeModal() {
                document.getElementById("cityModal").style.display = "none";
            }

            function selectCity(city) {
                var selectedCityElement = document.getElementById("selected-city");
                selectedCityElement.innerText = city;

                var cities = document.getElementsByClassName("city");
                for (var i = 0; i < cities.length; i++) {
                    cities[i].classList.remove("selected");
                }

                event.target.classList.add("selected");
                closeModal();
            }

            window.onclick = function (event) {
                var modal = document.getElementById("cityModal");
                if (event.target == modal) {
                    closeModal();
                }
            }

         
        </script>
    </body>
</html>