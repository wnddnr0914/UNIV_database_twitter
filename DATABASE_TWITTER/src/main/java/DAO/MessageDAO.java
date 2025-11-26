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
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&characterEncoding=UTF-8";
    private final String id = "root";
    private final String pw = "121709";

    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, id, pw);
        } catch (Exception e) { e.printStackTrace(); }
        return conn;
    }

    // 1. 메시지 전송
    public boolean sendMessage(message msgBean) {
        Connection conn = getConnection();
        String sql = "INSERT INTO MESSAGE (idMESSAGE, Sender, Recipient, TEXT, DATE) VALUES (?, ?, ?, ?, ?)"; 
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (int) (System.currentTimeMillis() % 100000) + (int)(Math.random() * 100)); 
            pstmt.setString(2, msgBean.getSender());
            pstmt.setString(3, msgBean.getRecipient());
            pstmt.setString(4, msgBean.getTEXT());
            pstmt.setTimestamp(5, msgBean.getDATE());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected == 1;
        } catch (SQLException e) {
            System.err.println("★ 메시지 전송 DB 오류: " + e.getMessage());
            return false;
        }
    }
    
    // 2. 대화 목록 조회 (페이징 적용: page, limit 추가)
    public List<message> getConversationList(String userId, int page, int limit) {
        List<message> conversation = new ArrayList<>();
        Connection conn = getConnection();
        int start = (page - 1) * limit;
        
        String sql = "SELECT idMESSAGE, Sender, Recipient, TEXT, DATE FROM MESSAGE "
                   + "WHERE Sender = ? OR Recipient = ? "
                   + "ORDER BY DATE DESC LIMIT ?, ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userId); 
            pstmt.setInt(3, start);
            pstmt.setInt(4, limit);
            
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

    // [추가] 전체 쪽지 개수 (페이징 계산용)
    public int getTotalMessageCount(String userId) {
        Connection conn = getConnection();
        int count = 0;
        String sql = "SELECT COUNT(*) FROM MESSAGE WHERE Sender = ? OR Recipient = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) count = rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }
}