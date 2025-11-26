<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.FollowDAO, BEAN.user, java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    if (myId == null) { response.sendRedirect("login.jsp"); return; }

    String targetId = request.getParameter("id"); // 누구의 리스트인가
    String mode = request.getParameter("mode");   // FOLLOWER or FOLLOWING
    
    if(targetId == null || mode == null) { response.sendRedirect("main.jsp"); return; }

    FollowDAO dao = new FollowDAO();
    // 리스트 가져오기
    ArrayList<user> list = dao.getFollowList(targetId, myId, mode);
    
    String title = mode.equals("FOLLOWER") ? "팔로워" : "팔로잉";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= targetId %>님의 <%= title %></title>
<style>
    body { font-family: -apple-system, sans-serif; margin: 0; background-color: rgba(0,0,0,0.4); display: flex; justify-content: center; align-items: center; height: 100vh; }
    .modal-box { width: 400px; height: 600px; background: white; border-radius: 16px; overflow: hidden; display: flex; flex-direction: column; }
    
    .header { padding: 10px 15px; border-bottom: 1px solid #eff3f4; display: flex; align-items: center; gap: 20px; font-weight: bold; font-size: 20px; }
    .btn-back { cursor: pointer; border: none; background: none; font-size: 20px; }
    
    .list-area { flex: 1; overflow-y: auto; }
    
    .user-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eff3f4; transition: 0.2s; }
    .user-item:hover { background-color: #f7f9fa; }
    .profile-img { width: 48px; height: 48px; border-radius: 50%; background-color: #ccc; margin-right: 12px; cursor: pointer; }
    
    .user-info { flex: 1; cursor: pointer; }
    .user-name { font-weight: bold; font-size: 15px; }
    .user-id { color: #536471; font-size: 14px; }
    
    .btn-follow { background-color: #0f1419; color: white; border: none; padding: 6px 16px; border-radius: 9999px; font-weight: bold; cursor: pointer; font-size: 14px; }
    .btn-following { background-color: white; color: #0f1419; border: 1px solid #cfd9de; }
    .btn-following:hover { background-color: #ffeaea; color: red; border-color: #f4212e; color: #f4212e; } /* 호버시 빨간색 */
</style>
<script>
    function toggleFollow(userId) {
        // 현재 페이지 정보를 from 파라미터로 넘김
        location.href = "follow_proc.jsp?targetId=" + userId + "&from=list&listId=<%=targetId%>&mode=<%=mode%>";
    }
</script>
</head>
<body>
    <div class="modal-box">
        <div class="header">
            <button class="btn-back" onclick="location.href='mypage.jsp?id=<%=targetId%>'">←</button>
            <span><%= title %></span>
        </div>
        
        <div class="list-area">
            <% if(list.isEmpty()) { %>
                <div style="text-align:center; padding: 50px; color:#536471;">목록이 없습니다.</div>
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