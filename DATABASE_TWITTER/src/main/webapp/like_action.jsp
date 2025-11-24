<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.LikeDAO" %>
<%@ page import="BEAN.post_like" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐ (로직은 그대로 유지)
    request.setCharacterEncoding("UTF-8"); 
    
    String action = request.getParameter("action");
    String postIdStr = request.getParameter("postId");
    String userId = request.getParameter("userId");
    
    boolean success = false;
    String message = "";
    
    // [보안 임시 조치]: 현재는 세션이 없으므로, ID가 없으면 'testuser'로 가정
    if (userId == null || userId.isEmpty()) {
        userId = "testuser";
    }
    
    // 2. 필수 데이터 유효성 검사
    if (postIdStr != null && userId != null && action != null) {
        
        try {
            int postId = Integer.parseInt(postIdStr);
            
            LikeDAO likeDAO = new LikeDAO();
            post_like likeBean = new post_like();
            likeBean.setPOST_idPOST(postId);
            likeBean.setUSER_idUSER(userId);
            
            if (action.equals("like")) {
                // 좋아요 요청 (INSERT)
                success = likeDAO.insertLike(likeBean);
                message = success ? "게시물에 좋아요를 눌렀습니다." : "이미 좋아요를 누른 게시물입니다.";
                
            } else if (action.equals("unlike")) {
                // 좋아요 취소 요청 (DELETE)
                success = likeDAO.deleteLike(likeBean);
                message = success ? "게시물 좋아요를 취소했습니다." : "좋아요 취소에 실패했습니다.";
            }
            
        } catch (NumberFormatException e) {
            message = "게시물 ID가 올바르지 않습니다.";
        }
    } else {
        message = "필수 정보(게시물ID, 사용자ID)가 누락되었습니다.";
    }

    // JSP 변수: 메시지에 따라 상태 클래스 결정 (성공/실패)
    // '눌렀습니다' 또는 '취소했습니다'가 포함되면 성공으로 간주합니다.
    boolean isSuccess = message.contains("눌렀습니다") || message.contains("취소했습니다");
    String statusClass = isSuccess ? "status-success" : "status-failure";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좋아요 처리 결과</title>
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
            color: #d4183d; /* 좋아요 성공은 빨간색으로 (Heart Icon color) */
            font-weight: bold;
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
        <h1 class="result-title">좋아요 처리 결과</h1>
        
        <p class="status-message <%= statusClass %>">
            <%= message %>
        </p>
        
        <div class="link-group">
            <a href="mypage.jsp?id=<%= userId %>">내 마이페이지로 돌아가기</a>
            <% 
                // [참고]: 좋아요 기능은 특정 게시물이 있는 페이지로 돌아가는 것이 이상적입니다. 
                // 현재는 임시로 마이페이지로 이동하도록 했습니다.
            %>
        </div>
        
        <% 
            // 3초 후 리다이렉트 스크립트 
            response.setHeader("Refresh", "3;url=mypage.jsp?id=" + userId);
        %>
    </div>
</body>
</html>