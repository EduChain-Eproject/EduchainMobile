class CountStudent {
  final int? allStudent;

  CountStudent({this.allStudent});

  factory CountStudent.fromJson(Map<String, dynamic> json) {
    return CountStudent(
      allStudent: json['allStudent'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allStudent': allStudent,
    };
  }
}
