<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    
    // 로그인 안 했으면 튕겨내기
    if (myId == null) { response.sendRedirect("login.jsp"); return; }

    // 현재 내 정보 가져오기 (기존 값을 화면에 보여주기 위해)
    UserDAO dao = new UserDAO();
    user member = dao.selectUserById(myId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>프로필 수정</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: #555; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .edit-container { background: white; width: 400px; padding: 30px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        h2 { margin-top: 0; color: #0f1419; }
        
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #536471; font-size: 14px; }
        input[type="text"], input[type="password"], input[type="date"] { width: 100%; padding: 10px; border: 1px solid #cfd9de; border-radius: 5px; box-sizing: border-box; font-size: 15px; }
        
        /* 버튼 스타일 */
        .btn-box { display: flex; gap: 10px; margin-top: 20px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 25px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-save { background-color: #0f1419; color: white; }
        .btn-save:hover { background-color: #272c30; }
        .btn-cancel { background-color: white; border: 1px solid #cfd9de; color: #0f1419; }
        .btn-cancel:hover { background-color: #eff3f4; }
        
        .readonly-field { background-color: #f7f9fa; color: #536471; }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2>프로필 수정</h2>
        <form action="profile_update_action.jsp" method="post">
            
            <div class="form-group">
                <label>아이디 (수정불가)</label>
                <input type="text" name="id" value="<%= member.getIdUSER() %>" readonly class="readonly-field">
            </div>
            
            <div class="form-group">
                <label>비밀번호</label>
                <input type="password" name="pass" value="<%= member.getPASSWORD() %>" required>
            </div>
            
            <div class="form-group">
                <label>이름 (닉네임)</label>
                <input type="text" name="name" value="<%= member.getNAME() %>" required>
            </div>
            
            <div class="form-group">
                <label>생년월일</label>
                <input type="date" name="birth" value="<%= member.getBIRTH() %>" required>
            </div>

            <div class="form-group">
                <label>성별</label>
                <input type="radio" name="gender" value="1" <%= member.getGENDER() == 1 ? "checked" : "" %>> 남성
                <input type="radio" name="gender" value="2" <%= member.getGENDER() == 2 ? "checked" : "" %>> 여성
            </div>

            <div class="btn-box">
                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-save">저장</button>
            </div>
        </form>
    </div>
</body>
</html>