package DAO;

public class message {
	private int idMESSAGE;
	private String Sender;
	private String Recipient;
	private String TEXT;
	public int getIdMESSAGE() {
		return idMESSAGE;
	}
	public void setIdMESSAGE(int idMESSAGE) {
		this.idMESSAGE = idMESSAGE;
	}
	public String getSender() {
		return Sender;
	}
	public void setSender(String sender) {
		Sender = sender;
	}
	public String getRecipient() {
		return Recipient;
	}
	public void setRecipient(String recipient) {
		Recipient = recipient;
	}
	public String getTEXT() {
		return TEXT;
	}
	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}
	
}
