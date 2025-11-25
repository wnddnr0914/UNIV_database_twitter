<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.GroupDAO, BEAN.group, java.util.ArrayList" %>
<%
    String myId = (String) session.getAttribute("idKey");
    if (myId == null) { response.sendRedirect("login.jsp"); return; }
    
    GroupDAO dao = new GroupDAO();
    ArrayList<group> groupList = dao.getAllGroups();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그룹 관리</title>
<style>
    /* 간단한 스타일 (트위터 느낌) */
    body { font-family: Arial, sans-serif; background: #f7f9f9; padding: 20px; display: flex; justify-content: center; }
    .container { background: white; width: 500px; padding: 30px; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    h2 { color: #0f1419; }
    
    .create-box { display: flex; gap: 10px; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eff3f4; }
    .input-text { flex: 1; padding: 10px; border: 1px solid #cfd9de; border-radius: 5px; }
    .btn { padding: 10px 20px; border: none; border-radius: 20px; font-weight: bold; cursor: pointer; }
    .btn-blue { background: #1d9bf0; color: white; }
    
    .group-item { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #eff3f4; }
    .group-name { font-weight: bold; font-size: 16px; }
    .btn-join { background: #0f1419; color: white; }
    .btn-joined { background: white; color: #0f1419; border: 1px solid #cfd9de; cursor: default; }
    
    a { text-decoration: none; color: #1d9bf0; font-weight: bold; display: block; margin-top: 20px; text-align: center;}
</style>
</head>
<body>
    <div class="container">
        <h2>👥 그룹 만들기</h2>
        <form action="group_action.jsp" method="post" class="create-box">
            <input type="hidden" name="action" value="create">
            <input type="text" name="groupName" class="input-text" placeholder="새 그룹 이름 입력" required>
            <button type="submit" class="btn btn-blue">생성</button>
        </form>
        
        <h2>탐색 및 가입</h2>
        <div class="list-box">
            <% for(group g : groupList) { 
                boolean isJoined = dao.isJoined(myId, g.getSEQ_GROUP());
            %>
            <div class="group-item">
                <span class="group-name"># <%= g.getG_NAME() %></span>
                <% if(isJoined) { %>
                    <button class="btn btn-joined" disabled>가입됨</button>
                <% } else { %>
                    <button class="btn btn-join" onclick="location.href='group_action.jsp?action=join&seq=<%=g.getSEQ_GROUP()%>'">가입하기</button>
                <% } %>
            </div>
            <% } %>
        </div>
        
        <a href="main.jsp">🏠 홈으로 돌아가기</a>
    </div>
</body>
</html>
