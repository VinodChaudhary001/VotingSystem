<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.votingsystem.DatabaseConnection"%>

<%
    // Session validation
    if(session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cast Your Vote - Online Voting System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .voting-section {
            margin: 20px 0;
        }
        .party-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .party-card {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            transition: transform 0.2s;
        }
        .party-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .vote-btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }
        .vote-btn:hover {
            background: #2980b9;
        }
        .vote-btn:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
            text-align: center;
        }
        .success {
            background: #2ecc71;
            color: white;
        }
        .error {
            background: #e74c3c;
            color: white;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .logout-btn {
            background: #e74c3c;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s;
        }
        .logout-btn:hover {
            background: #c0392b;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Cast Your Vote</h1>
            <a href="logout" class="logout-btn">Logout</a>
        </div>

        <%
            String username = (String)session.getAttribute("username");
            boolean hasVoted = false;
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Check if user has already voted
                PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT has_voted FROM users WHERE username = ?"
                );
                checkStmt.setString(1, username);
                ResultSet checkRs = checkStmt.executeQuery();
                
                if (checkRs.next()) {
                    hasVoted = checkRs.getBoolean("has_voted");
                }

                if (hasVoted) {
        %>
                    <div class="message success">
                        You have already cast your vote. Thank you for participating!
                    </div>
        <%
                } else {
        %>
                    <div class="voting-section">
                        <form action="vote" method="post" id="voteForm">
                            <div class="party-list">
                            <%
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM parties ORDER BY name");
                                while(rs.next()) {
                            %>
                                <div class="party-card">
                                    <h3><%=rs.getString("name")%></h3>
                                    <input type="radio" name="partyId" 
                                           value="<%=rs.getInt("id")%>" required>
                                    <p>Select to vote</p>
                                </div>
                            <%
                                }
                            %>
                            </div>
                            <div style="text-align: center; margin-top: 30px;">
                                <button type="submit" class="vote-btn" 
                                        onclick="return confirmVote()">
                                    Submit Vote
                                </button>
                            </div>
                        </form>
                    </div>
        <%
                }
            } catch(Exception e) {
        %>
                <div class="message error">
                    An error occurred: <%=e.getMessage()%>
                </div>
        <%
            }
        %>
    </div>

    <script>
        function confirmVote() {
            return confirm("Are you sure you want to cast your vote? This action cannot be undone.");
        }

        // Auto-hide messages after 5 seconds
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(message) {
                message.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>