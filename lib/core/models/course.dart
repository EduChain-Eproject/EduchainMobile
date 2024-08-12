import 'user_interests.dart';
import 'category.dart';
import 'blog.dart';
import 'chapter.dart';
import 'course_feedback.dart';
import 'user.dart';
import 'user_course.dart';

class Course {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final CourseStatus? status;
  final String? avatarPath;

  final List<Chapter>? chapterDtos;
  final List<Blog>? blogDtos;
  final User? teacherDto;
  final List<CourseFeedback>? courseFeedbackDtos;
  final List<Category>? categoryDtos;
  final List<UserCourse>? participatedUserDtos;
  final List<UserInterests>? userInterestDtos;
  final int? numberOfEnrolledStudents;
  final UserCourse? currentUserCourse;
  final List<Course>? relatedCourseDtos;
  final int? numberOfLessons;
  final bool? currentUserInterested;
  final int? lessonIdTolearn;

  Course({
    this.id,
    this.price,
    this.status,
    this.title,
    this.description,
    this.avatarPath,
    this.chapterDtos,
    this.blogDtos,
    this.teacherDto,
    this.courseFeedbackDtos,
    this.categoryDtos,
    this.participatedUserDtos,
    this.userInterestDtos,
    this.numberOfEnrolledStudents,
    this.currentUserCourse,
    this.relatedCourseDtos,
    this.numberOfLessons,
    this.currentUserInterested,
    this.lessonIdTolearn,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      price: json['price'] as double?,
      status: CourseStatusFromJson(json['status']),
      title: json['title'] as String?,
      description: json['description'] as String?,
      avatarPath: json['avatarPath'] as String?,
      chapterDtos: (json['chapterDtos'] as List<dynamic>?)
          ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      blogDtos: (json['blogDtos'] as List<dynamic>?)
          ?.map((e) => Blog.fromJson(e as Map<String, dynamic>))
          .toList(),
      teacherDto: json['teacherDto'] != null
          ? User.fromJson(json['teacherDto'] as Map<String, dynamic>)
          : null,
      courseFeedbackDtos: (json['courseFeedbackDtos'] as List<dynamic>?)
          ?.map((e) => CourseFeedback.fromJson(e as Map<String, dynamic>))
          .toList(),
      categoryDtos: (json['categoryDtos'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      participatedUserDtos: (json['participatedUserDtos'] as List<dynamic>?)
          ?.map((e) => UserCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
      userInterestDtos: (json['userInterestDtos'] as List<dynamic>?)
          ?.map((e) => UserInterests.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfEnrolledStudents: json['numberOfEnrolledStudents'] as int?,
      currentUserCourse: json['currentUserCourse'] != null
          ? UserCourse.fromJson(
              json['currentUserCourse'] as Map<String, dynamic>)
          : null,
      relatedCourseDtos: (json['relatedCourseDtos'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfLessons: json['numberOfLessons'] as int?,
      currentUserInterested: json['currentUserInterested'] as bool?,
      lessonIdTolearn: json['lessonIdTolearn'] as int?,
    );
  }

  Course copyWith({
    int? id,
    String? title,
    String? description,
    String? avatarPath,
    double? price,
    CourseStatus? status,
    List<Chapter>? chapterDtos,
    List<Blog>? blogDtos,
    User? teacherDto,
    List<CourseFeedback>? courseFeedbackDtos,
    List<Category>? categoryDtos,
    List<UserCourse>? participatedUserDtos,
    List<UserInterests>? userInterestDtos,
    int? numberOfEnrolledStudents,
    UserCourse? currentUserCourse,
    List<Course>? relatedCourseDtos,
    int? numberOfLessons,
    int? lessonIdTolearn,
    bool? currentUserInterested,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarPath: avatarPath ?? this.avatarPath,
      price: price ?? this.price,
      status: status ?? this.status,
      chapterDtos: chapterDtos ?? this.chapterDtos,
      blogDtos: blogDtos ?? this.blogDtos,
      teacherDto: teacherDto ?? this.teacherDto,
      courseFeedbackDtos: courseFeedbackDtos ?? this.courseFeedbackDtos,
      categoryDtos: categoryDtos ?? this.categoryDtos,
      participatedUserDtos: participatedUserDtos ?? this.participatedUserDtos,
      userInterestDtos: userInterestDtos ?? this.userInterestDtos,
      numberOfEnrolledStudents:
          numberOfEnrolledStudents ?? this.numberOfEnrolledStudents,
      currentUserCourse: currentUserCourse ?? this.currentUserCourse,
      relatedCourseDtos: relatedCourseDtos ?? this.relatedCourseDtos,
      numberOfLessons: numberOfLessons ?? this.numberOfLessons,
      lessonIdTolearn: lessonIdTolearn ?? this.lessonIdTolearn,
      currentUserInterested:
          currentUserInterested ?? this.currentUserInterested,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'price': price,
  //     'status': status?.name,
  //     'title': title,
  //     'description': description,
  //     'chapterDtos': chapterDtos?.map((e) => e.toJson()).toList(),
  //     'blogDtos': blogDtos?.map((e) => e.toJson()).toList(),
  //     'teacherDto': teacherDto?.toJson(),
  //     'courseFeedbackDtos': courseFeedbackDtos?.map((e) => e.toJson()).toList(),
  //     'categoryDtos': categoryDtos?.map((e) => e.toJson()).toList(),
  //     'participatedUserDtos':
  //         participatedUserDtos?.map((e) => e.toJson()).toList(),
  //     'userInterestDtos': userInterestDtos?.map((e) => e.toJson()).toList(),
  //     'numberOfEnrolledStudents': numberOfEnrolledStudents,
  //     'currentUserCourse': currentUserCourse?.toJson(),
  //     'relatedCourseDtos': relatedCourseDtos?.map((e) => e.toJson()).toList(),
  //   };
  // }
}

enum CourseStatus {
  DRAFT,
  UNDER_REVIEW,
  APPROVED,
  DELETED,
  DEACTIVATED,
  REACTIVATED
}

CourseStatus CourseStatusFromJson(String status) {
  switch (status) {
    case 'DRAFT':
      return CourseStatus.DRAFT;
    case 'UNDER_REVIEW':
      return CourseStatus.UNDER_REVIEW;
    case 'APPROVED':
      return CourseStatus.APPROVED;
    case 'DELETED':
      return CourseStatus.DELETED;
    case 'DEACTIVATED':
      return CourseStatus.DEACTIVATED;
    case 'REACTIVATED':
      return CourseStatus.REACTIVATED;
    default:
      throw ArgumentError('Unknown status: $status');
  }
}
