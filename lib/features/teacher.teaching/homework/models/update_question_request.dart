class UpdateQuestionRequest {
  final String questionText;
  final int correctAnswerId;

  UpdateQuestionRequest({
    required this.questionText,
    required this.correctAnswerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'correctAnswerId': correctAnswerId,
    };
  }
}
