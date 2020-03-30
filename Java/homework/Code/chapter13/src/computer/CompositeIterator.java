import java.util.ArrayList;
import java.util.List;


public class CompositeIterator implements Iterator {
    List<Iterator> iterators = new ArrayList<>();
    public CompositeIterator(Iterator iterator){
        // 保证加入的不是空的Iterator
        if(iterator.hasNext()){
            iterators.add(iterator);
        }
    }
    @Override
    public boolean hasNext(){
        return iterators.size() > 0 && iterators.get(0).hasNext();
    }
    @Override
    public Component next(){
        Iterator iter = iterators.get(0);
        Component c =  iter.next();
        Iterator cIter = c.iterator();
        // 如果迭代器有元素，将迭代器入列表
        if(cIter.hasNext()){
            iterators.add(cIter);
        }
        // 队首第一个遍历完成，去除队首的Iterator
        if(!iter.hasNext()){
            iterators.remove(0);
        }
        
        return c;
    }
}