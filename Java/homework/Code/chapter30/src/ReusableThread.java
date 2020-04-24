import java.security.DrbgParameters.Reseed;
import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ReusableThread extends Thread {
    private Runnable runTask = null; // 保存接受的线程任务
    private Queue<Runnable> q = new LinkedList<>();
    private ReentrantLock l = new ReentrantLock();
    private Condition notEmpty = l.newCondition();
    // TODO 加入需要的数据成员

    public ReusableThread() {
        super();
    }

    /**
     * 覆盖 Thread 类的 run 方法
     */
    @Override
    public void run() {
        // 这里必须是永远不结束的循环
        while (true) {
            try {
                l.lock();
                while(q.isEmpty()){
                    notEmpty.await();
                }
                Runnable r = q.poll();
                r.run();
                
            } catch (InterruptedException e) {
                e.printStackTrace();
            }finally{
                l.unlock();
            }
        }
    }

    /**
     * 提交新的任务
     * 
     * @param task 要提交的任务
     */
    public void submit(Runnable task) {
        try {
            l.lock();
            q.add(task);
            notEmpty.signal();
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            l.unlock();
        }
    }

    public static void test3() {
        Runnable task1 = new Runnable() {
            @Override
            public void run() {
                System.out.println("Thread " + Thread.currentThread().getId() + ": is running " + toString());
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public String toString() {
                return "task1";
            }
        };
        Runnable task2 = new Runnable() {
            @Override
            public void run() {
                System.out.println("Thread " + Thread.currentThread().getId() + " is running " + toString());
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public String toString() {
                return "task2";
            }
        };
        ReusableThread t = new ReusableThread();
        t.start(); // 主线程启动子线程
        for (int i = 0; i < 5; i++) {
            t.submit(task1);
            t.submit(task2);
        }
    }
    public static void main(String[] args) {
        ReusableThread.test3();
    }
}