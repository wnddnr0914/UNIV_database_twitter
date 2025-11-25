package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import BEAN.follow; // ⭐ BEAN 패키지의 소문자 파일명 follow를 import

public class FollowDAO {
    // 1. DB 접속 정보 설정 (UserDAO와 동일하게 유지)
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8";
    private final String id = "root";
    private final String pw = "L22kjun0!@"; // 사용자님의 비밀번호로 가정
    
    // 2. DB 연결 메서드 (UserDAO에서 복사)
    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
            // System.out.println("★ DB 연결 성공!"); // 로그는 필요할 때만 활성화
        } catch (Exception e) {
            e.printStackTrace();
            // System.err.println("☆ DB 연결 실패!");
        }
        return conn;
    }

    // 3. 팔로우 관계 삽입 (INSERT)
    // BEAN.follow 객체를 사용하여 팔로우 정보를 DB에 저장합니다.
    public boolean insertFollow(follow followBean) {
        Connection conn = getConnection();
        // SQL: FOLLOW 테이블에 FOLLOWING(나)와 FOLLOWER(대상) 삽입
        String sql = "INSERT INTO FOLLOW (FOLLOWING, FOLLOWER) VALUES (?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            // BEAN.follow 객체의 getter를 사용하여 값 설정
            pstmt.setString(1, followBean.getFollowing());
            pstmt.setString(2, followBean.getFollower());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1; // 1행 삽입 성공 시 true
        } catch (SQLException e) {
            // PK 충돌(이미 팔로우 중인 경우) 또는 FK 오류 발생 시 false 반환
            System.err.println("★ 팔로우 삽입 오류 (이미 팔로우 중일 수 있음): " + e.getMessage());
            return false;
        }
    }
    
    // 4. 팔로우 관계 삭제 (DELETE - 언팔로우)
    public boolean deleteFollow(follow followBean) {
        Connection conn = getConnection();
        // SQL: FOLLOWING과 FOLLOWER가 모두 일치하는 행을 삭제
        String sql = "DELETE FROM FOLLOW WHERE FOLLOWING = ? AND FOLLOWER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, followBean.getFollowing());
            pstmt.setString(2, followBean.getFollower());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1;
        } catch (SQLException e) {
            System.err.println("★ 언팔로우 DB 오류: " + e.getMessage());
            return false;
        }
    }
    // 5. 나를 따르는 사람 수 (팔로워 수) 조회
    public int getFollowerCount(String userId) {
        Connection conn = getConnection();
        int count = 0;
        // FOLLOWER가 '나'인 경우 -> 나를 팔로우 하는 사람들
        String sql = "SELECT COUNT(*) FROM FOLLOW WHERE FOLLOWER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // 6. 내가 따르는 사람 수 (팔로잉 수) 조회
    public int getFollowingCount(String userId) {
        Connection conn = getConnection();
        int count = 0;
        // FOLLOWING이 '나'인 경우 -> 내가 팔로우 하는 사람들
        String sql = "SELECT COUNT(*) FROM FOLLOW WHERE FOLLOWING = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
