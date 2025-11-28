<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.PostDAO, BEAN.post, java.util.ArrayList" %>
<%@ page import="DAO.CommentDAO, BEAN.post_comment, BEAN.reply_comment" %>
<%@ page import="DAO.UserDAO, BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");
    // 1. 로그인 체크
    String myId = (String) session.getAttribute("idKey");
    if (myId == null) {
%>
    <script>alert("로그인이 필요합니다."); location.href="login.jsp";</script>
<%
        return;
    }

    // 2. 탭 설정
    String tab = request.getParameter("tab");
    if (tab == null) tab = "ALL";

    // 3. 게시글 리스트 가져오기
    PostDAO dao = new PostDAO();
    
    int pageNum = 1;
    if(request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }
    int limit = 10;

    ArrayList<post> list = null;
    
    if ("GROUP".equals(tab)) {
        list = dao.getGroupTimeline(myId, pageNum, limit);
    } else {
        list = dao.getTimeline(myId, tab, pageNum, limit);
    }
    
    int totalCount = dao.getTotalPostCount(myId, tab);
    int totalPage = (int) Math.ceil((double) totalCount / limit);
    
    CommentDAO commentDao = new CommentDAO();

    // 4. 헤더에 띄울 '내 프로필 사진' 가져오기
    UserDAO userDao = new UserDAO();
    user myProfile = userDao.selectUserById(myId);
    String myProfileImg = (myProfile != null) ? myProfile.getProfileImage() : "profile_default.png";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>홈 / X</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* 전역 스타일 - 더 깔끔하고 현대적으로 */
        * { 
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body { 
            background: linear-gradient(to bottom, #f8f9fa 0%, #ffffff 100%);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            color: #14171a;
            line-height: 1.5;
        }
        
        a { 
            text-decoration: none; 
            color: inherit; 
        }
        
        /* 헤더 - 그림자와 블러 효과 추가 */
        .header { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            height: 65px; 
            padding: 0 40px; 
            border-bottom: 1px solid #e1e8ed;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            position: sticky; 
            top: 0; 
            z-index: 1000;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .header-left { 
            display: flex; 
            align-items: center; 
            gap: 35px; 
        }
        
        .logo { 
            width: 42px; 
            height: 42px; 
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            border-radius: 50%; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            color: white; 
            font-size: 24px;
            box-shadow: 0 3px 8px rgba(29, 161, 242, 0.3);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .logo:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 5px 15px rgba(29, 161, 242, 0.4);
        }
        
        .nav-menu { 
            display: flex; 
            gap: 5px; 
            font-size: 18px; 
        }
        
        .nav-item { 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            cursor: pointer; 
            padding: 10px 20px; 
            border-radius: 30px;
            font-weight: 500;
            color: #657786;
            transition: all 0.2s ease;
        }
        
        .nav-item:hover { 
            background-color: rgba(29, 161, 242, 0.08);
            color: #1da1f2;
        }
        
        .nav-item.active { 
            font-weight: 700;
            color: #14171a;
        }
        
        .nav-item span { 
            font-size: 22px; 
        }
        
        .header-right { 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            cursor: pointer;
            padding: 8px 16px;
            border-radius: 30px;
            transition: all 0.2s ease;
        }
        
        .header-right:hover {
            background-color: rgba(0, 0, 0, 0.03);
        }
        
        /* 프로필 이미지 - 더 세련된 스타일 */
        .my-profile-img { 
            width: 40px; 
            height: 40px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%; 
            background-size: cover; 
            background-position: center;
            border: 2px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }
        
        .my-profile-img:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .my-name { 
            font-weight: 600; 
            font-size: 15px;
            color: #14171a;
        }

        /* 컨테이너 - 그림자 추가 */
        .container { 
            width: 600px; 
            margin: 0 auto; 
            background: white;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            min-height: 100vh; 
            padding-bottom: 50px;
        }

        /* 탭 - 더 부드러운 전환 */
        .tabs { 
            display: flex; 
            border-bottom: 1px solid #e1e8ed;
            background: rgba(255,255,255,0.98);
            backdrop-filter: blur(12px);
            position: sticky; 
            top: 65px; 
            z-index: 900;
        }
        
        .tab-item { 
            flex: 1; 
            text-align: center; 
            padding: 16px 0; 
            font-weight: 600; 
            color: #657786; 
            cursor: pointer; 
            transition: all 0.3s ease;
            position: relative;
            font-size: 15px;
        }
        
        .tab-item:hover { 
            background-color: rgba(29, 161, 242, 0.05);
            color: #1da1f2;
        }
        
        .tab-item.active { 
            color: #14171a;
        }
        
        .tab-indicator { 
            position: absolute; 
            bottom: 0; 
            left: 50%; 
            transform: translateX(-50%); 
            width: 60px; 
            height: 4px; 
            background: linear-gradient(90deg, #1da1f2 0%, #0d8bd9 100%);
            border-radius: 9999px;
            display: none;
            box-shadow: 0 2px 8px rgba(29, 161, 242, 0.4);
        }
        
        .tab-item.active .tab-indicator { 
            display: block; 
        }

        /* 글쓰기 박스 - 더 깔끔한 디자인 */
        .write-box { 
            padding: 20px; 
            border-bottom: 8px solid #f7f9fa;
            display: flex; 
            gap: 15px;
            background: white;
        }
        
        .write-input-area { 
            flex: 1; 
        }
        
        .write-textarea { 
            width: 100%; 
            border: none; 
            outline: none; 
            font-size: 19px; 
            font-family: inherit; 
            resize: none; 
            margin-top: 10px; 
            min-height: 60px;
            color: #14171a;
            line-height: 1.6;
        }
        
        .write-textarea::placeholder {
            color: #a0aec0;
        }
        
        .write-actions { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-top: 15px; 
            padding-top: 15px;
            border-top: 1px solid #e1e8ed;
        }
        
        .btn-upload { 
            color: #1da1f2; 
            font-size: 14px; 
            font-weight: 600; 
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 20px;
            transition: all 0.2s ease;
        }
        
        .btn-upload:hover {
            background-color: rgba(29, 161, 242, 0.1);
        }
        
        .btn-post { 
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            color: white; 
            border: none; 
            padding: 10px 24px; 
            border-radius: 9999px; 
            font-weight: 700; 
            font-size: 15px; 
            cursor: pointer; 
            opacity: 0.5; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 2px 8px rgba(29, 161, 242, 0);
        }
        
        .btn-post:enabled { 
            opacity: 1;
            box-shadow: 0 4px 12px rgba(29, 161, 242, 0.3);
        }
        
        .btn-post:enabled:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(29, 161, 242, 0.4);
        }
        
        .btn-post:enabled:active {
            transform: translateY(0);
        }

        /* 게시물 아이템 - 더 세련된 호버 효과 */
        .post-item { 
            padding: 18px 20px; 
            border-bottom: 1px solid #e1e8ed;
            display: flex; 
            gap: 15px; 
            transition: all 0.2s ease;
            background: white;
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
            margin-bottom: 6px;
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
            font-weight: 400;
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
        
        /* 액션 버튼 - 더 부드러운 상호작용 */
        .post-actions { 
            display: flex; 
            gap: 60px; 
            color: #657786; 
            font-size: 13px;
            margin-top: 8px;
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
        
        /* 댓글 영역 스타일 */
        .comment-section {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e1e8ed;
        }
        
        .comment-form {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .comment-input {
            flex: 1;
            padding: 10px 16px;
            border: 1px solid #e1e8ed;
            border-radius: 20px;
            outline: none;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        
        .comment-input:focus {
            border-color: #1da1f2;
            box-shadow: 0 0 0 3px rgba(29, 161, 242, 0.1);
        }
        
        .comment-submit {
            background: #1da1f2;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        
        .comment-submit:hover {
            background: #0d8bd9;
        }
        
        .comment-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .comment-item {
            padding: 12px;
            background: #f7f9fa;
            border-radius: 12px;
            transition: all 0.2s ease;
        }
        
        .comment-item:hover {
            background: #eff3f4;
        }
        
        .comment-author {
            font-weight: 700;
            font-size: 14px;
            color: #14171a;
            margin-bottom: 4px;
        }
        
        .comment-text {
            font-size: 14px;
            color: #14171a;
            margin-bottom: 6px;
            line-height: 1.5;
        }
        
        .comment-meta {
            display: flex;
            gap: 12px;
            align-items: center;
            color: #657786;
            font-size: 12px;
        }
        
        .reply-toggle {
            background: none;
            border: none;
            color: #1da1f2;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            padding: 0;
            transition: all 0.2s ease;
        }
        
        .reply-toggle:hover {
            text-decoration: underline;
        }
        
        .reply-section {
            margin-left: 20px;
            margin-top: 12px;
            padding-left: 12px;
            border-left: 2px solid #e1e8ed;
        }
        
        .reply-item {
            padding: 10px;
            background: white;
            border-radius: 10px;
            margin-bottom: 8px;
        }
        
        /* 페이지네이션 - 더 현대적인 디자인 */
        .pagination {
            text-align: center;
            padding: 25px;
            margin-top: 10px;
        }
        
        .pagination a {
            text-decoration: none;
            color: #1da1f2;
            margin: 0 15px;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.2s ease;
        }
        
        .pagination a:hover {
            background-color: rgba(29, 161, 242, 0.1);
        }
        
        .pagination span {
            color: #657786;
            font-weight: 500;
        }
        
        /* 빈 상태 메시지 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #657786;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #14171a;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            font-size: 15px;
            margin-bottom: 20px;
        }
        
        .empty-state a {
            color: #1da1f2;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 20px;
            display: inline-block;
            transition: all 0.2s ease;
        }
        
        .empty-state a:hover {
            background-color: rgba(29, 161, 242, 0.1);
        }
    </style>
    <script>
        function checkInput(input) {
            const btn = document.getElementById('postBtn');
            btn.disabled = input.value.trim() === '';
        }
        
        function likePost(postId) { 
            location.href = 'like_action2.jsp?id=' + postId + '&tab=<%=tab%>'; 
        }
        
        function toggleComment(postId) {
            const section = document.getElementById('comment-section-' + postId);
            section.style.display = section.style.display === 'none' ? 'block' : 'none';
        }
        
        function toggleReply(commentId) {
            const section = document.getElementById('reply-section-' + commentId);
            section.style.display = section.style.display === 'none' ? 'block' : 'none';
        }
    </script>
</head>
<body>

    <div class="header">
        <div class="header-left">
            <a href="main.jsp" class="logo">🐦</a>
            <div class="nav-menu">
                <a href="main.jsp" class="nav-item active"><span>🏠</span> 홈</a>
                <a href="search.jsp" class="nav-item"><span>🔍</span> 검색</a>
                <a href="message_inbox.jsp" class="nav-item"><span>💬</span> 쪽지</a>
                <a href="group.jsp" class="nav-item"><span>👥</span> 그룹</a>
            </div>
        </div>
        <div class="header-right" onclick="location.href='mypage.jsp?id=<%=myId%>'">
            <div class="my-profile-img" style="background-image: url('<%= myProfileImg %>');"></div>
            <span class="my-name"><%= myId %></span>
        </div>
    </div>

    <div class="container">
        
        <div class="tabs">
            <div class="tab-item <%= tab.equals("FOLLOW") ? "active" : "" %>" onclick="location.href='main.jsp?tab=FOLLOW'">
                팔로잉
                <div class="tab-indicator"></div>
            </div>
            <div class="tab-item <%= tab.equals("GROUP") ? "active" : "" %>" onclick="location.href='main.jsp?tab=GROUP'">
                그룹
                <div class="tab-indicator"></div>
            </div>
            <div class="tab-item <%= tab.equals("ALL") ? "active" : "" %>" onclick="location.href='main.jsp?tab=ALL'">
                전체
                <div class="tab-indicator"></div>
            </div>
        </div>

        <div class="write-box">
            <div class="my-profile-img" style="background-image: url('<%= myProfileImg %>');"></div>
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

        <% if(list.size() == 0) { %>
            <div class="empty-state">
                <h3>표시할 게시글이 없습니다</h3>
                <% if("GROUP".equals(tab)) { %>
                    <p>그룹에 가입하여 새로운 소식을 받아보세요</p>
                    <a href="group.jsp">그룹 탐색하기</a>
                <% } else if("FOLLOW".equals(tab)) { %>
                    <p>팔로우한 사용자가 없거나 아직 게시글이 없습니다</p>
                    <a href="search.jsp">새로운 친구 찾기</a>
                <% } else { %>
                    <p>아직 게시글이 없습니다</p>
                <% } %>
            </div>
        <% } else { %>
            
            <% for(post p : list) { 
                int commentCount = commentDao.getCommentCount(p.getIdPOST());
            %>
            <div class="post-item">
                
                <div class="my-profile-img" 
                     onclick="location.href='mypage.jsp?id=<%= p.getUser() %>'" 
                     style="cursor: pointer; background-image: url('<%= p.getProfileImage() %>');"></div>
                
                <div class="post-content">
                    <div class="post-header">
                        <div onclick="location.href='mypage.jsp?id=<%= p.getUser() %>'" 
                             style="cursor: pointer; display: flex; align-items: center;">
                            <span class="post-user-name"><%= p.getUserName() %></span>
                            <span class="post-user-id">@<%= p.getUser() %></span>
                            <span class="post-time"> · <%= p.getDate().toString().substring(0, 16) %></span>
                        </div>
                        
                        <div style="color:#657786; cursor: pointer;">···</div>
                    </div>
                    
                    <div class="post-text"><%= p.getDetail() %></div>
                    
                    <div class="post-actions">
                        <button class="action-btn" onclick="toggleComment(<%= p.getIdPOST() %>)">
                            💬 <%= commentCount %>
                        </button>                        
                        <button class="action-btn">🔁 0</button>
                        <button class="action-btn <%= p.isLiked() ? "liked" : "" %>" onclick="likePost(<%= p.getIdPOST() %>)">
                            <%= p.isLiked() ? "❤️" : "🤍" %> <%= p.getLikeCount() %>
                        </button>
                        <button class="action-btn">📊</button>
                    </div>
                    
                    <div id="comment-section-<%= p.getIdPOST() %>" class="comment-section" style="display:none;">
                        <form action="comment_action.jsp" method="post" class="comment-form">
                            <input type="hidden" name="postId" value="<%= p.getIdPOST() %>">
                            <input type="hidden" name="tab" value="<%=tab%>">
                            <input type="text" name="content" placeholder="댓글 달기..." class="comment-input">
                            <button type="submit" class="comment-submit">댓글</button>
                        </form>
                        
                        <div class="comment-list">
                            <% 
                                ArrayList<post_comment> comments = commentDao.getComments(p.getIdPOST());
                                for(post_comment c : comments) { 
                                    int replyCount = commentDao.getReplyCount(c.getSEQ_POST());
                            %>
                            <div class="comment-item">
                                <div class="comment-author"><%= c.getUserName() %></div>
                                <div class="comment-text"><%= c.getDETAIL() %></div>
                                <div class="comment-meta">
                                    <span><%= c.getDATE().toString().substring(0, 16) %></span>
                                    <button onclick="toggleReply(<%= c.getSEQ_POST() %>)" class="reply-toggle">💬 답글 <%= replyCount %>개</button>
                                </div>
                                
                                <div id="reply-section-<%= c.getSEQ_POST() %>" class="reply-section" style="display:none;">
                                    <form action="reply_comment_action.jsp" method="post" class="comment-form">
                                        <input type="hidden" name="commentSeq" value="<%= c.getSEQ_POST() %>">
                                        <input type="hidden" name="tab" value="<%=tab%>">
                                        <input type="text" name="content" placeholder="답글 달기..." class="comment-input">
                                        <button type="submit" class="comment-submit">답글</button>
                                    </form>
                                    <% 
                                        ArrayList<reply_comment> replies = commentDao.getReplies(c.getSEQ_POST());
                                        for(reply_comment r : replies) { 
                                    %>
                                    <div class="reply-item">
                                        <div class="comment-author"><%= r.getUserName() %></div>
                                        <div class="comment-text"><%= r.getDETAIL() %></div>
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

        <div class="pagination">
            <% if(pageNum > 1) { %>
                <a href="main.jsp?tab=<%=tab%>&page=<%=pageNum-1%>">← 이전</a>
            <% } %>
            
            <span> <%=pageNum%> / <%=totalPage%> </span>

            <% if(pageNum < totalPage) { %>
                <a href="main.jsp?tab=<%=tab%>&page=<%=pageNum+1%>">다음 →</a>
            <% } %>
        </div>

    </div>
</body>
</html>
