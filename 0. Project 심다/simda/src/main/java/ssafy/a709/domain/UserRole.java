package ssafy.a709.domain;


public enum UserRole implements Code {
    ADMIN(0, "관리자"),

    USER(1, "일반"),

    USERWITHDREW(2, "탈퇴유저");

    private int code;
    private String value;

    UserRole(int code, String value){
        this.code = code;
        this.value = value;
    }

    @Override
    public int getCode() {
        return code;
    }

    @Override
    public String getValue() {
        return value;
    }
}