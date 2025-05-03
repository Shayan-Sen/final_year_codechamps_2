import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  Question({
    required this.question,
    required this.options,
    required this.correctOption,
  });
  final String question;
  final List<String> options;
  final int correctOption;

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctOption': correctOption,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      options: List<String>.from(map['options'] as List<dynamic>),
      correctOption: map['correctOption'] as int,
    );
  }
}

class Quiz {
  Quiz({
    this.id = "",
    required this.title,
    required this.description,
    required this.questions,
    this.timeLimit,
  });
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int? timeLimit;

  Quiz copyWith({
    String? title,
    String? description,
    List<Question>? questions,
    int? timeLimit,
  }) {
    return Quiz(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }

  Map<String, dynamic> toFirestore() {
    // ensure map accepts dynamic values
    final Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
    if (timeLimit != null) {
      map['timeLimit'] = timeLimit;
    }
    return map;
  }

  factory Quiz.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception('Data not found');
    return Quiz(
      id: snapshot.id,
      title: data['title'] as String,
      description: data['description'] as String,
      questions: List<Question>.from(
        (data['questions'] as List<dynamic>).map(
          (e) => Question.fromMap(e as Map<String, dynamic>),
        ),
      ),
      timeLimit: data['timeLimit'] as int?,
    );
  }
}
