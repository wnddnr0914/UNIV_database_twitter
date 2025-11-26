<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.CommentDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String myId = (String) session.getAttribute("idKey");
    String commentSeqStr = request.getParameter("commentSeq");
    String content = request.getParameter("content");
    String tab = request.getParameter("tab");

    if (myId != null && commentSeqStr != null && content != null && !content.trim().equals("")) {
        CommentDAO dao = new CommentDAO();
        dao.insertReply(Integer.parseInt(commentSeqStr), myId, content);
    }

    response.sendRedirect("main.jsp?tab=" + (tab != null ? tab : "ALL"));
%>