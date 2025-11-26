package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date; // java.sql.Date 사용
import BEAN.user; 

// 주의: 이 버전은 DBConnectionMgr을 사용하지 않고 수동으로 연결을 관리합니다.
public class UserDAO {
    // ⭐ 1. DB 접속 정보 설정 (수동 유지)
    private final String driver = "com.mysql.cj.jdbc.Driver"; 
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8"; 
    private final String id = "root"; 
    private final String pw = "121709"; 

    // ⭐ 2. DB 연결을 담당하는 메서드 (수동 유지)
    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
            // System.out.println("★ DB 연결 성공!");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("☆ DB 연결 실패!");
        }
        return conn;
    }
    
    // --- 기존 구현 기능 ---
    
    // 3. 단일 회원 정보 조회 (마이페이지)
    public user selectUserById(String userId) {
        user user = null; 
        Connection conn = getConnection(); 
        
        String sql = "SELECT idUSER, NAME, GENDER, BIRTH, PASSWORD FROM USER WHERE idUSER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new user(); 
                    user.setIdUSER(rs.getString("idUSER"));
                    user.setNAME(rs.getString("NAME"));
                    user.setGENDER(rs.getInt("GENDER"));
                    user.setBIRTH(rs.getDate("BIRTH")); 
                    user.setPASSWORD(rs.getString("PASSWORD"));
                }
            }
        } catch (Exception e) {
            System.err.println("★ 회원 정보 조회 중 오류 발생!");
            e.printStackTrace();
        } 
        // finally 블록에 conn.close()를 추가해야 정석이나, 현재 코드를 따릅니다.
        return user;
    }
    
    // 4. 로그인 체크 (ID, PW 검증)
    public user loginCheck(String userId, String userPw) {
        user user = null; 
        Connection conn = getConnection(); 
        
        String sql = "SELECT idUSER, NAME FROM USER WHERE idUSER = ? AND PASSWORD = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userPw);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new user(); 
                    user.setIdUSER(rs.getString("idUSER"));
                    user.setNAME(rs.getString("NAME"));
                }
            }
        } catch (Exception e) {
            System.err.println("★ 로그인 조회 중 오류 발생!");
            e.printStackTrace();
        }
        return user;
    }
    
    // 5. 회원가입 (INSERT)
    public boolean insertUser(user newUser) { 
        Connection conn = getConnection(); 
        
        String sql = "INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newUser.getIdUSER());
            pstmt.setString(2, newUser.getNAME());
            pstmt.setInt(3, newUser.getGENDER());
            pstmt.setDate(4, newUser.getBIRTH());
            pstmt.setString(5, newUser.getPASSWORD());
            
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected == 1;
            
        } catch (SQLException e) {
            System.err.println("★ 회원가입 중 오류 발생 (ID 중복 등)!");
            e.printStackTrace();
            return false;
        } 
    }
    
    // --- 버전 1에서 가져온 새로운 기능 (검색) ---

    // 6. 사용자 검색 (팔로우 여부 포함, 페이징 처리)
    public ArrayList<user> searchUsers(String myId, String keyword, int page, int limit) {
        ArrayList<user> list = new ArrayList<>();
        Connection con = getConnection(); // getConnection 사용
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 시작 인덱스 계산
        int start = (page - 1) * limit;
        
        try {
            // 쿼리 설명: 서브쿼리로 내가 팔로우했는지 확인 (IS_FOLLOWED)
            String sql = "SELECT u.*, "
                       + "(SELECT COUNT(*) FROM FOLLOW f WHERE f.FOLLOWING = ? AND f.FOLLOWER = u.idUSER) as IS_FOLLOWED "
                       + "FROM USER u "
                       + "WHERE (u.idUSER LIKE ? OR u.NAME LIKE ?) "
                       + "AND u.idUSER != ? " // 내 자신은 검색에서 제외
                       + "ORDER BY u.idUSER ASC LIMIT ?, ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId); 
            pstmt.setString(2, "%" + keyword + "%"); 
            pstmt.setString(3, "%" + keyword + "%"); 
            pstmt.setString(4, myId); 
            pstmt.setInt(5, start); 
            pstmt.setInt(6, limit); 
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                user bean = new user();
                bean.setIdUSER(rs.getString("idUSER"));
                bean.setNAME(rs.getString("NAME"));
                bean.setGENDER(rs.getInt("GENDER"));
                bean.setBIRTH(rs.getDate("BIRTH")); 
                bean.setPASSWORD(rs.getString("PASSWORD")); 
                
                // ⭐ user VO에 setFollowed(boolean) 메서드가 없으므로, 현재는 이 정보를 저장할 수 없습니다.
                // 임시로 출력만 확인합니다:
                // System.out.println("Followed: " + (rs.getInt("IS_FOLLOWED") > 0));
                
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 반납 (ResultSet, PreparedStatement, Connection)
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // 7. 검색된 총 인원수 구하기 (페이지네이션 계산용)
    public int getSearchCount(String myId, String keyword) {
        int count = 0;
        Connection con = getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT COUNT(*) FROM USER WHERE (idUSER LIKE ? OR NAME LIKE ?) AND idUSER != ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, myId);
            
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); } 
        finally {
            // 자원 반납
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return count;
    }
}
