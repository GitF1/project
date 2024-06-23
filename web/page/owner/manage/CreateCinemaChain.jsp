<%@page import="model.CinemaChain"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Cinema Chain</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        .container {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
        }

        h1 {
            background-color: #4e2c72;
            color: white;
            padding: 10px;
            margin: -20px -20px 20px;
            text-align: center;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        .form-group label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-group input[type="file"] {
            padding: 5px;
        }

        .btn-primary {
            background-color: #4e2c72;
            border-color: #4e2c72;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
            text-align: center;
            font-size: 16px;
            margin-top: 20px;
        }

        .btn-primary:hover {
            background-color: #3a1d54;
        }

        .btn-cancel {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
            text-align: center;
            font-size: 16px;
            margin-top: 20px;
            margin-left: 10px;
        }

        .btn-cancel:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Create Cinema Chain</h1>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:choose>
            <c:when test="${cinemaChain == null}">
                <form action="${pageContext.request.contextPath}/owner/createCinemaChain" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Name:</label>
                        <input type="text" class="form-control" name="name" id="name" required>
                    </div>
                    <div class="form-group">
                        <label for="information">Information:</label>
                        <textarea class="form-control" name="information" id="information" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="avatar">Avatar:</label>
                        <input type="file" class="form-control-file" name="avatar" id="avatar" accept="image/*" required>
                    </div>
                    <div class="form-group">
                        <label for="banner">Banner:</label>
                        <input type="file" class="form-control-file" name="banner" id="banner" accept="image/*" required>
                    </div>
                    <div class="form-row">
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-primary btn-block">Create</button>
                        </div>
                        <div class="col-md-6">
                            <a href="javascript:history.go(-1);" class="btn btn-cancel btn-block">Cancel</a>
                        </div>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">You already have a Cinema Chain. You cannot create another one.</div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
