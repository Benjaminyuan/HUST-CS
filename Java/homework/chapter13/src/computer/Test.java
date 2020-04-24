public class Test {
    public static void main(String[] args) {
        Component computer = ComponentFactory.create();
        System.out.println(
                "id: " + computer.getId() + ", name: " + computer.getName() + ", price:" + 
                computer.getPrice() + " calcPrice:" + computer.calcPrice());
        Iterator it = computer.iterator(); // 首先得到迭代器
        while (it.hasNext()) {
            Component c = it.next();
            System.out.println("id: " + c.getId() + ", name: " + 
            c.getName() + ", price:" + c.getPrice()+"totalPrice:"+c.calcPrice());
            
        }
    }
}