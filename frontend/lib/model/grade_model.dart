class GradeModel {
  final int id, score, examId;
  final String? email, createdAt;

  GradeModel(
      {required this.id,
      required this.email,
      required this.score,
      required this.examId,
      required this.createdAt});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
        id: json['id'],
        email: json['email'],
        score: json['score'],
        examId: json['exam_id'],
        createdAt: json['created_at']);
  }
}
