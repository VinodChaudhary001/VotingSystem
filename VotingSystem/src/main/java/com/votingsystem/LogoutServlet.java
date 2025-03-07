package com.votingsystem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);
        
        // Check if user was admin
        boolean wasAdmin = false;
        if (session != null) {
            wasAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        }
        
        // Invalidate session and remove all attributes
        if (session != null) {
            session.removeAttribute("username");
            session.removeAttribute("isAdmin");
            session.removeAttribute("userId");
            session.invalidate();
        }
        
        // Redirect based on user type
        if (wasAdmin) {
            response.sendRedirect("admin.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}