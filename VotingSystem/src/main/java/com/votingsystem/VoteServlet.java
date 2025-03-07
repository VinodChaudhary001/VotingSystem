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

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if user has already voted
        try (Connection conn = DatabaseConnection.getConnection()) {
            String username = (String) session.getAttribute("username");
            boolean hasVoted = checkIfVoted(conn, username);
            
            if (hasVoted) {
                request.setAttribute("message", "You have already cast your vote!");
                request.getRequestDispatcher("vote.jsp").forward(request, response);
            } else {
                // Load available parties
                loadParties(request, conn);
                request.getRequestDispatcher("vote.jsp").forward(request, response);
            }
        } catch (Exception e) {
            response.sendRedirect("vote.jsp?error=database");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String partyId = request.getParameter("partyId");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Verify user hasn't voted yet
            if (checkIfVoted(conn, username)) {
                response.sendRedirect("vote.jsp?error=already_voted");
                return;
            }

            // Start transaction
            conn.setAutoCommit(false);
            try {
                // Update party votes
                String updatePartySql = "UPDATE parties SET votes = votes + 1 WHERE id = ?";
                PreparedStatement pstmt1 = conn.prepareStatement(updatePartySql);
                pstmt1.setString(1, partyId);
                pstmt1.executeUpdate();

                // Mark user as voted
                String updateUserSql = "UPDATE users SET has_voted = true WHERE username = ?";
                PreparedStatement pstmt2 = conn.prepareStatement(updateUserSql);
                pstmt2.setString(1, username);
                pstmt2.executeUpdate();

                // Commit transaction
                conn.commit();
                
                // Update session
                session.setAttribute("hasVoted", true);
                
                response.sendRedirect("vote.jsp?success=true");
            } catch (Exception e) {
                // Rollback in case of error
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            response.sendRedirect("vote.jsp?error=failed");
        }
    }

    private boolean checkIfVoted(Connection conn, String username) throws Exception {
        String sql = "SELECT has_voted FROM users WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();
        return rs.next() && rs.getBoolean("has_voted");
    }

    private void loadParties(HttpServletRequest request, Connection conn) throws Exception {
        String sql = "SELECT id, name FROM parties ORDER BY name";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        request.setAttribute("parties", rs);
    }
}