<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user, java.sql.Date" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터 받기
    String id = request.getParameter("id");
    String pass = request.getParameter("pass");
    String name = request.getParameter("name");
    String birth = request.getParameter("birth");
    int gender = Integer.parseInt(request.getParameter("gender"));

    // 2. BEAN에 담기
    user bean = new user();
    bean.setIdUSER(id);
    bean.setPASSWORD(pass);
    bean.setNAME(name);
    bean.setBIRTH(Date.valueOf(birth)); // String -> Date 변환
    bean.setGENDER(gender);

    // 3. DAO로 업데이트 실행
    UserDAO dao = new UserDAO();
    dao.updateUser(bean);

    // 4. 마이페이지로 돌아가기 (새로고침 효과)
    response.sendRedirect("mypage.jsp?id=" + id);
%>