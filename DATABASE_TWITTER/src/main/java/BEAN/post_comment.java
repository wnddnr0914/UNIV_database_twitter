package BEAN;

import java.security.Timestamp;

public class post_comment {
	private int SEQ_POST;
	private int id_POST;
	private String USER_idUSER;
	private String DETAIL;
	private Timestamp DATE;
	public int getSEQ_POST() {
		return SEQ_POST;
	}
	public void setSEQ_POST(int sEQ_POST) {
		SEQ_POST = sEQ_POST;
	}
	public int getId_POST() {
		return id_POST;
	}
	public void setId_POST(int id_POST) {
		this.id_POST = id_POST;
	}
	public String getUSER_idUSER() {
		return USER_idUSER;
	}
	public void setUSER_idUSER(String uSER_idUSER) {
		USER_idUSER = uSER_idUSER;
	}
	public String getDETAIL() {
		return DETAIL;
	}
	public void setDETAIL(String dETAIL) {
		DETAIL = dETAIL;
	}
	public Timestamp getDATE() {
		return DATE;
	}
	public void setDATE(Timestamp dATE) {
		DATE = dATE;
	}
	
}
