package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import BEAN.message; 

public class MessageDAO {
    // DB 접속 정보 설정 (이전 DAO와 동일)
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8";
    private final String id = "root";
    private final String pw = "L22kjun0!@"; // 사용자님의 비밀번호로 가정

    // DB 연결 메서드
    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    // 1. 메시지 전송 (INSERT) - Java에서 생성한 Timestamp 사용
    public boolean sendMessage(message msgBean) {
        Connection conn = getConnection();
        // SQL: DATE 컬럼에도 값을 명시적으로 받음
        String sql = "INSERT INTO MESSAGE (idMESSAGE, Sender, Recipient, TEXT, DATE) VALUES (?, ?, ?, ?, ?)"; 
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            // 임시 ID 생성 (충돌 방지를 위해 Math.random() 추가)
            pstmt.setInt(1, (int) (System.currentTimeMillis() % 100000) + (int)(Math.random() * 100)); 
            pstmt.setString(2, msgBean.getSender());
            pstmt.setString(3, msgBean.getRecipient());
            pstmt.setString(4, msgBean.getTEXT());
            pstmt.setTimestamp(5, msgBean.getDATE()); // Java Timestamp 객체를 전달
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1;
        } catch (SQLException e) {
            System.err.println("★ 메시지 전송 DB 오류: " + e.getMessage());
            return false;
        }
    }
    
    // 2. 대화 목록 조회 (SELECT - 송신/수신 모두 포함)
    public List<message> getConversationList(String userId) {
        List<message> conversation = new ArrayList<>();
        Connection conn = getConnection();
        
        // 쿼리: Sender가 나이거나 Recipient가 나인 모든 대화를 최신순으로 조회 (참고 코드 반영)
        String sql = "SELECT idMESSAGE, Sender, Recipient, TEXT, DATE FROM MESSAGE WHERE Sender = ? OR Recipient = ? ORDER BY DATE DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userId); 
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    message msg = new message();
                    msg.setIdMESSAGE(rs.getInt("idMESSAGE"));
                    msg.setSender(rs.getString("Sender"));
                    msg.setRecipient(rs.getString("Recipient"));
                    msg.setTEXT(rs.getString("TEXT"));
                    msg.setDATE(rs.getTimestamp("DATE"));
                    conversation.add(msg);
                }
            }
        } catch (SQLException e) {
            System.err.println("★ 대화 목록 조회 DB 오류: " + e.getMessage());
        }
        return conversation;
    }
}