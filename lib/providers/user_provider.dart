import 'package:final_year_codechamps_2/models/student.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_codechamps_2/models/teacher.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StudentProvider extends ChangeNotifier {
  StudentServices services = StudentServices();
  Student? _student;
  bool _isLoading = false;

  Student? get student => _student;
  bool get isLoading => _isLoading;

  StudentProvider() {
    // Try to load cached data immediately on creation
    _loadCachedStudent();
  }

  // Load cached student data if available
  Future<void> _loadCachedStudent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_student_data');

      if (cachedData != null && cachedData.isNotEmpty) {
        final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
        _student = Student.fromJson(jsonData);
        notifyListeners();
        debugPrint('Loaded cached student data for: ${_student?.name}');
      }
    } catch (e) {
      debugPrint('Error loading cached student data: $e');
    }
  }

  // Cache the student data for persistence
  Future<void> _cacheStudentData() async {
    if (_student != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final jsonData = jsonEncode(_student!.toJson());
        await prefs.setString('cached_student_data', jsonData);
        debugPrint('Cached student data for: ${_student?.name}');
      } catch (e) {
        debugPrint('Error caching student data: $e');
      }
    }
  }

  Future<void> loadStudent() async {
    if (_isLoading) return; // Prevent multiple simultaneous loads

    _isLoading = true;
    notifyListeners();

    try {
      // Load student data from API or local storage
      final fetchedStudent = await services.getStudent();
      _student = fetchedStudent;

      if (_student != null) {
        // Cache the data for persistence
        await _cacheStudentData();
        debugPrint('Successfully loaded student: ${_student?.name}');
      } else {
        debugPrint('No student data returned from service');
      }
    } catch (e) {
      debugPrint('Error loading student data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _student = null;
    notifyListeners();

    // Clear cached data
    SharedPreferences.getInstance().then(
            (prefs) => prefs.remove('cached_student_data')
    );
    debugPrint('Student data reset');
  }
}

class TeacherProvider extends ChangeNotifier {
  TeacherServices services = TeacherServices();
  Teacher? _teacher;
  bool _isLoading = false;

  Teacher? get teacher => _teacher;
  bool get isLoading => _isLoading;

  TeacherProvider() {
    // Try to load cached data immediately on creation
    _loadCachedTeacher();
  }

  // Load cached teacher data if available
  Future<void> _loadCachedTeacher() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_teacher_data');

      if (cachedData != null && cachedData.isNotEmpty) {
        final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
        _teacher = Teacher.fromJson(jsonData);
        notifyListeners();
        debugPrint('Loaded cached teacher data for: ${_teacher?.name}');
      }
    } catch (e) {
      debugPrint('Error loading cached teacher data: $e');
    }
  }

  // Cache the teacher data for persistence
  Future<void> _cacheTeacherData() async {
    if (_teacher != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final jsonData = jsonEncode(_teacher!.toJson());
        await prefs.setString('cached_teacher_data', jsonData);
        debugPrint('Cached teacher data for: ${_teacher?.name}');
      } catch (e) {
        debugPrint('Error caching teacher data: $e');
      }
    }
  }

  Future<void> loadTeacher() async {
    if (_isLoading) return; // Prevent multiple simultaneous loads

    _isLoading = true;
    notifyListeners();

    try {
      // Load teacher data from API
      final fetchedTeacher = await services.getTeacher();
      _teacher = fetchedTeacher;

      if (_teacher != null) {
        // Cache the data for persistence
        await _cacheTeacherData();
        debugPrint('Successfully loaded teacher: ${_teacher?.name}');
      } else {
        debugPrint('No teacher data returned from service');
      }
    } catch (e) {
      debugPrint('Error loading teacher data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _teacher = null;
    notifyListeners();

    // Clear cached data
    SharedPreferences.getInstance().then(
            (prefs) => prefs.remove('cached_teacher_data')
    );
    debugPrint('Teacher data reset');
  }
}