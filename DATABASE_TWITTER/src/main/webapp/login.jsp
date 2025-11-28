<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%@ page import="BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");

    String currentId = (String) session.getAttribute("idKey");
    if (currentId != null) {
        response.sendRedirect("main.jsp");
        return;
    }

    String errorMsg = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");
        
        if (userId != null && userPw != null) {
            UserDAO dao = new UserDAO();
            user member = dao.loginCheck(userId, userPw); 
            
            if (member != null) {
                session.setAttribute("idKey", member.getIdUSER());
                session.setAttribute("nameKey", member.getNAME());
                session.setMaxInactiveInterval(60 * 60); 
                response.sendRedirect("main.jsp");
                return; 
            } else {
                errorMsg = "아이디 또는 비밀번호가 일치하지 않습니다.";
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>X 로그인</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
:root {
    --primary: #1da1f2;
    --primary-dark: #0d8bd9;
    --text: #14171a;
    --text-secondary: #657786;
    --background: #ffffff;
    --border: #e1e8ed;
    --error: #e0245e;
    --success: #17bf63;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

.login-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    width: 100%;
    max-width: 450px;
    overflow: hidden;
    animation: slideIn 0.5s ease-out;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.login-header {
    text-align: center;
    padding: 40px 30px 30px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.logo-icon {
    font-size: 48px;
    margin-bottom: 15px;
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

.login-header h1 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 8px;
}

.login-header p {
    font-size: 15px;
    opacity: 0.9;
}

.login-body {
    padding: 35px 30px;
}

.tabs {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
    margin-bottom: 30px;
    background: #f7f9fa;
    padding: 5px;
    border-radius: 12px;
}

.tab {
    padding: 12px;
    text-align: center;
    font-weight: 600;
    font-size: 15px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    color: var(--text-secondary);
    text-decoration: none;
}

.tab.active {
    background: white;
    color: var(--text);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.tab:not(.active):hover {
    color: var(--text);
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    font-size: 14px;
    color: var(--text);
}

.input-field {
    width: 100%;
    padding: 14px 18px;
    background: #f7f9fa;
    border: 2px solid #e1e8ed;
    border-radius: 12px;
    font-size: 15px;
    transition: all 0.3s ease;
    color: var(--text);
}

.input-field:focus {
    outline: none;
    background: white;
    border-color: var(--primary);
    box-shadow: 0 0 0 4px rgba(29, 161, 242, 0.1);
}

.input-field::placeholder {
    color: #a0aec0;
}

.button-submit {
    width: 100%;
    padding: 14px;
    margin-top: 10px;
    background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(29, 161, 242, 0.4);
}

.button-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(29, 161, 242, 0.5);
}

.button-submit:active {
    transform: translateY(0);
}

.error-msg {
    color: var(--error);
    font-size: 14px;
    margin-top: 15px;
    text-align: center;
    font-weight: 600;
    padding: 12px;
    background: rgba(224, 36, 94, 0.1);
    border-radius: 10px;
    animation: shake 0.5s;
}

@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-10px); }
    75% { transform: translateX(10px); }
}

.divider {
    display: flex;
    align-items: center;
    margin: 25px 0;
    color: var(--text-secondary);
    font-size: 14px;
}

.divider::before,
.divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border);
}

.divider span {
    padding: 0 15px;
}

.info-box {
    text-align: center;
    padding: 20px;
    background: #f7f9fa;
    border-radius: 12px;
    margin-top: 20px;
}

.info-box p {
    font-size: 13px;
    color: var(--text-secondary);
    line-height: 1.6;
}

/* 반응형 디자인 */
@media (max-width: 480px) {
    .login-container {
        border-radius: 15px;
    }
    
    .login-header {
        padding: 30px 20px 20px;
    }
    
    .login-header h1 {
        font-size: 24px;
    }
    
    .login-body {
        padding: 25px 20px;
    }
}
</style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="logo-icon">🐦</div>
            <h1>환영합니다</h1>
            <p>소셜 미디어에 로그인하세요</p>
        </div>
        
        <div class="login-body">
            <div class="tabs">
                <div class="tab active">로그인</div>
                <a href="signup.jsp" class="tab">회원가입</a>
            </div>

            <form method="POST" action="login.jsp">
                <div class="form-group">
                    <label for="login-email">아이디</label>
                    <input id="login-email" type="text" name="userId" placeholder="아이디를 입력하세요" required class="input-field" autofocus>
                </div>
                
                <div class="form-group">
                    <label for="login-password">비밀번호</label>
                    <input id="login-password" type="password" name="userPw" placeholder="비밀번호를 입력하세요" required class="input-field">
                </div>
                
                <button type="submit" class="button-submit">로그인</button>
            </form>
            
            <% if (!errorMsg.isEmpty()) { %>
                <p class="error-msg">⚠️ <%= errorMsg %></p>
            <% } %>
            
            <div class="divider">
                <span>또는</span>
            </div>
            
            <div class="info-box">
                <p>아직 계정이 없으신가요?<br>
                <strong>회원가입</strong> 탭에서 새로운 계정을 만들어보세요! 🚀</p>
            </div>
        </div>
    </div>
</body>
</html>
