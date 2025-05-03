import 'package:final_year_codechamps_2/models/student.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:flutter/cupertino.dart';
import '../models/teacher.dart';
import '../services/teacher_services.dart';

enum Status { idle, loading, success, error }

class StudentProvider extends ChangeNotifier {
  Student? student;
  Status _status = Status.idle;
  String? _errorMessage;
  final StudentServices studentServices;
  StudentProvider({required this.studentServices});
  Status get status => _status;
  String? get errorMessage => _errorMessage;
  Future<void> refreshUser() async {
    _status = Status.loading;
    notifyListeners();
    try {
      student = await studentServices.getStudent();
      _status = Status.success;
    } on Exception catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}

class TeacherProvider extends ChangeNotifier {
  Teacher? teacher;
  Status _status = Status.idle;
  String? _errorMessage;
  final TeacherServices teacherServices;
  TeacherProvider({required this.teacherServices});
  Status get status => _status;
  String? get errorMessage => _errorMessage;
  Future<void> refreshUser() async {
    _status = Status.loading;
    notifyListeners();
    try {
      teacher = await teacherServices.getTeacher();
      _status = Status.success;
    } on Exception catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
