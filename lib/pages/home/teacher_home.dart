import 'package:final_year_codechamps_2/pages/ai/chatpage.dart';
import 'package:final_year_codechamps_2/pages/auth/loginpage.dart';
import 'package:final_year_codechamps_2/pages/home/education_card.dart';
import 'package:final_year_codechamps_2/providers/user_provider.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';
import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final TeacherServices services = TeacherServices();
  int _currentIndex = 0;

  // Static data for dashboard
  final Map<String, double> attendanceData = {
    'Present': 85,
    'Absent': 10,
    'Late': 5,
  };

  final List<Map<String, dynamic>> classPerformance = [
    {'subject': 'Math', 'averageScore': 76},
    {'subject': 'Science', 'averageScore': 82},
    {'subject': 'English', 'averageScore': 79},
    {'subject': 'History', 'averageScore': 88},
    {'subject': 'Art', 'averageScore': 92},
  ];

  final List<Map<String, dynamic>> upcomingTasks = [
    {
      'title': 'Grade Math Tests',
      'dueDate': 'May 20',
      'priority': 'High',
      'completed': false
    },
    {
      'title': 'Parent-Teacher Meetings',
      'dueDate': 'May 25',
      'priority': 'High',
      'completed': false
    },
    {
      'title': 'Submit Quarterly Report',
      'dueDate': 'June 1',
      'priority': 'Medium',
      'completed': false
    },
    {
      'title': 'Science Fair Planning',
      'dueDate': 'June 12',
      'priority': 'Medium',
      'completed': false
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      'activity': 'Posted Science homework',
      'timestamp': '2 hours ago',
      'icon': Icons.science
    },
    {
      'activity': 'Updated Math syllabus',
      'timestamp': 'Yesterday',
      'icon': Icons.calculate
    },
    {
      'activity': 'Graded English essays',
      'timestamp': '2 days ago',
      'icon': Icons.menu_book
    },
    {
      'activity': 'Added new student to class',
      'timestamp': '3 days ago',
      'icon': Icons.person_add
    },
  ];

  final List<Map<String, dynamic>> students = [
    {
      'name': 'Emma Johnson',
      'id': 'S1001',
      'attendance': 98,
      'avgGrade': 'A',
      'alerts': 0
    },
    {
      'name': 'Noah Williams',
      'id': 'S1002',
      'attendance': 92,
      'avgGrade': 'B+',
      'alerts': 1
    },
    {
      'name': 'Olivia Brown',
      'id': 'S1003',
      'attendance': 95,
      'avgGrade': 'A-',
      'alerts': 0
    },
    {
      'name': 'Liam Jones',
      'id': 'S1004',
      'attendance': 85,
      'avgGrade': 'B',
      'alerts': 1
    },
    {
      'name': 'Ava Garcia',
      'id': 'S1005',
      'attendance': 78,
      'avgGrade': 'C+',
      'alerts': 2
    },
  ];

  // Weekly class engagement data
  final List<Map<String, dynamic>> weeklyEngagement = [
    {'day': 'Mon', 'participation': 75},
    {'day': 'Tue', 'participation': 82},
    {'day': 'Wed', 'participation': 68},
    {'day': 'Thu', 'participation': 90},
    {'day': 'Fri', 'participation': 85},
  ];

  late List<Widget> _tabs ;

  final List<String> _tabTitles = ['Profile Screen', 'Dashboard Screen', 'Students Screen', 'AI Chat Screen'];

  @override
  void initState() {
    super.initState();
    // Don't call methods that use Theme.of(context) here
    _tabs = [
      Container(),
      Container(), // Placeholder until build time
      Container(), // Placeholder until build time
      ChatBot(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize components that need context/theme here
    _tabs[0] = _profileSection();
    _tabs[1] = _buildDashboard();
    _tabs[2] = _buildStudentsTab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JycAppbar(data: _tabTitles[_currentIndex],actions: [IconButton(onPressed: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        await services.logout();
      }, icon: Icon(Icons.logout))],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile',backgroundColor: Color(0xFF001B4D)),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard),label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Analytics'),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bots),label: 'AI')
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }
      ),
    );
  }

  Widget _card({required String title,required String description}){
    return Card(
      elevation: 4, // Shadow depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );

  }

  Widget _profileSection() {
    final provider = context.watch<TeacherProvider>();

    // Show loading indicator if explicitly loading
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final student = provider.teacher;
    if (student == null) {
      // Handle no student case - maybe trigger a load or show error
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No student data available"),
            ElevatedButton(
              onPressed: () => provider.loadTeacher(),
              child: Text("Reload Data"),
            )
          ],
        ),
      );
    }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){},
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,

                    child: (student.profileImage == null )
                        ? Text('${student.name.split(' ').first[0].toUpperCase()}${student.name.split(' ').last[0].toUpperCase()}',style: TextStyle(fontSize: 44,color: Colors.white),)
                        : null,
                  ),
                ),
                const SizedBox(height: 70),
                _card(title: 'Name', description: student.name),
                const SizedBox(height: 10),
                _card(title: 'Email', description: student.email),
                const SizedBox(height: 10),
                _card(title: 'Email', description: student.about),
                const SizedBox(height: 10),
                _card(title: 'About', description: student.educationQualification),
                EducationCard(proofOfEducation: student.proofOfEducation),
                const SizedBox(height: 10)
              ],
            ),
          ),
        );
  }


  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Ms. Johnson!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildSummaryCards(),
          SizedBox(height: 20),
          _buildChartSection(),
          SizedBox(height: 20),
          _buildUpcomingTasksSection(),
          SizedBox(height: 20),
          _buildRecentActivitiesSection(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildSummaryCard(
          title: 'Total Students',
          value: '28',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildSummaryCard(
          title: 'Today\'s Attendance',
          value: '${attendanceData['Present']!.toInt()}%',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildSummaryCard(
          title: 'Class Average',
          value: '83%',
          icon: Icons.trending_up,
          color: Colors.orange,
        ),
        _buildSummaryCard(
          title: 'Pending Tasks',
          value: '${upcomingTasks.where((task) => !task['completed']).length}',
          icon: Icons.assignment_late,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                // <-- wrap your title in Expanded (or Flexible)
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,      // optional: show “…” instead of clipping
                    maxLines: 1,                          // optional: keep it to one line
                  ),
                ),
              ],
            ),

            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Attendance',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: _buildAttendancePieChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class Engagement',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: _buildEngagementLineChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subject Performance',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPerformanceBarChart(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendancePieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 20,
        sections: [
          PieChartSectionData(
            value: attendanceData['Present']!,
            title: '${attendanceData['Present']!.toInt()}%',
            color: Colors.green,
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: attendanceData['Absent']!,
            title: '${attendanceData['Absent']!.toInt()}%',
            color: Colors.red,
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: attendanceData['Late']!,
            title: '${attendanceData['Late']!.toInt()}%',
            color: Colors.orange,
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Mon');
                  case 1:
                    return Text('Tue');
                  case 2:
                    return Text('Wed');
                  case 3:
                    return Text('Thu');
                  case 4:
                    return Text('Fri');
                  default:
                    return Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, weeklyEngagement[0]['participation'].toDouble()),
              FlSpot(1, weeklyEngagement[1]['participation'].toDouble()),
              FlSpot(2, weeklyEngagement[2]['participation'].toDouble()),
              FlSpot(3, weeklyEngagement[3]['participation'].toDouble()),
              FlSpot(4, weeklyEngagement[4]['participation'].toDouble()),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withAlpha(25),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100.0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${classPerformance[groupIndex]['subject']}: ${rod.toY.round()}%',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(classPerformance[value.toInt()]['subject']);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28.0,
              getTitlesWidget: (value, meta) {
                if (value == 0) return Text('0%');
                if (value == 50) return Text('50%');
                if (value == 100) return Text('100%');
                return Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: classPerformance.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final double score = (data['averageScore'] as num).toDouble();  // cast here
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: score,
                color: _getPerformanceColor(score),  // now passes a double
                width: 22.0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  topRight: Radius.circular(6.0),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.amber;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildUpcomingTasksSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...upcomingTasks.take(3).map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    Color priorityColor;
    switch (task['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Priority indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with ellipsis if too long
                Text(
                  task['title'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                // Subtitle also ellipsized
                Text(
                  'Due: ${task['dueDate']} • ${task['priority']} Priority',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          // Checkbox
          Checkbox(
            value: task['completed'],
            onChanged: (bool? value) {
              setState(() {
                task['completed'] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Activities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...recentActivities.map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withAlpha(25),
            child: Icon(activity['icon'], color: Colors.blue, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['activity'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  activity['timestamp'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Students Tab
  Widget _buildStudentsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildStudentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/150'),
            ),
            title: Text(student['name']),
            subtitle: Text('ID: ${student['id']} • Attendance: ${student['attendance']}%'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGradeColor(student['avgGrade']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${student['avgGrade']}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                if (student['alerts'] > 0)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${student['alerts']}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Navigate to student details
            },
          ),
        );
      },
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade[0]) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
