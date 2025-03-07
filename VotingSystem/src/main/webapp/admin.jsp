<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.votingsystem.DatabaseConnection"%>

<%
    if (session.getAttribute("isAdmin") == null || !(Boolean)session.getAttribute("isAdmin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Voting System</title>
    <style>
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            border-bottom: 3px solid #eee;
            padding-bottom: 20px;
        }
        .header h1 {
            color: #2c3e50;
            font-size: 2.5em;
            margin: 0;
        }
        .section {
            background: #ffffff;
            margin: 30px 0;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .section h2 {
            color: #2c3e50;
            margin-top: 0;
            font-size: 1.8em;
        }
        .form-group {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
        }
        .form-group input[type="text"] {
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            flex: 1;
            transition: border-color 0.3s;
        }
        .form-group input[type="text"]:focus {
            border-color: #667eea;
            outline: none;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .btn-primary { 
            background: #667eea;
            color: white;
        }
        .btn-danger { 
            background: #e53e3e;
            color: white;
        }
        .btn-success { 
            background: #48bb78;
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 25px;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        th, td {
            padding: 18px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #667eea;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1px;
        }
        tr:hover {
            background: #f8fafc;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 25px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin: 15px 0;
        }
        .party-symbol {
            width: 40px;
            height: 40px;
            padding: 5px;
            border-radius: 50%;
            background: #f7fafc;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>

        <div class="section">
            <h2>Add New Party</h2>
            <form action="admin" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <input type="text" name="name" required placeholder="Enter party name">
                    <input type="text" name="symbol" required placeholder="Enter party symbol">
                    <button type="submit" class="btn btn-primary">Add Party</button>
                </div>
            </form>
        </div>

        <div class="section">
            <h2>Manage Parties</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Party Name</th>
                        <th>Symbol</th>
                        <th>Votes</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DatabaseConnection.getConnection()) {
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM parties ORDER BY id ASC");
                            while(rs.next()) {
                    %>
                    <tr>
                        <td><%=rs.getInt("id")%></td>
                        <td>
                            <form id="updateForm<%=rs.getInt("id")%>" style="display: none;">
                                <input type="text" value="<%=rs.getString("name")%>" 
                                       id="updateName<%=rs.getInt("id")%>">
                                <input type="text" value="<%=rs.getString("symbol")%>" 
                                       id="updateSymbol<%=rs.getInt("id")%>">
                                <button type="button" class="btn btn-success"
                                        onclick="updateParty(<%=rs.getInt("id")%>)">Save</button>
                            </form>
                            <span id="partyName<%=rs.getInt("id")%>"><%=rs.getString("name")%></span>
                        </td>
                        <td>
                            <span id="partySymbol<%=rs.getInt("id")%>"><%=rs.getString("symbol")%></span>
                        </td>
                        <td><%=rs.getInt("votes")%></td>
                        <td>
                            <button class="btn btn-primary" 
                                    onclick="toggleEdit(<%=rs.getInt("id")%>)">Edit</button>
                            <button class="btn btn-danger" 
                                    onclick="deleteParty(<%=rs.getInt("id")%>)">Delete</button>
                        </td>
                    </tr>
                    <%
                            }
                        } catch(Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="section">
            <h2>Voting Statistics</h2>
            <div class="stats-grid">
                <%
                    try (Connection conn = DatabaseConnection.getConnection()) {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(
                            "SELECT COUNT(*) as total_users, " +
                            "SUM(CASE WHEN has_voted = true THEN 1 ELSE 0 END) as voted_users " +
                            "FROM users WHERE is_admin = false"
                        );
                        if(rs.next()) {
                %>
                    <div class="stat-card">
                        <h3>Total Voters</h3>
                        <div class="stat-number"><%=rs.getInt("total_users")%></div>
                    </div>
                    <div class="stat-card">
                        <h3>Votes Cast</h3>
                        <div class="stat-number"><%=rs.getInt("voted_users")%></div>
                    </div>
                    <div class="stat-card">
                        <h3>Participation Rate</h3>
                        <div class="stat-number">
                            <%=String.format("%.1f", (rs.getDouble("voted_users")/rs.getDouble("total_users"))*100)%>%
                        </div>
                    </div>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<div>Error loading statistics</div>");
                    }
                %>
            </div>
        </div>
    </div>

    <script>
        function toggleEdit(id) {
            const nameSpan = document.getElementById('partyName' + id);
            const symbolSpan = document.getElementById('partySymbol' + id);
            const updateForm = document.getElementById('updateForm' + id);
            
            if (nameSpan.style.display !== 'none') {
                nameSpan.style.display = 'none';
                symbolSpan.style.display = 'none';
                updateForm.style.display = 'block';
            } else {
                nameSpan.style.display = 'block';
                symbolSpan.style.display = 'block';
                updateForm.style.display = 'none';
            }
        }

        function updateParty(id) {
            const newName = document.getElementById('updateName' + id).value;
            const newSymbol = document.getElementById('updateSymbol' + id).value;
            
            if(confirm('Update party details?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'admin';
                
                const inputs = {
                    'action': 'update',
                    'id': id,
                    'name': newName,
                    'symbol': newSymbol
                };

                for(let key in inputs) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = inputs[key];
                    form.appendChild(input);
                }

                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteParty(id) {
            if(confirm('Are you sure you want to delete this party?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'admin';
                
                const inputs = {
                    'action': 'delete',
                    'id': id
                };

                for(let key in inputs) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = inputs[key];
                    form.appendChild(input);
                }

                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
