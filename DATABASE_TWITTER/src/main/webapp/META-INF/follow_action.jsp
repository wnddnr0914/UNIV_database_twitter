<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jdbc.FollowDAO" %>
<%@ page import="BEAN.follow" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐ (로직은 그대로 유지)
    request.setCharacterEncoding("UTF-8"); 
    
    String action = request.getParameter("action");
    String followingId = request.getParameter("followingId");
    String followerId = request.getParameter("followerId");
    
    boolean success = false;
    String message = "";
    
    if (followingId == null || followingId.isEmpty()) {
        followingId = "testuser";
    }
    
    if (followingId != null && followerId != null && action != null) {
        
        FollowDAO followDAO = new FollowDAO();
        follow followBean = new follow();
        followBean.setFollowing(followingId);
        followBean.setFollower(followerId);
        
        if (action.equals("follow")) {
            success = followDAO.insertFollow(followBean);
            message = success ? followerId + "님을 팔로우했습니다." : "팔로우에 실패했습니다. (이미 팔로우 중이거나 ID 오류)";
            
        } else if (action.equals("unfollow")) {
            success = followDAO.deleteFollow(followBean);
            message = success ? followerId + "님을 언팔로우했습니다." : "언팔로우에 실패했습니다.";
        }
    } else {
        message = "필수 정보가 누락되었습니다. (액션 또는 대상 ID)";
    }
    
    // JSP 변수: 메시지에 따라 상태 클래스 결정 (성공/실패)
    String statusClass = (success && message.contains("성공")) ? "status-success" : "status-failure";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팔로우 처리 결과</title>
    <style>
        /* CSS 변수 (globals.css에서 핵심 디자인 추출) */
        :root {
            --background: #ffffff;
            --foreground: oklch(0.145 0 0);
            --primary: #030213; /* Black */
            --primary-foreground: oklch(1 0 0); /* White */
            --destructive: #d4183d; /* Red for errors */
            --radius: 0.625rem;
            --border: rgba(0, 0, 0, 0.1);
        }
        body {
            background-color: #f7f9f9; /* Light background */
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card {
            background: var(--background);
            border-radius: var(--radius);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 450px;
            text-align: center;
            border: 1px solid var(--border);
        }
        .result-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 15px;
        }
        .status-message {
            font-size: 1.1rem;
            margin-bottom: 25px;
            padding: 10px 0;
            border-top: 1px dashed var(--border);
            border-bottom: 1px dashed var(--border);
        }
        .status-success {
            color: green; /* 성공 메시지 색상 */
        }
        .status-failure {
            color: var(--destructive); /* 실패 메시지 색상 */
        }
        .link-group a {
            display: block;
            margin-top: 10px;
            color: #1DA1F2; /* Twitter Blue */
            text-decoration: none;
            font-weight: 500;
        }
        .link-group a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1 class="result-title">처리 완료</h1>
        
        <p class="status-message <%= statusClass %>">
            <%= message %>
        </p>
        
        <div class="link-group">
            <a href="mypage.jsp?id=<%= followingId %>">내 마이페이지로 돌아가기</a>
            <a href="mypage.jsp?id=<%= followerId %>">대상 마이페이지로 이동 (확인)</a>
        </div>
    </div>
</body>
</html>