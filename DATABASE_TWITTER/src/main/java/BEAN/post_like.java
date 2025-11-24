package BEAN;

public class post_like {
    private int POST_idPOST;   // 좋아요 대상 게시물 ID
    private String USER_idUSER; // 좋아요를 누른 사용자 ID
    
    // Getter 및 Setter
    public int getPOST_idPOST() {
        return POST_idPOST;
    }
    public void setPOST_idPOST(int pOST_idPOST) {
        POST_idPOST = pOST_idPOST;
    }
    public String getUSER_idUSER() {
        return USER_idUSER;
    }
    public void setUSER_idUSER(String uSER_idUSER) {
        USER_idUSER = uSER_idUSER;
    }
}