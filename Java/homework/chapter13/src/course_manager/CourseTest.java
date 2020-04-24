public class CourseTest{
    public static void main(String[] args) throws CloneNotSupportedException {
        Person teacher = new Faculty("James Gosling",65,0000,"professor",
        "http://test.html");
        Course javaCourse = new Course("Java language Programming",teacher);
        Person student1 = new Student("aaa",20,20170101,"CS","CS1706");
        Person student2 = new Student("bbb",20,20170102,"CS","CS1706");
        Person student3 = new Student("ccc",20,20170103,"CS","CS1706");
        javaCourse.register(student1);
        javaCourse.register(student2);
        javaCourse.register(student3);
        System.out.println(javaCourse);
        javaCourse.unregister(student3);
        System.out.println(javaCourse);

        Course javaCourse2 = (Course)javaCourse.clone();
        System.out.println(javaCourse.equals(javaCourse2));
        System.out.println(javaCourse.getCourseName() != javaCourse2.getCourseName());
        System.out.println(javaCourse.getTeacher() != javaCourse2.getTeacher());
        System.out.println(javaCourse.getStudents() != javaCourse2.getStudents());
        System.out.println(javaCourse2);
    }
}