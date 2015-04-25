

<%@page import="java.util.ArrayList"%>
<%@page import="user.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>E-commerce - Cart</title>
        <!-- Default Stylesheets -->
        <link rel="shortcut icon" href="images/logo/ico.ico"/>

        <link rel="stylesheet" type="text/css" href="css/reset.css"/>
        <link rel="stylesheet" type="text/css" href="css/text.css"/>
        <link rel="stylesheet" type="text/css" href="css/960_16.css"/>
        <link rel="stylesheet" type="text/css" href="css/styles.css"/>
        <link rel="stylesheet" type="text/css" href="css/product.css"  />

        <script type="text/javascript" src="js/jquery.js"></script>

    <script type="text/javascript" src="js/myScript.js"></script>

    </head>
    <body>
        <jsp:useBean id="cart" scope="session" class="cart.cart"/>

        <%
        if (session.getAttribute("user") == null ){// THen new user, show join now
            %>
            <jsp:include page="includesPage/_joinNow.jsp"></jsp:include>
        <%
        }else {
            %>
            <jsp:include page="includesPage/_logout.jsp"></jsp:include>
        <%
        }
        %>

    <%@include file="includesPage/_search_navigationbar.jsp" %>


    <div class="container_16">
        <div class="grid_16" id="whiteBox">
            <div class="grid_8 push_4" >
                <h1 class="push_2" style="padding:10px 00px">Products In your Cart</h1>
                <h3 class="push_2" >Your Cart contains following...</h3>
                
                         

        
        <div id="CartTable" style="padding:10px 00px" class="grid_11">
                    <div class="grid_5">
                        <h2>Name Of Product</h2> 
                    </div>
                    <div class="grid_2">
                        <h2>Price</h2>
                    </div>
                    <div class="grid_2">
                         <h2>Quantity</h2>
                    </div>
            
                   
                    <div class="grid_5">
                        <strong>Total Price of your Cart</strong>
                    </div>
            
                    
                    <div class="clear"></div>
                    
                    <br/>
                    <br/>
                    <a href="viewProducts_.jsp">
                    <div class="grid_3" id="greenBtn">
                        Buy These Items
                    </div>
                    </a>
                    <a href="index.jsp">
                        <div class="grid_3" id="greenBtn">
                        Continue Shopping
                    </div>
                    </a>
                </div>
                
            </div>
            
        </div>
    </div>
    </body>
</html>