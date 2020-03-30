public class Fan {
     private  int speed;
     private volatile boolean on;
     private double radius;
     private String color;

    public double getRadius() {
        return radius;
    }

    public int getSpeed() {
        return speed;
    }
    public boolean getStatus(){
        return on;
    }
    public String getColor() {
        return color;
    }
    public void setStatus(boolean on) {
        this.on = on;
    }
    public void setColor(String color) {
        this.color = color;
    }
    public void setRadius(double radius) {
        this.radius = radius;
    }
    public void setSpeed(int speed) {
        this.speed = speed;
    }


    public Fan(){
        speed = Speed.SLOW.getSpeed();
        on = false;
        radius = 5.0;
        color = Color.RED.getDescription();
    }
    @Override
    public String toString(){
        if(on){
            return String.format("fan speed:%d,color:%s,radius:%f",speed,color,radius);
        }else{
            return String.format("fan is off,color:%s,radius:%f",color,radius);
        }
    }

    public static void main(String[] args) {
        Fan fan1 = new Fan();
        fan1.setSpeed(Speed.FAST.getSpeed());
        fan1.setRadius(10);
        fan1.setColor(Color.YELLOW.getDescription());
        fan1.setStatus(true);
        Fan fan2 = new Fan();
        fan2.setSpeed(Speed.MEDIUM.getSpeed());
        fan2.setRadius(5);
        fan2.setColor(Color.Blue.getDescription());
        fan2.setStatus(false);
        System.out.println("fan1:"+fan1);
        System.out.println("fan2:"+fan2);
    }
}
