<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.LikeDAO" %>
<%@ page import="BEAN.post_like" %>
<% 
    // ⭐ MVC1 Controller 영역 ⭐
    request.setCharacterEncoding("UTF-8"); 
    
    // 1. 로그인 체크 (세션 사용)
    String userId = (String) session.getAttribute("idKey");
    
    // 비로그인 상태면 로그인 페이지로
    if (userId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    // 2. 파라미터 받기
    String action = request.getParameter("action");   // "like" or "unlike"
    String postIdStr = request.getParameter("postId"); // 게시물 ID
    
    boolean success = false;
    String message = "";
    
    // 3. 유효성 검사 및 DB 처리
    if (postIdStr != null && action != null) {
        
        try {
            int postId = Integer.parseInt(postIdStr);
            
            LikeDAO likeDAO = new LikeDAO();
            post_like likeBean = new post_like();
            
            // BEAN에 데이터 세팅
            likeBean.setPOST_idPOST(postId);
            likeBean.setUSER_idUSER(userId); // 세션에서 가져온 내 ID
            
            if (action.equals("like")) {
                // 좋아요 추가 (INSERT)
                success = likeDAO.insertLike(likeBean);
                message = success ? "게시물에 좋아요를 눌렀습니다. ❤️" : "이미 좋아요를 누른 게시물입니다.";
                
            } else if (action.equals("unlike")) {
                // 좋아요 취소 (DELETE)
                success = likeDAO.deleteLike(likeBean);
                message = success ? "좋아요를 취소했습니다. 💔" : "취소 실패 (시스템 오류)";
            }
            
        } catch (NumberFormatException e) {
            message = "잘못된 게시물 ID입니다.";
        }
    } else {
        message = "필수 정보가 누락되었습니다.";
    }

    // JSP 변수: 상태 클래스 결정
    boolean isSuccess = message.contains("했습니다");
    String statusClass = isSuccess ? "status-success" : "status-failure";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좋아요 처리 결과</title>
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
        .status-success { color: #d4183d; font-weight: bold; } /* 하트 색상 */
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
        <h1 class="result-title">좋아요 결과</h1>
        
        <p class="status-message <%= statusClass %>">
            <%= message %>
        </p>
        
        <div class="link-group">
            <a href="main.jsp">메인 타임라인으로 돌아가기</a>
            <a href="mypage.jsp?id=<%= userId %>">내 마이페이지로 가기</a>
        </div>
        
        <% 
            // 2초 후 자동으로 이전 페이지(보통 메인이나 마이페이지)로 이동하면 좋겠지만,
            // 상황에 따라 다르므로 일단 메인으로 보냅니다.
            if(isSuccess) {
        %>
            <script>
                setTimeout(function() {
                    location.href = "main.jsp"; // 2초 후 메인으로 자동 이동
                }, 2000);
            </script>
            <p style="color: #717182; font-size: 0.9rem; margin-top: 15px;">
                잠시 후 메인으로 이동합니다...
            </p>
        <% } %>
    </div>
</body>
</html>
