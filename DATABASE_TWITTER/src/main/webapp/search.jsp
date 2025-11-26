<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user, java.util.ArrayList" %>

<%
    // [테스트용] 이 코드가 있으면 'elon_musk'로 로그인된 걸로 칩니다. (테스트 끝나면 지우세요!)
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

    // 2. 검색어 및 페이지 처리
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = ""; 

    int pageNum = 1;
    if (request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }
    
    int limit = 10; 

    // 3. DB에서 리스트 가져오기
    UserDAO dao = new UserDAO();
    ArrayList<user> list = dao.searchUsers(myId, keyword, pageNum, limit);
    int totalCount = dao.getSearchCount(myId, keyword);
    int totalPage = (int) Math.ceil((double) totalCount / limit);
%>

<!DOCTYPE html>
<html>
<head>
    <title>트위터 검색</title>
    <style>
        /* 기본 리셋 */
        body { background-color: white; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }
        a { text-decoration: none; color: inherit; }
        
        /* ▼▼▼ [1] 헤더 스타일 (새로 추가됨) ▼▼▼ */
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            padding: 0 40px;
            border-bottom: 1px solid #eff3f4;
            background-color: white;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-left { display: flex; align-items: center; gap: 30px; }
        
        /* 로고 (파란새) */
        .logo { 
            width: 40px; height: 40px; 
            background-color: #1d9bf0; 
            border-radius: 50%; 
            display: flex; justify-content: center; align-items: center;
            color: white; font-size: 24px;
        }

        /* 네비게이션 메뉴 */
        .nav-menu { display: flex; gap: 30px; font-size: 19px; }
        .nav-item { display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 10px; border-radius: 30px; }
        .nav-item:hover { background-color: #f7f9fa; }
        .nav-item.active { font-weight: bold; } /* 현재 페이지 강조 */

        /* 우측 프로필 영역 */
        .header-right { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .my-profile-img { width: 40px; height: 40px; background-color: #ccc; border-radius: 50%; }
        .my-name { font-weight: bold; font-size: 15px; }

        /* ▲▲▲ 헤더 스타일 끝 ▲▲▲ */


        /* 기존 컨텐츠 스타일 */
        .container { width: 600px; margin: 0 auto; min-height: 100vh; }
        
        .search-header { padding: 20px 15px 10px 15px; background: white; }
        .search-bar { background-color: #eff3f4; border-radius: 9999px; display: flex; align-items: center; padding: 10px 20px; }
        .search-bar input { border: none; background: transparent; outline: none; width: 100%; font-size: 15px; margin-left: 10px; }
        .search-btn { background: none; border: none; cursor: pointer; color: #536471; font-size: 16px; }

        .user-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eff3f4; transition: 0.2s; }
        .user-item:hover { background-color: #f7f9fa; }
        .profile-img { width: 48px; height: 48px; border-radius: 50%; background-color: #ccc; margin-right: 12px; }
        .user-info { flex: 1; }
        .user-name { font-weight: bold; font-size: 15px; color: #0f1419; }
        .user-id { color: #536471; font-size: 14px; }
        
        .btn-follow { background-color: #0f1419; color: white; border: none; padding: 8px 16px; border-radius: 9999px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn-follow:hover { background-color: #272c30; }
        .btn-following { background-color: white; color: #0f1419; border: 1px solid #cfd9de; }
        .btn-following:hover { background-color: #ffeaea; color: red; border-color: #f4212e; }

        .pagination { text-align: center; padding: 20px; }
        .pagination a { text-decoration: none; color: #1d9bf0; margin: 0 5px; font-weight: bold; }
        .pagination span { color: #536471; }
    </style>
    
    <script>
        function toggleFollow(targetId, btn) {
            location.href = "follow_proc.jsp?targetId=" + targetId + "&keyword=<%=keyword%>&page=<%=pageNum%>";
        }
    </script>
</head>
<body>

    <div class="header">
        <div class="header-left">
            <a href="main.jsp" class="logo">🐦</a>
            
            <div class="nav-menu">
                <a href="main.jsp" class="nav-item">
                    <span>🏠</span> 홈
                </a>
                <a href="search.jsp" class="nav-item active">
                    <span>🔍</span> 검색
                </a>
                <a href="#" class="nav-item" onclick="alert('준비중입니다!')">
                    <span>💬</span> 쪽지
                </a>
                <a href="#" class="nav-item" onclick="alert('준비중입니다!')">
                    <span>👥</span> 그룹
                </a>
            </div>
        </div>

        <div class="header-right">
            <div class="my-profile-img" style="background-image: url('my_profile.png'); background-size: cover;"></div>
            <span class="my-name"><%= myId %></span>
        </div>
    </div>
    <div class="container">
        <div class="search-header">
            <form action="search.jsp" method="post">
                <div class="search-bar">
                    <button type="submit" class="search-btn">🔍</button>
                    <input type="text" name="keyword" placeholder="사용자 검색..." value="<%=keyword%>">
                </div>
            </form>
        </div>

        <div class="user-list">
            <% if(list.size() == 0) { %>
                <div style="text-align:center; padding: 50px; color: #536471;">
                    검색 결과가 없습니다.
                </div>
            <% } else { %>
                <% for(user u : list) { %>
                <div class="user-item">
                    <div class="profile-img" style="background-image: url('default_profile.png'); background-size: cover;"></div>
                    <div class="user-info">
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

        <div class="pagination">
            <% if(pageNum > 1) { %>
                <a href="search.jsp?keyword=<%=keyword%>&page=<%=pageNum-1%>">이전</a>
            <% } %>
            <span> <%=pageNum%> / <%=totalPage%> </span>
            <% if(pageNum < totalPage) { %>
                <a href="search.jsp?keyword=<%=keyword%>&page=<%=pageNum+1%>">다음</a>
            <% } %>
        </div>
    </div>

</body>
</html>