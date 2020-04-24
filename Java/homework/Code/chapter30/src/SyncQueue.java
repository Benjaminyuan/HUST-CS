import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Semaphore;

/**
 * 一个线程安全同步队列，模拟多线程环境下的生产者消费者机制 一个生产者线程通过 produce 方法向队列里产生元素 一个消费者线程通过 consume
 * 方法从队列里消费元素
 * 
 * @param <T> 元素类型
 */
public class SyncQueue<T> {
    /**
     * 保存队列元素
     */
    private Semaphore mutex = new Semaphore(1);
    private Semaphore notEmpty = new Semaphore(0);
    private ArrayList<T> list = new ArrayList<>();

    // TODO 这里加入需要的数据成员
    /**
     * 生产数据
     * 
     * @param elements 生产出的元素列表，需要将该列表元素放入队列
     * @throws InterruptedException
     */
    public void produce(List<T> elements) {
        try {
            if (elements.size() == 0) {
                return;
            }
            mutex.acquire();
            //数组长度从0变成>0时信号量才+1
            if(list.size() == 0){
                notEmpty.release();
            }
            list.addAll(elements);
            System.out.println("produce:" +list);
            mutex.release();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 消费数据
     * 
     * @return 从队列中取出的数据
     * @throws InterruptedException
     */
    public List<T> consume() {
        try {
            notEmpty.acquire();
            mutex.acquire();
            System.out.println("consume:"+list);
            List<T> res = new ArrayList<T>(list);
            list.clear();
            mutex.release();
            return res;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}