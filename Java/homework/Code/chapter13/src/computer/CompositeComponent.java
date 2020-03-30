public class CompositeComponent extends Component{
    private ComponentList childs = new ComponentList();
    public CompositeComponent(){}
    public CompositeComponent(int id ,String name,double price){
        super(id,name,price);
    }
    @Override
    public void add(Component c){
        childs.add(c);
    }
    @Override
    public void remove(Component c){
        childs.remove(c);
    }
    @Override
    public double calcPrice(){
        return childs.stream().mapToDouble(c->c.getPrice()).sum();
    }
    @Override
    public Iterator iterator(){
        return new CompositeIterator(childs);
    }
} 