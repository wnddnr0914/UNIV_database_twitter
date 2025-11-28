<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.FollowDAO, BEAN.user, java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    if (myId == null) { response.sendRedirect("login.jsp"); return; }

    String targetId = request.getParameter("id");
    String mode = request.getParameter("mode");
    
    if(targetId == null || mode == null) { response.sendRedirect("main.jsp"); return; }

    FollowDAO dao = new FollowDAO();
    ArrayList<user> list = dao.getFollowList(targetId, myId, mode);
    
    String title = mode.equals("FOLLOWER") ? "팔로워" : "팔로잉";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= targetId %>님의 <%= title %> / X</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    
    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        margin: 0;
        background: linear-gradient(135deg, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.7) 100%);
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        padding: 20px;
    }
    
    .modal-box { 
        width: 100%;
        max-width: 500px;
        height: 700px;
        background: white;
        border-radius: 20px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        animation: modalIn 0.3s ease-out;
    }
    
    @keyframes modalIn {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    
    .header { 
        padding: 20px 24px;
        border-bottom: 1px solid #e1e8ed;
        display: flex;
        align-items: center;
        gap: 20px;
        background: linear-gradient(135deg, #f7f9fa 0%, #ffffff 100%);
    }
    
    .btn-back { 
        cursor: pointer;
        border: none;
        background: none;
        font-size: 24px;
        color: #14171a;
        padding: 8px;
        border-radius: 50%;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
    }
    
    .btn-back:hover {
        background: rgba(29, 161, 242, 0.1);
        color: #1da1f2;
    }
    
    .header-title {
        font-weight: 800;
        font-size: 24px;
        color: #14171a;
    }
    
    .list-area { 
        flex: 1;
        overflow-y: auto;
        background: white;
    }
    
    /* 스크롤바 스타일 */
    .list-area::-webkit-scrollbar {
        width: 8px;
    }
    
    .list-area::-webkit-scrollbar-track {
        background: #f7f9fa;
    }
    
    .list-area::-webkit-scrollbar-thumb {
        background: #e1e8ed;
        border-radius: 4px;
    }
    
    .list-area::-webkit-scrollbar-thumb:hover {
        background: #657786;
    }
    
    .user-item { 
        display: flex;
        align-items: center;
        padding: 18px 24px;
        border-bottom: 1px solid #e1e8ed;
        transition: all 0.2s ease;
    }
    
    .user-item:hover { 
        background-color: #f7f9fa;
    }
    
    .profile-img { 
        width: 52px;
        height: 52px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        margin-right: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    
    .profile-img:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    
    .user-info { 
        flex: 1;
        cursor: pointer;
    }
    
    .user-name { 
        font-weight: 700;
        font-size: 16px;
        color: #14171a;
        margin-bottom: 2px;
    }
    
    .user-id { 
        color: #657786;
        font-size: 15px;
    }
    
    .btn-follow { 
        background-color: #14171a;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 9999px;
        font-weight: 700;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.2s ease;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    
    .btn-follow:hover { 
        background-color: #272c30;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }
    
    .btn-following { 
        background-color: white;
        color: #14171a;
        border: 2px solid #e1e8ed;
        box-shadow: none;
    }
    
    .btn-following:hover { 
        background-color: rgba(244, 33, 46, 0.1);
        color: #f4212e;
        border-color: rgba(244, 33, 46, 0.4);
    }
    
    /* 빈 상태 */
    .empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        color: #657786;
        padding: 40px 20px;
    }
    
    .empty-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .empty-state h3 {
        font-size: 22px;
        color: #14171a;
        margin-bottom: 10px;
    }
    
    .empty-state p {
        font-size: 15px;
        text-align: center;
    }
    
    /* 카운트 뱃지 */
    .count-badge {
        background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
        color: white;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 13px;
        font-weight: 700;
        margin-left: auto;
    }
</style>
<script>
    function toggleFollow(userId) {
        location.href = "follow_proc.jsp?targetId=" + userId + "&from=list&listId=<%=targetId%>&mode=<%=mode%>";
    }
</script>
</head>
<body>
    <div class="modal-box">
        <div class="header">
            <button class="btn-back" onclick="location.href='mypage.jsp?id=<%=targetId%>'">←</button>
            <span class="header-title"><%= title %></span>
            <span class="count-badge"><%= list.size() %></span>
        </div>
        
        <div class="list-area">
            <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">👥</div>
                    <h3><%= title %> 목록이 비어있습니다</h3>
                    <% if(mode.equals("FOLLOWER")) { %>
                        <p>아직 이 사용자를 팔로우한 사람이 없습니다</p>
                    <% } else { %>
                        <p>아직 팔로우한 사용자가 없습니다</p>
                    <% } %>
                </div>
            <% } else { %>
                <% for(user u : list) { %>
                <div class="user-item">
                    <div class="profile-img" onclick="location.href='mypage.jsp?id=<%=u.getIdUSER()%>'"></div>
                    
                    <div class="user-info" onclick="location.href='mypage.jsp?id=<%=u.getIdUSER()%>'">
                        <div class="user-name"><%= u.getNAME() %></div>
                        <div class="user-id">@<%= u.getIdUSER() %></div>
                    </div>
                    
                    <% if(!u.getIdUSER().equals(myId)) { %>
                        <div>
                            <% if(u.isFollowed()) { %>
                                <button class="btn-follow btn-following" onclick="toggleFollow('<%=u.getIdUSER()%>')">팔로잉</button>
                            <% } else { %>
                                <button class="btn-follow" onclick="toggleFollow('<%=u.getIdUSER()%>')">팔로우</button>
                            <% } %>
                        </div>
                    <% } %>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>
