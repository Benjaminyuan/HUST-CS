
public class Component {
    private int id;
    private String name;
    private double price;

    public Component() {

    }

    public Component(int id, String name, double price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    public void remove(Component c) {
        return;
    }

    public void add(Component c) {
        return;
    }

    public double calcPrice() {
        return price;
    }

    public Iterator iterator() {
        return new NullIterator();
    }

    @Override
    public String toString() {
        return String.format("id: %d, name: %s, price: %lf", id, name, price);
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof Component) {
            Component c = (Component) o;
            return c.getId() == this.getId() && c.getName() == this.getName();
        }
        return false;
    }

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the price
     */
    public double getPrice() {
        return price;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @param price the price to set
     */
    public void setPrice(double price) {
        this.price = price;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

}