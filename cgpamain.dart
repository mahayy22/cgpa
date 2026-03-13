import 'package:flutter/material.dart';

void main() {
  runApp(const CGPAApp());
}

class CGPAApp extends StatelessWidget {
  const CGPAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CUI CGPA Calculator",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1E88E5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
        ),
      ),
      home: const Dashboard(),
    );
  }
}

class Subject {
  String name;
  int credit;

  double mid = 0;
  double sess = 0;
  double finalExam = 0;

  Subject(this.name, this.credit);

  double get total => mid + sess + finalExam;

  double get gradePoint {
    double t = total;
    if (t >= 85) return 4.0;
    if (t >= 80) return 3.7;
    if (t >= 75) return 3.3;
    if (t >= 70) return 3.0;
    if (t >= 65) return 2.7;
    if (t >= 61) return 2.3;
    if (t >= 58) return 2.0;
    if (t >= 50) return 1.0;
    return 0;
  }
}

class CGPAStore {
  static Map<int, List<Subject>> semesters = {
    1: [
      Subject("ICT Fundamentals", 3),
      Subject("Islamic Studies", 2),
      Subject("Calculus", 3),
      Subject("English", 3),
      Subject("Pak Studies", 2),
    ],
    2: [
      Subject("Programming Fundamentals", 4),
      Subject("Discrete Structures", 3),
      Subject("Applied Physics", 3),
      Subject("Linear Algebra", 3),
      Subject("Communication Skills", 2),
    ],
    3: [
      Subject("OOP", 4),
      Subject("Data Structures", 4),
      Subject("Digital Logic", 3),
      Subject("Statistics", 3),
      Subject("Technical Writing", 2),
    ],
    4: [
      Subject("Database Systems", 4),
      Subject("Computer Organization", 3),
      Subject("Design & Analysis Algo", 3),
      Subject("Operating Systems", 3),
      Subject("Numerical Computing", 3),
    ],
    5: [
      Subject("Software Engineering", 3),
      Subject("Computer Networks", 3),
      Subject("Theory of Automata", 3),
      Subject("Artificial Intelligence", 3),
      Subject("Web Engineering", 3),
    ],
    6: [
      Subject("Compiler Construction", 3),
      Subject("Information Security", 3),
      Subject("Human Computer Interaction", 3),
      Subject("Mobile App Development", 3),
      Subject("Professional Ethics", 2),
    ],
    7: [
      Subject("FYP I", 3),
      Subject("Machine Learning", 3),
      Subject("Distributed Computing", 3),
      Subject("Elective I", 3),
      Subject("Elective II", 3),
    ],
    8: [
      Subject("FYP II", 6),
      Subject("Elective III", 3),
      Subject("Elective IV", 3),
      Subject("Internship", 3),
    ],
  };

  static double getSGPA(int sem) {
    double points = 0;
    int credits = 0;
    for (var s in semesters[sem]!) {
      if (s.total == 0) continue;
      points += s.gradePoint * s.credit;
      credits += s.credit;
    }
    if (credits == 0) return 0;
    return points / credits;
  }

  static double getCGPA() {
    double points = 0;
    int credits = 0;
    semesters.forEach((key, subjects) {
      for (var s in subjects) {
        if (s.total == 0) continue;
        points += s.gradePoint * s.credit;
        credits += s.credit;
      }
    });
    if (credits == 0) return 0;
    return points / credits;
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double cgpa = CGPAStore.getCGPA();

    return Scaffold(
      body: Column(
        children: [
          dashboardHeader(),
          const SizedBox(height: 16),
          cgpaCard(cgpa),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select Semester",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: semesterList(context, refresh)),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

Widget dashboardHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
      ),
    ),
    child: Row(
      children: [
        const Icon(Icons.school, color: Colors.white, size: 40),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "COMSATS University Islamabad",
              style:
              TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Vehari Campus",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        )
      ],
    ),
  );
}

Widget cgpaCard(double cgpa) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
      ),
    ),
    child: Column(
      children: [
        const Text("Total CGPA", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          cgpa.toStringAsFixed(2),
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}

Widget semesterList(BuildContext context, VoidCallback refresh) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: CGPAStore.semesters.length,
    itemBuilder: (context, index) {
      int sem = index + 1;
      double sgpa = CGPAStore.getSGPA(sem);

      Color color;
      if (sgpa >= 3.5) {
        color = Colors.greenAccent;
      } else if (sgpa >= 2.5) {
        color = Colors.orangeAccent;
      } else if (sgpa > 0) {
        color = Colors.redAccent;
      } else {
        color = Colors.grey;
      }

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text("Semester $sem"),
          trailing: CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Text(
              sgpa == 0 ? "--" : sgpa.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SemesterPage(semester: sem, refreshDashboard: refresh)),
            );
            refresh();
          },
        ),
      );
    },
  );
}

class SemesterPage extends StatefulWidget {
  final int semester;
  final VoidCallback refreshDashboard;
  const SemesterPage({super.key, required this.semester, required this.refreshDashboard});

  @override
  State<SemesterPage> createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  @override
  Widget build(BuildContext context) {
    List<Subject> subjects = CGPAStore.semesters[widget.semester]!;
    double sgpa = CGPAStore.getSGPA(widget.semester);

    return Scaffold(
      appBar: AppBar(
        title: Text("Semester ${widget.semester}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                Subject sub = subjects[index];
                return subjectCard(sub, () {
                  setState(() {});
                  widget.refreshDashboard();
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1A237E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: sgpa >= 3.0
                      ? Colors.greenAccent
                      : sgpa >= 2.0
                      ? Colors.orangeAccent
                      : Colors.redAccent,
                  child: Text(
                    sgpa.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget subjectCard(Subject sub, VoidCallback refresh) {
    // Fixed green background
    Color bgColor = Colors.green.shade300.withOpacity(0.5);

    return Card(
      color: bgColor,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              sub.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                marksField("Mid", 25, (v) {
                  sub.mid = double.tryParse(v) ?? 0;
                  refresh();
                }),
                marksField("Sess", 25, (v) {
                  sub.sess = double.tryParse(v) ?? 0;
                  refresh();
                }),
                marksField("Final", 50, (v) {
                  sub.finalExam = double.tryParse(v) ?? 0;
                  refresh();
                }),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Total: ${sub.total.toStringAsFixed(0)}  |  GPA: ${sub.gradePoint.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget marksField(String label, int max, Function(String) onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            hintText: "Max $max",
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
