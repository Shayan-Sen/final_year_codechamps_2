import 'package:final_year_codechamps_2/models/student.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_codechamps_2/models/teacher.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';

enum Status { idle, loading, success, error }

extension StudentProviderX on StudentProvider {
  bool get hasProfile => status == Status.success && student != null;
}

class StudentProvider extends ChangeNotifier {
  Student? student;
  Status _status = Status.idle;
  String? _errorMessage;
  final StudentServices studentServices;

  StudentProvider({required this.studentServices});

  Status get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => status == Status.success && student != null;

  Future<void> refreshUser() async {
    _status = Status.loading;
    notifyListeners();
    try {
      student = await studentServices.getStudent();
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}

extension TeacherProviderX on TeacherProvider {
  bool get hasProfile => status == Status.success && teacher != null;
}

class TeacherProvider extends ChangeNotifier {
  Teacher? teacher;
  Status _status = Status.idle;
  String? _errorMessage;
  final TeacherServices teacherServices;

  TeacherProvider({required this.teacherServices});

  Status get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => status == Status.success && teacher != null;

  Future<void> refreshUser() async {
    _status = Status.loading;
    notifyListeners();
    try {
      teacher = await teacherServices.getTeacher();
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
