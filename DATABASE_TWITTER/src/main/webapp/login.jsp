<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jdbc.UserDAO" %>
<%@ page import="BEAN.user" %> <%
request.setCharacterEncoding("UTF-8");

    // [Controller 역할]: 로그인 요청 처리
    String errorMsg = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // 폼에서 전송된 ID와 PW를 받음
        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");
        
        if (userId != null && userPw != null) {
            UserDAO dao = new UserDAO();
            
            // ⭐ 수정: UserVO -> user
            user member = dao.loginCheck(userId, userPw); 
            
            if (member != null) {
                // 1. 로그인 성공 시: 세션에 사용자 정보 저장 (실제 구현 시 필요)
                // session.setAttribute("loggedInUser", member); 
                
                // 2. 로그인 성공 시: 마이페이지로 리다이렉트 (임시)
                // ⭐ 수정: member.getIdUser() -> member.getIdUSER()
                response.sendRedirect("mypage.jsp?id=" + member.getIdUSER());
                return; // 리다이렉트 후 페이지 실행 중지
            } else {
                // 로그인 실패 시
                errorMsg = "ID 또는 비밀번호가 올바르지 않습니다.";
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
/* CSS 변수 (globals.css에서 핵심 디자인 추출) */
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

/* 기본 스타일 */
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
.card-header {
    text-align: center;
    padding: 24px;
    border-bottom: 1px solid var(--border);
}
.card-title {
    font-size: 1.5rem;
    font-weight: bold;
}
.logo-icon {
    font-size: 2rem;
    color: #1DA1F2; /* Twitter Blue */
    margin-bottom: 1rem;
}
.tabs-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    background-color: var(--border);
    border-radius: 9999px; /* full rounded */
    padding: 4px;
    margin-bottom: 16px;
}
.tabs-trigger {
    padding: 8px 12px;
    font-weight: 500;
    border-radius: 9999px;
    cursor: pointer;
    transition: background-color 0.2s;
    text-align: center;
    text-decoration: none;
    color: var(--foreground);
}
.tabs-trigger.active {
    background-color: var(--background);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* 폼 요소 스타일 */
.form-group {
    margin-bottom: 16px;
}
.input-field {
    width: 100%;
    padding: 10px;
    background-color: var(--input);
    border: 1px solid var(--border);
    border-radius: 6px;
    box-sizing: border-box;
    margin-top: 4px;
}
.button-submit {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background-color: var(--primary);
    color: var(--primary-foreground);
    border: none;
    border-radius: 30px;
    font-size: 1rem;
    cursor: pointer;
    transition: opacity 0.2s;
}
.button-submit:hover {
    opacity: 0.9;
}
.error-msg {
    color: red;
    font-size: 0.875rem;
    margin-top: 8px;
}
</style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="logo-icon">X</div>
            <div class="card-title">소셜 미디어에 오신 것을 환영합니다</div>
            <p class="text-gray-500">로그인하거나 새 계정을 만드세요</p>
        </div>
        
        <div class="card-content p-6">
            <div class="tabs-list">
                <div class="tabs-trigger active">로그인</div>
                <a href="signup.jsp" class="tabs-trigger">회원가입</a>
            </div>

            <form method="POST" action="login.jsp" class="space-y-4">
                
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
                <p class="error-msg"><%= errorMsg %></p>
            <% } %>

            <div class="mt-4 text-center text-sm">
                <a href="#" style="color: #1DA1F2; text-decoration: none;">비밀번호를 잊으셨나요?</a>
            </div>
        </div>
    </div>
</body>
</html>