package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import BEAN.post_like; // ⭐ 새로 만든 post_like VO import

public class LikeDAO {
    // 1. DB 접속 정보 설정 (UserDAO, FollowDAO와 동일)
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8";
    private final String id = "root";
    private final String pw = "121709"; // 사용자님의 비밀번호로 가정
    
    // 2. DB 연결 메서드
    public Connection getConnection() {
        // ... (getConnection() 메서드 구현 내용은 FollowDAO와 동일) ...
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    // 3. 좋아요 추가 (INSERT)
    public boolean insertLike(post_like likeBean) {
        Connection conn = getConnection();
        // SQL: POST_LIKE 테이블에 게시물 ID와 사용자 ID 삽입
        String sql = "INSERT INTO POST_LIKE (POST_idPOST, USER_idUSER) VALUES (?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, likeBean.getPOST_idPOST());
            pstmt.setString(2, likeBean.getUSER_idUSER());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1; 
        } catch (SQLException e) {
            System.err.println("★ 좋아요 삽입 오류 (이미 좋아요 누름): " + e.getMessage());
            return false;
        }
    }
    
    // 4. 좋아요 취소 (DELETE)
    public boolean deleteLike(post_like likeBean) {
        Connection conn = getConnection();
        // SQL: 게시물 ID와 사용자 ID가 일치하는 행을 삭제
        String sql = "DELETE FROM POST_LIKE WHERE POST_idPOST = ? AND USER_idUSER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, likeBean.getPOST_idPOST());
            pstmt.setString(2, likeBean.getUSER_idUSER());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1;
        } catch (SQLException e) {
            System.err.println("★ 좋아요 취소 DB 오류: " + e.getMessage());
            return false;
        }
    }
}