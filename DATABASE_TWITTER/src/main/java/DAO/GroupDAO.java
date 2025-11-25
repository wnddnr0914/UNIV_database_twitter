package DAO;

import java.sql.*;
import java.util.ArrayList;
import BEAN.group; // group BEAN 필요
import DB.DBConnectionMgr;

public class GroupDAO {
    private DBConnectionMgr pool;

    public GroupDAO() {
        try { pool = new DBConnectionMgr(); } catch (Exception e) { e.printStackTrace(); }
    }

    // 1. 그룹 생성
    public boolean createGroup(String groupName) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO `GROUP` (G_NAME) VALUES (?)"; // GROUP은 예약어라 백틱(``) 권장
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, groupName);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
        finally { pool.freeConnection(con, pstmt); }
    }

    // 2. 전체 그룹 목록 조회 (가입용)
    public ArrayList<group> getAllGroups() {
        ArrayList<group> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM `GROUP` ORDER BY SEQ_GROUP DESC";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                group g = new group();
                g.setSEQ_GROUP(rs.getInt("SEQ_GROUP"));
                g.setG_NAME(rs.getString("G_NAME"));
                list.add(g);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { pool.freeConnection(con, pstmt, rs); }
        return list;
    }

    // 3. 그룹 가입
    public boolean joinGroup(String userId, int groupSeq) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            // 이미 가입했는지 체크는 생략(PK 제약조건으로 에러나면 catch로 잡힘)
            String sql = "INSERT INTO JOIN_GROUP (USER_idUSER, GROUP_SEQ_GROUP) VALUES (?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, groupSeq);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { 
            // e.printStackTrace(); // 이미 가입된 경우 에러 로그 안 찍히게 주석 처리 가능
            return false; 
        }
        finally { pool.freeConnection(con, pstmt); }
    }

    // 4. 내가 가입한 그룹인지 확인 (버튼 상태용)
    public boolean isJoined(String userId, int groupSeq) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM JOIN_GROUP WHERE USER_idUSER=? AND GROUP_SEQ_GROUP=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, groupSeq);
            rs = pstmt.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); return false; }
        finally { pool.freeConnection(con, pstmt, rs); }
    }
}
