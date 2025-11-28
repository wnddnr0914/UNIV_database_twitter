<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user, java.sql.Date, java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    String resultMsg = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("userId");
        String userName = request.getParameter("userName");
        String userPw = request.getParameter("userPw");
        String birthStr = request.getParameter("birth");
        String genderStr = request.getParameter("gender");

        if (userId != null && !userId.isEmpty() && userPw != null && !userPw.isEmpty()) {
            UserDAO dao = new UserDAO();
            
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
<title>회원가입 / X</title>
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

.signup-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    width: 100%;
    max-width: 500px;
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

.signup-header {
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

.signup-header h1 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 8px;
}

.signup-header p {
    font-size: 15px;
    opacity: 0.9;
}

.signup-body {
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

.id-check-group {
    display: flex;
    gap: 10px;
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

.btn-check {
    padding: 0 20px;
    background: linear-gradient(135deg, #14171a 0%, #272c30 100%);
    color: white;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    font-weight: 700;
    font-size: 14px;
    white-space: nowrap;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.btn-check:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
}

.check-msg {
    font-size: 13px;
    margin-top: 8px;
    display: block;
    font-weight: 600;
}

select.input-field {
    cursor: pointer;
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

.button-submit:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none !important;
}

.button-submit:enabled:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(29, 161, 242, 0.5);
}

.button-submit:enabled:active {
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

.info-box strong {
    color: var(--text);
}

/* Progress indicator */
.progress-indicator {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin-bottom: 20px;
}

.progress-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #e1e8ed;
    transition: all 0.3s ease;
}

.progress-dot.active {
    background: var(--primary);
    width: 24px;
    border-radius: 4px;
}

/* 반응형 디자인 */
@media (max-width: 480px) {
    .signup-container {
        border-radius: 15px;
    }
    
    .signup-header {
        padding: 30px 20px 20px;
    }
    
    .signup-header h1 {
        font-size: 24px;
    }
    
    .signup-body {
        padding: 25px 20px;
    }
    
    .id-check-group {
        flex-direction: column;
    }
    
    .btn-check {
        width: 100%;
        padding: 14px;
    }
}
</style>

<script>
    function checkId() {
        const userId = document.getElementById('signup-id').value;
        const msgSpan = document.getElementById('id-msg');
        const submitBtn = document.getElementById('submitBtn');

        if(userId.trim() === "") {
            alert("아이디를 입력해주세요!");
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", "check_id_proc.jsp?userId=" + encodeURIComponent(userId), true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const response = xhr.responseText.trim();
                
                if (response === "YES") {
                    msgSpan.style.color = "#17bf63";
                    msgSpan.innerText = "✅ 사용 가능한 아이디입니다.";
                    submitBtn.disabled = false;
                    document.getElementById('idChecked').value = "Y";
                } else {
                    msgSpan.style.color = "#e0245e";
                    msgSpan.innerText = "❌ 이미 사용 중인 아이디입니다.";
                    submitBtn.disabled = true;
                    document.getElementById('idChecked').value = "N";
                }
            }
        };
        xhr.send();
    }

    function resetCheck() {
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('idChecked').value = "N";
        document.getElementById('id-msg').innerText = "";
    }
    
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
    <div class="signup-container">
        <div class="signup-header">
            <div class="logo-icon">🐦</div>
            <h1>계정 만들기</h1>
            <p>새로운 여정을 시작하세요</p>
        </div>
        
        <div class="signup-body">
            <div class="progress-indicator">
                <div class="progress-dot active"></div>
                <div class="progress-dot"></div>
                <div class="progress-dot"></div>
            </div>
            
            <div class="tabs">
                <a href="login.jsp" class="tab">로그인</a>
                <div class="tab active">회원가입</div>
            </div>

            <form method="POST" action="signup.jsp" onsubmit="return validateForm()">
                <input type="hidden" id="idChecked" value="N">
                
                <div class="form-group">
                    <label for="signup-id">아이디 *</label>
                    <div class="id-check-group">
                        <input id="signup-id" type="text" name="userId" placeholder="영문, 숫자 조합" 
                               required class="input-field" oninput="resetCheck()" autofocus>
                        <button type="button" class="btn-check" onclick="checkId()">중복확인</button>
                    </div>
                    <span id="id-msg" class="check-msg"></span>
                </div>
                
                <div class="form-group">
                    <label for="signup-name">이름 *</label>
                    <input id="signup-name" type="text" name="userName" placeholder="표시될 이름을 입력하세요" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-password">비밀번호 *</label>
                    <input id="signup-password" type="password" name="userPw" placeholder="안전한 비밀번호를 입력하세요" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-birth">생년월일 *</label>
                    <input id="signup-birth" type="date" name="birth" required class="input-field">
                </div>
                
                <div class="form-group">
                    <label for="signup-gender">성별 *</label>
                    <select id="signup-gender" name="gender" required class="input-field">
                        <option value="">선택해주세요</option>
                        <option value="1">남성</option>
                        <option value="2">여성</option>
                    </select>
                </div>
                
                <button type="submit" id="submitBtn" class="button-submit" disabled>가입하기</button>
            </form>
            
            <% if (!resultMsg.isEmpty()) { %>
                <p class="error-msg">⚠️ <%= resultMsg %></p>
            <% } %>
            
            <div class="info-box">
                <p>계정을 생성하면 <strong>이용약관</strong> 및<br>
                <strong>개인정보 보호정책</strong>에 동의하게 됩니다.</p>
            </div>
        </div>
    </div>
</body>
</html>
