package BEAN;

import java.security.Timestamp;

public class post {
	private int idPOST;
	private String user;
	private long detail;
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
	public long getDetail() {
		return detail;
	}
	public void setDetail(long detail) {
		this.detail = detail;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	
}
