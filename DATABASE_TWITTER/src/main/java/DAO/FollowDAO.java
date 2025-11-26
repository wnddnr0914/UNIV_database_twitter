package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import BEAN.follow; // ⭐ BEAN 패키지의 소문자 파일명 follow를 import
import java.util.ArrayList;
import BEAN.user; // 팔로워/팔로잉 목록은 user 객체로 담아야 함
public class FollowDAO {
    // 1. DB 접속 정보 설정 (UserDAO와 동일하게 유지)
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8";
    private final String id = "root";
    private final String pw = "121709"; // 사용자님의 비밀번호로 가정
    
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
 // 7. 팔로잉/팔로워 리스트 가져오기 (핵심 기능)
    // mode: "FOLLOWER" (나를 따르는 사람 목록) / "FOLLOWING" (내가 따르는 사람 목록)
    public ArrayList<user> getFollowList(String targetId, String myId, String mode) {
        ArrayList<user> list = new ArrayList<>();
        Connection conn = getConnection(); // 기존 수동 연결 메서드 사용
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "";

            if ("FOLLOWER".equals(mode)) {
                // targetId를 팔로우하는 사람들 목록 (Follower List)
                // 논리: FOLLOWER 컬럼이 targetId인 행들의 FOLLOWING(한 사람) 정보를 가져옴
                // + '내(myId)'가 그 사람을 팔로우 중인지 확인 (IS_FOLLOWED)
                sql = "SELECT u.*, "
                    + "(SELECT COUNT(*) FROM FOLLOW f2 WHERE f2.FOLLOWING = ? AND f2.FOLLOWER = u.idUSER) AS IS_FOLLOWED "
                    + "FROM USER u JOIN FOLLOW f ON u.idUSER = f.FOLLOWING "
                    + "WHERE f.FOLLOWER = ?";
            } else {
                // targetId가 팔로우하는 사람들 목록 (Following List)
                // 논리: FOLLOWING 컬럼이 targetId인 행들의 FOLLOWER(당한 사람) 정보를 가져옴
                sql = "SELECT u.*, "
                    + "(SELECT COUNT(*) FROM FOLLOW f2 WHERE f2.FOLLOWING = ? AND f2.FOLLOWER = u.idUSER) AS IS_FOLLOWED "
                    + "FROM USER u JOIN FOLLOW f ON u.idUSER = f.FOLLOWER "
                    + "WHERE f.FOLLOWING = ?";
            }

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, myId);     // 서브쿼리용: 내가 이 사람을 팔로우했는지 확인 (1=true)
            pstmt.setString(2, targetId); // 메인쿼리용: 리스트의 주인
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                user bean = new user();
                bean.setIdUSER(rs.getString("idUSER"));
                bean.setNAME(rs.getString("NAME"));
                bean.setGENDER(rs.getInt("GENDER"));
                bean.setBIRTH(rs.getDate("BIRTH"));
                
                // 검색 화면과 동일하게 팔로우 상태 저장
                bean.setFollowed(rs.getInt("IS_FOLLOWED") > 0);
                
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("★ 팔로우 리스트 조회 실패!");
        } finally {
            // 수동 연결이므로 꼼꼼하게 닫기
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        return list;
    }
}
