package studentManager;

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.util.List;
import org.json.JSONException;

public class MainGui extends JFrame {
    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTextField textField;
    private JLabel nameLabel, yearLabel, gpaLabel, scheduleLabel;
    private DefaultListModel<String> classListModel;
    private JList<String> classList;
    private StudentManager studentManager;

    /**
     * Launch the application.
     */
    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    String projectRoot = System.getProperty("user.dir");
                    String studentFilesPath = projectRoot + "/src/studentManager/studentfiles";
                    StudentManager studentManager = new StudentManager(studentFilesPath);
                    MainGui frame = new MainGui(studentManager);
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Create the frame.
     */
    public MainGui(StudentManager studentManager) {
        this.studentManager = studentManager;
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 450, 300);
        contentPane = new JPanel();
        setContentPane(contentPane);
        contentPane.setLayout(new BorderLayout(0, 0));
        studentInfoPanel();
        userInputPanel();
    }

    private void studentInfoPanel() {
        JPanel studentPanel = new JPanel();
        contentPane.add(studentPanel, BorderLayout.CENTER);
        studentPanel.setLayout(new BorderLayout(0, 0));

        JPanel Studentpanel = new JPanel();
        studentPanel.add(Studentpanel, BorderLayout.WEST);
        Studentpanel.setLayout(new GridLayout(3, 1));
        Studentpanel.setPreferredSize(new Dimension(100, 10));

        nameLabel = new JLabel("Name: ");
        Studentpanel.add(nameLabel);

        yearLabel = new JLabel("Year: ");
        Studentpanel.add(yearLabel);

        gpaLabel = new JLabel("GPA: ");
        Studentpanel.add(gpaLabel);

        JPanel schedulePanel = new JPanel();
        studentPanel.add(schedulePanel, BorderLayout.CENTER);
        schedulePanel.setLayout(new BorderLayout(0, 0));

        classListModel = new DefaultListModel<>();
        classList = new JList<>(classListModel);
        scheduleLabel = new JLabel("Schedule:");
        schedulePanel.add(scheduleLabel, BorderLayout.NORTH);
        schedulePanel.add(new JScrollPane(classList), BorderLayout.CENTER);

        JButton backupButton = new JButton("Backup student");
        schedulePanel.add(backupButton, BorderLayout.SOUTH);

        backupButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String projectRoot = System.getProperty("user.dir");
                String outputFilePath = projectRoot + "/src/studentManager/studentfiles/backup.json";

                try {
                    studentManager.saveStudentsToFile(outputFilePath);
                    JOptionPane.showMessageDialog(MainGui.this, "Students saved to " + outputFilePath, "Backup Successful", JOptionPane.INFORMATION_MESSAGE);
                } catch (JSONException ex) {
                    JOptionPane.showMessageDialog(MainGui.this, "Error saving students to file", "Backup Failed", JOptionPane.ERROR_MESSAGE);
                    ex.printStackTrace();
                }
            }
        });
    }

    private void userInputPanel() {
        JPanel panel = new JPanel();
        contentPane.add(panel, BorderLayout.NORTH);

        JLabel lblNewLabel = new JLabel("Please enter student name: ");
        panel.add(lblNewLabel);

        textField = new JTextField();
        panel.add(textField);
        textField.setColumns(10);

        JButton submitButton = new JButton("Submit");
        panel.add(submitButton);

        JButton backupButton = new JButton("Backup");
        panel.add(backupButton); // Add the backupButton to the panel

        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String studentName = textField.getText();
                Student foundStudent = studentManager.searchStudent(studentName);

                if (foundStudent != null) {
                    nameLabel.setText("Name: " + foundStudent.getName());
                    yearLabel.setText("Year: " + foundStudent.getYear());
                    gpaLabel.setText("GPA: " + foundStudent.getGPA());

                    classListModel.clear();
                    List<Class> classes = foundStudent.getClasses();
                    for (Class classInstance : classes) {
                        classListModel.addElement(classInstance.getName());
                    }
                } else {
                    nameLabel.setText("Name: ");
                    yearLabel.setText("Year: ");
                    gpaLabel.setText("GPA: ");
                    classListModel.clear();
                    JOptionPane.showMessageDialog(MainGui.this, "Student not found.", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        backupButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String projectRoot = System.getProperty("user.dir");
                String outputFilePath = projectRoot + "/src/studentManager/studentfiles/output.json";

                try {
                    studentManager.saveStudentsToFile(outputFilePath);
                    JOptionPane.showMessageDialog(MainGui.this, "Students saved to " + outputFilePath, "Backup Successful", JOptionPane.INFORMATION_MESSAGE);
                } catch (JSONException ex) {
                    JOptionPane.showMessageDialog(MainGui.this, "Error saving students to file", "Backup Failed", JOptionPane.ERROR_MESSAGE);
                    ex.printStackTrace();
                }
            }
        });
    }
}
