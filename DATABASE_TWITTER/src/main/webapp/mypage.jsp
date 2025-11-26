<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DAO.PostDAO, DAO.FollowDAO" %>
<%@ page import="BEAN.user, BEAN.post" %>
<%@ page import="java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터 처리
    String userId = request.getParameter("id"); // 프로필 주인 ID
    String myId = (String) session.getAttribute("idKey"); // 현재 로그인한 내 ID

    // 파라미터 없으면 내 프로필로
    if (userId == null || userId.isEmpty()) {
        userId = myId;
    }

    // 로그인 안 했으면 로그인 페이지로
    if (myId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. DAO 객체 생성
    UserDAO userDAO = new UserDAO();
    PostDAO postDAO = new PostDAO();
    FollowDAO followDAO = new FollowDAO();

    // 3. 데이터 조회
    user member = userDAO.selectUserById(userId); // 프로필 주인 정보
    
    int postsCount = 0;
    int followersCount = 0;
    int followingCount = 0;
    String genderText = "정보 없음";
    
    // ⭐ 게시글 목록 담을 리스트
    ArrayList<post> userPosts = new ArrayList<>();

    if (member != null) {
        genderText = (member.getGENDER() == 1) ? "남성" : "여성";
        
        // 통계 정보 가져오기
        postsCount = postDAO.getPostCount(userId);
        followersCount = followDAO.getFollowerCount(userId);
        followingCount = followDAO.getFollowingCount(userId);
        
        // ⭐ 프로필 주인이 쓴 게시글 목록 가져오기
        userPosts = postDAO.getUserPosts(userId, myId);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= userId %>님의 프로필</title>
<style>
    /* CSS 변수 */
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
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background-color: var(--secondary);
        padding: 0; margin: 0;
    }
    a { text-decoration: none; color: inherit; }
    
    .profile-container {
        max-width: 600px;
        margin: 0 auto;
        background-color: var(--background);
        border-left: 1px solid var(--border);
        border-right: 1px solid var(--border);
        min-height: 100vh;
    }
    .profile-header {
        background-color: #555;
        height: 200px;
        position: relative;
    }
    .user-avatar-wrapper {
        padding: 0 16px;
        margin-top: -64px;
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
    }
    .profile-photo {
        width: 128px; height: 128px;
        border-radius: 50%;
        border: 4px solid var(--background);
        background-color: #ccc;
        background-image: url('default_profile.png');
        background-size: cover;
    }
    .edit-button {
        background-color: white;
        color: var(--primary);
        border: 1px solid #cfd9de;
        padding: 8px 16px;
        border-radius: 9999px;
        font-weight: bold;
        cursor: pointer;
    }
    .btn-logout {
        background-color: white;
        color: #f4212e; /* 경고용 빨간색 */
        border: 1px solid #fcfcfc;
        padding: 8px 16px;
        border-radius: 9999px;
        font-weight: bold;
        cursor: pointer;
        margin-left: 8px; /* 버튼 사이 간격 */
    }
    .btn-logout:hover {
        background-color: #ffFOFO; /* 연한 빨강 배경 */
        border-color: #f4212e;
    }
    
    .user-info-section { padding: 0 16px 20px 16px; }
    .user-name { font-size: 1.5rem; font-weight: bold; margin-top: 10px; margin-bottom: 4px; }
    .user-handle { color: var(--muted-foreground); font-size: 1rem; }
    .user-details { margin-top: 16px; color: var(--muted-foreground); font-size: 0.875rem; }
    .user-details div { margin-bottom: 4px; display: flex; align-items: center; gap: 8px; }
    
    .stats-grid { display: flex; gap: 16px; margin-top: 20px; }
    .stat-item { flex: 1; text-align: center; padding: 12px; border: 1px solid var(--border); border-radius: var(--radius); }
    .stat-value { font-size: 1.5rem; font-weight: bold; color: var(--primary); }
    .stat-label { font-size: 0.875rem; color: var(--muted-foreground); margin-top: 4px; }
    
    /* 네비게이션 */
    .top-nav { padding: 10px; font-weight: bold; color: white; position: absolute; top: 10px; left: 10px; z-index: 10; text-shadow: 0 0 5px rgba(0,0,0,0.5);}
    
    /* ▼▼▼ 게시글 리스트 스타일 (main.jsp와 동일) ▼▼▼ */
    .profile-tabs-list {
        display: grid; grid-template-columns: repeat(2, 1fr);
        border-bottom: 1px solid var(--border); margin-top: 24px;
    }
    .tab-trigger {
        text-align: center; padding: 12px 0; font-weight: 500; cursor: pointer;
        border-bottom: 2px solid transparent; color: var(--muted-foreground);
    }
    .tab-trigger.active {
        border-bottom-color: #1d9bf0; color: var(--primary); font-weight: bold;
    }
    
    .post-item { padding: 15px; border-bottom: 1px solid #eff3f4; display: flex; gap: 12px; cursor: pointer; transition: 0.2s; text-align: left; }
    .post-item:hover { background-color: #f7f9fa; }
    .post-content { flex: 1; }
    .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
    .post-user-name { font-weight: bold; font-size: 15px; color: #0f1419; }
    .post-user-id { color: #536471; font-size: 14px; margin-left: 5px; }
    .post-time { color: #536471; font-size: 14px; }
    .post-text { font-size: 15px; line-height: 20px; color: #0f1419; margin-bottom: 10px; white-space: pre-wrap; }
    .post-actions { display: flex; gap: 20px; color: #536471; font-size: 13px; }
    .action-btn { display: flex; align-items: center; gap: 5px; cursor: pointer; transition: 0.2s; border: none; background: none; color: inherit; }
    .action-btn.liked { color: #f91880; }
</style>
<script>
    // 좋아요 버튼 클릭 (main.jsp 로직 재사용)
    function likePost(postId) {
        // 좋아요 후 다시 현재 마이페이지로 돌아오게 처리
        // like_action2.jsp를 수정하거나, 간단히 여기서는 alert 처리 후 이동 등을 할 수 있음
        // 편의상 main.jsp의 로직을 따라가되, 돌아올 페이지를 명시하지 못하므로(현재 like_action2가 단순함)
        // 일단 알림만 띄웁니다. 완벽 구현을 위해서는 AJAX가 필요합니다.
        
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
                <div class="profile-photo"></div>
                
                <% if(userId.equals(myId)) { %>
                    <div>
                        <button class="edit-button" onclick="location.href='profile_edit.jsp'">
                            프로필 수정
                        </button>
                        <button class="btn-logout" onclick="if(confirm('정말 로그아웃 하시겠습니까?')) location.href='logout_action.jsp'">
                            로그아웃
                        </button>
                    </div>
                <% } else { %>
                    <button class="edit-button" onclick="toggleFollow('<%= userId %>')">
                        팔로우 / 언팔로우
                    </button>
                <% } %>
            </div>
            
            <div class="user-info-section">
                <div class="user-names">
                    <h1 class="user-name"><%= member.getNAME() %></h1>
                    <p class="user-handle">@<%= member.getIdUSER() %></p>
                </div>

                <div class="user-details">
                    <div>📅 가입일: (정보 없음)</div> 
                    <div>👤 성별: <%= genderText %></div>
                    <div>🎂 생년월일: <%= member.getBIRTH().toString() %></div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value"><%= postsCount %></div>
                        <div class="stat-label">게시물</div>
                    </div>
                    <div class="stat-item" style="cursor: pointer;" onclick="location.href='follow_list.jsp?id=<%= userId %>&mode=FOLLOWER'">
        <div class="stat-value"><%= followersCount %></div>
        <div class="stat-label">팔로워</div>
    </div>
    <div class="stat-item" style="cursor: pointer;" onclick="location.href='follow_list.jsp?id=<%= userId %>&mode=FOLLOWING'">
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
                        <div style="text-align:center; padding: 40px; color: #536471;">
                            아직 작성한 게시물이 없습니다.
                        </div>
                    <% } else { %>
                        <% for(post p : userPosts) { %>
                        <div class="post-item">
                            <div class="profile-photo" style="width: 40px; height: 40px; border:none;"></div>
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
                </div>
            
        <% } else { %>
            <div style="padding: 50px; text-align: center;">
                <h2>사용자를 찾을 수 없습니다.</h2>
                <a href="main.jsp" style="color: #1d9bf0;">홈으로 돌아가기</a>
            </div>
        <% } %>
    </div>
</body>
</html>
