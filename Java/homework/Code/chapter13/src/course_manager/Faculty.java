public class Faculty extends Person implements Cloneable {
    private int facultyId;
    private String title;
    private String email;

    public Faculty() {
    }

    public Faculty(String name, int age, int facultyId, String title, String email) {
        super(name, age);
        this.facultyId = facultyId;
        this.title = title;
        this.email = email;
    }

    @Override
    public String toString() {
        return String.format("%s, facultyId: %s, title: %s, email: %s", super.toString(), facultyId, title, email);
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof Faculty) {
            Faculty f = (Faculty) o;
            return this.getFacultyId() == f.getFacultyId() && this.getEmail().equals(f.getEmail())
                    && this.getTitle().equals(f.getTitle());
        }
        return false;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        Faculty f = (Faculty) super.clone();
        f.setEmail(this.getEmail());
        f.setFacultyId(this.getFacultyId());
        f.setTitle(this.getTitle());
        return f;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @return the facultyId
     */
    public int getFacultyId() {
        return facultyId;
    }

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @param facultyId the facultyId to set
     */
    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

}