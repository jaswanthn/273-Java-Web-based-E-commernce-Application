
<%@page import="java.util.ArrayList"%>
<%@page import="com.mongodb.*" %>
<%@page import="java.util.*,java.util.Date,java.text.SimpleDateFormat,java.text.DateFormat,java.lang.String,java.lang.Object" %>    


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>E-commerce</title>
        <jsp:useBean class="product.product" id="product" scope="session"></jsp:useBean>

        <%@page import="java.sql.*, database.*" %>
        <link rel="shortcut icon" href="images/logo/ico.ico"/>
        <link rel="stylesheet" type="text/css" href="css/reset.css"/>
        <link rel="stylesheet" type="text/css" href="css/text.css"/>
        <link rel="stylesheet" type="text/css" href="css/960_16.css"/>
        <link rel="stylesheet" type="text/css" href="css/product.css"  />

        <link rel="stylesheet" type="text/css" href="css/lightbox.css"  />

        <link rel="stylesheet" type="text/css" href="css/styles.css"/>

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

       
      
        <div class="container_16">
            <div id = "contents">
                <!-- LeftSide -->
                <%
                    
                %>
                
                <div id="leftside" class="grid_3">
                    
                    <%
                        String category, subcategory;
                        StringBuffer sql = new StringBuffer();
                        sql.append("SELECT * FROM  `products` p "
                                        + "INNER JOIN  `images` i "
                                        + "USING (  `product-name` ) ");
                        
                        category = "";
                        subcategory = "";
                        if(session.getAttribute("cat") != null ){
                            category = (String) session.getAttribute("cat");
                            ArrayList subCat = product.getSubcategory(category);
                                
                            %>
                           
                       
                             <%
                            if (session.getAttribute("scat") != null){
                                subcategory = (String) session.getAttribute("scat");
                                
                            }
                        } else {
                            //Show Category
                            ArrayList Cat = product.getCategory();
                            %>
                            <div>
                                <ul id="leftsideNav">
                                    <li><a href="#"><strong>Categories</strong></a></li>
                            <%
                            for (int i =0; i< Cat.size(); i++){
                                %>
                                <li><a href="addProductFilters.jsp?cat=<%= Cat.get(i) %>"><%= Cat.get(i) %></a></li>      
                                <%
                            } Cat.clear();
                            %>
                                </ul>
                            </div>
                            <%
                        }
                    %>
                 
                    
                </div>
            </div>

            <!-- Middle -->
            <div id="middle"class="grid_13">
                <div class="grid_13" id="whiteBox">
                    <div class="ProductHeading">
                        <div class="grid_12">
                                <h2 class="heading">Products >
                                    <%= category %> 
                                    <%= subcategory %>
                                </h2>
                        </div>
                        
                    </div>
                    <div class="grid_12 productListing">
                        
                        <div class="clear"></div>
                        <%
                            if (session.getAttribute("cat") != null){
                                category = (String)session.getAttribute("cat");
                                /*
WHERE  `category-name` =  'Games'
AND  `sub-category-name` =  'Action-Adventure-Game'
GROUP BY  `product-name` */
                                
                                sql.append(" WHERE  `category-name` =  '"+category+"' ");
                                %>
                                    <div class="grid_4 ">
                                        <a id="greenBtn" href="removeProductFilter.jsp?cat=<%= category %>">Category : <%= category %> [x]</a>
                                    </div>
                                <%
                                
                                %>

                                    <%
                                        if (session.getAttribute("scat") != null){
                                            subcategory = (String)session.getAttribute("scat");
                                            sql.append(" AND  `sub-category-name` =  '"+subcategory+"' ");
                                            %>
                                                <div class="grid_4 ">
                                                    <a id="greenBtn" href="removeProductFilter.jsp?scat=<%= subcategory %>">Sub-Category : <%= subcategory %> [x]</a>
                                                </div>
                                            <%
                                        }
                                    %>
                                <%
                            }
                        %>
                        
                        <%
                            //String sql = "SELECT * FROM  `products` p "
                             //           + "INNER JOIN  `images` i "
                             //           + "USING (  `product-name` ) 
                             //             +`product_qty` > 0
                              //          + "GROUP BY  `product-name` ";

                        DB_Conn con = new DB_Conn();
                        Connection c = con.getConnection();
                        Statement st = c.createStatement();
                        ResultSet rs ;
                         if (sql.toString().equalsIgnoreCase("SELECT * FROM  `products` p "
                                                            + "INNER JOIN  `images` i "
                                                            + "USING (  `product-name` ) "
                                                            )){
                            
                            String newSQL  = "SELECT * FROM  `products` p "
                                            + "INNER JOIN  `images` i "
                                           + "USING (  `product-name` ) "
                                            + " WHERE `product_qty` > 0 "
                                          +" GROUP BY  `product-name` "
                                         + " ORDER BY  `hits` DESC  ";
                            //out.print("Equals "+sql.toString() +" "+newSQL);
                         rs= st.executeQuery(newSQL);
                         }else { 
                            
                        sql.append(" AND `product_qty` > 0  "
                                + " GROUP BY  `product-name` "
                                + " ORDER BY  `hits` DESC  ");
                            //out.print("Not Equals "+sql.toString());
                            rs= st.executeQuery(sql.toString());                        
                         }
                        

                                while (rs.next()) {
                                    /*
product-name	product_id	sub-category-name	category-name	company-name	price	summary	image-id	image-name*/
                                    String product_id = rs.getString("product_id");

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
                                            cursor=bc.find(new BasicDBObject("pid", product_id));
                                                           while (cursor.hasNext()) {
                                                    DBObject object = cursor.next();
                                                 price_m = object.get("Price").toString();
                                                category_m = object.get("Category").toString();
                                                title_m = object.get("Title").toString();
                                                product_m = object.get("Product").toString();

                                                 t1 = object.get("Start Date").toString();
                                                t2 = object.get("End Date").toString();

                                               
                                               } cursor.close();}   
                                   
                        %>
                        <div class="clear"></div>
                        <div class="grid_2">
                            <a href="product.jsp?id=<%=product_id%>"><img src="<%= image_name %>" /></a>
                        </div>
                        <div class="grid_9">
                            <div class="grid_5">
                                <p id="info"><a href="product.jsp?id=<%=product_id%>"><h3><span class="blue"> <%=product_name %></span></h3></a>By <%= product_m+" " %><br/><span class="red">$ <%= price_m %></span></p>
                            </div>
                            <div class="grid_3 push_2">
                                <p><%=sub_category_name %>  <a href="product.jsp?id=<%= product_id %>" id="greenBtn">Click for details</a></p><p>Will Be delivered in 3 Working days</p>
                            </div>
                        </div>
                        <div class="clear"></div>
                        <%
                                }
                            rs.close();
                            st.close();
                            c.close();
                        %>

                    </div>
                </div>


            </div>
            <!--The Middle Content Div Closing -->
        </div>
        <!--The Center Content Div Closing -->

    </body>
</html>
