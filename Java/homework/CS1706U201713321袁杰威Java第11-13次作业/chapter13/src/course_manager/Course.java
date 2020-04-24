import java.util.ArrayList;
import java.util.List;

public class Course implements Cloneable {
    private String courseName;
    private List<Person> students = new ArrayList<>();
    private Person teacher;

    
    public Course(String courseName, Person teacher) {
        this.courseName = courseName;
        this.teacher = teacher;
    }

    public void register(Person student) {
        if (!this.students.contains(student)) {
            this.students.add(student);
        }
    }

    public void unregister(Person student) {
        this.students.remove(student);
    }

    public int getNumberOfStudent(){
        return students.size();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(String.format("Course Name: %s\nTeacher Info: %s\nStudent List:\n",
                courseName, this.teacher.toString()));

        students.forEach((e) -> {
            sb.append(e.toString()).append("\n");
        });

        sb.append(String.format("Totally: %d students", this.students.size()));
        return sb.toString();
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        Course c = (Course) super.clone();
        c.setTeacher((Person)this.teacher.clone());
        c.setStudents(this.getStudents());
        c.setCourseName(this.getCourseName());
        return c;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof Course) {
            Course c = (Course) o;
            return this.students.containsAll(c.students) && this.getCourseName().equals(getCourseName())
                    && this.getTeacher().equals(c.getTeacher());
        }
        return false;
    }

    /**
     * @return the courseName
     */
    public String getCourseName() {
        return courseName;
    }

    /**
     * @return the students
     */
    public List<Person> getStudents() {
        return new ArrayList<Person>(students);
    }

    /**
     * @return the teacher
     */
    public Person getTeacher() {
        return teacher;
    }

    /**
     * @param courseName the courseName to set
     */
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    /**
     * @param students the students to set
     */
    public void setStudents(List<Person> students) {
        this.students = students;
    }

    /**
     * @param teacher the teacher to set
     */
    public void setTeacher(Person teacher) {
        this.teacher = teacher;
    }

}