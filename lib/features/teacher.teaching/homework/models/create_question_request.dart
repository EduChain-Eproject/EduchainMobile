class CreateQuestionRequest {
  final int homeworkId;
  final String questionText;
  final List<String> answerTexts;
  final int correctAnswerIndex;

  CreateQuestionRequest({
    required this.homeworkId,
    required this.questionText,
    required this.answerTexts,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'homeworkId': homeworkId,
      'questionText': questionText,
      'answerTexts': answerTexts,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
