import 'package:educhain/core/models/course_feedback.dart';

class Statistics {
  final int? numberOfEnrollments;
  final int? certificationsMade;
  final int? satisfactionRate;
  final List<CourseFeedback>? bestFeedbacks;

  Statistics({
    this.numberOfEnrollments,
    this.certificationsMade,
    this.satisfactionRate,
    this.bestFeedbacks,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      numberOfEnrollments: json['numberOfEnrollments'],
      certificationsMade: json['certificationsMade'],
      satisfactionRate: json['satisfactionRate'],
      bestFeedbacks: (json['bestFeedbacks'] as List<dynamic>?)
          ?.map((e) => CourseFeedback.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfEnrollments': numberOfEnrollments,
      'certificationsMade': certificationsMade,
      'satisfactionRate': satisfactionRate,
      'bestFeedbacks': bestFeedbacks?.map((item) => item.toJson()).toList(),
    };
  }
}
