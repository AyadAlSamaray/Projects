package studentManager;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

/** Class for reading and writing JSON files
 *
 * @author Ayad Al Samaray
 */
public class StudentManager {
    private List<Student> students;
    private String studentFilesPath;

    public StudentManager(String studentFilesPath) {
        this.studentFilesPath = studentFilesPath;
        students = new ArrayList<>();
    }

    public void addStudent(Student student) {
        students.add(student);
    }

    public void removeStudent(Student student) {
        students.remove(student);
    }

    public Student searchStudent(String name) {
        Path folderPath = Paths.get(studentFilesPath);
        List<Path> fileNames;
        try {
            fileNames = Files.list(folderPath)
                    .filter(p -> p.getFileName().toString().equalsIgnoreCase(name + ".json"))
                    .collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        if (fileNames.isEmpty()) {
            return null;
        }

        Path filePath = fileNames.get(0);
        loadStudentsFromFile(filePath.toString());

        return students.stream()
                .filter(s -> s.getName().equalsIgnoreCase(name))
                .findFirst()
                .orElse(null);
    }

    public List<Student> getStudents() {
        return students;
    }

    public void loadStudentsFromFile(String fileName) {
        try (FileReader reader = new FileReader(fileName)) {
            JSONTokener tokener = new JSONTokener(reader);
            JSONObject jsonObject = new JSONObject(tokener);

            String studentName = jsonObject.getString("student_name");
            double gpa = jsonObject.getDouble("gpa");
            String year = jsonObject.getString("year");
            JSONArray classScheduleArray = jsonObject.getJSONArray("class_schedule");

            List<Class> classSchedule = new ArrayList<>();

            for (int j = 0; j < classScheduleArray.length(); j++) {
                JSONObject classJson = classScheduleArray.getJSONObject(j);
                String className = classJson.getString("class_name");
                String classGrade = classJson.getString("class_grade");
                String classTime = classJson.getString("class_time");
                Class classInstance = new Class(className, classGrade, classTime);
                classSchedule.add(classInstance);
            }

            Student student = new Student(studentName, year, gpa, classSchedule);
            students.add(student);

        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }
    }

    public void saveStudentsToFile(String fileName) throws JSONException {
        JSONArray jsonArray = new JSONArray();

        for (Student student : students) {
            JSONObject jsonStudent = new JSONObject();
            jsonStudent.put("student_name", student.getName());
            jsonStudent.put("gpa", student.getGPA());
            jsonStudent.put("year", student.getYear());

            JSONArray classScheduleArray = new JSONArray();
            for (Class classInstance : student.getClasses()) {
                JSONObject classJson = new JSONObject();
                classJson.put("class_name", classInstance.getName());
                classJson.put("class_time", classInstance.getSchedule());
                classJson.put("class_grade", classInstance.getGrade());
                classScheduleArray.put(classJson);
            }

            jsonStudent.put("class_schedule", classScheduleArray);
            jsonArray.put(jsonStudent);
        }

        try (FileWriter writer = new FileWriter(fileName)) {
            writer.write(jsonArray.toString(2));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
