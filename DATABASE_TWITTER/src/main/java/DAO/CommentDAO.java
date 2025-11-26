package DAO;

import java.sql.*;
import java.util.ArrayList;
import BEAN.post_comment;
import DB.DBConnectionMgr;
import BEAN.reply_comment;  

public class CommentDAO {
    private DBConnectionMgr pool;
    
    public CommentDAO() {
        try {
            pool = new DBConnectionMgr();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 댓글 작성
    public boolean insertComment(int postId, String userId, String content) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            
            // 최대값 + 1
            String maxSql = "SELECT IFNULL(MAX(SEQ_POST), 0) + 1 AS next_seq FROM POST_COMMENT";
            pstmt = con.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            
            int nextSeq = 1;
            if (rs.next()) {
                nextSeq = rs.getInt("next_seq");
            }
            
            // 삽입
            String sql = "INSERT INTO POST_COMMENT (SEQ_POST, POST_idPOST, USER_idUSER, DETAIL, DATE) " +
                         "VALUES (?, ?, ?, ?, NOW())";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, nextSeq);
            pstmt.setInt(2, postId);
            pstmt.setString(3, userId);
            pstmt.setString(4, content);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
    }
    
    // 댓글 목록
    public ArrayList<post_comment> getComments(int postId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<post_comment> list = new ArrayList<>();
        
        try {
            con = pool.getConnection();
            String sql = "SELECT c.*, u.NAME " +
                        "FROM POST_COMMENT c " +
                        "JOIN USER u ON c.USER_idUSER = u.idUSER " +
                        "WHERE c.POST_idPOST = ? " +
                        "ORDER BY c.DATE DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                post_comment comment = new post_comment();
                comment.setSEQ_POST(rs.getInt("SEQ_POST"));
                comment.setPOST_idPOST(rs.getInt("POST_idPOST"));
                comment.setUSER_idUSER(rs.getString("USER_idUSER"));
                comment.setDETAIL(rs.getString("DETAIL"));
                comment.setDATE(rs.getTimestamp("DATE"));
                comment.setUserName(rs.getString("NAME"));  // 이름!
                list.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return list;
    }
    
    // 댓글 개수
    public int getCommentCount(int postId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) as cnt FROM POST_COMMENT WHERE POST_idPOST = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return 0;
    }
    	
	 // 대댓글 작성
	 public boolean insertReply(int commentSeq, String userId, String content) {
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     
	     try {
	         con = pool.getConnection();
	         
	         String sql = "INSERT INTO REPLY_COMMENT (POSTCOMMENT_SEQ_POST, USER_idUSER, DETAIL, DATE) " +
	                      "VALUES (?, ?, ?, NOW())";
	         
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, commentSeq);
	         pstmt.setString(2, userId);
	         pstmt.setString(3, content);
	         
	         int result = pstmt.executeUpdate();
	         return result > 0;
	     } catch (Exception e) {
	         e.printStackTrace();
	         return false;
	     } finally {
	         pool.freeConnection(con, pstmt);
	     }
	 }
	
	 // 대댓글 목록 조회
	 public ArrayList<reply_comment> getReplies(int commentSeq) {
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     ArrayList<reply_comment> list = new ArrayList<>();
	     
	     try {
	         con = pool.getConnection();
	         String sql = "SELECT r.*, u.NAME " +
	                     "FROM REPLY_COMMENT r " +
	                     "JOIN USER u ON r.USER_idUSER = u.idUSER " +
	                     "WHERE r.POSTCOMMENT_SEQ_POST = ? " +
	                     "ORDER BY r.DATE ASC";
	         
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, commentSeq);
	         rs = pstmt.executeQuery();
	         
	         while (rs.next()) {
	             reply_comment reply = new reply_comment();
	             reply.setPOSTCOMMENT_SEQ_POST(rs.getInt("POSTCOMMENT_SEQ_POST"));
	             reply.setRECOMMENT_SEQ(rs.getInt("RECOMMENT_SEQ"));
	             reply.setUSER_idUSER(rs.getString("USER_idUSER"));
	             reply.setDETAIL(rs.getString("DETAIL"));
	             reply.setDATE(rs.getTimestamp("DATE"));
	             reply.setUserName(rs.getString("NAME"));
	             list.add(reply);
	         }
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         pool.freeConnection(con, pstmt, rs);
	     }
	     
	     return list;
	 }
	
	 // 대댓글 개수
	 public int getReplyCount(int commentSeq) {
	     Connection con = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
	     
	     try {
	         con = pool.getConnection();
	         String sql = "SELECT COUNT(*) as cnt FROM REPLY_COMMENT WHERE POSTCOMMENT_SEQ_POST = ?";
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, commentSeq);
	         rs = pstmt.executeQuery();
	         
	         if (rs.next()) {
	             return rs.getInt("cnt");
	         }
	     } catch (Exception e) {
	         e.printStackTrace();
	     } finally {
	         pool.freeConnection(con, pstmt, rs);
	     }
	     
	     return 0;
	 }
}