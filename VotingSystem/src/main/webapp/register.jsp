<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Online Voting System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(120deg, #2ecc71, #3498db);
        }
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #34495e;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #2ecc71;
            box-shadow: 0 0 5px rgba(46,204,113,0.3);
        }
        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #2ecc71;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .submit-btn:hover {
            background: #27ae60;
        }
        .links {
            margin-top: 20px;
            text-align: center;
        }
        .links a {
            color: #2ecc71;
            text-decoration: none;
            margin: 0 10px;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .error-message {
            background: #ff6b6b;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .password-strength {
            font-size: 12px;
            margin-top: 5px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Create Account</h2>
        
        <% 
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="error-message">
                <% if (error.equals("username_exists")) { %>
                    Username already exists!
                <% } else if (error.equals("password_mismatch")) { %>
                    Passwords do not match!
                <% } else { %>
                    Registration failed. Please try again.
                <% } %>
            </div>
        <% } %>

        <form action="register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required 
                       minlength="4" pattern="[A-Za-z0-9]+" 
                       placeholder="Choose a username (letters and numbers only)">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required 
                       minlength="4" onkeyup="checkPasswordStrength()"
                       placeholder="Choose a strong password">
                <div id="password-strength" class="password-strength"></div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       required placeholder="Confirm your password">
            </div>
            
            <button type="submit" class="submit-btn">Register</button>
        </form>
        
        <div class="links">
            <a href="login.jsp">Already have an account? Login</a>
            <a href="index.jsp">Back to Home</a>
        </div>
    </div>

    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }

        function checkPasswordStrength() {
            var password = document.getElementById("password").value;
            var strength = 0;
            var strengthDiv = document.getElementById("password-strength");
            
            if (password.match(/[a-z]+/)) strength += 1;
            if (password.match(/[A-Z]+/)) strength += 1;
            if (password.match(/[0-9]+/)) strength += 1;
            if (password.match(/[$@#&!]+/)) strength += 1;

            switch (strength) {
                case 0:
                    strengthDiv.style.color = "#ff6b6b";
                    strengthDiv.innerHTML = "Very Weak";
                    break;
                case 1:
                    strengthDiv.style.color = "#ffa502";
                    strengthDiv.innerHTML = "Weak";
                    break;
                case 2:
                    strengthDiv.style.color = "#ff7f50";
                    strengthDiv.innerHTML = "Medium";
                    break;
                case 3:
                    strengthDiv.style.color = "#2ecc71";
                    strengthDiv.innerHTML = "Strong";
                    break;
                case 4:
                    strengthDiv.style.color = "#27ae60";
                    strengthDiv.innerHTML = "Very Strong";
                    break;
            }
        }

        // Clear error messages after 5 seconds
        setTimeout(function() {
            var messages = document.querySelectorAll('.error-message');
            messages.forEach(function(message) {
                message.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>