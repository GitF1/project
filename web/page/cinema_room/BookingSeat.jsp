
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.Seat" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Seat</title>
        <style>
            #container {
                width: 100vw;
                height: 200vh;
                position: relative;
                background-color: #262626;
            }
            .seatButton {
                position: absolute;
                width: 35px;
                height: 35px;
                font-size: 13px;
                color: white;
                border: none;
                border-radius: 8px;
            }

            #seatInfo {
                width: 100vw;
                height: 12%;
                background-color: #262626;
                position: fixed;
                top: 58%;
            }

            #movieInfo {
                width: 100vw;
                height: 30%;
                background-color: white;
                position: fixed;
                top: 70%;
            }

            .price-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .price-details {
                display: flex;
                flex-direction: column;
            }
            .price-details div,
            .price-details h3 {
                margin: 0;
            }

            #bookedSeatInfoButton {
                top: 25%;
                left: 35%;
                background-color: rgb(64, 64, 64);
            }

            #bookedSeatInfoString {
                position: absolute;
                top: 35%;
                left: calc(35% + 45px);
                color: white;
            }

            #availableSeatInfoButton {
                top: 25%;
                left: calc(45%);
                background-color: rgb(114, 46, 209);
            }

            #availableSeatInfoString {
                position: absolute;
                top: 35%;
                left: calc(45% + 45px);
                color: white;
            }

            #chosenSeatInfoButton {
                top: 25%;
                left: calc(55%);
                background-color: rgb(216, 45, 139);
            }

            #chosenSeatInfoString {
                position: absolute;
                top: 35%;
                left: calc(55% + 45px);
                color: white;
            }

            .purchaseBtn {
                padding: 15px 30px;
                background-color: #d82d8b;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                text-transform: uppercase;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }
            
            @media only screen and (max-width: 1024px) {
                .seatButton {
                    width: 25px;
                    height: 25px;
                    font-size: 10px;
                }
            }

        </style>
    </head>
    <body>

        <form id="bookingSeatForm">
            <div id="container">

                <c:set var="movieSlot" value="${requestScope.movieSlot}"></c:set>
                <c:set var="movie" value="${requestScope.movie}"></c:set>
                <c:set var="room" value="${requestScope.room}"></c:set>
                <c:set var="seats" value="${requestScope.seats}"></c:set>

                    <input type="hidden" id="movieSlotID" name="movieSlotID" value="${requestScope.movieSlotID}"/>

                <c:forEach var="seat" items="${seats}">
                    <c:set var="seatName" value="${seat.getName()}" />
                    <c:set var="seatNameLength" value="${fn:length(seatName)}" />

                    <button type="button" class="seatButton" id="seatButton_${seat.seatID}" onclick="chooseSeat('${seat.getSeatID()}', '${seat.getName()}');">
                        ${seatName}
                    </button>



                </c:forEach>
                <div id="seatInfo">
                    <button class="seatButton" id="bookedSeatInfoButton" type="button"></button>
                    <div id="bookedSeatInfoString">Đã đặt</div>

                    <button class="seatButton" id="availableSeatInfoButton" type="button"></button>
                    <div id="availableSeatInfoString">Ghế trống</div>       

                    <button class="seatButton" id="chosenSeatInfoButton" type="button"></button>
                    <div id="chosenSeatInfoString">Ghế bạn chọn</div>
                </div>

                <div id="movieInfo">
                    <h3 style="margin-left: 3%">${movie.getTitle()}</h3>
                    <div style="margin-left: 3%; margin-top: 0;">${movieSlot.getFormattedStartTime()} ~ ${movieSlot.getFormattedEndTime()}, ${room.getName()}, ${movieSlot.getType()}</div>
                    <hr style="margin-left: 2%; margin-right: 3%;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-right: 6%;">
                        <div style="margin-left: 3%; color: gray;">Ghế đã chọn: </div> 
                        <div style="margin-left: auto; color: black; border: none; border-radius: 5px;" id="selectedSeatsDiv"></div>
                    </div>

                    <hr style="margin-left: 2%; margin-right: 3%;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-left: 3%; margin-right: 6%;">
                        <div>
                            <div style="margin-bottom: 5%; color: gray;">Giá tiền</div>
                            <h3 id="totalPriceH3" style="margin: 0;">0đ</h3>
                            <input type="hidden" id="totalPriceTicket" name="totalPriceTicket"/>
                        </div>


                        <div  class="purchaseBtn" style="margin-left: auto;" onclick="toggleComboBox()">Đặt vé</div>
                    </div>
                </div>

                <div>
                    <c:forEach var="i" begin="1" end="8" step="1">
                        <input type="hidden" id="selectedSeat${i}" name="selectedSeat${i}"/>
                    </c:forEach>   
                </div>
            </div>
            <jsp:include page="./Canteen.jsp" />
        </form>

    </body>

    <script>

        const start = 5;

        const sizeX = Math.floor((9 * window.innerWidth / 10) / 40);
        const sizeY = Math.floor((9 * window.innerHeight / 10) / 40);
        
        const roomWidth = ${requestScope.maxWidth}, roomLength = ${requestScope.maxLength};
        const initX = Math.floor((sizeX - roomLength) / 2);
        const initY = 0;
        const distance = 40; // 40px

        const bookedSeatColor = "rgb(64, 64, 64)";
        const availableSeatColor = "rgb(114, 46, 209)", chosenSeatColor = "rgb(216, 45, 139)";

        var selectedSeats = [];

        <c:set var="bookedSeatColor" value="rgb(64, 64, 64)"/>
        <c:set var="availableSeatColor" value="rgb(114, 46, 209)"/>
        <c:set var="chosenSeatColor" value="rgb(216, 45, 139)"/>

        var numberOfSelectedSeat = 0, totalPrice = 0;
        const price = ${movieSlot.getPrice()}, discount = ${movieSlot.getDiscount()};
        const finalPrice = price - (price * discount / 100);

        <c:forEach var="seat" items="${seats}">
            seatID = ${seat.getSeatID()};
            backgroundColor = "${seat.getStatus() == 'Available' ? availableSeatColor : bookedSeatColor}";
            cursor = "${seat.getStatus() == 'Available' ? 'pointer' : 'not-allowed'}";
            console.log("background-color: " + backgroundColor + ";");
            document.getElementById("seatButton_" + seatID).style = "top: calc(5vh + " + (${seat.getY()} + initY - 1) * distance + "px);"
                                                                    + "left: calc(5vw + " + (${seat.getX()} + initX - 1) * distance + "px);";
            document.getElementById("seatButton_" + seatID).style.backgroundColor = backgroundColor;  
            document.getElementById("seatButton_" + seatID).style.cursor = cursor;                                             
        </c:forEach>

        function selectSeat(seatID, seatName) {
            if (numberOfSelectedSeat >= 8) {
                alert("Quý khách chỉ có thể chọn tối đa 8 ghế 1 lần.");
                return;
            }
            document.getElementById("seatButton_" + seatID).style.backgroundColor = chosenSeatColor;

            newSelectedSeat = {
                seatID,
                seatName
            };
            selectedSeats = [...selectedSeats, newSelectedSeat];
            
            for(let i = 1; i <= 8; ++i) {
                if(document.getElementById("selectedSeat" + i).value === "") {
                    document.getElementById("selectedSeat" + i).value = seatID;
                    break;
                }
            }
            ++numberOfSelectedSeat;
            updateTotalPrice();
            updateSelectedSeatsText();
        }

        function unselectSeat(seatID) {
            document.getElementById("seatButton_" + seatID).style.backgroundColor = availableSeatColor;
            selectedSeats = selectedSeats.filter((seat) => seat.seatID !== seatID);
            for (let i = 1; i <= 8; ++i) {
                if (document.getElementById("selectedSeat" + i).value === seatID) {
                    document.getElementById("selectedSeat" + i).value = "";
                    break;
                }
            }
            --numberOfSelectedSeat;
            updateTotalPrice();
            updateSelectedSeatsText();
        }

        function updateTotalPrice() {
            totalPrice = numberOfSelectedSeat * finalPrice;
            document.getElementById("totalPriceH3").textContent = totalPrice + "đ";
            document.getElementById("totalPriceTicket").value = totalPrice;
        }
        function compareSeatByName(seat1, seat2) {
            if (seat1.seatName.length !== seat2.seatName.length) return seat1.seatName.length - seat2.seatName.length;
            for (let i = 0; i < seat1.seatName.length; ++i) {
                if (seat1.seatName[i] !== seat2.seatName[i]) return seat1.seatName[i] - seat2.seatName[i];
            }
            return 0;
        }
        function updateSelectedSeatsText() {
            let selectedSeatsDivText = "";
            let i = 0;
            selectedSeats = selectedSeats.sort((seat1, seat2) => compareSeatByName(seat1, seat2));
            for (; i < selectedSeats.length - 1; ++i) {
                selectedSeatsDivText += selectedSeats[i].seatName + ", ";
            }
            if (selectedSeats.length > 0)
                selectedSeatsDivText += selectedSeats[i].seatName;
            document.getElementById('selectedSeatsDiv').textContent = selectedSeatsDivText;
        }

        function chooseSeat(seatID, seatName) {
            if (document.getElementById("seatButton_" + seatID).style.backgroundColor === bookedSeatColor)
                return;
            if (document.getElementById("seatButton_" + seatID).style.backgroundColor === availableSeatColor)
                selectSeat(seatID, seatName);
            else if (document.getElementById("seatButton_" + seatID).style.backgroundColor === chosenSeatColor)
                unselectSeat(seatID);
        }




    </script>

    <script>

        function purchaseTickets() {
            if (numberOfSelectedSeat === 0) {
                alert("Quý khách vui lòng chọn ít nhất 1 ghế.");
                return false;
            }
            return true;
        }
        
        function toggleComboBox() {
            if (!purchaseTickets())
                return;


            let comboBox = document.getElementById("comboBox");

            if (comboBox.style.display === "none" || comboBox.style.display === "") {
                comboBox.style.display = "block";
            } else {
                comboBox.style.display = "none";
            }

        }

    </script>
</html>
