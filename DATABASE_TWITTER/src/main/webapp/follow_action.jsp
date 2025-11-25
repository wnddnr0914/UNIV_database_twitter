<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.FollowDAO" %>
<%@ page import="BEAN.follow" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐
    request.setCharacterEncoding("UTF-8"); 
    
    // 1. 로그인 체크 (세션 확인)
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

    // 2. 파라미터 받기
    String action = request.getParameter("action");     // "follow" 또는 "unfollow"
    String targetId = request.getParameter("targetId"); // 상대방 ID (기존 followerId)
    
    boolean success = false;
    String message = "";
    
    // 3. 유효성 검사 및 DB 처리
    if (targetId != null && !targetId.isEmpty() && action != null) {
        
        FollowDAO followDAO = new FollowDAO();
        follow followBean = new follow();
        
        // ⭐ DAO 주석 기준: FOLLOWING이 '나', FOLLOWER가 '상대방'
        followBean.setFollowing(myId);  // 나 (주체)
        followBean.setFollower(targetId); // 상대방 (대상)
        
        if (action.equals("follow")) {
            // 팔로우 추가
            success = followDAO.insertFollow(followBean);
            message = success ? targetId + "님을 팔로우했습니다. 🎉" : "팔로우 실패 (이미 팔로우 중이거나 오류 발생)";
            
        } else if (action.equals("unfollow")) {
            // 언팔로우 삭제
            success = followDAO.deleteFollow(followBean);
            message = success ? targetId + "님을 언팔로우했습니다. 👋" : "언팔로우 실패 (시스템 오류)";
        }
        
    } else {
        message = "필수 정보가 누락되었습니다. (잘못된 접근)";
    }
    
    // JSP 변수: 메시지에 따라 상태 클래스 결정 (성공/실패)
    // 성공 메시지나 '했습니다'가 포함되면 성공 스타일 적용
    boolean isSuccess = message.contains("했습니다");
    String statusClass = isSuccess ? "status-success" : "status-failure";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팔로우 처리 결과</title>
    <style>
        /* CSS 변수 (globals.css 스타일 유지) */
        :root {
            --background: #ffffff;
            --foreground: oklch(0.145 0 0);
            --primary: #030213;
            --primary-foreground: oklch(1 0 0);
            --destructive: #d4183d;
            --radius: 0.625rem;
            --border: rgba(0, 0, 0, 0.1);
        }
        body {
            background-color: #f7f9f9;
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
        .status-success { color: #1d9bf0; font-weight: bold; } /* 트위터 블루 */
        .status-failure { color: var(--destructive); font-weight: bold; }
        
        .link-group a {
            display: block;
            margin-top: 10px;
            color: #1DA1F2;
            text-decoration: none;
            font-weight: 500;
        }
        .link-group a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="card">
        <h1 class="result-title">처리 완료</h1>
        
        <p class="status-message <%= statusClass %>">
            <%= message %>
        </p>
        
        <div class="link-group">
            <a href="mypage.jsp?id=<%= myId %>">내 마이페이지로 돌아가기</a>
            <% if(targetId != null) { %>
                <a href="mypage.jsp?id=<%= targetId %>">상대방 프로필 확인하기</a>
            <% } %>
            <a href="search.jsp">검색 페이지로 이동</a>
        </div>
    </div>
</body>
</html>
