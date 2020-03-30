public enum Speed {
    SLOW(1,"slow speed"),
    MEDIUM(2,"medium speed"),
    FAST(3,"fast speed");
    private int speed;
    private String description;
    Speed(int speed,String description){
        this.speed = speed;
        this.description = description;
    }
    public int getSpeed() {
        return speed;
    }
    public String getDescription() {
        return description;
    }
}
