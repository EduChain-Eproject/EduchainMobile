class UpdateAnswerRequest {
  final String answerText;

  UpdateAnswerRequest({required this.answerText});

  Map<String, dynamic> toJson() {
    return {
      'answerText': answerText,
    };
  }
}
