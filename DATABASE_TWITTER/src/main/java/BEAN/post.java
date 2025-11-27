package BEAN;
import java.sql.Timestamp;

public class post {
    // 기존 변수들
    private int idPOST;
    private String user; // 아이디 (DB컬럼: USER_idUSER)
    private String detail;
    private Timestamp date;
    private String postCol;

    // [추가] 화면 표시용 변수 (DB 테이블에는 없지만 필요함)
    private String userName;   // 작성자 이름 (홍길동)
    private int likeCount;     // 좋아요 개수
    private boolean isLiked;   // 내가 좋아요 눌렀는지 여부


    
    // Getter & Setter (기존 것 + 추가된 것)
    public int getIdPOST() { return idPOST; }
    public void setIdPOST(int idPOST) { this.idPOST = idPOST; }
    
    public String getUser() { return user; }
    public void setUser(String user) { this.user = user; }
    
    public String getDetail() { return detail; }
    public void setDetail(String detail) { this.detail = detail; }
    
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
    
    public String getPostCol() { return postCol; }
    public void setPostCol(String postCol) { this.postCol = postCol; }

    // [추가된 Getter/Setter]
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    
    public boolean isLiked() { return isLiked; }
    public void setLiked(boolean isLiked) { this.isLiked = isLiked; }
 // [추가] 작성자 성별을 담을 변수
    private int authorGender; 

    public int getAuthorGender() { return authorGender; }
    public void setAuthorGender(int authorGender) { this.authorGender = authorGender; }



    // [추가] 성별에 따른 이미지 파일명 반환 (JSP에서 사용)
    public String getProfileImage() {
        if (this.authorGender == 1) {
            return "1.png"; // 남성
        } else if (this.authorGender == 2) {
            return "2.png"; // 여성
        } else {
            return "profile_default.png"; // 기본
        }
    }
}