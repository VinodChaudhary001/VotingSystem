<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Online Voting System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .description {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .button-group {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        .btn-secondary {
            background-color: #2ecc71;
            color: white;
        }
        .features {
            display: flex;
            justify-content: space-around;
            margin: 40px 0;
            flex-wrap: wrap;
            gap: 20px;
        }
        .feature {
            flex: 1;
            min-width: 200px;
            padding: 20px;
            border-radius: 5px;
            background: #f8f9fa;
        }
        .feature h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Online Voting System</h1>
        
        <div class="description">
            Welcome to our secure and efficient online voting platform. 
            Exercise your right to vote from anywhere, anytime.
        </div>

        <div class="features">
            <div class="feature">
                <h3>Secure Voting</h3>
                <p>Advanced security measures to protect your vote</p>
            </div>
            <div class="feature">
                <h3>Easy Access</h3>
                <p>Vote with just a few clicks</p>
            </div>
            <div class="feature">
                <h3>Real-time Results</h3>
                <p>Instant vote counting and result updates</p>
            </div>
        </div>

        <%
            // Check if user is already logged in
            if(session != null && session.getAttribute("username") != null) {
                Boolean isAdmin = (Boolean)session.getAttribute("isAdmin");
                if(isAdmin != null && isAdmin) {
        %>
                <div class="button-group">
                    <a href="admin.jsp" class="btn btn-primary">Go to Admin Dashboard</a>
                    <a href="logout" class="btn btn-secondary">Logout</a>
                </div>
        <%
                } else {
        %>
                <div class="button-group">
                    <a href="vote.jsp" class="btn btn-primary">Cast Your Vote</a>
                    <a href="logout" class="btn btn-secondary">Logout</a>
                </div>
        <%
                }
            } else {
        %>
                <div class="button-group">
                    <a href="login.jsp" class="btn btn-primary">Login</a>
                    <a href="register.jsp" class="btn btn-secondary">Register</a>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>