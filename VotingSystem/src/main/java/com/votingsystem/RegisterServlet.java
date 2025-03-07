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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (!validateInput(username, password, confirmPassword)) {
            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=password_mismatch");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if username already exists
            if (isUsernameExists(conn, username)) {
                response.sendRedirect("register.jsp?error=username_exists");
                return;
            }

            // Register new user
            String sql = "INSERT INTO users (username, password, is_admin, has_voted) VALUES (?, ?, false, false)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // Registration successful
                response.sendRedirect("login.jsp?success=registered");
            } else {
                response.sendRedirect("register.jsp?error=failed");
            }

        } catch (Exception e) {
            response.sendRedirect("register.jsp?error=database");
        }
    }

    private boolean validateInput(String username, String password, String confirmPassword) {
        return username != null && !username.trim().isEmpty() 
            && password != null && !password.trim().isEmpty()
            && confirmPassword != null && !confirmPassword.trim().isEmpty()
            && username.length() >= 4 && password.length() >= 6;
    }

    private boolean isUsernameExists(Connection conn, String username) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        return rs.getInt(1) > 0;
    }
}