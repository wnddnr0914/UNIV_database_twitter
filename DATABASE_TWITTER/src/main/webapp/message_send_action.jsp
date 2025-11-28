<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.sql.Timestamp" %>
<% 
    request.setCharacterEncoding("UTF-8"); 
    
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
    
    String recipientId = request.getParameter("recipientId");
    if (recipientId == null) recipientId = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String targetId = request.getParameter("recipientId");
        String messageText = request.getParameter("messageText");
        
        recipientId = targetId; 
        
        if (targetId != null && !targetId.isEmpty() && messageText != null && !messageText.trim().isEmpty()) {
            
            MessageDAO msgDAO = new MessageDAO();
            message msgBean = new message();
            
            msgBean.setSender(myId);
            msgBean.setRecipient(targetId);
            msgBean.setTEXT(messageText);
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            msgBean.setDATE(now);
            
            boolean success = msgDAO.sendMessage(msgBean);
            
            if (success) {
                resultMsg = "⭐ 메시지 전송 성공! (" + targetId + "님에게)";
                statusClass = "status-success";
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
    <title>쪽지 보내기 / X</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .card-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            width: 100%;
            max-width: 550px;
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
        
        .result-title {
            font-size: 32px;
            font-weight: 800;
            color: #14171a;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .result-subtitle {
            font-size: 15px;
            color: #657786;
            margin-bottom: 30px;
        }
        
        .status-message {
            font-size: 16px;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            font-weight: 600;
        }
        
        .status-success { 
            color: #17bf63;
            background-color: rgba(23, 191, 99, 0.1);
            border: 2px solid rgba(23, 191, 99, 0.3);
        }
        
        .status-failure { 
            color: #e0245e;
            background-color: rgba(224, 36, 94, 0.1);
            border: 2px solid rgba(224, 36, 94, 0.3);
        }
        
        .form-group { 
            margin-bottom: 25px;
        }
        
        .form-label { 
            display: block;
            margin-bottom: 10px;
            font-weight: 700;
            font-size: 15px;
            color: #14171a;
        }
        
        .input-field {
            width: 100%;
            padding: 14px 18px;
            background-color: #f7f9fa;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        .input-field:focus {
            outline: none;
            background-color: white;
            border-color: #1da1f2;
            box-shadow: 0 0 0 4px rgba(29, 161, 242, 0.1);
        }
        
        .input-field:disabled {
            background-color: #e1e8ed;
            color: #657786;
            cursor: not-allowed;
        }
        
        .input-field::placeholder {
            color: #a0aec0;
        }
        
        textarea.input-field {
            resize: vertical;
            min-height: 150px;
            font-family: inherit;
        }
        
        .button-submit {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            cursor: pointer;
            font-weight: 700;
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
        
        .nav-links { 
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e1e8ed;
            font-size: 15px;
            text-align: center;
        }
        
        .nav-links a { 
            color: #1da1f2;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-block;
        }
        
        .nav-links a:hover { 
            text-decoration: underline;
        }
        
        .sender-info {
            background: linear-gradient(135deg, #f7f9fa 0%, #e1e8ed 100%);
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            border: 2px solid #e1e8ed;
        }
        
        .sender-info-label {
            font-size: 13px;
            color: #657786;
            font-weight: 600;
            margin-bottom: 6px;
        }
        
        .sender-info-value {
            font-size: 18px;
            color: #14171a;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="card-container">
        <h1 class="result-title">📝 쪽지 보내기</h1>
        <p class="result-subtitle">다른 사용자에게 메시지를 전송하세요</p>
        
        <% if (!resultMsg.isEmpty()) { %>
            <div class="status-message <%= statusClass %>">
                <%= resultMsg %>
            </div>
        <% } %>
        
        <form action="message_send_action.jsp" method="post">
            <div class="sender-info">
                <div class="sender-info-label">보내는 사람</div>
                <div class="sender-info-value"><%= myId %></div>
            </div>

            <div class="form-group">
                <label for="recipientId" class="form-label">받는 사람 ID</label>
                <input id="recipientId" 
                       type="text" 
                       name="recipientId" 
                       value="<%= recipientId %>" 
                       required 
                       placeholder="예: elon_musk" 
                       class="input-field"
                       autofocus>
            </div>

            <div class="form-group">
                <label for="messageText" class="form-label">메시지 내용</label>
                <textarea id="messageText" 
                          name="messageText" 
                          required 
                          placeholder="내용을 입력하세요..." 
                          class="input-field"></textarea>
            </div>
            
            <input type="submit" value="전송하기" class="button-submit">
        </form>
        
        <div class="nav-links">
            <a href="message_inbox.jsp">📩 쪽지함으로</a>
            |
            <a href="main.jsp">🏠 메인으로</a>
        </div>
    </div>
</body>
</html>
