<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, BEAN.user" %>
<%
    request.setCharacterEncoding("UTF-8");
    String myId = (String) session.getAttribute("idKey");
    
    if (myId == null) { response.sendRedirect("login.jsp"); return; }

    UserDAO dao = new UserDAO();
    user member = dao.selectUserById(myId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>프로필 수정 / X</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .edit-container { 
            background: white;
            width: 100%;
            max-width: 550px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideIn 0.5s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        h2 { 
            margin: 0 0 10px 0;
            color: #14171a;
            font-size: 32px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .subtitle {
            color: #657786;
            font-size: 15px;
            margin-bottom: 35px;
        }
        
        .form-group { 
            margin-bottom: 25px;
        }
        
        label { 
            display: block;
            font-weight: 700;
            margin-bottom: 10px;
            color: #14171a;
            font-size: 15px;
        }
        
        input[type="text"], 
        input[type="password"], 
        input[type="date"] { 
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f7f9fa;
            color: #14171a;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="date"]:focus {
            outline: none;
            border-color: #1da1f2;
            background: white;
            box-shadow: 0 0 0 4px rgba(29, 161, 242, 0.1);
        }
        
        .readonly-field { 
            background-color: #e1e8ed !important;
            color: #657786 !important;
            cursor: not-allowed;
        }
        
        /* 라디오 버튼 스타일 */
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        
        .radio-item:hover {
            background: #f7f9fa;
        }
        
        input[type="radio"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #1da1f2;
        }
        
        .radio-item label {
            margin: 0;
            font-weight: 500;
            cursor: pointer;
            font-size: 15px;
        }
        
        /* 버튼 스타일 */
        .btn-box { 
            display: flex;
            gap: 12px;
            margin-top: 35px;
        }
        
        .btn { 
            flex: 1;
            padding: 14px;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .btn-save { 
            background: linear-gradient(135deg, #1da1f2 0%, #0d8bd9 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(29, 161, 242, 0.3);
        }
        
        .btn-save:hover { 
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(29, 161, 242, 0.4);
        }
        
        .btn-save:active {
            transform: translateY(0);
        }
        
        .btn-cancel { 
            background: white;
            border: 2px solid #e1e8ed;
            color: #14171a;
        }
        
        .btn-cancel:hover { 
            background: #f7f9fa;
            border-color: #657786;
        }
        
        /* 프로필 이미지 미리보기 */
        .profile-preview {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #f7f9fa 0%, #ffffff 100%);
            border-radius: 16px;
        }
        
        .profile-preview-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0 auto 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        
        .profile-preview-name {
            font-size: 20px;
            font-weight: 700;
            color: #14171a;
            margin-bottom: 5px;
        }
        
        .profile-preview-id {
            font-size: 15px;
            color: #657786;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2>✏️ 프로필 수정</h2>
        <p class="subtitle">회원 정보를 수정하세요</p>
        
        <div class="profile-preview">
            <div class="profile-preview-img"></div>
            <div class="profile-preview-name"><%= member.getNAME() %></div>
            <div class="profile-preview-id">@<%= member.getIdUSER() %></div>
        </div>
        
        <form action="profile_update_action.jsp" method="post">
            
            <div class="form-group">
                <label>아이디 (변경 불가)</label>
                <input type="text" name="id" value="<%= member.getIdUSER() %>" readonly class="readonly-field">
            </div>
            
            <div class="form-group">
                <label>비밀번호</label>
                <input type="password" name="pass" value="<%= member.getPASSWORD() %>" required placeholder="새 비밀번호 입력">
            </div>
            
            <div class="form-group">
                <label>이름 (닉네임)</label>
                <input type="text" name="name" value="<%= member.getNAME() %>" required placeholder="표시될 이름">
            </div>
            
            <div class="form-group">
                <label>생년월일</label>
                <input type="date" name="birth" value="<%= member.getBIRTH() %>" required>
            </div>

            <div class="form-group">
                <label>성별</label>
                <div class="radio-group">
                    <div class="radio-item">
                        <input type="radio" id="male" name="gender" value="1" <%= member.getGENDER() == 1 ? "checked" : "" %>>
                        <label for="male">남성</label>
                    </div>
                    <div class="radio-item">
                        <input type="radio" id="female" name="gender" value="2" <%= member.getGENDER() == 2 ? "checked" : "" %>>
                        <label for="female">여성</label>
                    </div>
                </div>
            </div>

            <div class="btn-box">
                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-save">저장하기</button>
            </div>
        </form>
    </div>
</body>
</html>
