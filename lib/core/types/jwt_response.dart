class JwtResponse {
  final String accessToken;
  final String refreshToken;

  JwtResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  // Convert JSON to JwtResponse
  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  // // Convert JwtResponse to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'accessToken': accessToken,
  //     'refreshToken': refreshToken,
  //   };
  // }
}
