package BEAN;

import java.sql.Timestamp;

public class reply_comment {
    private int POSTCOMMENT_SEQ_POST;
    private int RECOMMENT_SEQ;
    private String USER_idUSER;        // 추가
    private String DETAIL;
    private Timestamp DATE;
    private String userName;           // 추가 (화면 표시용)
    
    public int getPOSTCOMMENT_SEQ_POST() {
        return POSTCOMMENT_SEQ_POST;
    }
    
    public void setPOSTCOMMENT_SEQ_POST(int POSTCOMMENT_SEQ_POST) {
        this.POSTCOMMENT_SEQ_POST = POSTCOMMENT_SEQ_POST;
    }
    
    public int getRECOMMENT_SEQ() {
        return RECOMMENT_SEQ;
    }
    
    public void setRECOMMENT_SEQ(int RECOMMENT_SEQ) {
        this.RECOMMENT_SEQ = RECOMMENT_SEQ;
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