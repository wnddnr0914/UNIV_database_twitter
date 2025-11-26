<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    request.setCharacterEncoding("UTF-8");
    // 1. 로그인 체크
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

    // 2. DAO 호출 (페이징 적용)
    int pageNum = 1;
    if(request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }
    int limit = 10; // 10개씩 보기

    MessageDAO msgDAO = new MessageDAO();
    // [수정] 페이징된 메소드 호출
    List<message> conversation = msgDAO.getConversationList(myId, pageNum, limit);
    
    // 전체 페이지 수 계산
    int totalCount = msgDAO.getTotalMessageCount(myId);
    int totalPage = (int) Math.ceil((double) totalCount / limit);
    
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

        .message-list-container {
            background-color: var(--background);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            padding: 20px;
            min-height: 400px;
        }

        .msg-container { 
            padding: 12px 16px;
            margin-bottom: 12px;
            border-radius: 12px;
            max-width: 80%; 
            position: relative;
        }
        
        .msg-mine {
            background-color: #e1f5fe;
            margin-left: auto;
            border-bottom-right-radius: 0;
            text-align: right;
        }
        
        .msg-other {
            background-color: #f3f3f5;
            margin-right: auto;
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
        
        .msg-mine .user-info { justify-content: flex-end; color: #0277bd; }
        .msg-other .user-info { justify-content: flex-start; color: var(--primary); }

        .message-content { font-size: 1rem; margin: 0; line-height: 1.5; word-break: break-all; }
        .timestamp { font-size: 0.75rem; color: var(--muted-foreground); margin-top: 5px; display: block; }
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
                boolean sentByMe = msg.getSender().equals(myId);
                String otherPerson = sentByMe ? msg.getRecipient() : msg.getSender();
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
        <% if(pageNum > 1) { %>
            <a href="message_inbox.jsp?page=<%=pageNum-1%>" style="margin-right:10px; font-weight:bold; color:#1d9bf0; text-decoration:none;">이전</a>
        <% } %>
        
        <span style="color:#536471;"> <%=pageNum%> / <%=totalPage%> </span>

        <% if(pageNum < totalPage) { %>
            <a href="message_inbox.jsp?page=<%=pageNum+1%>" style="margin-left:10px; font-weight:bold; color:#1d9bf0; text-decoration:none;">다음</a>
        <% } %>
    </div>

    <div style="text-align: center; margin-top: 10px;">
        <a href="javascript:location.reload();" style="color: var(--muted-foreground); text-decoration: none;">🔄 새로고침</a>
    </div>

</body>
</html>