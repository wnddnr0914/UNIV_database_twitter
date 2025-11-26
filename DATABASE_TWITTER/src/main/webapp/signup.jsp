<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user, java.sql.Date, java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    String resultMsg = "";
    
    // POST 요청 처리 (가입하기 버튼 클릭 시)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("userId");
        String userName = request.getParameter("userName");
        String userPw = request.getParameter("userPw");
        String birthStr = request.getParameter("birth");
        String genderStr = request.getParameter("gender");

        if (userId != null && !userId.isEmpty() && userPw != null && !userPw.isEmpty()) {
            UserDAO dao = new UserDAO();
            
            // [중요] 서버단에서도 한 번 더 중복 검사 (보안 강화)
            if(!dao.checkId(userId)) {
                resultMsg = "이미 사용 중인 아이디입니다.";
            } else {
                try {
                    user newUser = new user();
                    newUser.setIdUSER(userId);
                    newUser.setNAME(userName);
                    newUser.setPASSWORD(userPw);
                    newUser.setGENDER(Integer.parseInt(genderStr));
                    
                    java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthStr);
                    newUser.setBIRTH(new Date(utilDate.getTime()));
                    
                    if (dao.insertUser(newUser)) {
%>
                        <script>
                            alert("회원가입 완료! 🎉\n로그인 페이지로 이동합니다.");
                            location.href = "login.jsp";
                        </script>
<%
                        return;
                    } else {
                        resultMsg = "회원가입 실패 (DB 오류)";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    resultMsg = "입력 정보를 확인해주세요 (생년월일 형식 등)";
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>X 가입하기</title>
<style>
/* CSS 변수 유지 */
:root { --background: #ffffff; --foreground: oklch(0.145 0 0); --primary: #030213; --primary-foreground: oklch(1 0 0); --border: rgba(0, 0, 0, 0.1); --radius: 0.625rem; --input: #f3f3f5; }
body { background-color: var(--background); font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
.card { background: var(--background); border-radius: var(--radius); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); width: 100%; max-width: 400px; }
.card-header { text-align: center; padding: 24px; border-bottom: 1px solid var(--border); }
.card-title { font-size: 1.5rem; font-weight: bold; }
.logo-icon { font-size: 2rem; color: #1d9bf0; margin-bottom: 1rem; }
.tabs-list { display: grid; grid-template-columns: repeat(2, 1fr); background-color: var(--border); border-radius: 9999px; padding: 4px; margin-bottom: 16px; }
.tabs-trigger { padding: 8px 12px; font-weight: 500; border-radius: 9999px; cursor: pointer; text-align: center; text-decoration: none; color: var(--foreground); transition: background-color 0.2s; }
.tabs-trigger.active { background-color: var(--background); box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1); }
.card-content { padding: 24px; }
.form-group { margin-bottom: 16px; }
.form-group label { display: block; margin-bottom: 4px; font-size: 0.875rem; font-weight: 500; }
.input-field { width: 100%; padding: 10px; background-color: var(--input); border: 1px solid var(--border); border-radius: 6px; box-sizing: border-box; margin-top: 4px; font-size: 1rem; }

/* ▼▼▼ AJAX 버튼 스타일 추가 ▼▼▼ */
.id-check-group { display: flex; gap: 8px; }
.btn-check { padding: 0 15px; background-color: #0f1419; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 0.85rem; white-space: nowrap; }
.btn-check:hover { background-color: #272c30; }
.check-msg { font-size: 12px; margin-top: 4px; display: block; }

.button-submit { width: 100%; padding: 12px; margin-top: 15px; background-color: var(--primary); color: var(--primary-foreground); border: none; border-radius: 30px; font-size: 1rem; cursor: pointer; font-weight: bold; transition: opacity 0.2s; }
.button-submit:disabled { opacity: 0.5; cursor: not-allowed; } /* 비활성화 스타일 */
.error-msg { color: #d4183d; font-size: 0.875rem; margin-top: 15px; font-weight: bold; text-align: center; }
</style>

<script>
    // AJAX 아이디 중복 확인 함수
    function checkId() {
        const userId = document.getElementById('signup-id').value;
        const msgSpan = document.getElementById('id-msg');
        const submitBtn = document.getElementById('submitBtn');

        if(userId.trim() === "") {
            alert("아이디를 입력해주세요!");
            return;
        }

        // AJAX 요청 시작 (XMLHttpRequest 사용 - 순수 자바스크립트)
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "check_id_proc.jsp?userId=" + encodeURIComponent(userId), true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const response = xhr.responseText.trim(); // YES or NO
                
                if (response === "YES") {
                    msgSpan.style.color = "green";
                    msgSpan.innerText = "✅ 사용 가능한 아이디입니다.";
                    submitBtn.disabled = false; // 가입 버튼 활성화
                    document.getElementById('idChecked').value = "Y"; // 체크 완료 표시
                } else {
                    msgSpan.style.color = "red";
                    msgSpan.innerText = "❌ 이미 사용 중인 아이디입니다.";
                    submitBtn.disabled = true; // 가입 버튼 비활성화
                    document.getElementById('idChecked').value = "N";
                }
            }
        };
        xhr.send();
    }

    // 아이디 수정하면 다시 체크하도록 초기화
    function resetCheck() {
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('idChecked').value = "N";
        document.getElementById('id-msg').innerText = "";
    }
    
    // 폼 제출 전 최종 확인
    function validateForm() {
        if(document.getElementById('idChecked').value !== "Y") {
            alert("아이디 중복 확인을 해주세요!");
            return false;
        }
        return true;
    }
</script>
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

            <form method="POST" action="signup.jsp" onsubmit="return validateForm()">
                <input type="hidden" id="idChecked" value="N">
                
                <div class="form-group">
                    <label for="signup-id">아이디</label>
                    <div class="id-check-group">
                        <input id="signup-id" type="text" name="userId" placeholder="영문, 숫자" 
                               required class="input-field" oninput="resetCheck()">
                        <button type="button" class="btn-check" onclick="checkId()">중복확인</button>
                    </div>
                    <span id="id-msg" class="check-msg"></span> </div>
                
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
                
                <button type="submit" id="submitBtn" class="button-submit" disabled>가입하기</button>
            </form>
            
            <% if (!resultMsg.isEmpty()) { %>
                <p class="error-msg">⚠️ <%= resultMsg %></p>
            <% } %>
            
        </div>
    </div>
</body>
</html>