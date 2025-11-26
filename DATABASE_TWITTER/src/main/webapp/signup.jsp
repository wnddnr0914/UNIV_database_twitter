<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%@ page import="BEAN.user" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    String resultMsg = "";
    String userId = request.getParameter("userId");
    
    // 2. POST 요청 처리 (가입하기 버튼 클릭 시)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userName = request.getParameter("userName");
        String userPw = request.getParameter("userPw");
        String birthStr = request.getParameter("birth");
        String genderStr = request.getParameter("gender");
        
        // 필수 값 검증
        if (userId != null && !userId.isEmpty() && 
            userPw != null && !userPw.isEmpty() && 
            birthStr != null && !birthStr.isEmpty()) {
            
            UserDAO dao = new UserDAO();
            user newUser = new user();
            
            try {
                // 데이터 세팅
                newUser.setIdUSER(userId);
                newUser.setNAME(userName);
                newUser.setPASSWORD(userPw);
                newUser.setGENDER(Integer.parseInt(genderStr));
                
                // 날짜 변환 (String yyyy-MM-dd -> java.sql.Date)
                java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthStr);
                newUser.setBIRTH(new Date(utilDate.getTime()));
                
                // ⭐ DB에 실제 저장 (UserDAO.insertUser 호출)
                boolean success = dao.insertUser(newUser);
                
                if (success) {
                    // 성공 시 자바스크립트로 알림 후 이동
%>
                    <script>
                        alert("회원가입이 성공적으로 완료되었습니다! 🎉\n로그인 페이지로 이동합니다.");
                        location.href = "login.jsp";
                    </script>
<%
                    return; // 더 이상 HTML을 렌더링하지 않고 종료
                } else {
                    resultMsg = "이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.";
                }
                
            } catch (java.text.ParseException e) {
                resultMsg = "생년월일 형식이 올바르지 않습니다. (예: 1999-01-01)";
            } catch (Exception e) {
                e.printStackTrace();
                resultMsg = "회원가입 처리 중 오류가 발생했습니다.";
            }
        } else {
            resultMsg = "모든 정보를 입력해주세요.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>X 가입하기</title>
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
    color: #1d9bf0;
    margin-bottom: 1rem;
}

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
.tabs-trigger.active {
    background-color: var(--background);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.card-content { padding: 24px; }
.form-group { margin-bottom: 16px; }
.form-group label { display: block; margin-bottom: 4px; font-size: 0.875rem; font-weight: 500; }
.input-field {
    width: 100%; padding: 10px;
    background-color: var(--input);
    border: 1px solid var(--border);
    border-radius: 6px;
    box-sizing: border-box;
    margin-top: 4px;
    font-size: 1rem;
}
.button-submit {
    width: 100%; padding: 12px; margin-top: 15px;
    background-color: var(--primary);
    color: var(--primary-foreground);
    border: none;
    border-radius: 30px;
    font-size: 1rem;
    cursor: pointer;
    font-weight: bold;
    transition: opacity 0.2s;
}
.button-submit:hover { opacity: 0.9; }
.error-msg {
    color: #d4183d;
    font-size: 0.875rem;
    margin-top: 15px;
    font-weight: bold;
    text-align: center;
}
</style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="logo-icon">🐦</div>
            <div class="card-title">계정 만들기</div>
        </div>
        
        <div class="card-content">
            <div class="tabs-list">
                <a href="login.jsp" class="tabs-trigger">로그인</a>
                <div class="tabs-trigger active">회원가입</div>
            </div>

            <form method="POST" action="signup.jsp">
                
                <div class="form-group">
                    <label for="signup-id">아이디</label>
                    <input id="signup-id" type="text" name="userId" placeholder="영문, 숫자" value="<%= userId != null ? userId : "" %>" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-name">이름</label>
                    <input id="signup-name" type="text" name="userName" placeholder="이름" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-password">비밀번호</label>
                    <input id="signup-password" type="password" name="userPw" placeholder="비밀번호" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-birth">생년월일</label>
                    <input id="signup-birth" type="text" name="birth" placeholder="예: 1999-01-01" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-gender">성별</label>
                    <select id="signup-gender" name="gender" required class="input-field">
                        <option value="1">남성</option>
                        <option value="0">여성</option>
                    </select>
                </div>
                
                <button type="submit" class="button-submit">가입하기</button>
            </form>
            
            <% if (!resultMsg.isEmpty()) { %>
                <p class="error-msg">⚠️ <%= resultMsg %></p>
            <% } %>
            
        </div>
    </div>
</body>
</html>
