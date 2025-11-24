<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%@ page import="BEAN.user" %>
<%@ page import="java.sql.Date" %> 
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%
request.setCharacterEncoding("UTF-8");
    // [Controller 역할]: 회원가입 요청 처리
    String resultMsg = "";
    
    // 폼이 POST 방식으로 제출되었는지 확인
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // 폼에서 전송된 모든 데이터를 받음
        String userId = request.getParameter("userId");
        String userName = request.getParameter("userName");
        String genderStr = request.getParameter("gender");
        String birthStr = request.getParameter("birth");
        String userPw = request.getParameter("userPw");
        
        // 필수 값 검증 (간단하게)
        if (userId != null && !userId.isEmpty() && userPw != null && !userPw.isEmpty()) {
            
            // 1. VO 객체에 데이터 담기
            user newUser = new user(); 
            
            // [BIRTH 타입 변환 로직]
            Date sqlDate = null;
            try {
                // yyyy-MM-dd 형식의 문자열을 util.Date로 파싱
                java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthStr);
                // java.util.Date를 java.sql.Date로 변환
                sqlDate = new Date(utilDate.getTime());
            } catch (Exception e) {
                resultMsg = "❌ 생년월일 형식이 올바르지 않습니다 (YYYY-MM-DD).";
                sqlDate = null; 
            }

            if (sqlDate != null) {
                // ⭐ 대문자 Setter 사용
                newUser.setIdUSER(userId);       
                newUser.setNAME(userName);         
                newUser.setGENDER(Integer.parseInt(genderStr)); 
                newUser.setBIRTH(sqlDate);       
                newUser.setPASSWORD(userPw);
                
                // 2. DAO(Model) 호출
                UserDAO dao = new UserDAO();
                boolean success = dao.insertUser(newUser);
                
                if (success) {
                    resultMsg = "⭐ 회원가입 성공! 이제 로그인해주세요.";
                    response.setHeader("Refresh", "3;url=login.jsp");
                } else {
                    resultMsg = "❌ 회원가입 실패! (이미 존재하는 ID일 수 있습니다)";
                }
            }
        } else {
            resultMsg = "모든 필수 항목을 입력해주세요.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>X 가입하기</title>
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
/* Card 컴포넌트 스타일 */
.card {
    background: var(--background);
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
    color: #1DA1F2; /* X/Twitter Blue */
    margin-bottom: 1rem;
}

/* Tabs 컴포넌트 스타일 (LoginPage.tsx에서 가져옴) */
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
}
.tabs-trigger.active {
    background-color: var(--background);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* 폼 요소 스타일 */
.card-content {
    padding: 24px; /* p-6 */
}
.space-y-4 > * + * {
    margin-top: 16px;
}
.form-group label {
    display: block;
    margin-bottom: 4px;
    font-size: 0.875rem; /* text-sm */
    font-weight: 500;
}
.input-field {
    width: 100%;
    padding: 10px;
    background-color: var(--input);
    border: 1px solid var(--border);
    border-radius: 6px;
    box-sizing: border-box;
    margin-top: 4px;
    font-size: 1rem;
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
    font-weight: bold;
}
.button-submit:hover {
    opacity: 0.9;
}
.message {
    margin-top: 15px;
    font-size: 0.875rem;
    font-weight: bold;
}
</style> </head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="logo-icon">X</div>
            <div class="card-title">X 계정 만들기</div>
        </div>
        
        <div class="card-content">
            <div class="tabs-list">
                <a href="login.jsp" class="tabs-trigger">로그인</a>
                <div class="tabs-trigger active">회원가입</div>
            </div>

            <form method="POST" action="signup.jsp" class="space-y-4">
                
                <div class="form-group">
                    <label for="signup-id">아이디</label>
                    <input id="signup-id" type="text" name="userId" placeholder="아이디" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-name">이름</label>
                    <input id="signup-name" type="text" name="userName" placeholder="이름" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-password">비밀번호</label>
                    <input id="signup-password" type="password" name="userPw" placeholder="••••••••" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-birth">생년월일 (YYYY-MM-DD)</label>
                    <input id="signup-birth" type="text" name="birth" placeholder="예: 1990-01-01" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-gender">성별</label>
                    <select id="signup-gender" name="gender" required class="input-field">
                        <option value="">성별 선택</option>
                        <option value="1">남성</option>
                        <option value="0">여성</option>
                    </select>
                </div>
                
                <button type="submit" class="button-submit">가입하기</button>
            </form>
            
            <% if (!resultMsg.isEmpty()) { %>
                <p class="message" style="color: <%= resultMsg.contains("성공") ? "green" : "red" %>;">
                    <%= resultMsg %>
                </p>
            <% } %>
            
            <div class="mt-4 text-center text-sm">
                <p style="font-size: 14px; color: var(--muted-foreground);">
                    이미 계정이 있으신가요? 
                    <a href="login.jsp" style="color: #1DA1F2; text-decoration: none;">로그인</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>