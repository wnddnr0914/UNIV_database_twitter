package BEAN;

import java.sql.Date;

public class user {
	private String idUSER;
	private String NAME;
	private int GENDER;
	private Date BIRTH;
	private String PASSWORD;
	public String getIdUSER() {
		return idUSER;
	}
	public void setIdUSER(String idUSER) {
		this.idUSER = idUSER;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public int getGENDER() {
		return GENDER;
	}
	public void setGENDER(int gENDER) {
		GENDER = gENDER;
	}
	public Date getBIRTH() {
		return BIRTH;
	}
	public void setBIRTH(Date bIRTH) {
		BIRTH = bIRTH;
	}
	public String getPASSWORD() {
		return PASSWORD;
	}
	public void setPASSWORD(String pASSWORD) {
		PASSWORD = pASSWORD;
	}
	
}
