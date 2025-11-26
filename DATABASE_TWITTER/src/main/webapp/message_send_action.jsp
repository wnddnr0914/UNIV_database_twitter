<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.sql.Timestamp" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐
    request.setCharacterEncoding("UTF-8"); 
    
    // 1. 로그인 체크 (세션 확인)
    String myId = (String) session.getAttribute("idKey");
    
    if (myId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    String resultMsg = "";
    String statusClass = "";
    
    // 2. 파라미터 받기 (GET으로 들어온 수신자 ID 처리)
    // 예: mypage.jsp에서 '쪽지 보내기' 클릭 시 recipientId가 넘어올 수 있음
    String recipientId = request.getParameter("recipientId");
    if (recipientId == null) recipientId = ""; // 없으면 빈 문자열

    // 3. POST 요청 처리 (실제 전송 버튼 클릭 시)
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // 폼에서 입력한 수신자 ID와 내용
        String targetId = request.getParameter("recipientId");
        String messageText = request.getParameter("messageText");
        
        // 갱신된 recipientId 유지 (폼에 다시 보여주기 위함)
        recipientId = targetId; 
        
        if (targetId != null && !targetId.isEmpty() && messageText != null && !messageText.trim().isEmpty()) {
            
            MessageDAO msgDAO = new MessageDAO();
            message msgBean = new message();
            
            // ⭐ 보내는 사람은 무조건 세션의 '나' (위조 방지)
            msgBean.setSender(myId);
            msgBean.setRecipient(targetId);
            msgBean.setTEXT(messageText);
            
            // 현재 시간 설정
            Timestamp now = new Timestamp(System.currentTimeMillis());
            msgBean.setDATE(now);
            
            // DAO 호출
            boolean success = msgDAO.sendMessage(msgBean);
            
            if (success) {
                resultMsg = "⭐ 메시지 전송 성공! (" + targetId + "님에게)";
                statusClass = "status-success";
                // 성공 시 내용은 비우기 (또 보낼 수 있으니까 수신자는 유지)
                // messageText = ""; 
            } else {
                resultMsg = "❌ 메시지 전송 실패 (존재하지 않는 ID일 수 있습니다)";
                statusClass = "status-failure";
            }
            
        } else {
            resultMsg = "수신자 ID와 내용을 모두 입력해주세요.";
            statusClass = "status-failure";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쪽지 보내기</title>
    <style>
        /* CSS 변수 (globals.css 스타일 유지) */
        :root {
            --background: #ffffff;
            --foreground: oklch(0.145 0 0);
            --primary: #030213;
            --primary-foreground: oklch(1 0 0);
            --destructive: #d4183d;
            --radius: 0.625rem;
            --border: rgba(0, 0, 0, 0.1);
            --input: #f3f3f5;
        }
        body {
            background-color: #f7f9f9;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card-container {
            background: var(--background);
            border-radius: var(--radius);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 450px;
            text-align: center;
            border: 1px solid var(--border);
        }
        .result-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .status-message {
            font-size: 1rem;
            padding: 10px 0;
            border-radius: 5px;
            margin-bottom: 25px;
        }
        .status-success { color: #008000; background-color: #e8f5e9; border: 1px solid #c8e6c9; }
        .status-failure { color: #d4183d; background-color: #ffebee; border: 1px solid #ffcdd2; }
        
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9rem; }
        .input-field {
            width: 100%; padding: 10px;
            background-color: var(--input);
            border: 1px solid var(--border);
            border-radius: 6px;
            box-sizing: border-box;
            resize: none;
        }
        .button-submit {
            width: 100%; padding: 12px; margin-top: 15px;
            background-color: #1d9bf0; /* 트위터 블루 */
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 1rem;
            cursor: pointer;
            font-weight: bold;
        }
        .button-submit:hover { background-color: #1a8cd8; }
        
        .nav-links { margin-top: 20px; font-size: 0.9rem; }
        .nav-links a { color: #536471; text-decoration: none; margin: 0 10px; }
        .nav-links a:hover { color: #1d9bf0; text-decoration: underline; }
    </style>
</head>
<body>
    <div class="card-container">
        <h1 class="result-title">📝 쪽지 보내기</h1>
        
        <% if (!resultMsg.isEmpty()) { %>
            <p class="status-message <%= statusClass %>">
                <%= resultMsg %>
            </p>
        <% } %>
        
        <form action="message_send_action.jsp" method="post">
            <div class="form-group">
                <span class="form-label">보내는 사람</span>
                <input type="text" value="<%= myId %>" disabled class="input-field" style="color: #536471; background-color: #e9ecef;">
            </div>

            <div class="form-group">
                <label for="recipientId" class="form-label">받는 사람 ID</label>
                <input id="recipientId" type="text" name="recipientId" value="<%= recipientId %>" required placeholder="예: elon_musk" class="input-field">
            </div>

            <div class="form-group">
                <label for="messageText" class="form-label">메시지 내용</label>
                <textarea id="messageText" name="messageText" rows="5" required placeholder="내용을 입력하세요..." class="input-field"></textarea>
            </div>
            
            <input type="submit" value="전송하기" class="button-submit">
        </form>
        
        <div class="nav-links">
            <a href="message_inbox.jsp">📩 쪽지함으로</a> |
            <a href="main.jsp">🏠 메인으로</a>
        </div>
    </div>
</body>
</html>
