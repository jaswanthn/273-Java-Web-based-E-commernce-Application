/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package loginRegister;

import user.user;
import database.DB_Conn;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import helpers.*;

import java.sql.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author jaswanth
 */
public class registerServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /*
             * TODO output your page here. You may use following sample code.
             */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet registerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet registerServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);

        String message, messageDetail;
        message = null;
        messageDetail = null;
        String email, pass, passAgain;
        boolean isRegistered = false;

        String messageUrl = "/message.jsp";
        RequestDispatcher dispatchMessage =
                request.getServletContext().getRequestDispatcher(messageUrl);

        email = request.getParameter("emailReg");
        pass = request.getParameter("passReg");
        passAgain = request.getParameter("passAgainReg");
        EmailValidator validator = new EmailValidator();
        boolean isEmailValid = validator.validate(email);

        String ipAdd = request.getRemoteAddr();

        PrintWriter out = response.getWriter();

        HttpSession userSession = request.getSession();

        try {
            DB_Conn con = new DB_Conn();
            Connection c = con.getConnection();
            if ((request.getParameter("emailReg") != null) || (request.getParameter("emailReg") != null)){
                if (isEmailValid) {
                    if (pass.length() > 7) {
                        if (pass.equals(passAgain)) {
                            // then the user is registered and a session is 

                            String sql = "INSERT INTO  `bestchoice`.`user` "
                                    + "(`user_id` ,`email` ,`pass` ,`registeredOn`) "
                                    + "VALUES (NULL ,  ?, SHA1(  ? ) , NOW( )); ";

                            PreparedStatement psmt = c.prepareStatement(sql);

                            psmt.setString(1, email);

                            psmt.setString(2, pass);

                            int i = psmt.executeUpdate();

                            if (i == 1) {
                                isRegistered = true;
                                out.println("You are registered ");
                                user User = new user();
                                User.setUserEmail(email);
                                userSession.setAttribute("user", User);
                                response.sendRedirect(request.getContextPath());
                            } else {
                                isRegistered = false;
                                out.println("You are not registered");
                            }

                        } //Else both passwords do not match
                        else {
                            isRegistered = false;
                            message = "Passwords do not match";
                            messageDetail = "Please provide a matching passwords";
                            out.print(" nOT Success!  both passwords do not match!");

                        }
                    } //or the paasword length is less than 7
                    else {
                        isRegistered = false;
                        message = "Password length is less than 7 characters";
                        messageDetail = "Please provide a passwords that has password length of minimum of seven alphanumeric characters";
                        out.print(" nOT Success!! the paasword length is less than 7");
                    }
                } //or email is wrong
                else {
                    isRegistered = false;
                    message = "No email address typed";
                    messageDetail = "Please provide a valid email address";
                    out.print(" nOT Success!! email is wrong");
                }
            }
            else {
                isRegistered = false;
                message = "Please enter values";
                messageDetail = "Please provide an email address. Your account currently is not registered";
            }
            
            if (isRegistered == false) {
                request.setAttribute("message", message);
                request.setAttribute("messageDetail", messageDetail);
                dispatchMessage.forward(request, response);
            }

            //try ends here
        } catch (SQLIntegrityConstraintViolationException ex) {
            // user exsts but wrong passwotd ask to CHANGE THE PASSWORD
            messageDetail = ex.getMessage();
            message = "You have been registered earlier please try your right password again, else change your password...";
            out.print(" nOT Success!!" + ex);
            request.setAttribute("message", message);
            request.setAttribute("messageDetail", messageDetail);
            dispatchMessage.forward(request, response);
        } catch (Exception ex) {
            messageDetail = ex.getMessage();
            message = "There was a problem in registering your account please do retry again later...";
            out.print(" nOT Success!!" + ex);
            request.setAttribute("message", message);
            request.setAttribute("messageDetail", messageDetail);
            dispatchMessage.forward(request, response);
            response.sendError(404);
        }
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
