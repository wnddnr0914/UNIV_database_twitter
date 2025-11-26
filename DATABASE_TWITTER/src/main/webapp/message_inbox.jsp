<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐
    request.setCharacterEncoding("UTF-8"); 
    
    // 1. 로그인 체크 (세션 확인)
    String myId = (String) session.getAttribute("idKey");
    
    // 로그인이 안 되어 있다면 로그인 페이지로 보냄
    if (myId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    // 2. DAO 호출 (내 아이디와 관련된 모든 메시지 조회)
    // MessageDAO.getConversationList는 내가 보낸 것 + 내가 받은 것 모두 최신순으로 가져옴
    MessageDAO msgDAO = new MessageDAO();
    List<message> conversation = msgDAO.getConversationList(myId);
    
    // 날짜 포맷 설정 (예: 2024-11-25 14:30)
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 쪽지함</title>
    <style>
        /* CSS 변수 (globals.css 스타일 유지) */
        :root {
            --background: #ffffff;
            --foreground: oklch(0.145 0 0);
            --primary: #030213;
            --primary-foreground: oklch(1 0 0);
            --secondary: #ececf0; 
            --muted-foreground: #717182;
            --border: rgba(0, 0, 0, 0.1);
            --radius: 0.625rem;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9f9;
            color: var(--foreground);
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        /* 상단 헤더 및 네비게이션 */
        .header-area {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .header-title { font-size: 1.8rem; font-weight: bold; color: var(--primary); margin: 0; }
        .nav-links a { text-decoration: none; color: #1d9bf0; font-weight: bold; margin-left: 15px; }

        /* 메시지 리스트 컨테이너 */
        .message-list-container {
            background-color: var(--background);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            padding: 20px;
            min-height: 400px;
        }

        /* 개별 메시지 박스 스타일 */
        .msg-container { 
            padding: 12px 16px; 
            margin-bottom: 12px;
            border-radius: 12px;
            max-width: 80%; /* 말풍선 느낌 */
            position: relative;
        }
        
        /* 내가 보낸 메시지 (오른쪽 정렬, 파란색 배경) */
        .msg-mine {
            background-color: #e1f5fe; /* 연한 파랑 */
            margin-left: auto; /* 오른쪽 정렬 */
            border-bottom-right-radius: 0;
            text-align: right;
        }
        
        /* 받은 메시지 (왼쪽 정렬, 회색 배경) */
        .msg-other {
            background-color: #f3f3f5; /* 연한 회색 */
            margin-right: auto; /* 왼쪽 정렬 */
            border-bottom-left-radius: 0;
            text-align: left;
        }

        .user-info { 
            font-size: 0.85rem; 
            font-weight: bold; 
            margin-bottom: 6px; 
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        /* 내가 보낸 메시지의 유저 정보 정렬 */
        .msg-mine .user-info { justify-content: flex-end; color: #0277bd; }
        /* 받은 메시지의 유저 정보 정렬 */
        .msg-other .user-info { justify-content: flex-start; color: var(--primary); }

        .message-content { font-size: 1rem; margin: 0; line-height: 1.5; word-break: break-all; }
        
        .timestamp { 
            font-size: 0.75rem; 
            color: var(--muted-foreground); 
            margin-top: 5px; 
            display: block; 
        }
        
        .empty-box { text-align: center; padding: 50px; color: var(--muted-foreground); }
    </style>
</head>
<body>

    <div class="header-area">
        <div>
            <h1 class="header-title">✉️ 통합 쪽지함</h1>
            <span style="font-size: 0.9rem; color: gray;">로그인: <strong><%= myId %></strong></span>
        </div>
        <div class="nav-links">
            <a href="main.jsp">🏠 홈으로</a>
            <a href="message_send_action.jsp">📝 쪽지 쓰기</a>
        </div>
    </div>
    
    <div class="message-list-container">
        
        <% if (conversation.isEmpty()) { %>
            <div class="empty-box">
                <p>주고받은 쪽지가 없습니다.</p>
                <p>새로운 대화를 시작해보세요!</p>
                <br>
                <a href="message_send_action.jsp" style="color: #1d9bf0; text-decoration: none;">[새 쪽지 보내러 가기]</a>
            </div>
        <% } else { %>
            
            <% for (message msg : conversation) { 
                // 내가 보낸 메시지인지 확인
                boolean sentByMe = msg.getSender().equals(myId);
                
                // 화면에 표시할 상대방 이름 (내가 보냈으면 받는사람, 내가 받았으면 보낸사람)
                String otherPerson = sentByMe ? msg.getRecipient() : msg.getSender();
                
                // 스타일 클래스 결정
                String containerClass = sentByMe ? "msg-mine" : "msg-other";
            %>
                <div class="msg-container <%= containerClass %>">
                    <div class="user-info">
                        <% if (sentByMe) { %>
                            <span>To. <%= otherPerson %></span> 📤
                        <% } else { %>
                            📥 <span>From. <%= otherPerson %></span>
                        <% } %>
                    </div>
                    
                    <p class="message-content"><%= msg.getTEXT() %></p>
                    <span class="timestamp"><%= sdf.format(msg.getDATE()) %></span>
                </div>
            <% } %>
            
        <% } %>
        
    </div>
    
    <div style="text-align: center; margin-top: 20px;">
        <a href="javascript:location.reload();" style="color: var(--muted-foreground); text-decoration: none;">🔄 새로고침</a>
    </div>

</body>
</html>
