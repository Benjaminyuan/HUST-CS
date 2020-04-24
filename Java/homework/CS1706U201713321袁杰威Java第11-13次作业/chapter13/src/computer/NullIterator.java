public class NullIterator implements Iterator {
    @Override
    public boolean hasNext(){
        return false;
    }
    public Component next(){
        return null;
    }
}