package BEAN;

import java.sql.Timestamp;

public class post_comment {
    private int SEQ_POST;
    private int POST_idPOST;
    private String USER_idUSER;
    private String DETAIL;
    private Timestamp DATE;
    private String userName;
    
    public int getSEQ_POST() {
        return SEQ_POST;
    }
    
    public void setSEQ_POST(int SEQ_POST) {
        this.SEQ_POST = SEQ_POST;
    }
    
    public int getPOST_idPOST() {
        return POST_idPOST;
    }
    
    public void setPOST_idPOST(int POST_idPOST) {
        this.POST_idPOST = POST_idPOST;
    }
    
    public String getUSER_idUSER() {
        return USER_idUSER;
    }
    
    public void setUSER_idUSER(String USER_idUSER) {
        this.USER_idUSER = USER_idUSER;
    }
    
    public String getDETAIL() {
        return DETAIL;
    }
    
    public void setDETAIL(String DETAIL) {
        this.DETAIL = DETAIL;
    }
    
    public Timestamp getDATE() {
        return DATE;
    }
    
    public void setDATE(Timestamp DATE) {
        this.DATE = DATE;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
