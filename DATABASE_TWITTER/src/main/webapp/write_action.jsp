<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.PostDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    String content = request.getParameter("content");
    String tab = request.getParameter("tab"); // 현재 탭 유지용

    if (myId != null && content != null && !content.trim().equals("")) {
        PostDAO dao = new PostDAO();
        dao.insertPost(myId, content);
    }
    response.sendRedirect("main.jsp?tab=" + (tab != null ? tab : "ALL"));
%>