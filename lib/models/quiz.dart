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
      question: map['question'],
      options: List<String>.from(map['options']),
      correctOption: map['correctOption'],
    );
  }
}

class Quiz{
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

  Map<String,dynamic> toFireStore(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((e) => e.toMap()).toList(),
      'timeLimit': timeLimit
    };
  }

  factory Quiz.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options){
    final data = snapshot.data();
    if (data == null) throw Exception('Data not found');
    return Quiz(
      id: (data['id'] != snapshot.id)? snapshot.id : data['id'],
      title: data['title'],
      description: data['description'],
      questions: List<Question>.from(data['questions'].map((e) => Question.fromMap(e))),
      timeLimit: data['timeLimit']
    );
  }
}
