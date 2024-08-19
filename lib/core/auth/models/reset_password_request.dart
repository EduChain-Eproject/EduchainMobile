class ResetPasswordRequest {
  final String email;
  final String password;
  final int code;

  ResetPasswordRequest(this.email, this.password, this.code);

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "code": code,
    };
  }
}
