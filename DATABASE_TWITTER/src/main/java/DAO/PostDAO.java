package DAO;

import java.sql.*;
import java.util.ArrayList;
import BEAN.post;
import DB.DBConnectionMgr;

public class PostDAO {
    private DBConnectionMgr pool;

    public PostDAO() {
        try { pool = new DBConnectionMgr(); } catch (Exception e) { e.printStackTrace(); }
    }

    // 1. 게시글 작성
    public void insertPost(String userId, String content) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO POST (USER_idUSER, detail, DATE) VALUES (?, ?, NOW())";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, content);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if(pool != null) pool.freeConnection(con, pstmt); }
    }

    // 2. 타임라인 목록 가져오기 (페이징 적용: page, limit 추가)
    public ArrayList<post> getTimeline(String myId, String mode, int page, int limit) {
        ArrayList<post> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int start = (page - 1) * limit; // 시작 위치 계산

        try {
            con = pool.getConnection();
            
            String sql = "SELECT p.*, u.NAME, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST) AS like_cnt, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST AND pl.USER_idUSER = ?) AS my_like "
                       + "FROM POST p JOIN USER u ON p.USER_idUSER = u.idUSER ";

            if ("FOLLOW".equals(mode)) {
                sql += "WHERE p.USER_idUSER IN (SELECT FOLLOWING FROM FOLLOW WHERE FOLLOWER = ?) ";
            }
            
            sql += "ORDER BY p.idPOST DESC LIMIT ?, ?"; // 페이징 쿼리 추가

            pstmt = con.prepareStatement(sql);
            
            int idx = 1;
            pstmt.setString(idx++, myId); // 좋아요 확인용
            
            if ("FOLLOW".equals(mode)) {
                pstmt.setString(idx++, myId); // 팔로우 필터링용
            }
            
            pstmt.setInt(idx++, start);
            pstmt.setInt(idx++, limit);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                post bean = new post();
                bean.setIdPOST(rs.getInt("idPOST"));
                bean.setUser(rs.getString("USER_idUSER"));
                bean.setUserName(rs.getString("NAME"));
                bean.setDetail(rs.getString("detail"));
                bean.setDate(rs.getTimestamp("DATE"));
                bean.setLikeCount(rs.getInt("like_cnt"));
                bean.setLiked(rs.getInt("my_like") > 0);
                list.add(bean);
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
        return list;
    }

    // 3. 그룹 타임라인 가져오기 (페이징 적용)
    public ArrayList<post> getGroupTimeline(String myId, int page, int limit) {
        ArrayList<post> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int start = (page - 1) * limit;

        try {
            con = pool.getConnection();
            
            String sql = "SELECT p.*, u.NAME, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST) AS like_cnt, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST AND pl.USER_idUSER = ?) AS my_like "
                       + "FROM POST p "
                       + "JOIN USER u ON p.USER_idUSER = u.idUSER "
                       + "WHERE p.USER_idUSER IN ("
                       + "    SELECT DISTINCT j2.USER_idUSER "
                       + "    FROM JOIN_GROUP j1 "
                       + "    JOIN JOIN_GROUP j2 ON j1.GROUP_SEQ_GROUP = j2.GROUP_SEQ_GROUP "
                       + "    WHERE j1.USER_idUSER = ? "
                       + ") "
                       + "ORDER BY p.idPOST DESC LIMIT ?, ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId);
            pstmt.setString(2, myId);
            pstmt.setInt(3, start);
            pstmt.setInt(4, limit);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                post bean = new post();
                bean.setIdPOST(rs.getInt("idPOST"));
                bean.setUser(rs.getString("USER_idUSER"));
                bean.setUserName(rs.getString("NAME"));
                bean.setDetail(rs.getString("detail"));
                bean.setDate(rs.getTimestamp("DATE"));
                bean.setLikeCount(rs.getInt("like_cnt"));
                bean.setLiked(rs.getInt("my_like") > 0);
                list.add(bean);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
        return list;
    }

    // 4. 좋아요 토글
    public void toggleLike(String userId, int postId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            String checkSql = "SELECT * FROM POST_LIKE WHERE POST_idPOST=? AND USER_idUSER=?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setInt(1, postId);
            pstmt.setString(2, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) { 
                pstmt.close();
                String delSql = "DELETE FROM POST_LIKE WHERE POST_idPOST=? AND USER_idUSER=?";
                pstmt = con.prepareStatement(delSql);
                pstmt.setInt(1, postId);
                pstmt.setString(2, userId);
                pstmt.executeUpdate();
            } else { 
                pstmt.close();
                String insSql = "INSERT INTO POST_LIKE (POST_idPOST, USER_idUSER) VALUES (?, ?)";
                pstmt = con.prepareStatement(insSql);
                pstmt.setInt(1, postId);
                pstmt.setString(2, userId);
                pstmt.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
    }

    // 5. 특정 유저 게시글 (마이페이지용 - 페이징 미적용 상태 유지)
    public ArrayList<post> getUserPosts(String targetId, String myId) {
        ArrayList<post> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT p.*, u.NAME, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST) AS like_cnt, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST AND pl.USER_idUSER = ?) AS my_like "
                       + "FROM POST p JOIN USER u ON p.USER_idUSER = u.idUSER "
                       + "WHERE p.USER_idUSER = ? "
                       + "ORDER BY p.idPOST DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId);
            pstmt.setString(2, targetId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                post bean = new post();
                bean.setIdPOST(rs.getInt("idPOST"));
                bean.setUser(rs.getString("USER_idUSER"));
                bean.setUserName(rs.getString("NAME"));
                bean.setDetail(rs.getString("detail"));
                bean.setDate(rs.getTimestamp("DATE"));
                bean.setLikeCount(rs.getInt("like_cnt"));
                bean.setLiked(rs.getInt("my_like") > 0);
                list.add(bean);
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
        return list;
    }
    
    // 6. 게시글 개수 세기 (마이페이지용)
    public int getPostCount(String userId) {
        int count = 0;
        Connection con = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM POST WHERE USER_idUSER = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            if(rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
        return count;
    }

    // [추가] 메인 페이지용 전체 게시글 수 계산 (페이징 계산을 위해 필요)
    public int getTotalPostCount(String myId, String mode) {
        int count = 0;
        Connection con = null; PreparedStatement pstmt = null; ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "";
            
            if ("GROUP".equals(mode)) {
                sql = "SELECT COUNT(*) FROM POST p WHERE p.USER_idUSER IN ("
                    + "    SELECT DISTINCT j2.USER_idUSER "
                    + "    FROM JOIN_GROUP j1 "
                    + "    JOIN JOIN_GROUP j2 ON j1.GROUP_SEQ_GROUP = j2.GROUP_SEQ_GROUP "
                    + "    WHERE j1.USER_idUSER = ? "
                    + ")";
            } else if ("FOLLOW".equals(mode)) {
                sql = "SELECT COUNT(*) FROM POST WHERE USER_idUSER IN (SELECT FOLLOWING FROM FOLLOW WHERE FOLLOWER = ?)";
            } else {
                sql = "SELECT COUNT(*) FROM POST";
            }

            pstmt = con.prepareStatement(sql);
            if (!"ALL".equals(mode)) {
                pstmt.setString(1, myId);
            }
            
            rs = pstmt.executeQuery();
            if(rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        finally { if(pool != null) pool.freeConnection(con, pstmt, rs); }
        return count;
    }
}