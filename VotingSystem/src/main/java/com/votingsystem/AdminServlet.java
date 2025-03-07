package com.votingsystem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            switch (action) {
                case "add":
                    addParty(conn, request.getParameter("name"), request.getParameter("symbol"));
                    resetIds(conn);
                    break;
                case "update":
                    updateParty(conn, 
                              Integer.parseInt(request.getParameter("id")),
                              request.getParameter("name"),
                              request.getParameter("symbol"));
                    break;
                case "delete":
                    deleteParty(conn, Integer.parseInt(request.getParameter("id")));
                    resetIds(conn);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("admin.jsp");
    }
    
    private void addParty(Connection conn, String name, String symbol) throws Exception {
        String sql = "INSERT INTO parties (name, symbol, votes) VALUES (?, ?, 0)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, symbol);
        pstmt.executeUpdate();
    }
    
    private void updateParty(Connection conn, int id, String name, String symbol) throws Exception {
        String sql = "UPDATE parties SET name = ?, symbol = ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, symbol);
        pstmt.setInt(3, id);
        pstmt.executeUpdate();
    }
    
    private void deleteParty(Connection conn, int id) throws Exception {
        String sql = "DELETE FROM parties WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();
    }

    private void resetIds(Connection conn) throws Exception {
        Statement stmt = conn.createStatement();
        stmt.execute("ALTER TABLE parties DROP id");
        stmt.execute("ALTER TABLE parties ADD id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST");
    }
}