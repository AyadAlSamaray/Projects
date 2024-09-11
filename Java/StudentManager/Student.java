package studentManager;

import java.util.*;

public class Student {
    private String name;
    private String year;
    private double gpa;
    private List<Class> classes;

    public Student(String name, String year, double gpa, List<Class> classes) {
        this.classes = classes;
        this.name = name;
        this.year = year;
        this.gpa = gpa;
    }

    public String getName() {
        return name;
    }

    public String getYear() {
        return year;
    }

    public double getGPA() {
        return gpa;
    }

    public List<Class> getClasses() {
        return classes;
    }

    public void addClass(Class className) {
        classes.add(className);
    }

    public void removeClass(Class className) {
        classes.remove(className);
    }

    public List<Class> getClassSchedule() {
        return null;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setYear(String year) {
        this.year = year;
    }
}
