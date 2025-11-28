<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.GroupDAO, BEAN.group, java.util.ArrayList" %>

<%
    String myId = (String) session.getAttribute("idKey");
    if (myId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다. 로그인 해주세요! 🔒");
        location.href = "login.jsp";
    </script>
<%
        return; 
    }

    GroupDAO dao = new GroupDAO();
    ArrayList<group> groupList = dao.getAllGroups();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그룹 관리 / X</title>
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
        padding: 40px 20px;
        color: #14171a;
    }
    
    .container { 
        background: white;
        max-width: 700px;
        margin: 0 auto;
        padding: 40px;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
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
    
    h2 { 
        color: #14171a;
        font-size: 32px;
        font-weight: 800;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .subtitle {
        color: #657786;
        font-size: 15px;
        margin-bottom: 30px;
    }
    
    /* 그룹 생성 박스 */
    .create-box { 
        display: flex;
        gap: 12px;
        margin-bottom: 40px;
        padding-bottom: 30px;
        border-bottom: 2px solid #e1e8ed;
    }
    
    .input-text { 
        flex: 1;
        padding: 14px 18px;
        border: 2px solid #e1e8ed;
        border-radius: 12px;
        font-size: 15px;
        transition: all 0.3s ease;
        background: #f7f9fa;
    }
    
    .input-text:focus {
        outline: none;
        border-color: #1da1f2;
        background: white;
        box-shadow: 0 0 0 4px rgba(29, 161, 242, 0.1);
    }
    
    .input-text::placeholder {
        color: #a0aec0;
    }
    
    .btn { 
        padding: 14px 28px;
        border: none;
        border-radius: 12px;
        font-weight: 700;
        cursor: pointer;
        font-size: 15px;
        transition: all 0.3s ease;
    }
    
    .btn-blue { 
        background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
        color: white;
        box-shadow: 0 4px 12px rgba(29, 161, 242, 0.3);
    }
    
    .btn-blue:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(29, 161, 242, 0.4);
    }
    
    .btn-blue:active {
        transform: translateY(0);
    }
    
    /* 그룹 리스트 */
    .list-box {
        margin-top: 20px;
    }
    
    .group-item { 
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 24px;
        border-radius: 16px;
        margin-bottom: 12px;
        background: linear-gradient(135deg, #f7f9fa 0%, #ffffff 100%);
        border: 2px solid #e1e8ed;
        transition: all 0.3s ease;
    }
    
    .group-item:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        border-color: #1da1f2;
    }
    
    .group-name { 
        font-weight: 700;
        font-size: 18px;
        color: #14171a;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .group-name::before {
        content: '#';
        color: #1da1f2;
        font-size: 22px;
    }
    
    .btn-join { 
        background: linear-gradient(135deg, #14171a 0%, #272c30 100%);
        color: white;
        padding: 10px 24px;
        border-radius: 9999px;
        border: none;
        font-weight: 700;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    
    .btn-join:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }
    
    .btn-joined { 
        background: white;
        color: #17bf63;
        border: 2px solid #17bf63;
        cursor: default;
        box-shadow: none;
    }
    
    .btn-joined:hover {
        transform: none;
        box-shadow: none;
    }
    
    /* 홈 링크 */
    .home-link {
        text-align: center;
        margin-top: 40px;
        padding-top: 30px;
        border-top: 1px solid #e1e8ed;
    }
    
    .home-link a {
        text-decoration: none;
        color: #1da1f2;
        font-weight: 700;
        font-size: 16px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 24px;
        border-radius: 20px;
        transition: all 0.2s ease;
    }
    
    .home-link a:hover {
        background-color: rgba(29, 161, 242, 0.1);
    }
    
    /* 빈 상태 */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #657786;
    }
    
    .empty-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .empty-state h3 {
        font-size: 24px;
        color: #14171a;
        margin-bottom: 12px;
    }
    
    .empty-state p {
        font-size: 16px;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>👥 그룹 관리</h2>
        <p class="subtitle">관심사가 비슷한 사람들과 그룹을 만들어보세요</p>
        
        <form action="group_action.jsp" method="post" class="create-box">
            <input type="hidden" name="action" value="create">
            <input type="text" 
                   name="groupName" 
                   class="input-text" 
                   placeholder="새 그룹 이름 입력 (예: 개발자 모임)" 
                   required
                   autofocus>
            <button type="submit" class="btn btn-blue">생성하기</button>
        </form>
        
        <h2 style="font-size: 24px; margin-bottom: 20px;">🔍 그룹 탐색 및 가입</h2>
        
        <div class="list-box">
            <% if(groupList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">👥</div>
                    <h3>생성된 그룹이 없습니다</h3>
                    <p>첫 번째 그룹을 만들어보세요!</p>
                </div>
            <% } else { %>
                <% for(group g : groupList) { 
                    boolean isJoined = dao.isJoined(myId, g.getSEQ_GROUP());
                %>
                <div class="group-item">
                    <span class="group-name"><%= g.getG_NAME() %></span>
                    <% if(isJoined) { %>
                        <button class="btn btn-joined" disabled>✓ 가입됨</button>
                    <% } else { %>
                        <button class="btn btn-join" onclick="location.href='group_action.jsp?action=join&seq=<%=g.getSEQ_GROUP()%>'">가입하기</button>
                    <% } %>
                </div>
                <% } %>
            <% } %>
        </div>
        
        <div class="home-link">
            <a href="main.jsp">🏠 홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
