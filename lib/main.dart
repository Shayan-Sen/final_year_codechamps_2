
import 'package:final_year_codechamps_2/firebase_options.dart';
import 'package:final_year_codechamps_2/pages/auth/loginpage.dart';
import 'package:final_year_codechamps_2/pages/home/teacher_home.dart';
import 'package:final_year_codechamps_2/pages/home/student_home.dart';
import 'package:final_year_codechamps_2/providers/user_provider.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';
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
        ChangeNotifierProvider(create: (_) => StudentProvider(studentServices: StudentServices())),
        ChangeNotifierProvider(create: (_) => TeacherProvider(teacherServices: TeacherServices())),
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
  bool _didFetch = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final studentProv = context.watch<StudentProvider>();
    final teacherProv = context.watch<TeacherProvider>();

    // 1) Not signed in → go to login
    if (user == null) {
      return const LoginPage();
    }

    // 2) Kick off profile fetch exactly once
    if (!_didFetch) {
      _didFetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        studentProv.refreshUser().then((_) {
          if (!studentProv.hasProfile) {
            teacherProv.refreshUser();
          }
        });
      });
    }

    // 3) Show loading while fetching
    if (studentProv.status == Status.loading ||
        teacherProv.status == Status.loading ||
        (studentProv.status == Status.idle && teacherProv.status == Status.idle)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 4) Route once we have a profile
    if (studentProv.hasProfile) {
      return const StudentHome();
    }
    if (teacherProv.hasProfile) {
      return const TeacherHome();
    }

    // 5) Both failed → show error
    return Scaffold(
      body: Center(
        child: Text(
          'No profile found for ${user.email}.\n'
              'Please log in with the correct role.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
