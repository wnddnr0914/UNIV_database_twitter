<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.MessageDAO" %>
<%@ page import="BEAN.message" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    int pageNum = 1;
    if(request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }
    int limit = 10;

    MessageDAO msgDAO = new MessageDAO();
    List<message> conversation = msgDAO.getConversationList(myId, pageNum, limit);
    
    int totalCount = msgDAO.getTotalMessageCount(myId);
    int totalPage = (int) Math.ceil((double) totalCount / limit);
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쪽지함 / X</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(to bottom, #f8f9fa 0%, #ffffff 100%);
            color: #14171a;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        /* 헤더 영역 */
        .header-area {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            padding: 25px 30px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .header-left h1 {
            font-size: 32px;
            font-weight: 800;
            color: #14171a;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .header-left span {
            font-size: 16px;
            color: #657786;
            font-weight: 400;
        }
        
        .header-left strong {
            color: #1da1f2;
            font-weight: 700;
        }
        
        .nav-links {
            display: flex;
            gap: 15px;
        }
        
        .nav-links a {
            text-decoration: none;
            color: #14171a;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 20px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav-links a:hover {
            background-color: rgba(29, 161, 242, 0.1);
            color: #1da1f2;
        }

        /* 메시지 컨테이너 */
        .message-list-container {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 30px;
            min-height: 500px;
        }

        /* 메시지 아이템 */
        .msg-container { 
            padding: 18px 20px;
            margin-bottom: 15px;
            border-radius: 16px;
            max-width: 75%; 
            position: relative;
            animation: slideIn 0.3s ease-out;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .msg-mine {
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            margin-left: auto;
            border-bottom-right-radius: 4px;
            color: white;
        }
        
        .msg-other {
            background: linear-gradient(135deg, #f7f9fa 0%, #e1e8ed 100%);
            margin-right: auto;
            border-bottom-left-radius: 4px;
            color: #14171a;
        }

        .user-info { 
            font-size: 13px;
            font-weight: 700; 
            margin-bottom: 8px; 
            display: flex;
            align-items: center;
            gap: 6px;
            opacity: 0.9;
        }
        
        .msg-mine .user-info { 
            justify-content: flex-end;
        }
        
        .msg-other .user-info { 
            justify-content: flex-start;
            color: #657786;
        }

        .message-content { 
            font-size: 15px;
            line-height: 1.6;
            word-break: break-word;
        }
        
        .timestamp { 
            font-size: 12px;
            margin-top: 8px;
            display: block;
            opacity: 0.7;
        }
        
        /* 빈 상태 */
        .empty-box { 
            text-align: center;
            padding: 80px 20px;
            color: #657786;
        }
        
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-box h3 {
            font-size: 24px;
            color: #14171a;
            margin-bottom: 12px;
        }
        
        .empty-box p {
            font-size: 16px;
            margin-bottom: 25px;
        }
        
        .empty-box a {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(29, 161, 242, 0.3);
        }
        
        .empty-box a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(29, 161, 242, 0.4);
        }
        
        /* 페이지네이션 */
        .pagination {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e1e8ed;
        }
        
        .pagination a {
            text-decoration: none;
            color: #1da1f2;
            margin: 0 15px;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.2s ease;
        }
        
        .pagination a:hover {
            background-color: rgba(29, 161, 242, 0.1);
        }
        
        .pagination span {
            color: #657786;
            font-weight: 500;
            margin: 0 10px;
        }
        
        /* 새로고침 버튼 */
        .refresh-area {
            text-align: center;
            margin-top: 20px;
        }
        
        .refresh-area a {
            color: #1da1f2;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .refresh-area a:hover {
            background-color: rgba(29, 161, 242, 0.1);
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-area">
            <div class="header-left">
                <h1>✉️ 쪽지함</h1>
                <span>로그인: <strong><%= myId %></strong></span>
            </div>
            <div class="nav-links">
                <a href="main.jsp">🏠 홈으로</a>
                <a href="message_send_action.jsp">📝 쪽지 쓰기</a>
            </div>
        </div>
        
        <div class="message-list-container">
            
            <% if (conversation.isEmpty()) { %>
                <div class="empty-box">
                    <div class="empty-icon">💬</div>
                    <h3>주고받은 쪽지가 없습니다</h3>
                    <p>새로운 대화를 시작해보세요!</p>
                    <a href="message_send_action.jsp">새 쪽지 보내기</a>
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
            
            <% if(totalPage > 1) { %>
            <div class="pagination">
                <% if(pageNum > 1) { %>
                    <a href="message_inbox.jsp?page=<%=pageNum-1%>">← 이전</a>
                <% } %>
                
                <span><%=pageNum%> / <%=totalPage%></span>

                <% if(pageNum < totalPage) { %>
                    <a href="message_inbox.jsp?page=<%=pageNum+1%>">다음 →</a>
                <% } %>
            </div>
            <% } %>
        </div>

        <div class="refresh-area">
            <a href="javascript:location.reload();">
                🔄 새로고침
            </a>
        </div>
    </div>

</body>
</html>
