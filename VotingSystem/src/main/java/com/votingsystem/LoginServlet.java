package com.votingsystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Create session and set attributes
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("isAdmin", rs.getBoolean("is_admin"));
                session.setAttribute("hasVoted", rs.getBoolean("has_voted"));
                session.setMaxInactiveInterval(30 * 60); // 30 minutes session timeout

                // Redirect based on user role
                if (rs.getBoolean("is_admin")) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("vote.jsp");
                }
            } else {
                // Invalid credentials
                response.sendRedirect("login.jsp?error=invalid");
            }
        } catch (Exception e) {
            // Database error
            response.sendRedirect("login.jsp?error=database");
        }
    }

    private boolean validateInput(String username, String password) {
        return username != null && !username.trim().isEmpty() 
            && password != null && !password.trim().isEmpty();
    }
}