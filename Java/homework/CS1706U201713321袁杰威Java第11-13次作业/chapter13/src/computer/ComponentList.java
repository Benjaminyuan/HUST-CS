import java.util.ArrayList;

public class ComponentList extends ArrayList<Component> implements Iterator {
    private int position = 0;
    @Override
    public boolean hasNext(){
        return position < this.size();
    }
    public Component next(){
        return this.get(position++);
    }
}