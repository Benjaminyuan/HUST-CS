public enum Color {
    RED(1,"red"),
    Blue(2,"blue"),
    YELLOW(3,"yellow");
    private  String description;
    private int value;
    Color(int value,String description){
        this.value = value;
        this.description = description;
    }
    public int getValue() {
        return value;
    }
    public String getDescription() {
        return description;
    }
}
