package BEAN;

import java.sql.Timestamp;

public class post {
	private int idPOST;
	private String user;
	private String detail;
	private Timestamp date;
	public int getIdPOST() {
		return idPOST;
	}
	public void setIdPOST(int idPOST) {
		this.idPOST = idPOST;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	
}

