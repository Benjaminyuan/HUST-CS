import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class SynchronizedContainer<T> {
    private List<T> elements = new ArrayList<>();

    /**
     * 添加元素
     * 
     * @param e 要添加的元素
     */
    public synchronized void add(T e) {
        elements.add(e);
    }

    /**
     * 删除指定下标的元素
     * 
     * @param index 指定元素下标
     * @return 被删除的元素
     */
    public synchronized T remove(int index) {
        return elements.remove(index);
    }

    /**
     * 获取容器里元素的个数
     * 
     * @return 元素个数
     */
    public int size() {
        return elements.size();
    }

    /**
     * 获取指定下标的元素
     * 
     * @param index 指定下标
     * @return 指定下标的元素
     */
    public T get(int index) {
        return elements.get(index);
    }
}

public class Test {
    public static void testAdd() {
        SynchronizedContainer<Integer> container = new SynchronizedContainer<>();
        int addLoops = 10; // addTask 内的循环次数
        Runnable addTask = new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < addLoops; i++) {
                    container.add(i);
                }
            }
        };
        int addTaskCount = 100; // addTask 线程个数
        ExecutorService es = Executors.newCachedThreadPool();
        for (int i = 0; i < addTaskCount; i++) {
            es.execute(addTask);
        }
        es.shutdown();
        while (!es.isTerminated()) {
        }
        System.out.println("Test add " + (addLoops * addTaskCount) + " elements to container");
        System.out.println("Container size = " + container.size() + ", correct size = " + (addLoops * addTaskCount));
    }

    public static void testRemove() {
        SynchronizedContainer<Integer> container = new SynchronizedContainer<>();
        int removeLoops = 10; // removeTask 内的循环次数
        int removeTaskCount = 100; // removeTask 线程个数
        // 首先添加 removeLoops * removeTask 个元素到容器
        for (int i = 0; i < removeLoops * removeTaskCount; i++) {
            container.add(i);
        }
        Runnable removeTask = new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < removeLoops; i++) {
                    container.remove(0);
                }
            }
        };
        ExecutorService es = Executors.newCachedThreadPool();
        for (int i = 0; i < removeTaskCount; i++) {
            es.execute(removeTask);
        }
        es.shutdown();
        while (!es.isTerminated()) {
        }
        System.out.println("Test remove " + (removeLoops * removeTaskCount) + " elements from container");
        System.out.println("Container size = " + container.size() + ", correct size = 0");
    }

    public static void main(String[] args) {
        testAdd();
        testRemove();
    }
}