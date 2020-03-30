public class Student extends Person implements Cloneable {
    private int studentId;
    private String department;
    private String classNo;

    public Student() {

    }

    public Student(String name, int age,int studentId, String department, String classNo) {
        super(name,age);
        this.studentId = studentId;
        this.department = department;
        this.classNo = classNo;
    }

    @Override
    public String toString() {
        return String.format("%s, calssNo: %s, studentId: %d, department: %s", super.toString(), classNo, studentId,
                department);
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof Student) {
            Student s = (Student) o;
            return this.getStudentId() == s.getStudentId() && this.getDepartment().equals(s.getDepartment())
                    && this.getClassNo().equals(s.getClassNo());
        }
        return false;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        Student s = (Student) super.clone();
        s.setClassNo(this.getClassNo());
        s.setStudentId(this.getStudentId());
        s.setDepartment(this.getDepartment());
        return s;
    }

    /**
     * @return the classNo
     */
    public String getClassNo() {
        return classNo;
    }

    /**
     * @return the department
     */
    public String getDepartment() {
        return department;
    }

    /**
     * @return the studentId
     */
    public int getStudentId() {
        return studentId;
    }

    /**
     * @param classNo the classNo to set
     */
    public void setClassNo(String classNo) {
        this.classNo = classNo;
    }

    /**
     * @param department the department to set
     */
    public void setDepartment(String department) {
        this.department = department;
    }

    /**
     * @param studentId the studentId to set
     */
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
}