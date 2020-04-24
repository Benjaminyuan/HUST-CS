import java.util.concurrent.Semaphore;

public class ThreadRunInOrder {
    public static void main(String[] args) {
        Semaphore t1 = new Semaphore(0);
        Semaphore t2 = new Semaphore(0);
        Thread A = new Thread(()->{
            try{
                System.out.println("A----");
                t1.release();
            }catch(Exception e){
                e.printStackTrace();
            }
           
        });
        Thread B = new Thread(()->{
            try{
                t1.acquire();
                System.out.println("B----");
                t2.release();
            }catch(Exception e){
                e.printStackTrace();
            }

        });
        Thread C = new Thread(()->{
            try{
                t2.acquire();
                System.out.println("C----");
            }catch(Exception e){
                e.printStackTrace();
            }
        });
        C.start();
        B.start();
        A.start();
    }
}