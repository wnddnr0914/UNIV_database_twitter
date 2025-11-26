<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.GroupDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    String action = request.getParameter("action");
    
    if(myId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    GroupDAO dao = new GroupDAO();
    
    if("create".equals(action)) {
        String name = request.getParameter("groupName");
        if(name != null && !name.isEmpty()) {
            dao.createGroup(name);
        }
    } else if("join".equals(action)) {
        String seqStr = request.getParameter("seq");
        if(seqStr != null) {
            dao.joinGroup(myId, Integer.parseInt(seqStr));
        }
    }
    
    response.sendRedirect("group.jsp");
%>
