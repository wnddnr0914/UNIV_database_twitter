<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user, java.util.ArrayList" %>

<%
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

    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = ""; 

    int pageNum = 1;
    if (request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }
    
    int limit = 10; 

    UserDAO dao = new UserDAO();
    ArrayList<user> list = dao.searchUsers(myId, keyword, pageNum, limit);
    int totalCount = dao.getSearchCount(myId, keyword);
    int totalPage = (int) Math.ceil((double) totalCount / limit);
    
    UserDAO userDao = new UserDAO();
    user myProfile = userDao.selectUserById(myId);
    String myProfileImg = (myProfile != null) ? myProfile.getProfileImage() : "profile_default.png";
%>

<!DOCTYPE html>
<html>
<head>
    <title>검색 / X</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body { 
            background: linear-gradient(to bottom, #f8f9fa 0%, #ffffff 100%);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            color: #14171a;
        }
        
        a { 
            text-decoration: none; 
            color: inherit; 
        }
        
        /* 헤더 스타일 - main.jsp와 동일한 스타일 */
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
        
        /* 컨테이너 */
        .container { 
            width: 600px; 
            margin: 0 auto; 
            background: white;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            min-height: 100vh;
        }
        
        /* 검색 헤더 */
        .search-header { 
            padding: 20px; 
            background: white;
            border-bottom: 1px solid #e1e8ed;
        }
        
        .search-bar { 
            background-color: #f7f9fa;
            border: 2px solid #e1e8ed;
            border-radius: 30px;
            display: flex; 
            align-items: center; 
            padding: 12px 20px;
            transition: all 0.3s ease;
        }
        
        .search-bar:focus-within {
            background-color: white;
            border-color: #1da1f2;
            box-shadow: 0 0 0 4px rgba(29, 161, 242, 0.1);
        }
        
        .search-bar input { 
            border: none; 
            background: transparent; 
            outline: none; 
            width: 100%; 
            font-size: 16px; 
            margin-left: 12px;
            color: #14171a;
        }
        
        .search-bar input::placeholder {
            color: #a0aec0;
        }
        
        .search-btn { 
            background: none; 
            border: none; 
            cursor: pointer; 
            color: #657786; 
            font-size: 20px;
            transition: all 0.2s ease;
        }
        
        .search-btn:hover {
            color: #1da1f2;
        }

        /* 사용자 리스트 */
        .user-list {
            background: white;
        }
        
        .user-item { 
            display: flex; 
            align-items: center; 
            padding: 18px 20px; 
            border-bottom: 1px solid #e1e8ed;
            transition: all 0.2s ease;
        }
        
        .user-item:hover { 
            background-color: #f7f9fa;
        }
        
        .profile-img { 
            width: 52px; 
            height: 52px; 
            border-radius: 50%; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin-right: 15px;
            background-size: cover;
            background-position: center;
            border: 2px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .profile-img:hover {
            transform: scale(1.08);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .user-info { 
            flex: 1;
            cursor: pointer;
        }
        
        .user-name { 
            font-weight: 700; 
            font-size: 16px; 
            color: #14171a;
            margin-bottom: 2px;
        }
        
        .user-id { 
            color: #657786; 
            font-size: 15px;
        }
        
        .btn-follow { 
            background-color: #14171a;
            color: white; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 9999px; 
            font-weight: 700; 
            cursor: pointer; 
            font-size: 15px;
            transition: all 0.2s ease;
        }
        
        .btn-follow:hover { 
            background-color: #272c30;
        }
        
        .btn-following { 
            background-color: white;
            color: #14171a; 
            border: 2px solid #e1e8ed;
        }
        
        .btn-following:hover { 
            background-color: rgba(244, 33, 46, 0.1);
            color: #f4212e; 
            border-color: rgba(244, 33, 46, 0.4);
        }

        /* 페이지네이션 */
        .pagination { 
            text-align: center; 
            padding: 25px;
            background: white;
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
            line-height: 1.6;
        }
        
        /* 검색 결과 헤더 */
        .search-results-header {
            padding: 20px;
            background: #f7f9fa;
            border-bottom: 1px solid #e1e8ed;
            font-size: 15px;
            color: #657786;
        }
        
        .search-results-header strong {
            color: #14171a;
            font-weight: 700;
        }
    </style>
    
    <script>
        function toggleFollow(targetId, btn) {
            if(event) event.stopPropagation();
            location.href = "follow_proc.jsp?targetId=" + targetId + "&from=search&keyword=<%=keyword%>&page=<%=pageNum%>";
        }
    </script>
</head>
<body>

    <div class="header">
        <div class="header-left">
            <a href="main.jsp" class="logo">🐦</a>
            <div class="nav-menu">
                <a href="main.jsp" class="nav-item"><span>🏠</span> 홈</a>
                <a href="search.jsp" class="nav-item active"><span>🔍</span> 검색</a>
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
        <div class="search-header">
            <form action="search.jsp" method="post">
                <div class="search-bar">
                    <button type="submit" class="search-btn">🔍</button>
                    <input type="text" name="keyword" placeholder="사용자 검색..." value="<%=keyword%>" autofocus>
                </div>
            </form>
        </div>

        <% if(!keyword.isEmpty() && totalCount > 0) { %>
        <div class="search-results-header">
            "<strong><%=keyword%></strong>" 검색 결과 <strong><%=totalCount%></strong>건
        </div>
        <% } %>

        <div class="user-list">
            <% if(list.size() == 0) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">🔍</div>
                    <% if(keyword.isEmpty()) { %>
                        <h3>사용자를 검색해보세요</h3>
                        <p>아이디나 이름으로 다른 사용자를 찾아보세요</p>
                    <% } else { %>
                        <h3>검색 결과가 없습니다</h3>
                        <p>"<%=keyword%>"와 일치하는 사용자를 찾을 수 없습니다</p>
                    <% } %>
                </div>
            <% } else { %>
                <% for(user u : list) { %>
                <div class="user-item">
                    <div class="profile-img" 
                         style="background-image: url('<%= u.getProfileImage() %>'); background-size: cover;"
                         onclick="location.href='mypage.jsp?id=<%= u.getIdUSER() %>'">
                    </div>
                    
                    <div class="user-info" 
                         onclick="location.href='mypage.jsp?id=<%= u.getIdUSER() %>'">
                        <div class="user-name"><%= u.getNAME() %></div>
                        <div class="user-id">@<%= u.getIdUSER() %></div>
                    </div>
                    
                    <div>
                        <% if(u.isFollowed()) { %>
                            <button class="btn-follow btn-following" onclick="toggleFollow('<%=u.getIdUSER()%>', this)">팔로잉</button>
                        <% } else { %>
                            <button class="btn-follow" onclick="toggleFollow('<%=u.getIdUSER()%>', this)">팔로우</button>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>

        <% if(totalPage > 1) { %>
        <div class="pagination">
            <% if(pageNum > 1) { %>
                <a href="search.jsp?keyword=<%=keyword%>&page=<%=pageNum-1%>">← 이전</a>
            <% } %>
            <span> <%=pageNum%> / <%=totalPage%> </span>
            <% if(pageNum < totalPage) { %>
                <a href="search.jsp?keyword=<%=keyword%>&page=<%=pageNum+1%>">다음 →</a>
            <% } %>
        </div>
        <% } %>
    </div>

</body>
</html>
