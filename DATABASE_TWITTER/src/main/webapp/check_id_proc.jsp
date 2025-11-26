<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO" %>
<%
    // 1. 검사할 아이디 받기
    String userId = request.getParameter("userId");
    
    // 2. DAO 호출해서 검사
    if(userId != null && !userId.trim().isEmpty()) {
        UserDAO dao = new UserDAO();
        boolean isAvailable = dao.checkId(userId);
        
        if(isAvailable) {
            out.print("YES"); // 사용 가능
        } else {
            out.print("NO");  // 이미 있음
        }
    } else {
        out.print("EMPTY");
    }
%>