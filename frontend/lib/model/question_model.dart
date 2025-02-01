class QuestionModel {
  int? id;
  int? examId;
  String question;
  List<String> options;
  String answer;
  int score;
  bool _delete;

  QuestionModel({
    this.id,
    this.examId,
    required this.question,
    required this.options,
    required this.answer,
    required this.score,
    bool? delete,
  }) : _delete = delete ?? false;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      examId: json['exam_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      score: json['score'],
      delete: json['_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question.toString(),
      "options": options.map((option) => option.toString()).toList(),
      "answer": answer.toString(),
      "score": score,
      "_delete": _delete,
    };
  }

  bool get isDeleted => _delete;

  void markForDeletion() {
    _delete = true;
  }

  void unmarkForDeletion() {
    _delete = false;
  }
}
