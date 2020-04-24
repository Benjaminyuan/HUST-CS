import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class TwoTuple<T1 extends Comparable, T2 extends Comparable> implements Comparable {
    private T1 first;
    private T2 second;

    public TwoTuple(T1 t1, T2 t2) {
        first = t1;
        second = t2;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof TwoTuple) {
            try {
                TwoTuple<T1, T2> o = (TwoTuple<T1,T2>) obj;
                return this.getFirst().equals(o.getFirst()) && this.getSecond().equals(o.getSecond());
            } catch (ClassCastException e) {
                e.printStackTrace();
            }

        }
        return false;
    }

    @Override
    public String toString() {
        return String.format("(%s,%s)", first.toString(),second.toString());
    }

    /**
     * @return the first
     */
    public T1 getFirst() {
        return first;
    }

    /**
     * @return the second
     */
    public T2 getSecond() {
        return second;
    }

    /**
     * @param first the first to set
     */
    public void setFirst(T1 first) {
        this.first = first;
    }

    /**
     * @param second the second to set
     */
    public void setSecond(T2 second) {
        this.second = second;
    }

    @Override
    public int compareTo(Object o) {
        try {
            if (o instanceof TwoTuple) {
                TwoTuple<T1, T2> tuple = (TwoTuple<T1, T2>) o;
                int firstRes = this.getFirst().compareTo(tuple.getFirst());
                if (firstRes == 0) {
                    return this.getSecond().compareTo(tuple.getSecond());
                }
                return firstRes;
            }else{
                throw new Exception("class not equal");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public static void main(String[] args) {
        
        TwoTuple<Integer,String> twoTuple1 =new TwoTuple<>(1, "ccc");
        TwoTuple<Integer,String> twoTuple2 =new TwoTuple<>(1, "bbb");
        TwoTuple<Integer,String> twoTuple3 =new TwoTuple<>(1, "aaa");
        TwoTuple<Integer,String> twoTuple4 =new TwoTuple<>(2, "ccc");
        TwoTuple<Integer,String> twoTuple5 =new TwoTuple<>(2, "bbb");
        TwoTuple<Integer,String> twoTuple6 =new TwoTuple<>(2, "aaa");
        List<TwoTuple<Integer,String>> list = new ArrayList<>();
        list.add(twoTuple1);
        list.add(twoTuple2);
        list.add(twoTuple3);
        list.add(twoTuple4);
        list.add(twoTuple5);
        list.add(twoTuple6);

        //测试equals，contains方法是基于equals方法结果来判断
        TwoTuple<Integer,String> twoTuple10 =new TwoTuple<>(1, "ccc"); //内容=twoTuple1
        System.out.println(twoTuple1.equals(twoTuple10)); //应该为true
        if(!list.contains(twoTuple10)){
            list.add(twoTuple10);  //这时不应该重复加入
        }

        //sort方法是根据元素的compareTo方法结果进行排序，课测试compareTo方法是否实现正确
        Collections.sort(list);


        for (TwoTuple<Integer, String> t: list) {
            System.out.println(t);
        }
	
        TwoTuple<TwoTuple<Integer,String >,TwoTuple<Integer,String >> tt1 =
                    new TwoTuple<>(new TwoTuple<>(1,"aaa"),new TwoTuple<>(1,"bbb"));
            TwoTuple<TwoTuple<Integer,String>,TwoTuple<Integer,String >> tt2 =
                    new TwoTuple<>(new TwoTuple<>(1,"aaa"),new TwoTuple<>(2,"bbb"));
        System.out.println(tt1.compareTo(tt2)); //输出-1
        System.out.println(tt1);
    }
}