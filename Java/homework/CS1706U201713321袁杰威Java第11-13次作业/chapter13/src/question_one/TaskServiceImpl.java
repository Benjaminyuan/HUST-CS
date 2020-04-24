import java.util.ArrayList;
import java.util.List;
public  class TaskServiceImpl implements TaskService{

    private List<Task> taskList = new ArrayList<>();
    @Override
    public void exeuteTasks() {
        for(Task t : taskList){
            t.execute();
        }
    }

    @Override
    public void addTask(Task t) {
        taskList.add(t);
    }
    public static void main(String[] args) {
        TaskServiceImpl taskServiceImpl = new TaskServiceImpl();
        taskServiceImpl.addTask(()->{
            System.out.println("task-1;");
        });
        taskServiceImpl.addTask(()->{
            System.out.println("task-2;");
        });
        taskServiceImpl.addTask(()->{
            System.out.println("task-3;");
        });
        taskServiceImpl.exeuteTasks();
    }
}