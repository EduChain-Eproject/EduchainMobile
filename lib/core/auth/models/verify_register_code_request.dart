class VerifyRegisterCodeRequest {
  final String email;
  final int code;

  VerifyRegisterCodeRequest(this.email, this.code);

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };
}
