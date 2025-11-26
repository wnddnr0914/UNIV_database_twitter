<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, DB.DBConnectionMgr" %>
<%
    request.setCharacterEncoding("UTF-8");

    String myId = (String) session.getAttribute("idKey"); // 나 (FOLLOWING)
    String targetId = request.getParameter("targetId");   // 상대방 (FOLLOWER)
    
    // 어디서 왔는지 확인
    String from = request.getParameter("from");         
    String keyword = request.getParameter("keyword");   
    String pageNum = request.getParameter("page");      
    String listId = request.getParameter("listId");     
    String mode = request.getParameter("mode");         

    if(myId != null && targetId != null) {
        DBConnectionMgr pool = new DBConnectionMgr();
        Connection con = pool.getConnection();
        
        // 1. 이미 팔로우 중인지 확인
        // 규칙: FOLLOWING = 나, FOLLOWER = 상대방
        String checkSql = "SELECT * FROM FOLLOW WHERE FOLLOWING=? AND FOLLOWER=?";
        PreparedStatement pstmt = con.prepareStatement(checkSql);
        pstmt.setString(1, myId);     // 나
        pstmt.setString(2, targetId); // 상대방
        ResultSet rs = pstmt.executeQuery();
        
        if(rs.next()) { 
            // 이미 있음 -> 삭제 (언팔로우)
            String delSql = "DELETE FROM FOLLOW WHERE FOLLOWING=? AND FOLLOWER=?";
            PreparedStatement pstmt2 = con.prepareStatement(delSql);
            pstmt2.setString(1, myId);
            pstmt2.setString(2, targetId);
            pstmt2.executeUpdate();
            pstmt2.close();
        } else { 
            // 없음 -> 추가 (팔로우)
            String insSql = "INSERT INTO FOLLOW (FOLLOWING, FOLLOWER) VALUES (?, ?)";
            PreparedStatement pstmt2 = con.prepareStatement(insSql);
            pstmt2.setString(1, myId);     // 나 (FOLLOWING)
            pstmt2.setString(2, targetId); // 상대방 (FOLLOWER)
            pstmt2.executeUpdate();
            pstmt2.close();
        }
        
        pool.freeConnection(con, pstmt, rs);
    }
    
    // 2. 원래 있던 페이지로 되돌아가기
    if("search".equals(from)) {
        // [중요] 검색 페이지로 복귀
        if(keyword == null) keyword = "";
        response.sendRedirect("search.jsp?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&page=" + (pageNum != null ? pageNum : "1"));
        
    } else if("list".equals(from)) {
        // 팔로워/팔로잉 리스트 팝업으로 복귀
        response.sendRedirect("follow_list.jsp?id=" + listId + "&mode=" + mode);
        
    } else {
        // 그 외에는(마이페이지 등) 상대방 프로필로 이동
        response.sendRedirect("mypage.jsp?id=" + targetId);
    }
%>