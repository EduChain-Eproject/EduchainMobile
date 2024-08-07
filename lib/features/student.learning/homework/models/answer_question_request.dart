class AnswerQuestionRequest {
  final int questionId;
  final int answerId;

  AnswerQuestionRequest({required this.questionId, required this.answerId});

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerId': answerId,
    };
  }
}
