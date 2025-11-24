<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.PostDAO" %>
<%
    String myId = (String) session.getAttribute("idKey");
    String postIdStr = request.getParameter("id");
    String tab = request.getParameter("tab");

    if (myId != null && postIdStr != null) {
        PostDAO dao = new PostDAO();
        dao.toggleLike(myId, Integer.parseInt(postIdStr));
    }
    response.sendRedirect("main.jsp?tab=" + (tab != null ? tab : "ALL"));
%>