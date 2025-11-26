<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.CommentDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String myId = (String) session.getAttribute("idKey");
    String postIdStr = request.getParameter("postId");
    String content = request.getParameter("content");
    String tab = request.getParameter("tab");
    
    if (myId != null && postIdStr != null && content != null && !content.trim().equals("")) {
        CommentDAO dao = new CommentDAO();
        dao.insertComment(Integer.parseInt(postIdStr), myId, content);
    }
    
    response.sendRedirect("main.jsp?tab=" + (tab != null ? tab : "ALL"));
%>