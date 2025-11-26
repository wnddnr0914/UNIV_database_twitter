package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import BEAN.user;
import DB.DBConnectionMgr;

public class UserDAO {

    private DBConnectionMgr pool;

    // ⭐ [필수] 생성자: 이게 있어야 pool이 세팅되어 에러가 안 납니다!
    public UserDAO() {
        try {
            pool = new DBConnectionMgr();
        } catch (Exception e) {
            System.out.println("❌ DBConnectionMgr 로드 실패");
            e.printStackTrace();
        }
    }

    // 1. 로그인 (ID/PW 확인)
 // 1. 로그인 (수정됨: boolean -> user 객체 반환)
 	public user loginCheck(String id, String pw) {
 		Connection con = null;
 		PreparedStatement pstmt = null;
 		ResultSet rs = null;
 		user bean = null; // 로그인 실패 시 null 반환

 		try {
 			con = pool.getConnection();
 			// 아이디와 비번이 맞는지 확인하고, 맞으면 정보까지 가져옴
 			String sql = "SELECT * FROM USER WHERE idUSER = ? AND PASSWORD = ?";
 			pstmt = con.prepareStatement(sql);
 			pstmt.setString(1, id);
 			pstmt.setString(2, pw);
 			rs = pstmt.executeQuery();

 			if (rs.next()) {
 				// 로그인 성공! 정보를 담아서 보냄
 				bean = new user();
 				bean.setIdUSER(rs.getString("idUSER"));
 				bean.setNAME(rs.getString("NAME"));
 				bean.setGENDER(rs.getInt("GENDER"));
 				bean.setBIRTH(rs.getDate("BIRTH"));
 				bean.setPASSWORD(rs.getString("PASSWORD"));
 			}
 		} catch (Exception e) {
 			e.printStackTrace();
 		} finally {
 			pool.freeConnection(con, pstmt, rs);
 		}
 		return bean;
 	}

    // 2. 회원정보 가져오기 (마이페이지용)
    public user selectUserById(String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        user bean = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM USER WHERE idUSER = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                bean = new user();
                bean.setIdUSER(rs.getString("idUSER"));
                bean.setNAME(rs.getString("NAME"));
                bean.setGENDER(rs.getInt("GENDER"));
                bean.setBIRTH(rs.getDate("BIRTH"));
                bean.setPASSWORD(rs.getString("PASSWORD"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return bean;
    }

    // 3. 회원가입
    public boolean insertUser(user bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) VALUES (?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getIdUSER());
            pstmt.setString(2, bean.getNAME());
            pstmt.setInt(3, bean.getGENDER());
            pstmt.setDate(4, bean.getBIRTH());
            pstmt.setString(5, bean.getPASSWORD());
            if (pstmt.executeUpdate() == 1) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        return flag;
    }

 // 4. 사용자 검색 (수정됨: 팔로우 여부 체크 쿼리 수정)
    public ArrayList<user> searchUsers(String myId, String keyword, int page, int limit) {
        ArrayList<user> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int start = (page - 1) * limit;
        try {
            con = pool.getConnection();
            
            // ▼▼▼ 여기가 수정되었습니다! (FOLLOWING = ? 로 변경) ▼▼▼
            // "내가(?=myId) 저 사람(u.idUSER)을 팔로우하고 있는지" 확인해야 합니다.
            String sql = "SELECT u.*, "
                       + "(SELECT COUNT(*) FROM FOLLOW f WHERE f.FOLLOWING = ? AND f.FOLLOWER = u.idUSER) as IS_FOLLOWED "
                       + "FROM USER u "
                       + "WHERE (u.idUSER LIKE ? OR u.NAME LIKE ?) "
                       + "AND u.idUSER != ? "
                       + "ORDER BY u.idUSER ASC LIMIT ?, ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, myId);           // 내가 팔로우 했는지 확인 (FOLLOWING = 나)
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, "%" + keyword + "%");
            pstmt.setString(4, myId);           // 검색 결과에서 나는 제외
            pstmt.setInt(5, start);
            pstmt.setInt(6, limit);
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                user bean = new user();
                bean.setIdUSER(rs.getString("idUSER"));
                bean.setNAME(rs.getString("NAME"));
                bean.setGENDER(rs.getInt("GENDER"));
                bean.setBIRTH(rs.getDate("BIRTH"));
                
                // 1이면 true(팔로잉 중), 0이면 false
                bean.setFollowed(rs.getInt("IS_FOLLOWED") > 0);
                
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return list;
    }

    // 5. 검색 결과 수 (페이지네이션용)
    public int getSearchCount(String myId, String keyword) {
        int count = 0;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM USER WHERE (idUSER LIKE ? OR NAME LIKE ?) AND idUSER != ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, myId);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); } 
        finally { pool.freeConnection(con, pstmt, rs); }
        return count;
    }

    // 6. 회원정보 수정 (프로필 수정용)
    public void updateUser(user bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            String sql = "UPDATE USER SET PASSWORD=?, NAME=?, GENDER=?, BIRTH=? WHERE idUSER=?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getPASSWORD());
            pstmt.setString(2, bean.getNAME());
            pstmt.setInt(3, bean.getGENDER());
            pstmt.setDate(4, bean.getBIRTH());
            pstmt.setString(5, bean.getIdUSER());
            
            pstmt.executeUpdate();
            System.out.println("✅ 회원정보 수정 완료: " + bean.getIdUSER());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(pool != null) pool.freeConnection(con, pstmt);
        }
    }
 // 7. 아이디 중복 확인 (AJAX용)
    // true: 사용 가능 (중복 없음), false: 사용 불가 (중복 있음)
    public boolean checkId(String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isAvailable = false;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT idUSER FROM USER WHERE idUSER = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                // 결과가 없으면(null) 사용 가능한 아이디!
                isAvailable = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return isAvailable;
    }
}