import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/user_course.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/core/models/user_interests.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/student.personal/models/participated_courses_request.dart';
import 'package:educhain/features/student.personal/models/user_homeworks_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_interests_request.dart';
import '../student_personal_service.dart';

part 'personal_event.dart';
part 'personal_state.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  final StudentPersonalService personalService;

  PersonalBloc(this.personalService) : super(PersonalInitial()) {
    on<FetchParticipatedCourses>((event, emit) async {
      final response =
          await personalService.getParticipatedCourses(event.request);
      await response.on(
        onSuccess: (newCourses) {
          emit(ParticipatedCoursesLoaded(newCourses));
        },
        onError: (error) => emit(ParticipatedCoursesError(error)),
      );
    });

    on<FetchUserHomeworks>((event, emit) async {
      final response = await personalService.getUserHomeworks(event.request);
      await response.on(
        onSuccess: (newHomeworks) {
          emit(UserHomeworksLoaded(newHomeworks));
        },
        onError: (error) => emit(UserHomeworksError(error)),
      );
    });

    // on<FetchUserAwards>((event, emit) async {
    //   final response = await personalService.getUserAwards(event.request);
    //   await response.on(
    //     onSuccess: (newHomeworks) {
    //       emit(UserAwardsLoaded(newHomeworks));
    //     },
    //     onError: (error) => emit(UserAwardsError(error)),
    //   );
    // });

    on<FetchUserInterests>((event, emit) async {
      final response = await personalService.getUserInterests(event.request);
      await response.on(
        onSuccess: (newInterests) {
          emit(UserInterestsLoaded(newInterests));
        },
        onError: (error) => emit(UserInterestsError(error)),
      );
    });

    on<AddUserInterest>((event, emit) async {
      final response = await personalService.addUserInterest(event.request);
      await response.on(
        onSuccess: (interest) {
          emit(UserInterestSaved(interest, status: 'added'));
        },
        onError: (error) => emit(UserInterestSaveError(error)),
      );
    });

    on<RemoveUserInterest>((event, emit) async {
      final response = await personalService.removeUserInterest(event.request);
      await response.on(
        onSuccess: (_) {
          emit(UserInterestSaved(
              UserInterests(courseDto: Course(id: event.request.courseId)),
              status: 'removed'));
        },
        onError: (error) => emit(UserInterestSaveError(error)),
      );
    });
  }
}
