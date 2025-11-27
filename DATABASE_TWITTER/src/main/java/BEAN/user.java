package BEAN;

import java.sql.Date;
import java.sql.Timestamp;  

public class user {
	private String idUSER;
	private String NAME;
	private int GENDER;
	private Date BIRTH;
	private String PASSWORD;
    private Timestamp JOIN_DATE;  

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
    public Timestamp getJOIN_DATE() {
        return JOIN_DATE;
    }
    
    public void setJOIN_DATE(Timestamp JOIN_DATE) {
        this.JOIN_DATE = JOIN_DATE;
    }
	public String getPASSWORD() {
		return PASSWORD;
	}
	public void setPASSWORD(String pASSWORD) {
		PASSWORD = pASSWORD;
	}
	private boolean isFollowed; 

    public boolean isFollowed() { return isFollowed; }
    public void setFollowed(boolean isFollowed) { this.isFollowed = isFollowed; }
 // [추가] 성별에 따라 이미지 파일명을 반환하는 기능
    public String getProfileImage() {
        if (this.GENDER == 1) {
            return "1.png"; // 남성 이미지
        } else if (this.GENDER == 2) {
            return "2.png"; // 여성 이미지
        } else {
            return "profile_default.png"; // 기본 이미지
        }
    }
}
