package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement; 
import java.sql.ResultSet;       
import java.sql.SQLException;

import BEAN.user; // ⭐ 수정됨: BEAN.user (소문자) 클래스를 import

public class UserDAO {
    // 1. MySQL 접속 정보 설정
    private final String driver = "com.mysql.cj.jdbc.Driver"; 
    // DB 이름이 'twitter_DB'이고 인코딩이 UTF-8임을 명시
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8"; 
    private final String id = "root"; 
    private final String pw = "L22kjun0!@"; // 사용자님의 비밀번호

    // 2. DB 연결을 담당하는 메서드
    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
            // System.out.println("★ DB 연결 성공!"); // 콘솔에 성공 로그 출력 (옵션)
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("☆ DB 연결 실패!");
        }
        return conn;
    }
    
    // 3. 단일 회원 정보 조회 (마이페이지)
    public user selectUserById(String userId) {
        user user = null; // user 객체 선언
        Connection conn = getConnection(); 
        
        // 쿼리: BIRTH 컬럼이 java.sql.Date 타입이므로 getString 대신 getObject 또는 getDate 사용
        String sql = "SELECT idUSER, NAME, GENDER, BIRTH, PASSWORD FROM USER WHERE idUSER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new user(); 
                    // user.java VO의 대문자 필드명 setter 사용
                    user.setIdUSER(rs.getString("idUSER"));
                    user.setNAME(rs.getString("NAME"));
                    user.setGENDER(rs.getInt("GENDER"));
                    
                    // DB DATE 컬럼을 java.sql.Date 타입으로 가져옴
                    user.setBIRTH(rs.getDate("BIRTH")); 
                    
                    user.setPASSWORD(rs.getString("PASSWORD"));
                }
            }
        } catch (Exception e) {
            System.err.println("★ 회원 정보 조회 중 오류 발생!");
            e.printStackTrace();
        } 
        return user;
    }
    
    // 4. 로그인 체크 (ID, PW 검증)
    public user loginCheck(String userId, String userPw) {
        user user = null; // user 객체 선언
        Connection conn = getConnection(); 
        
        String sql = "SELECT idUSER, NAME FROM USER WHERE idUSER = ? AND PASSWORD = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userPw);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // 로그인 성공 시 ID와 NAME만 가져옴
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
            
            // java.sql.Date 타입의 BIRTH 필드를 setDate로 바인딩
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
}