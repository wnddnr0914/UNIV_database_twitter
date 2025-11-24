package BEAN;

public class follow {
    private String following; // 팔로우 하는 사람 ID
    private String follower;  // 팔로우 받는 사람 ID (대상)
    
    // Getter/Setter는 이클립스 Refactor 기능을 사용하여 자동 생성합니다.
    
    public String getFollowing() {
        return following;
    }
    public void setFollowing(String following) {
        this.following = following;
    }
    public String getFollower() {
        return follower;
    }
    public void setFollower(String follower) {
        this.follower = follower;
    }
}