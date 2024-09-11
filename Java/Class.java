package studentManager;

/**
 * a Class to represent an academic class and the students grade meant to be implemented by the student Class
 *
 */

public class Class {
    private String name;
    private String grade;
    private String timeSlot;

    public Class(String name, String grade, String timeSlot) {
        this.name = name;
        this.timeSlot = timeSlot;
        this.grade = grade;
    }

    public String getName() {
        return this.name;
    }

    public String getGrade() {
        return this.grade;
    }

    public String getSchedule() {
        return this.timeSlot;
    }

    public void setName(String nameChange) {
        this.name = nameChange;
    }

    public void setGrade(String newGrade) {
        this.grade = newGrade;
    }

    public void setSchedule(String newTime) {
        this.timeSlot = newTime;
    }
}