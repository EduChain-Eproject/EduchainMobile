class MailRequest {
  final String email;

  MailRequest({required this.email});

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
