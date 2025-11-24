<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jdbc.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // ⭐ MVC1 Controller 영역 - 수신함 조회 ⭐
    request.setCharacterEncoding("UTF-8"); 
    
    // [임시 조치]: 현재 로그인한 사용자의 ID를 'testuser'로 가정
    String loggedInUserId = "testuser"; 
    
    // 💡 참고: 실제 구현 시 세션에서 ID를 가져와야 함: 
    // String loggedInUserId = (String) session.getAttribute("userId");
    
    MessageDAO msgDAO = new MessageDAO();
    List<message> conversation = msgDAO.getConversationList(loggedInUserId);
    
    // 날짜 형식: 2025-11-24 15:40 형식
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쪽지함 (전체 대화)</title>
    <style>
        /* CSS 변수 (globals.css에서 핵심 디자인 추출) */
        :root {
            --background: #ffffff;
            --foreground: oklch(0.145 0 0);
            --primary: #030213; /* Black */
            --primary-foreground: oklch(1 0 0); /* White */
            --secondary: #ececf0; /* muted */
            --muted-foreground: #717182;
            --border: rgba(0, 0, 0, 0.1);
            --radius: 0.625rem;
            --font-weight-medium: 500;
        }

        /* 기본 레이아웃 및 스타일 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9f9; /* 가볍고 밝은 배경 */
            color: var(--foreground);
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .header-title {
            font-size: 1.8rem;
            font-weight: bold;
            border-bottom: 1px solid var(--border);
            padding-bottom: 10px;
            margin-bottom: 20px;
            color: var(--primary);
        }
        
        /* 메시지 컨테이너 (Card Component 대체) */
        .message-list-container {
            background-color: var(--background);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        
        /* 메시지 아이템 스타일 (Threads) */
        .msg-container { 
            padding: 15px; 
            border-bottom: 1px solid var(--border);
            transition: background-color 0.15s;
        }
        .msg-container:last-child {
            border-bottom: none;
        }
        .msg-container:hover {
            background-color: var(--secondary); /* hover:bg-gray-50 */
        }
        
        /* 텍스트 스타일 */
        .user-info { 
            font-weight: var(--font-weight-medium); 
            margin-bottom: 5px; 
            display: flex;
            justify-content: space-between;
        }
        .sender-id {
            color: var(--primary);
        }
        .recipient-id {
            color: var(--muted-foreground);
        }
        .message-content { 
            font-size: 0.9rem; 
            margin: 5px 0; 
            color: var(--foreground);
        }
        .timestamp { 
            font-size: 0.75rem; 
            color: var(--muted-foreground); 
            display: block; 
            text-align: right; 
        }
    </style>
</head>
<body>
    <h1 class="header-title">✉️ 쪽지함</h1>
    <p>현재 사용자: <strong><%= loggedInUserId %></strong></p>
    
    <div class="message-list-container">
        
        <% if (conversation.isEmpty()) { %>
            <div style="padding: 30px; text-align: center; color: var(--muted-foreground);">
                <p>새 쪽지가 없습니다. 아래 링크를 통해 쪽지를 보내보세요.</p>
            </div>
        <% } else { %>
            
            <% for (message msg : conversation) { 
                boolean sentByMe = msg.getSender().equals(loggedInUserId); // 내가 보냈는지 확인
                String displayUser = sentByMe ? msg.getRecipient() : msg.getSender(); // 상대방 ID
            %>
                <div class="msg-container">
                    <div class="user-info">
                        <% if (sentByMe) { %>
                            <span class="recipient-id">받는 사람: **<%= displayUser %>**</span>
                        <% } else { %>
                            <span class="sender-id">보낸 사람: **<%= displayUser %>**</span>
                        <% } %>
                        <span class="timestamp"><%= sdf.format(msg.getDATE()) %></span>
                    </div>
                    
                    <p class="message-content"><%= msg.getTEXT() %></p>
                </div>
            <% } %>
            
        <% } %>
        
    </div>
    
    <div style="margin-top: 20px; text-align: center;">
        <a href="message_send_action.jsp" style="color: #1DA1F2; text-decoration: none; font-weight: bold;">
            📝 새 쪽지 보내기
        </a>
        &nbsp;|&nbsp;
        <a href="javascript:location.reload();" style="color: var(--muted-foreground); text-decoration: none;">
            🔄 새로고침
        </a>
    </div>
</body>
</html>