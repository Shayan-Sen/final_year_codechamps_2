
import 'package:final_year_codechamps_2/pages/ai/chatpage.dart';
import 'package:final_year_codechamps_2/pages/auth/loginpage.dart';
import 'package:final_year_codechamps_2/providers/user_provider.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  final StudentServices services = StudentServices();

  int _currentIndex = 0;
  final double gpa = 3.7;
  final int attendance = 92;
  final int completedAssignments = 24;
  final int totalAssignments = 30;
  final int upcomingTests = 2;

  final List<Map<String, dynamic>> courseData = [
    {'name': 'Mathematics', 'grade': 'A', 'progress': 0.9, 'color': Colors.blue},
    {'name': 'Programming', 'grade': 'A-', 'progress': 0.85, 'color': Colors.green},
    {'name': 'Data Structures', 'grade': 'B+', 'progress': 0.78, 'color': Colors.amber},
    {'name': 'Web Development', 'grade': 'A', 'progress': 0.92, 'color': Colors.purple},
  ];
  final List<Map<String, dynamic>> termGrades = [
    {'term': 'Term 1', 'gpa': 3.5},
    {'term': 'Term 2', 'gpa': 3.2},
    {'term': 'Term 3', 'gpa': 3.7},
    {'term': 'Term 4', 'gpa': 3.6},
    {'term': 'Current', 'gpa': 3.7},
  ];
  final List<Map<String, dynamic>> weeklyAttendance = [
    {'week': 'Week 1', 'percentage': 90},
    {'week': 'Week 2', 'percentage': 100},
    {'week': 'Week 3', 'percentage': 80},
    {'week': 'Week 4', 'percentage': 100},
    {'week': 'Week 5', 'percentage': 90},
  ];
  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'Algorithm Test',
      'subject': 'Data Structures',
      'date': 'May 10, 2025',
      'icon': Icons.assignment
    },
    {
      'title': 'Project Submission',
      'subject': 'Web Development',
      'date': 'May 15, 2025',
      'icon': Icons.computer
    },
    {
      'title': 'Linear Algebra Quiz',
      'subject': 'Mathematics',
      'date': 'May 20, 2025',
      'icon': Icons.calculate
    },
  ];

  late List<Widget> _tabs ;
  final List<String> _tabTitles = ['Profile Screen', 'Dashboard Screen', 'Analytics Screen', 'AI Chat Screen'];

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
    _tabs[0] = _profileSection();
    _tabs[1] = _buildDashboard();
    _tabs[2] = _buildAnalytics();
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard),label: 'Dashboard',backgroundColor: Color(0xFF001B4D)),
            BottomNavigationBarItem(icon: Icon(Icons.analytics),label: 'Analytics',backgroundColor: Color(0xFF001B4D)),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bots),label: 'AI',backgroundColor: Color(0xFF001B4D))
          ],
        onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
        }
      ),
    );
  }

  // ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snack(String message){
  //   return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)),
  //   );
  // }

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
    final provider = context.watch<StudentProvider>();

    // Show loading indicator if explicitly loading
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final student = provider.student;
    if (student == null) {
      // Handle no student case - maybe trigger a load or show error
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No student data available"),
            ElevatedButton(
              onPressed: () => provider.loadStudent(),
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
                _card(title: 'About', description: student.about),
              ],
            ),
          ),
        );
  }



  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildProgressSection(),
          const SizedBox(height: 20),
          _buildCourseSection(),
          const SizedBox(height: 20),
          _buildUpcomingEvents(),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                'Assignments',
                '$completedAssignments/$totalAssignments',
                completedAssignments / totalAssignments,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProgressCard(
                'Attendance',
                '$attendance%',
                attendance / 100,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProgressCard(
                'Upcoming Tests',
                '$upcomingTests',
                1.0,
                Colors.orange,
                showProgress: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(
      String title,
      String value,
      double progress,
      Color color, {
        bool showProgress = true,
      })
  {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Performance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courseData.length,
          itemBuilder: (context, index) {
            final course = courseData[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Grade: ${course['grade']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: course['color'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: course['progress'],
                      backgroundColor: course['color'].withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(course['color']),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completion: ${(course['progress'] * 100).toInt()}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(event['icon'], color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(event['title']),
                subtitle: Text('${event['subject']} • ${event['date']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Event: ${event['title']}')),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGPAChart(),
          const SizedBox(height: 20),
          _buildAttendanceChart(),
          const SizedBox(height: 20),
          _buildSubjectPerformance(),
        ],
      ),
    );
  }

  Widget _buildGPAChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GPA Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current GPA: $gpa',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: _leftTitleWidgets,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < termGrades.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                termGrades[index]['term'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: 0,
                  maxX: termGrades.length - 1.0,
                  minY: 2.0,
                  maxY: 4.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        termGrades.length,
                            (index) => FlSpot(
                          index.toDouble(),
                          termGrades[index]['gpa'],
                        ),
                      ),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAttendanceChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Average: $attendance%',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  minY: 0,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      tooltipRoundedRadius: 8,
                      tooltipBorder: BorderSide(color: Colors.blueGrey.shade600),

                      // <-- replace tooltipBgColor with getTooltipColor:
                      getTooltipColor: (BarChartGroupData group) {
                        // you can inspect group.x or other properties here if needed
                        return Colors.blueGrey.shade700;
                      },

                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final pct = weeklyAttendance[groupIndex]['percentage'];
                        return BarTooltipItem(
                          '$pct%',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),

                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: _leftTitleWidgets,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index >= 0 && index < weeklyAttendance.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'W${index + 1}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: List.generate(
                    weeklyAttendance.length,
                        (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyAttendance[index]['percentage'].toDouble(),
                          color: _getAttendanceColor(weeklyAttendance[index]['percentage']),
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAttendanceColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.amber;
    return Colors.red;
  }

  Widget _buildSubjectPerformance() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: courseData.map((course) {
                    return PieChartSectionData(
                      color: course['color'],
                      value: course['progress'] * 100,
                      title: course['name'],
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courseData.length,
              itemBuilder: (context, index) {
                final course = courseData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: course['color'],
                    radius: 12,
                  ),
                  title: Text(course['name']),
                  trailing: Text(
                    '${(course['progress'] * 100).toInt()}% - ${course['grade']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: course['color'],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}


// Helper function for charts
Widget _leftTitleWidgets(double value, TitleMeta meta) {
  return Text(
    value.toStringAsFixed(1),
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
  );
}