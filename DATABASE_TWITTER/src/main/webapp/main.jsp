<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.PostDAO, BEAN.post, java.util.ArrayList" %>
<%@ page import="DAO.CommentDAO, BEAN.post_comment, BEAN.reply_comment" %>
<%
    // [테스트용] 테스트 끝나면 꼭 주석 처리하거나 지우세요!
    // session.setAttribute("idKey", "elon_musk");
%>

<%
    // 1. 로그인 체크
    // session.setAttribute("idKey", "elon_musk");
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

    // 2. 탭 설정 (전체 vs 팔로잉)
    String tab = request.getParameter("tab");
    if (tab == null) tab = "ALL"; // 기본값 전체 보기

    // 3. 게시글 리스트 가져오기
    PostDAO dao = new PostDAO();
    ArrayList<post> list = dao.getTimeline(myId, tab);
    CommentDAO commentDao = new CommentDAO(); 


%>

<!DOCTYPE html>
<html>
<head>
    <title>홈 / 트위터</title>
    <style>
        /* 공통 스타일 */
        body { background-color: white; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }
        a { text-decoration: none; color: inherit; }
        
        /* 헤더 (search.jsp와 동일) */
        .header { display: flex; align-items: center; justify-content: space-between; height: 60px; padding: 0 40px; border-bottom: 1px solid #eff3f4; background-color: white; position: sticky; top: 0; z-index: 1000; }
        .header-left { display: flex; align-items: center; gap: 30px; }
        .logo { width: 40px; height: 40px; background-color: #1d9bf0; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: white; font-size: 24px; }
        .nav-menu { display: flex; gap: 30px; font-size: 19px; }
        .nav-item { display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 10px; border-radius: 30px; }
        .nav-item:hover { background-color: #f7f9fa; }
        .nav-item.active { font-weight: bold; }
        .header-right { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .my-profile-img { width: 40px; height: 40px; background-color: #ccc; border-radius: 50%; }
        .my-name { font-weight: bold; font-size: 15px; }

        /* 메인 컨테이너 */
        .container { width: 600px; margin: 0 auto; border-left: 1px solid #eff3f4; border-right: 1px solid #eff3f4; min-height: 100vh; }

        /* 상단 탭 (팔로잉 | 전체) */
        .tabs { display: flex; border-bottom: 1px solid #eff3f4; background: rgba(255,255,255,0.95); backdrop-filter: blur(12px); position: sticky; top: 60px; z-index: 900; }
        .tab-item { flex: 1; text-align: center; padding: 15px 0; font-weight: bold; color: #536471; cursor: pointer; transition: 0.2s; position: relative; }
        .tab-item:hover { background-color: #eff3f4; }
        .tab-item.active { color: #0f1419; }
        /* 탭 아래 파란 줄 */
        .tab-indicator { position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 56px; height: 4px; background-color: #1d9bf0; border-radius: 9999px; display: none; }
        .tab-item.active .tab-indicator { display: block; }

        /* 글쓰기 박스 */
        .write-box { padding: 15px; border-bottom: 1px solid #eff3f4; display: flex; gap: 12px; }
        .write-input-area { flex: 1; }
        .write-textarea { width: 100%; border: none; outline: none; font-size: 20px; font-family: inherit; resize: none; margin-top: 10px; min-height: 50px; }
        .write-textarea::placeholder { color: #536471; }
        .write-actions { display: flex; justify-content: space-between; align-items: center; margin-top: 10px; border-top: 1px solid #eff3f4; padding-top: 10px; }
        .btn-upload { color: #1d9bf0; font-size: 14px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 5px; }
        .btn-post { background-color: #1d9bf0; color: white; border: none; padding: 8px 16px; border-radius: 9999px; font-weight: bold; font-size: 15px; cursor: pointer; opacity: 0.5; transition: 0.2s; }
        .btn-post:enabled { opacity: 1; }
        .btn-post:hover:enabled { background-color: #1a8cd8; }

        /* 피드 리스트 */
        .post-item { padding: 15px; border-bottom: 1px solid #eff3f4; display: flex; gap: 12px; cursor: pointer; transition: 0.2s; }
        .post-item:hover { background-color: #f7f9fa; }
        .post-content { flex: 1; }
        .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
        .post-user-name { font-weight: bold; font-size: 15px; color: #0f1419; }
        .post-user-id { color: #536471; font-size: 14px; margin-left: 5px; }
        .post-time { color: #536471; font-size: 14px; }
        .post-text { font-size: 15px; line-height: 20px; color: #0f1419; margin-bottom: 10px; white-space: pre-wrap; }
        
        .post-actions { display: flex; gap: 20px; color: #536471; font-size: 13px; }
        .action-btn { display: flex; align-items: center; gap: 5px; cursor: pointer; transition: 0.2s; border: none; background: none; color: inherit; }
        .action-btn.liked { color: #f91880; } /* 좋아요 누르면 핑크색 */
        .action-btn:hover { color: #1d9bf0; }
        .action-btn.liked:hover { color: #c20e60; }
    </style>
    <script>
        // 글자 입력해야 게시 버튼 활성화
        function checkInput(input) {
            const btn = document.getElementById('postBtn');
            btn.disabled = input.value.trim() === '';
            btn.style.opacity = input.value.trim() === '' ? '0.5' : '1';
        }
        
        // 좋아요 버튼 클릭
        function likePost(postId) {
            location.href = 'like_action2.jsp?id=' + postId + '&tab=<%=tab%>';
        }
        // 댓글 영역 토글 
        function toggleComment(postId) {
            const section = document.getElementById('comment-section-' + postId);
            if (section.style.display === 'none') {
                section.style.display = 'block';
            } else {
                section.style.display = 'none';
            }
        }
     // 대댓글 영역 토글
        function toggleReply(commentId) {
            const section = document.getElementById('reply-section-' + commentId);
            if (section.style.display === 'none') {
                section.style.display = 'block';
            } else {
                section.style.display = 'none';
            }
        }
    </script>
</head>
<body>

    <!-- 헤더 -->
    <div class="header">
        <div class="header-left">
            <a href="main.jsp" class="logo">🐦</a>
            <div class="nav-menu">
                <a href="main.jsp" class="nav-item active"><span>🏠</span> 홈</a>
                <a href="search.jsp" class="nav-item"><span>🔍</span> 검색</a>
                <a href="#" class="nav-item" onclick="alert('준비중')"><span>💬</span> 쪽지</a>
                <a href="#" class="nav-item" onclick="alert('준비중')"><span>👥</span> 그룹</a>
            </div>
        </div>
        <div class="header-right">
            <div class="my-profile-img"></div>
            <span class="my-name"><%= myId %></span>
        </div>
    </div>

    <!-- 메인 컨테이너 -->
    <div class="container">
        
        <!-- 탭 (팔로잉 / 전체) -->
        <div class="tabs">
            <div class="tab-item <%= tab.equals("FOLLOW") ? "active" : "" %>" onclick="location.href='main.jsp?tab=FOLLOW'">
                팔로잉
                <div class="tab-indicator"></div>
            </div>
            <div class="tab-item <%= tab.equals("ALL") ? "active" : "" %>" onclick="location.href='main.jsp?tab=ALL'">
                전체
                <div class="tab-indicator"></div>
            </div>
        </div>

        <!-- 글쓰기 영역 -->
        <div class="write-box">
            <div class="my-profile-img"></div>
            <div class="write-input-area">
                <form action="write_action.jsp" method="post">
                    <input type="hidden" name="tab" value="<%=tab%>">
                    <textarea name="content" class="write-textarea" placeholder="무슨 일이 일어나고 있나요?" oninput="checkInput(this)"></textarea>
                    
                    <div class="write-actions">
                        <div class="btn-upload">🖼️ 사진</div>
                        <button type="submit" id="postBtn" class="btn-post" disabled>게시하기</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 타임라인 피드 -->
        <% if(list.size() == 0) { %>
            <div style="text-align:center; padding: 40px; color: #536471;">
                표시할 게시글이 없습니다.<br>
                <% if(tab.equals("FOLLOW")) { %>
                    <br><a href="search.jsp" style="color:#1d9bf0">친구를 찾아 팔로우해보세요!</a>
                <% } %>
            </div>
        <% } else { %>
            <% for(post p : list) { 
            int commentCount = commentDao.getCommentCount(p.getIdPOST());
            %>
            <div class="post-item">
                <div class="my-profile-img"></div> <!-- 프로필 사진 -->
                <div class="post-content">
                    <div class="post-header">
                        <div>
                            <span class="post-user-name"><%= p.getUserName() %></span>
                            <span class="post-user-id">@<%= p.getUser() %></span>
                            <span class="post-time"> · <%= p.getDate().toString().substring(0, 16) %></span>
                        </div>
                        <div style="color:#536471">···</div>
                    </div>
                    
                    <div class="post-text"><%= p.getDetail() %></div>

                    <div class="post-actions">
                    <button class="action-btn" onclick="toggleComment(<%= p.getIdPOST() %>)">
                        💬 <%= commentCount %>
                    </button>                        
                    <button class="action-btn">🔁 0</button>
                        
                        <!-- 좋아요 버튼 로직 -->
                        <button class="action-btn <%= p.isLiked() ? "liked" : "" %>" onclick="likePost(<%= p.getIdPOST() %>)">
                            <%= p.isLiked() ? "❤️" : "🤍" %> <%= p.getLikeCount() %>
                        </button>
                        
                        <button class="action-btn">📊</button>
                    </div>
                    <div id="comment-section-<%= p.getIdPOST() %>" style="display:none; margin-top:10px; border-top:1px solid #eff3f4; padding-top:10px;">
                        <!-- 댓글 작성 폼 -->
                        <form action="comment_action.jsp" method="post" style="display:flex; gap:10px; margin-bottom:10px;">
                            <input type="hidden" name="postId" value="<%= p.getIdPOST() %>">
                            <input type="hidden" name="tab" value="<%=tab%>">
                            <input type="text" name="content" placeholder="댓글을 입력하세요..." 
                                   style="flex:1; padding:8px; border:1px solid #eff3f4; border-radius:20px; outline:none;">
                            <button type="submit" style="background:#1d9bf0; color:white; border:none; padding:8px 16px; border-radius:20px; cursor:pointer; font-weight:bold;">
                                댓글
                            </button>
                        </form>
                        
<%--                         <!-- 댓글 목록 -->
                        <div class="comment-list">
                            <% 
                                ArrayList<post_comment> comments = commentDao.getComments(p.getIdPOST());
                                for(post_comment c : comments) { 
                            %>
                            <div style="padding:10px; border-bottom:1px solid #f7f9fa;">
                            <div style="font-weight:bold; font-size:14px; color:#0f1419;"><%= c.getUserName() %></div>
                                <div style="font-size:14px; margin-top:4px; color:#0f1419;"><%= c.getDETAIL() %></div>
                                <div style="color:#536471; font-size:12px; margin-top:4px;">
                                    <%= c.getDATE().toString().substring(0, 16) %>
                                </div>
                            </div>
                            <% } %>
                        </div> --%>
						<!-- 댓글 목록 -->
						<div class="comment-list">
						    <% 
						        ArrayList<post_comment> comments = commentDao.getComments(p.getIdPOST());
						        for(post_comment c : comments) { 
						            int replyCount = commentDao.getReplyCount(c.getSEQ_POST());
						    %>
						    <div style="padding:10px; border-bottom:1px solid #f7f9fa;">
						        <div style="font-weight:bold; font-size:14px; color:#0f1419;"><%= c.getUserName() %></div>
						        <div style="font-size:14px; margin-top:4px; color:#0f1419;"><%= c.getDETAIL() %></div>
						        <div style="color:#536471; font-size:12px; margin-top:4px; display:flex; gap:10px; align-items:center;">
						            <span><%= c.getDATE().toString().substring(0, 16) %></span>
						            <button onclick="toggleReply(<%= c.getSEQ_POST() %>)" 
						                    style="background:none; border:none; color:#1d9bf0; cursor:pointer; font-size:12px;">
						                💬 답글 <%= replyCount %>개
						            </button>
						        </div>
						        
						        <!-- 대댓글 영역 -->
						        <div id="reply-section-<%= c.getSEQ_POST() %>" style="display:none; margin-left:20px; margin-top:10px; padding-left:10px; border-left:2px solid #eff3f4;">
						            <!-- 대댓글 작성 폼 -->
						            <form action="reply_comment_action.jsp" method="post" style="display:flex; gap:8px; margin-bottom:10px;">
						                <input type="hidden" name="commentSeq" value="<%= c.getSEQ_POST() %>">
						                <input type="hidden" name="tab" value="<%=tab%>">
						                <input type="text" name="content" placeholder="답글 달기..." 
						                       style="flex:1; padding:6px; border:1px solid #eff3f4; border-radius:15px; outline:none; font-size:13px;">
						                <button type="submit" style="background:#1d9bf0; color:white; border:none; padding:6px 12px; border-radius:15px; cursor:pointer; font-size:13px; font-weight:bold;">
						                    답글
						                </button>
						            </form>
						            
						            <!-- 대댓글 목록 -->
						            <% 
						                ArrayList<reply_comment> replies = commentDao.getReplies(c.getSEQ_POST());
						                for(reply_comment r : replies) { 
						            %>
						            <div style="padding:8px; margin-bottom:6px; background:#f7f9fa; border-radius:8px;">
						                <div style="font-weight:bold; font-size:13px; color:#0f1419;"><%= r.getUserName() %></div>
						                <div style="font-size:13px; margin-top:2px; color:#0f1419;"><%= r.getDETAIL() %></div>
						                <div style="color:#536471; font-size:11px; margin-top:2px;">
						                    <%= r.getDATE().toString().substring(0, 16) %>
						                </div>
						            </div>
						            <% } %>
						        </div>
						    </div>
						    <% } %>
						</div>
                    </div>
                    
                </div>
            </div>
            <% } %>
        <% } %>

    </div>

</body>
</html>