
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*, database.*" %>
<%@page import="com.mongodb.*" %>
<%@page import="java.util.*,java.util.Date,java.text.SimpleDateFormat,java.text.DateFormat,java.lang.String,java.lang.Object" %>    


<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>E-commerce</title>
        <jsp:useBean class="product.product" id="product" scope="session"></jsp:useBean>
        <link rel="shortcut icon" href="images/logo/ico.ico"/>

        <link rel="stylesheet" type="text/css" href="css/reset.css"/>
        <link rel="stylesheet" type="text/css" href="css/text.css"/>
        <link rel="stylesheet" type="text/css" href="css/960_16.css"/>
        <link rel="stylesheet" type="text/css" href="css/styles.css"/>
        <link rel="stylesheet" type="text/css" href="css/product.css"  />

        <link rel="stylesheet" type="text/css" href="css/lightbox.css"  />

        <script src="js/jquery-1.7.2.min.js"></script>
        <script src="js/lightbox.js"></script>
 <script src="js/myScript.js"></script>
    </head>
    <body>

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
        
       

        <%
            String id = request.getParameter("id");
            if (request.getParameter("id") == null) {
                response.sendRedirect("viewProducts_.jsp");
            }else {

            DB_Conn c = new DB_Conn();
            Connection con = c.getConnection();

            Statement st = con.createStatement();


            String getProductQuery = "SELECT * FROM  `products` p INNER JOIN  `images` i USING (  `product-name` ) WHERE  `product_id` ="+id+" GROUP BY  `product-name` ";
            ResultSet rs = st.executeQuery(getProductQuery);

            rs.next();
            //out.println(""+rs.getString("product-name"));

            String product_id = rs.getString("product_id");
            
            int product_hits = rs.getInt("hits");

            String product_name = rs.getString("product-name");

            String sub_category_name = rs.getString("sub-category-name");

            String category_name = rs.getString("category-name");

            String company_name = rs.getString("company-name");


            String price = rs.getString("price");

            String summary = rs.getString("summary");

            String image_name = rs.getString("image-name");

    String database = "bestchoice";
    String username = "jaswanth";
    String pass = "4321";
    char[] password = pass.toCharArray();
    String coll = "";


        MongoClient mongoClient = new MongoClient();
        DB db = mongoClient.getDB(database);
        boolean auth = db.authenticate(username, password);

        DBCollection bc = db.getCollection("bestchoice");

        if (request.getParameter("Submit") != null && request.getParameter("Submit").equals("Drop collections")) {
            bc.drop();
        }

                   Set<String> colls = db.getCollectionNames();
            String price_m = null;
            String category_m=null;
            String title_m=null;
            String product_m=null;
            String t2=null;
            String t1=null;
            
            

            for (String s : colls) {
      
                        
            //int comparison2 = date2.compareTo(dateString);
            DBCursor cursor = bc.find();
            cursor=bc.find(new BasicDBObject("pid", id));
                           while (cursor.hasNext()) {
                    DBObject object = cursor.next();
                 price_m = object.get("Price").toString();
                category_m = object.get("Category").toString();
                title_m = object.get("Title").toString();
                product_m = object.get("Product").toString();

                 t1 = object.get("Start Date").toString();
                t2 = object.get("End Date").toString();

               
               } cursor.close();}  
            DateFormat dateInstance = SimpleDateFormat.getDateInstance();
            String d=dateInstance.format(Calendar.getInstance().getTime());
            DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
            Date j = new Date();
            SimpleDateFormat k = new SimpleDateFormat("MM-dd-YYYY");
            String formattedDate = k.format(j);
            Date d1= df.parse(formattedDate);
            
            Date date = new Date();
            Date d2=df.parse(t1);
            Date d3=df.parse(t2);

             
            %>
        <div class="container_16">
            
 <div id="leftside" class="grid_3">
                <div>
                    <ul id="leftsideNav">
                        <li><a href="viewProducts_.jsp"><strong>Show Categories</strong></a></li>
                        
                        
                    </ul>
                </div>
                
            </div>

            <div class="grid_16" id="productStrip">
                <div class="ProductHeading">
                    
                    <div class="grid_16">
                        
                        <h2 class="heading"><%= product_name%>- <%=company_name%> <%= category_name%></h2>
                    
                    </div>
                </div>
                        

                <div class="grid_10">
                     
                    <div class="grid_10">
                         <div id="productImages" >
                        <!-- Images with T are thumbs Images While with Q are The actual source Images -->

                        <img class="BigProductBox" alt="<%= product_name %>" src="<%= image_name%>" />

                        <div class="clear"></div>
                        
                        <br/>
                        <h5>Category :<a href="viewProducts_.jsp"><span class="blue"><%=category_m%></span></h5>
                        <div class="clear"></div>
                        <br/>
                        <h5>Priced At <span class="BigRed">$ <%= price_m%></span></h5>
                        <br/>
                        <br/>
                        <%
                            if (session.getAttribute("admin") != null){
                            %>
                         <a href="admin_manageProduct.jsp?pid=<%= product_id %>">
                            <div class="grid_1" id="buy">
                                Edit
                            </div>
                        </a>
                        <%
                            }
                        %>
                        
                       
<% if(d1.compareTo(d2)>=0&&d1.compareTo(d3)<=0){ %>
         	
         	<h2><span class="blue">This product is Sellable</span></h2><br/>
         	
                        <a href="addToCart.jsp?id=<%= product_id %>"> 
                            <div  class="grid_5" align="center">
                            <div class="grid_3" id="buy">
                                Buy This Product Now
                                
                            </div>
                                
                        </a>
                           
                        <%} %>
                        <%if(d1.compareTo(d2)<0||d1.compareTo(d3)>0) {
                        %> 
<h1><span class="blue">NOT SELLABLE</span></h1> <%} %>
                        <h1>Description</h1>
                        <br/>
                        <table class="grid_6" id="descripTable">
                            <tr class="grid_6">
                                <td>Name:</td>
                                <td><%= title_m%></td>
                            </tr>
                            <tr class="grid_6">
                                <td>Category:</td>
                                <td><%= category_m%></td>
                            </tr>
                            
                            <tr class="grid_6">
                                <td>Company:</td>
                                <td><%= product_m%></td>
                            </tr>
                        </table>
                    </div>
                </div>

                
                        <%
                            String getImages = "SELECT  `image-name` FROM  `products` INNER JOIN  `images` USING (  `product-name` ) WHERE  `product_id` =" + product_id + "";
                            
                            rs.close();

                            rs = st.executeQuery(getImages);
                            int img_number = 1;
                            rs.next();
                            // GET THE REST OF THE PRODUCT IMAGES
                            while (rs.next()) {

                                 image_name = rs.getString("image-name");

                        %>
 
                           
                        <a href="<%= image_name %>" rel="lightbox[product]" title="Click on the right side of the image to move forward.">
                            <img class="SmallProductBox" alt="<%= image_name %> 1 of 12 thumb" src="<%= image_name %>" />
                        </a>
                        
                        <%                            
                            }
                            st.execute("UPDATE  `products` "
+" SET  `hits` =  '"+(product_hits+1)+"' "
+" WHERE  `products`.`product_id` ="+product_id+" ");
                            st.close();
                        }
                        %>
                    </div>
                    <div class="clear"></div>
                    
                </div>

            </div>

                       
            
            
            
        </div>



                        



    </body>
</html>
