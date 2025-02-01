import 'package:frontend/model/question_model.dart';

class ExamModel {
  int? id;
  String title;
  String description;
  String startDate;
  int duration;
  List<QuestionModel> questions;

  ExamModel({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.duration,
    required this.questions,
  });

  factory ExamModel.createNew({
    required String title,
    required String description,
    required String startDate,
    required int duration,
    List<QuestionModel>? questions,
  }) {
    return ExamModel(
      title: title,
      description: description,
      startDate: startDate,
      duration: duration,
      questions: questions ?? [],
    );
  }

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      duration: json['duration'],
      questions: json['questions']
          .map<QuestionModel>((q) => QuestionModel.fromJson(q))
          .toList(),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title.toString(),
      "description": description.toString(),
      "start_date": startDate.toString(),
      "duration": duration,
      "questions": questions.map((q) => q.toJson()).toList(),
    };
  }
}
