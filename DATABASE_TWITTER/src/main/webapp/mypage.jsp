<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DAO.PostDAO, DAO.FollowDAO" %>
<%@ page import="BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터로 조회할 대상 ID 가져오기
    String userId = request.getParameter("id"); 
    
    // 만약 파라미터가 없으면, 현재 로그인한 사람(세션)을 보여줌
    if (userId == null || userId.isEmpty()) {
        userId = (String) session.getAttribute("idKey");
    }

    // 로그인도 안되어 있고 파라미터도 없으면 로그인 페이지로 보냄
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. DAO 객체 생성
    UserDAO userDAO = new UserDAO();
    PostDAO postDAO = new PostDAO();
    FollowDAO followDAO = new FollowDAO();

    // 3. 데이터 조회
    user member = userDAO.selectUserById(userId);
    
    // 카운트 변수 초기화 (DB에서 가져온 값으로 채움)
    int postsCount = 0;
    int followersCount = 0;
    int followingCount = 0;
    String genderText = "정보 없음";

    if (member != null) {
        // 성별 변환
        genderText = (member.getGENDER() == 1) ? "남성" : "여성";
        
        // ⭐ DB에서 실제 데이터 개수 가져오기 ⭐
        postsCount = postDAO.getPostCount(userId);
        followersCount = followDAO.getFollowerCount(userId); // 나를 팔로우한 사람
        followingCount = followDAO.getFollowingCount(userId); // 내가 팔로우한 사람
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= userId %>님의 프로필</title>
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
        --font-weight-medium: 500;
    }
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background-color: var(--secondary);
        padding: 0; margin: 0;
    }
    .profile-container {
        max-width: 600px;
        margin: 0 auto;
        background-color: var(--background);
        border: 1px solid var(--border);
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
        background-image: url('default_profile.png'); /* 이미지 경로 확인 필요 */
        background-size: cover;
    }
    .edit-button {
        background-color: white; /* 버튼 배경 수정 */
        color: var(--primary);
        border: 1px solid #cfd9de;
        padding: 8px 16px;
        border-radius: 9999px;
        font-weight: bold;
        cursor: pointer;
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
    
    /* 네비게이션용 추가 스타일 */
    .top-nav { padding: 10px; font-weight: bold; color: white; position: absolute; top: 10px; left: 10px; z-index: 10; text-shadow: 0 0 5px rgba(0,0,0,0.5);}
    .top-nav a { text-decoration: none; color: white; }
</style>
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
                <% if(userId.equals(session.getAttribute("idKey"))) { %>
                    <button class="edit-button" onclick="alert('프로필 수정 기능은 준비중입니다.')">
                        프로필 수정
                    </button>
                <% } else { 
                     // 타인인 경우 팔로우 버튼 등을 넣을 수 있음
                %>
                    <button class="edit-button" onclick="alert('팔로우 기능은 검색 페이지를 이용해주세요.')">
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
                    <div class="stat-item">
                        <div class="stat-value"><%= followersCount %></div>
                        <div class="stat-label">팔로워</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><%= followingCount %></div>
                        <div class="stat-label">팔로잉</div>
                    </div>
                </div>
                
                <div style="margin-top: 30px; text-align: center; color: #717182; padding: 40px; border-top: 1px solid #eff3f4;">
                    작성한 게시물이 아래에 표시될 예정입니다.<br>
                    (PostDAO.getTimeline 메서드 수정 필요)
                </div>
            </div>
            
        <% } else { %>
            <div style="padding: 50px; text-align: center;">
                <h2>사용자를 찾을 수 없습니다.</h2>
                <p>존재하지 않는 아이디이거나 삭제된 계정입니다.</p>
                <a href="main.jsp" style="color: #1DA1F2;">홈으로 돌아가기</a>
            </div>
        <% } %>
    </div>
</body>
</html>
