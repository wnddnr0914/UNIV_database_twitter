package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import BEAN.user; // 만드신 VO import
import DB.DBConnectionMgr; // 방금 만든 연결 관리자 import

public class UserDAO {

	private DBConnectionMgr pool;

	public UserDAO() {
		try {
			pool = new DBConnectionMgr();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 회원가입 (INSERT) 메소드
	public boolean insertUser(user bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;

		try {
			con = pool.getConnection(); // DB 연결 빌려오기
			
			// SQL문 작성 (물음표 ? 는 나중에 채워넣음)
			// 테이블 컬럼 순서: idUSER, NAME, GENDER, BIRTH, PASSWORD
			sql = "INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) VALUES (?, ?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			
			// 물음표(?)에 값 채우기
			pstmt.setString(1, bean.getIdUSER());
			pstmt.setString(2, bean.getNAME());
			pstmt.setInt(3, bean.getGENDER()); // 1 or 2
			pstmt.setDate(4, bean.getBIRTH()); // java.sql.Date 타입
			pstmt.setString(5, bean.getPASSWORD());

			// 실행! (성공하면 1을 반환함)
			if (pstmt.executeUpdate() == 1) {
				flag = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt); // 자원 반납
		}
		
		return flag; // 성공 여부 리턴
		
	}
	// UserDAO 클래스 안에 아래 메소드들을 추가하세요.

	// 1. 사용자 검색 (팔로우 여부 포함, 페이징 처리)
	public ArrayList<user> searchUsers(String myId, String keyword, int page, int limit) {
	    ArrayList<user> list = new ArrayList<>();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    // 시작 인덱스 계산
	    int start = (page - 1) * limit;
	    
	    try {
	        con = pool.getConnection();
	        
	        // 쿼리 설명: 
	        // 1. 사용자 이름이나 ID에 검색어가 포함된 사람을 찾음
	        // 2. 서브쿼리(SELECT COUNT...)로 내가 이 사람을 팔로우했는지 확인 (1이면 true, 0이면 false)
	        String sql = "SELECT u.*, "
	                   + "(SELECT COUNT(*) FROM FOLLOW f WHERE f.FOLLOWER = ? AND f.FOLLOWING = u.idUSER) as IS_FOLLOWED "
	                   + "FROM USER u "
	                   + "WHERE (u.idUSER LIKE ? OR u.NAME LIKE ?) "
	                   + "AND u.idUSER != ? " // 내 자신은 검색에서 제외
	                   + "ORDER BY u.idUSER ASC LIMIT ?, ?";
	        
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, myId);           // 내 아이디 (팔로우 확인용)
	        pstmt.setString(2, "%" + keyword + "%"); // 검색어 (아이디)
	        pstmt.setString(3, "%" + keyword + "%"); // 검색어 (이름)
	        pstmt.setString(4, myId);           // 내 아이디 (제외용)
	        pstmt.setInt(5, start);             // 시작 번호
	        pstmt.setInt(6, limit);             // 가져올 개수
	        
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            user bean = new user();
	            bean.setIdUSER(rs.getString("idUSER"));
	            bean.setNAME(rs.getString("NAME"));
	            // ... 나머지 정보 set ...
	            
	            // 팔로우 여부 저장 (1이면 true)
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

	// 2. 검색된 총 인원수 구하기 (페이지네이션 계산용)
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
}