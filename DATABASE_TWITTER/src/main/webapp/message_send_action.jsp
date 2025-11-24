<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jdbc.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.sql.Timestamp" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐ (로직은 그대로 유지)
    request.setCharacterEncoding("UTF-8"); 
    
    // 1. 요청 파라미터 받기 (폼 데이터)
    String senderId = request.getParameter("senderId");     
    String recipientId = request.getParameter("recipientId"); 
    String messageText = request.getParameter("messageText"); 
    
    boolean success = false;
    String resultMsg = "";
    
    // [임시 조치]: senderId가 없으면 'testuser'로 가정
    if (senderId == null || senderId.isEmpty()) {
        senderId = "testuser"; 
    }
    
    if (recipientId != null && !recipientId.isEmpty() && messageText != null && !messageText.isEmpty()) {
        
        MessageDAO msgDAO = new MessageDAO();
        message msgBean = new message();
        
        msgBean.setSender(senderId);
        msgBean.setRecipient(recipientId);
        msgBean.setTEXT(messageText);
        
        // 현재 시각을 Timestamp로 생성하여 VO에 설정
        Timestamp now = new Timestamp(System.currentTimeMillis());
        msgBean.setDATE(now);
        
        // 2. DAO 호출 (메시지 전송)
        success = msgDAO.sendMessage(msgBean);
        
        resultMsg = success ? "⭐ 메시지 전송 성공! (수신자: " + recipientId + ")" : "❌ 메시지 전송 실패 (DB 오류 또는 수신 ID 오류 등)";
        
    } else {
        resultMsg = "메시지 내용 또는 수신 대상 ID가 누락되었습니다. (senderId: " + senderId + ", recipientId: " + recipientId + ")";
    }
    
    // JSP 변수: 메시지에 따라 상태 클래스 결정 (성공/실패)
    String statusClass = resultMsg.contains("성공") ? "status-success" : "status-failure";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메시지 전송 결과</title>
    <style>
        /* CSS 변수 (globals.css에서 핵심 디자인 추출) */
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
            border-top: 1px dashed var(--border);
            border-bottom: 1px dashed var(--border);
            margin-bottom: 25px;
        }
        .status-success {
            color: green;
            font-weight: bold;
        }
        .status-failure {
            color: var(--destructive);
            font-weight: bold;
        }
        /* 폼 요소 스타일 (Signup/Login과 동일하게 통일) */
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }
        .input-field {
            width: 100%;
            padding: 10px;
            background-color: var(--input);
            border: 1px solid var(--border);
            border-radius: 6px;
            box-sizing: border-box;
            margin-top: 5px;
            resize: none; /* Textarea resizing disabled */
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
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="card-container">
        <h1 class="result-title">메시지 전송 결과</h1>
        
        <p class="status-message <%= statusClass %>">
            <%= resultMsg %>
        </p>
        
        <hr style="border: 0; border-top: 1px solid var(--border); margin: 20px 0;">

        <h2 style="font-size: 1.2rem; margin-bottom: 15px;">새 메시지 보내기</h2>
        <form action="message_send_action.jsp" method="post">
            <input type="hidden" name="senderId" value="<%= senderId %>">
            
            <div class="form-group">
                <label for="recipientId">수신 ID</label>
                <input id="recipientId" type="text" name="recipientId" required placeholder="예: otheruser" class="input-field">
            </div>

            <div class="form-group">
                <label for="messageText">메시지 내용</label>
                <textarea id="messageText" name="messageText" rows="5" required class="input-field"></textarea>
            </div>
            
            <input type="submit" value="쪽지 보내기" class="button-submit">
        </form>
        
        <div style="margin-top: 20px;">
            <a href="message_inbox.jsp" style="color: #1DA1F2; text-decoration: none; font-weight: 500;">
                ← 쪽지함 목록으로 돌아가기
            </a>
        </div>
    </div>
</body>
</html>