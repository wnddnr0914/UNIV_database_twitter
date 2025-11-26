<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 세션 삭제 (로그아웃 처리)
    session.invalidate();

    // 2. 알림 띄우고 로그인 페이지로 이동
%>
<script>
    alert("로그아웃 되었습니다.");
    location.href = "login.jsp";
</script>