<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, DB.DBConnectionMgr" %>
<%
    String myId = (String) session.getAttribute("idKey");
    String targetId = request.getParameter("targetId");
    String keyword = request.getParameter("keyword");
    String pageNum = request.getParameter("page");
    
    if(myId != null && targetId != null) {
        DBConnectionMgr pool = new DBConnectionMgr();
        Connection con = pool.getConnection();
        
        // 1. 이미 팔로우 중인지 확인
        String checkSql = "SELECT * FROM FOLLOW WHERE FOLLOWER=? AND FOLLOWING=?";
        PreparedStatement pstmt = con.prepareStatement(checkSql);
        pstmt.setString(1, myId);
        pstmt.setString(2, targetId);
        ResultSet rs = pstmt.executeQuery();
        
        if(rs.next()) {
            // 이미 팔로우 중 -> 언팔로우(삭제)
            String delSql = "DELETE FROM FOLLOW WHERE FOLLOWER=? AND FOLLOWING=?";
            PreparedStatement pstmt2 = con.prepareStatement(delSql);
            pstmt2.setString(1, myId);
            pstmt2.setString(2, targetId);
            pstmt2.executeUpdate();
            pstmt2.close();
        } else {
            // 팔로우 안함 -> 팔로우(추가)
            String insSql = "INSERT INTO FOLLOW (FOLLOWER, FOLLOWING) VALUES (?, ?)";
            PreparedStatement pstmt2 = con.prepareStatement(insSql);
            pstmt2.setString(1, myId);
            pstmt2.setString(2, targetId);
            pstmt2.executeUpdate();
            pstmt2.close();
        }
        
        pool.freeConnection(con, pstmt, rs);
    }
    
    // 처리가 끝나면 다시 검색 페이지로 돌아감 (새로고침 효과)
    response.sendRedirect("search.jsp?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&page=" + pageNum);
%>