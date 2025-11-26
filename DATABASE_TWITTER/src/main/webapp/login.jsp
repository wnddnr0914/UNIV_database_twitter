<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%@ page import="BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 0. 이미 로그인된 상태라면 메인으로 튕겨내기 (세션 확인)
    String currentId = (String) session.getAttribute("idKey");
    if (currentId != null) {
        response.sendRedirect("main.jsp");
        return;
    }

    String errorMsg = "";
    
    // 1. POST 요청 처리 (로그인 버튼 클릭 시)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");
        
        if (userId != null && userPw != null) {
            UserDAO dao = new UserDAO();
            
            // ⭐ DB 연동: 실제 MySQL에서 아이디/비번 확인
            user member = dao.loginCheck(userId, userPw); 
            
            if (member != null) {
                // ---------------------------------------------------------
                // ⭐ [핵심] 세션 생성 (가장 중요한 부분)
                // 이제 'elon_musk' 같은 가짜 데이터 대신, 로그인한 진짜 ID가 저장됩니다.
                // ---------------------------------------------------------
                session.setAttribute("idKey", member.getIdUSER());
                session.setAttribute("nameKey", member.getNAME()); // 이름도 저장해두면 편함
                
                // 세션 유지 시간 설정 (예: 60분)
                session.setMaxInactiveInterval(60 * 60); 
                
                // 로그인 성공 시 홈(타임라인)으로 이동
                response.sendRedirect("main.jsp");
                return; 
            } else {
                // 로그인 실패
                errorMsg = "아이디 또는 비밀번호가 일치하지 않습니다.";
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>X 가입하기 및 로그인</title>
<style>
/* CSS 변수 (globals.css 스타일 유지) */
:root {
    --background: #ffffff;
    --foreground: oklch(0.145 0 0);
    --primary: #030213;
    --primary-foreground: oklch(1 0 0);
    --border: rgba(0, 0, 0, 0.1);
    --radius: 0.625rem;
    --input: #f3f3f5;
    --muted-foreground: #717182;
}

body {
    background-color: var(--background);
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}
.card {
    background: white;
    border-radius: var(--radius);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 400px;
}
.card-header { text-align: center; padding: 24px; border-bottom: 1px solid var(--border); }
.card-title { font-size: 1.5rem; font-weight: bold; }
.logo-icon { font-size: 2rem; color: #1d9bf0; margin-bottom: 1rem; }

.tabs-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    background-color: var(--border);
    border-radius: 9999px;
    padding: 4px;
    margin-bottom: 16px;
}
.tabs-trigger {
    padding: 8px 12px;
    font-weight: 500;
    border-radius: 9999px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    color: var(--foreground);
    transition: background-color 0.2s;
}
.tabs-trigger.active { background-color: var(--background); box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1); }

.form-group { margin-bottom: 16px; }
.input-field {
    width: 100%; padding: 10px;
    background-color: var(--input);
    border: 1px solid var(--border);
    border-radius: 6px;
    box-sizing: border-box;
    margin-top: 4px;
}
.button-submit {
    width: 100%; padding: 12px; margin-top: 15px;
    background-color: var(--primary);
    color: var(--primary-foreground);
    border: none;
    border-radius: 30px;
    font-size: 1rem;
    cursor: pointer;
    transition: opacity 0.2s;
    font-weight: bold;
}
.button-submit:hover { opacity: 0.9; }
.error-msg { color: #d4183d; font-size: 0.875rem; margin-top: 8px; text-align: center; font-weight: bold; }
</style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="logo-icon">🐦</div>
            <div class="card-title">소셜 미디어에 오신 것을 환영합니다</div>
            <p style="color:var(--muted-foreground); font-size:0.9rem; margin-top:5px;">로그인하거나 새 계정을 만드세요</p>
        </div>
        
        <div style="padding: 24px;">
            <div class="tabs-list">
                <div class="tabs-trigger active">로그인</div>
                <a href="signup.jsp" class="tabs-trigger">회원가입</a>
            </div>

            <form method="POST" action="login.jsp">
                
                <div class="form-group">
                    <label for="login-email">아이디</label>
                    <input id="login-email" type="text" name="userId" placeholder="아이디" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="login-password">비밀번호</label>
                    <input id="login-password" type="password" name="userPw" placeholder="••••••••" required class="input-field">
                </div>
                
                <button type="submit" class="button-submit">로그인</button>
            </form>
            
            <% if (!errorMsg.isEmpty()) { %>
                <p class="error-msg">⚠️ <%= errorMsg %></p>
            <% } %>

            <div style="margin-top: 16px; text-align: center; font-size: 0.875rem;">
                <a href="#" style="color: #1d9bf0; text-decoration: none;">비밀번호를 잊으셨나요?</a>
            </div>
        </div>
    </div>
</body>
</html>
