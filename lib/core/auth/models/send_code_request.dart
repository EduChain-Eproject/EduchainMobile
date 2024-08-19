class SendCodeRequest {
  final String email;

  SendCodeRequest(this.email);

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}
