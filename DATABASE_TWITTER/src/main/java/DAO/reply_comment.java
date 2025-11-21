package DAO;

import java.security.Timestamp;

public class reply_comment {
	private int POSTCOMMENT_SEQ_POST;
	private int RECOMMENT_SEQ;
	private String DETAIL;
	private Timestamp DATE;
	public int getPOSTCOMMENT_SEQ_POST() {
		return POSTCOMMENT_SEQ_POST;
	}
	public void setPOSTCOMMENT_SEQ_POST(int pOSTCOMMENT_SEQ_POST) {
		POSTCOMMENT_SEQ_POST = pOSTCOMMENT_SEQ_POST;
	}
	public int getRECOMMENT_SEQ() {
		return RECOMMENT_SEQ;
	}
	public void setRECOMMENT_SEQ(int rECOMMENT_SEQ) {
		RECOMMENT_SEQ = rECOMMENT_SEQ;
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
