<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%@ page import="BEAN.user" %> <%
request.setCharacterEncoding("UTF-8");
    // [Controller 역할]: URL 파라미터에서 현재 로그인한 사용자 ID를 가져옵니다.
    String userId = request.getParameter("id"); 
    
    // ⭐ 수정: UserVO -> user
    user member = null;
    String genderText = "정보 없음";
    
    // ID가 null이 아니거나 비어있지 않은 경우에만 DB 조회를 실행합니다.
    if (userId != null && !userId.isEmpty()) {
        UserDAO dao = new UserDAO();
        member = dao.selectUserById(userId);
        
        if (member != null) {
            // 성별 코드 변환 (1: 남성, 0: 여성)
            genderText = (member.getGENDER() == 1) ? "남성" : "여성";
        }
    }

    // [임시 데이터] 팔로워, 팔로잉, 게시물 수 (실제 DB 연동 필요)
    int postsCount = 15;
    int followersCount = 1200;
    int followingCount = 350;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= userId %>님의 프로필</title>
<style>
/* CSS 변수 (globals.css에서 핵심 디자인 추출) */
:root {
    --background: #ffffff;
    --foreground: oklch(0.145 0 0);
    --primary: #030213;
    --primary-foreground: oklch(1 0 0);
    --secondary: #ececf0; /* muted */
    --muted-foreground: #717182;
    --border: rgba(0, 0, 0, 0.1);
    --radius: 0.625rem;
    --font-weight-medium: 500;
}

/* 기본 스타일 */
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    background-color: var(--secondary); /* 전체 배경색 */
    padding: 0;
    margin: 0;
}
.profile-container {
    max-width: 600px;
    margin: 0 auto;
    background-color: var(--background);
    border: 1px solid var(--border);
    min-height: 100vh;
}
.p-4 { padding: 16px; }
.pt-6 { padding-top: 24px; }
.mt-4 { margin-top: 16px; }

/* 1. 헤더 영역 (ProfilePage.tsx 상단 배경) */
.profile-header {
    background-color: #555; /* 임시 배경색 */
    height: 200px;
    position: relative;
}
.user-avatar-wrapper {
    padding: 0 16px; /* 좌우 패딩 */
    margin-top: -64px; /* 아바타를 헤더 위로 올림 (size-32 / 2) */
    position: relative;
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
}
.profile-photo {
    width: 128px; /* size-32 */
    height: 128px;
    border-radius: 50%;
    border: 4px solid var(--background); /* 흰색 배경 테두리 */
    background-color: #ccc; 
    flex-shrink: 0;
}
.edit-button {
    background-color: var(--primary);
    color: var(--primary-foreground);
    border: 1px solid var(--border);
    padding: 8px 16px;
    border-radius: 9999px; /* full rounded */
    font-size: 0.875rem;
    font-weight: var(--font-weight-medium);
    cursor: pointer;
    transition: background-color 0.2s;
}
.edit-button:hover {
    opacity: 0.9;
}

/* 2. 사용자 정보 영역 */
.user-info-section {
    padding: 0 16px 20px 16px;
}
.user-name {
    font-size: 1.5rem; /* text-2xl */
    font-weight: bold;
    margin-top: 10px;
    margin-bottom: 4px;
}
.user-handle {
    color: var(--muted-foreground);
    font-size: 1rem;
}
.user-details {
    margin-top: 16px;
    color: var(--muted-foreground);
    font-size: 0.875rem; /* text-sm */
}
.user-details div {
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 8px;
}
.icon {
    width: 16px;
    height: 16px;
    fill: currentColor;
    /* Calendar, User Icon 대체 */
}

/* 3. 통계 및 탭 영역 */
.stats-grid {
    display: flex;
    gap: 16px;
    margin-top: 20px;
}
.stat-item {
    flex: 1;
    text-align: center;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
}
.stat-value {
    font-size: 1.5rem; /* text-2xl */
    font-weight: bold;
    color: var(--primary);
}
.stat-label {
    font-size: 0.875rem;
    color: var(--muted-foreground);
    margin-top: 4px;
}

/* 4. 프로필 탭 (Posts, About) */
.profile-tabs-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    border-bottom: 1px solid var(--border);
    margin-top: 24px;
}
.tab-trigger {
    text-align: center;
    padding: 12px 0;
    font-weight: var(--font-weight-medium);
    cursor: pointer;
    border-bottom: 2px solid transparent;
    color: var(--muted-foreground);
    transition: border-color 0.2s, color 0.2s;
}
.tab-trigger.active {
    border-bottom-color: #1DA1F2; /* X/Twitter Blue */
    color: var(--primary);
}

/* 5. 탭 내용 영역 */
.tab-content {
    padding: 16px;
    color: var(--muted-foreground);
    text-align: center;
}
</style>
</head>
<body>
    <div class="profile-container">
        
        <% if (member != null) { %>
        
            <div class="profile-header"></div>
            
            <div class="user-avatar-wrapper">
                <div class="profile-photo"></div>
                <button class="edit-button">
                    <span style="color: white;">회원 정보 수정</span></button>
            </div>
            
            <div class="user-info-section">
                <div class="user-names">
                    <%-- ⭐ 수정: member.getName() -> member.getNAME() --%>
                    <h1 class="user-name"><%= member.getNAME() %></h1>
                    <%-- ⭐ 수정: member.getIdUser() -> member.getIdUSER() --%>
                    <p class="user-handle">@<%= member.getIdUSER() %></p>
                </div>

                <div class="user-details">
                    <div><span class="icon">📅</span> 가입일: 2024년 11월 22일 (가정)</div>
                    <div><span class="icon">👤</span> 성별: <%= genderText %></div>
                    <%-- ⭐ 수정: member.getBirth() -> member.getBIRTH().toString() --%>
                    <div><span class="icon">🎂</span> 생년월일: <%= member.getBIRTH().toString() %></div>
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

                <div class="profile-tabs-list">
                    <div class="tab-trigger active">게시물</div>
                    <div class="tab-trigger">정보</div>
                </div>
                
                <div class="tab-content">
                    <p>게시물이 여기에 표시됩니다. (PostCard.tsx 적용 필요)</p>
                </div>
            </div>
            
        <% } else { %>
            <div class="pt-6 p-4">
                <p>사용자 정보가 없습니다. 로그인이 필요합니다.</p>
                <p><a href="login.jsp" style="color: #1DA1F2; text-decoration: none;">로그인 페이지로 이동</a></p>
            </div>
        <% } %>
    </div>
</body>
</html>