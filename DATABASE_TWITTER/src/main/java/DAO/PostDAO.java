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
        finally { pool.freeConnection(con, pstmt); }
    }

    // 2. 타임라인 목록 가져오기 (mode: "ALL" 또는 "FOLLOW")
    public ArrayList<post> getTimeline(String myId, String mode) {
        ArrayList<post> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            
            // 쿼리 설명: 게시글 + 작성자이름 + 좋아요개수 + 내가좋아요했는지 여부 를 한방에 가져옴
            String sql = "SELECT p.*, u.NAME, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST) AS like_cnt, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST AND pl.USER_idUSER = ?) AS my_like "
                       + "FROM POST p JOIN USER u ON p.USER_idUSER = u.idUSER ";

            // '팔로잉' 탭이면 내가 팔로우한 사람 글만 보기
            if ("FOLLOW".equals(mode)) {
                sql += "WHERE p.USER_idUSER IN (SELECT FOLLOWING FROM FOLLOW WHERE FOLLOWER = ?) ";
            }
            
            sql += "ORDER BY p.idPOST DESC LIMIT 50"; // 최신순 50개

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId); // 좋아요 여부 확인용
            
            if ("FOLLOW".equals(mode)) {
                pstmt.setString(2, myId); // 팔로우 필터링용
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                post bean = new post();
                bean.setIdPOST(rs.getInt("idPOST"));
                bean.setUser(rs.getString("USER_idUSER"));
                bean.setUserName(rs.getString("NAME"));
                bean.setDetail(rs.getString("detail"));
                bean.setDate(rs.getTimestamp("DATE"));
                bean.setLikeCount(rs.getInt("like_cnt"));
                bean.setLiked(rs.getInt("my_like") > 0); // 0보다 크면 true
                list.add(bean);
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { pool.freeConnection(con, pstmt, rs); }
        return list;
    }

    // 3. 좋아요 토글 (있으면 삭제, 없으면 추가)
    public void toggleLike(String userId, int postId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            // 이미 좋아요 눌렀는지 확인
            String checkSql = "SELECT * FROM POST_LIKE WHERE POST_idPOST=? AND USER_idUSER=?";
            pstmt = con.prepareStatement(checkSql);
            pstmt.setInt(1, postId);
            pstmt.setString(2, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) { // 이미 있음 -> 삭제(취소)
                pstmt.close(); // 기존 pstmt 닫기
                String delSql = "DELETE FROM POST_LIKE WHERE POST_idPOST=? AND USER_idUSER=?";
                pstmt = con.prepareStatement(delSql);
                pstmt.setInt(1, postId);
                pstmt.setString(2, userId);
                pstmt.executeUpdate();
            } else { // 없음 -> 추가
                pstmt.close();
                String insSql = "INSERT INTO POST_LIKE (POST_idPOST, USER_idUSER) VALUES (?, ?)";
                pstmt = con.prepareStatement(insSql);
                pstmt.setInt(1, postId);
                pstmt.setString(2, userId);
                pstmt.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { pool.freeConnection(con, pstmt, rs); }
    }
    // 4. 특정 유저의 게시글 개수 구하기 (마이페이지용)
    public int getPostCount(String userId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM POST WHERE USER_idUSER = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return count;
    }
    // 5. 특정 유저의 게시글 목록 가져오기 (마이페이지용)
    // targetId: 프로필 주인, myId: 현재 로그인한 사람(좋아요 여부 확인용)
    public ArrayList<post> getUserPosts(String targetId, String myId) {
        ArrayList<post> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            
            // 쿼리: 해당 유저(targetId)가 쓴 글만 조회 + 좋아요 정보 포함
            String sql = "SELECT p.*, u.NAME, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST) AS like_cnt, "
                       + "(SELECT COUNT(*) FROM POST_LIKE pl WHERE pl.POST_idPOST = p.idPOST AND pl.USER_idUSER = ?) AS my_like "
                       + "FROM POST p JOIN USER u ON p.USER_idUSER = u.idUSER "
                       + "WHERE p.USER_idUSER = ? " // ⭐ 이 부분이 핵심 (특정 유저 필터링)
                       + "ORDER BY p.idPOST DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId);     // 내가 좋아요 눌렀는지 확인용
            pstmt.setString(2, targetId); // 게시글 주인 아이디

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
        finally { pool.freeConnection(con, pstmt, rs); }
        return list;
    }
}
