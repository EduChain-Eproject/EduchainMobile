import 'category.dart';

class UserCourse {
  final String? teacherName;
  final String? teacherEmail;
  final String? title;
  final DateTime? enrollmentDate;
  final double? price;
  final CompletionStatus? completionStatus;
  final List<Category>? categoryList;

  UserCourse({
    this.teacherName,
    this.teacherEmail,
    this.title,
    this.enrollmentDate,
    this.price,
    this.completionStatus,
    this.categoryList,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      teacherName: json['teacherName'] as String?,
      teacherEmail: json['teacherEmail'] as String?,
      title: json['title'] as String?,
      enrollmentDate: json['enrollmentDate'] != null
          ? DateTime.tryParse(json['enrollmentDate'] as String)
          : null,
      price: (json['price'] as num?)?.toDouble(),
      completionStatus: json['completionStatus'] != null
          ? completionStatusFromJson(json['completionStatus'] as String)
          : null,
      categoryList: (json['categoryList'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherName': teacherName,
      'teacherEmail': teacherEmail,
      'title': title,
      'enrollmentDate': enrollmentDate?.toIso8601String(),
      'price': price,
      'completionStatus': completionStatus?.name,
      'categoryList':
          categoryList?.map((category) => category.toJson()).toList(),
    };
  }
}

enum CompletionStatus { NOT_STARTED, IN_PROGRESS, COMPLETED }

CompletionStatus completionStatusFromJson(String status) {
  switch (status) {
    case 'NOT_STARTED':
      return CompletionStatus.NOT_STARTED;
    case 'IN_PROGRESS':
      return CompletionStatus.IN_PROGRESS;
    case 'COMPLETED':
      return CompletionStatus.COMPLETED;
    default:
      throw ArgumentError('Unknown CompletionStatus: $status');
  }
}
