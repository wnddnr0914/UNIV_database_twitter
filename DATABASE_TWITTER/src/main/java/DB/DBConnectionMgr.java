package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBConnectionMgr {

	// 1. DB 접속 정보 (본인 MySQL 비밀번호로 꼭 수정하세요!)
	private final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	private final String JDBC_URL = "jdbc:mysql://localhost:3306/twitter_DB?serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
	private final String USER = "root";  // 아이디
	private final String PASS = "121709";  // 비밀번호 (설치할 때 정한 것)
	

	// 2. 연결(Connection)을 가져오는 메소드
	public Connection getConnection() {
		try {
			Class.forName(JDBC_DRIVER);
			return DriverManager.getConnection(JDBC_URL, USER, PASS);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// 3. 자원 반납(Close) 메소드 - 메모리 누수 방지
	public void freeConnection(Connection con, PreparedStatement pstmt, ResultSet rs) {
		try {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (con != null) con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// (오버로딩) SELECT가 아닐 때(INSERT, UPDATE 등)는 ResultSet이 없으므로
	public void freeConnection(Connection con, PreparedStatement pstmt) {
		try {
			if (pstmt != null) pstmt.close();
			if (con != null) con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}