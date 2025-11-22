package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class jdbc {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		try {

			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/twitter_db?serverTimezone=UTC", 
					"root","121709");
			System.out.println("success성공이요~~");
			Statement stmt = conn.createStatement();

		} catch (SQLException ex) {
			System.out.println("SQLException" + ex);
		}
		
		
		
	}

}