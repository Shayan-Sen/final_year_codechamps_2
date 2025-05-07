import 'package:final_year_codechamps_2/firebase_options.dart';
import 'package:final_year_codechamps_2/pages/auth/loginpage.dart';
import 'package:final_year_codechamps_2/pages/home/teacher_home.dart';
import 'package:final_year_codechamps_2/pages/home/student_home.dart';
import 'package:final_year_codechamps_2/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Tutor',
        home: const DefaultPage(),
      ),
    );
  }
}

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});
  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Trigger data loading after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserAndLoadData();
    });
  }

  Future<void> _checkUserAndLoadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Load data from both providers
      final studentProvider = Provider.of<StudentProvider>(context, listen: false);
      final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);

      await Future.wait([
        studentProvider.loadStudent(),
        teacherProvider.loadTeacher(),
      ]);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If no user is logged in, show login page
    if (user == null) {
      return const LoginPage();
    }

    // Initial loading
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Watch providers for changes
    final studentProv = context.watch<StudentProvider>();
    final teacherProv = context.watch<TeacherProvider>();

    // Loading indicators for individual providers
    if (studentProv.isLoading || teacherProv.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Navigate based on which profile is available
    if (studentProv.student != null) {
      return const StudentHome();
    }

    if (teacherProv.teacher != null) {
      return const TeacherHome();
    }

    // No profile found case
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No profile found'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkUserAndLoadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}