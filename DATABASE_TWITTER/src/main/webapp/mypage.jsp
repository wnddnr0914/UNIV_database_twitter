<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DAO.PostDAO, DAO.FollowDAO" %>
<%@ page import="BEAN.user, BEAN.post" %>
<%@ page import="java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("id");
    String myId = (String) session.getAttribute("idKey");

    if (userId == null || userId.isEmpty()) {
        userId = myId;
    }

    if (myId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    PostDAO postDAO = new PostDAO();
    FollowDAO followDAO = new FollowDAO();

    user member = userDAO.selectUserById(userId);
    
    int postsCount = 0;
    int followersCount = 0;
    int followingCount = 0;
    String genderText = "정보 없음";
    
    ArrayList<post> userPosts = new ArrayList<>();

    if (member != null) {
        genderText = (member.getGENDER() == 1) ? "남성" : "여성";
        postsCount = postDAO.getPostCount(userId);
        followersCount = followDAO.getFollowerCount(userId);
        followingCount = followDAO.getFollowingCount(userId);
        userPosts = postDAO.getUserPosts(userId, myId);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= userId %>님의 프로필 / X</title>
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
    }
    
    a { 
        text-decoration: none; 
        color: inherit; 
    }
    
    .profile-container {
        max-width: 600px;
        margin: 0 auto;
        background-color: white;
        box-shadow: 0 0 20px rgba(0,0,0,0.08);
        min-height: 100vh;
    }
    
    /* 헤더 배너 - 그라디언트 */
    .profile-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        height: 200px;
        position: relative;
        box-shadow: inset 0 -2px 10px rgba(0,0,0,0.1);
    }
    
    /* 돌아가기 버튼 */
    .top-nav {
        padding: 15px 20px;
        position: absolute;
        top: 0;
        left: 0;
        z-index: 10;
    }
    
    .top-nav a {
        color: white;
        font-weight: 600;
        font-size: 15px;
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        border-radius: 20px;
        transition: all 0.2s ease;
        background: rgba(0,0,0,0.2);
        backdrop-filter: blur(10px);
    }
    
    .top-nav a:hover {
        background: rgba(0,0,0,0.3);
    }
    
    /* 프로필 정보 영역 */
    .user-avatar-wrapper {
        padding: 0 20px;
        margin-top: -70px;
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 15px;
    }
    
    .profile-photo {
        width: 140px;
        height: 140px;
        border-radius: 50%;
        border: 5px solid white;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        background-size: cover;
        background-position: center;
        box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        transition: all 0.3s ease;
    }
    
    .profile-photo:hover {
        transform: scale(1.05);
        box-shadow: 0 12px 32px rgba(0,0,0,0.25);
    }
    
    .action-buttons {
        display: flex;
        gap: 10px;
    }
    
    .edit-button,
    .btn-logout,
    .btn-follow {
        background-color: white;
        color: #14171a;
        border: 2px solid #e1e8ed;
        padding: 10px 20px;
        border-radius: 9999px;
        font-weight: 700;
        cursor: pointer;
        font-size: 15px;
        transition: all 0.2s ease;
    }
    
    .edit-button:hover,
    .btn-follow:hover {
        background-color: #f7f9fa;
        border-color: #657786;
    }
    
    .btn-logout {
        color: #f4212e;
        border-color: #ffcdd2;
    }
    
    .btn-logout:hover {
        background-color: rgba(244, 33, 46, 0.1);
        border-color: #f4212e;
    }
    
    /* 사용자 정보 섹션 */
    .user-info-section { 
        padding: 0 20px 20px;
    }
    
    .user-names {
        margin-bottom: 15px;
    }
    
    .user-name { 
        font-size: 24px;
        font-weight: 800;
        margin-bottom: 4px;
        color: #14171a;
    }
    
    .user-handle { 
        color: #657786;
        font-size: 16px;
        font-weight: 400;
    }

    .user-details { 
        margin-top: 20px;
        color: #657786;
        font-size: 15px;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    
    .user-details div { 
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .user-details div span:first-child {
        font-size: 18px;
    }
    
    /* 통계 그리드 */
    .stats-grid { 
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
        margin-top: 25px;
    }
    
    .stat-item { 
        text-align: center;
        padding: 20px 15px;
        background: linear-gradient(135deg, #f7f9fa 0%, #ffffff 100%);
        border: 1px solid #e1e8ed;
        border-radius: 16px;
        transition: all 0.3s ease;
        cursor: pointer;
    }
    
    .stat-item:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        border-color: #1da1f2;
    }
    
    .stat-value { 
        font-size: 28px;
        font-weight: 800;
        color: #14171a;
        margin-bottom: 6px;
    }
    
    .stat-label { 
        font-size: 14px;
        color: #657786;
        font-weight: 600;
    }
    
    /* 탭 네비게이션 */
    .profile-tabs-list {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        border-bottom: 1px solid #e1e8ed;
        margin-top: 30px;
        position: sticky;
        top: 0;
        background: white;
        z-index: 100;
    }
    
    .tab-trigger {
        text-align: center;
        padding: 16px 0;
        font-weight: 600;
        cursor: pointer;
        border-bottom: 3px solid transparent;
        color: #657786;
        transition: all 0.2s ease;
        font-size: 15px;
    }
    
    .tab-trigger.active {
        border-bottom-color: #1da1f2;
        color: #14171a;
        font-weight: 700;
    }
    
    .tab-trigger:hover:not(.active) {
        background-color: #f7f9fa;
        color: #14171a;
    }
    
    /* 게시물 리스트 */
    .post-list {
        background: white;
    }
    
    .post-item { 
        padding: 20px;
        border-bottom: 1px solid #e1e8ed;
        display: flex;
        gap: 15px;
        transition: all 0.2s ease;
    }
    
    .post-item:hover { 
        background-color: #f7f9fa;
    }
    
    .post-content { 
        flex: 1;
    }
    
    .post-header { 
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }
    
    .post-user-name { 
        font-weight: 700;
        font-size: 15px;
        color: #14171a;
    }
    
    .post-user-id { 
        color: #657786;
        font-size: 14px;
        margin-left: 6px;
    }
    
    .post-time { 
        color: #657786;
        font-size: 14px;
    }
    
    .post-text { 
        font-size: 15px;
        line-height: 1.6;
        color: #14171a;
        margin-bottom: 12px;
        white-space: pre-wrap;
    }
    
    .post-actions { 
        display: flex;
        gap: 60px;
        color: #657786;
        font-size: 13px;
        margin-top: 10px;
    }
    
    .action-btn { 
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        border: none;
        background: none;
        color: inherit;
        padding: 6px 10px;
        border-radius: 20px;
        transition: all 0.2s ease;
        font-weight: 500;
    }
    
    .action-btn:hover {
        color: #1da1f2;
        background-color: rgba(29, 161, 242, 0.1);
    }
    
    .action-btn.liked { 
        color: #e0245e;
    }
    
    .action-btn.liked:hover {
        background-color: rgba(224, 36, 94, 0.1);
    }
    
    /* 빈 상태 */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        color: #657786;
    }
    
    .empty-state-icon {
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
        font-size: 15px;
    }
    
    /* 404 에러 상태 */
    .error-state {
        padding: 100px 20px;
        text-align: center;
    }
    
    .error-state h2 {
        font-size: 32px;
        color: #14171a;
        margin-bottom: 16px;
    }
    
    .error-state a {
        color: #1da1f2;
        font-weight: 600;
        display: inline-block;
        margin-top: 20px;
        padding: 12px 24px;
        border-radius: 20px;
        transition: all 0.2s ease;
    }
    
    .error-state a:hover {
        background-color: rgba(29, 161, 242, 0.1);
    }
</style>
<script>
    function likePost(postId) {
        if(confirm("좋아요를 변경하시겠습니까? (메인으로 이동합니다)")) {
             location.href = 'like_action2.jsp?id=' + postId + '&tab=ALL';
        }
    }
    
    function toggleFollow(targetId) {
        location.href = "follow_proc.jsp?targetId=" + targetId + "&keyword=&page=1";
    }
</script>
</head>
<body>
    <div class="profile-container">
        <div class="top-nav">
            <a href="main.jsp">← 홈으로 돌아가기</a>
        </div>

        <% if (member != null) { %>
        
            <div class="profile-header"></div>
            
            <div class="user-avatar-wrapper">
                <div class="profile-photo" 
                     style="background-image: url('<%= member.getProfileImage() %>'); background-size: cover;">
                </div>
                
                <% if(userId.equals(myId)) { %>
                    <div class="action-buttons">
                        <button class="edit-button" onclick="location.href='profile_edit.jsp'">
                            프로필 수정
                        </button>
                        <button class="btn-logout" onclick="if(confirm('정말 로그아웃 하시겠습니까?')) location.href='logout_action.jsp'">
                            로그아웃
                        </button>
                    </div>
                <% } else { %>
                    <button class="btn-follow" onclick="toggleFollow('<%= userId %>')">
                        팔로우
                    </button>
                <% } %>
            </div>
            
            <div class="user-info-section">
                <div class="user-names">
                    <h1 class="user-name"><%= member.getNAME() %></h1>
                    <p class="user-handle">@<%= member.getIdUSER() %></p>
                </div>

                <div class="user-details">
                    <div>
                        <span>📅</span>
                        <span>가입일: <%= member.getJOIN_DATE() != null ? member.getJOIN_DATE().toString().substring(0, 10) : "정보 없음" %></span>
                    </div>
                    <div>
                        <span>👤</span>
                        <span>성별: <%= genderText %></span>
                    </div>
                    <div>
                        <span>🎂</span>
                        <span>생년월일: <%= member.getBIRTH().toString() %></span>
                    </div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value"><%= postsCount %></div>
                        <div class="stat-label">게시물</div>
                    </div>
                    <div class="stat-item" onclick="location.href='follow_list.jsp?id=<%= userId %>&mode=FOLLOWER'">
                        <div class="stat-value"><%= followersCount %></div>
                        <div class="stat-label">팔로워</div>
                    </div>
                    <div class="stat-item" onclick="location.href='follow_list.jsp?id=<%= userId %>&mode=FOLLOWING'">
                        <div class="stat-value"><%= followingCount %></div>
                        <div class="stat-label">팔로잉</div>
                    </div>
                </div>
            </div>
            
            <div class="profile-tabs-list">
                <div class="tab-trigger active">게시물</div>
                <div class="tab-trigger">답글</div>
            </div>
            
            <div class="post-list">
                <% if(userPosts.size() == 0) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📝</div>
                        <h3>아직 작성한 게시물이 없습니다</h3>
                        <% if(userId.equals(myId)) { %>
                            <p>첫 번째 게시물을 작성해보세요!</p>
                        <% } %>
                    </div>
                <% } else { %>
                    <% for(post p : userPosts) { %>
                    <div class="post-item">
                        <div class="profile-photo" 
                             style="width: 48px; height: 48px; background-image: url('<%= member.getProfileImage() %>'); background-size: cover;">
                        </div>
                        
                        <div class="post-content">
                            <div class="post-header">
                                <div>
                                    <span class="post-user-name"><%= p.getUserName() %></span>
                                    <span class="post-user-id">@<%= p.getUser() %></span>
                                    <span class="post-time"> · <%= p.getDate().toString().substring(0, 16) %></span>
                                </div>
                            </div>
                            
                            <div class="post-text"><%= p.getDetail() %></div>
        
                            <div class="post-actions">
                                <button class="action-btn">💬 0</button>
                                <button class="action-btn">🔁 0</button>
                                <button class="action-btn <%= p.isLiked() ? "liked" : "" %>" onclick="likePost(<%= p.getIdPOST() %>)">
                                    <%= p.isLiked() ? "❤️" : "🤍" %> <%= p.getLikeCount() %>
                                </button>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>
            
        <% } else { %>
            <div class="error-state">
                <h2>😕 사용자를 찾을 수 없습니다</h2>
                <p>해당 사용자가 존재하지 않거나 삭제되었습니다.</p>
                <a href="main.jsp">홈으로 돌아가기</a>
            </div>
        <% } %>
    </div>
</body>
</html>
