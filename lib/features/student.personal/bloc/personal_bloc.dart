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
      final currentState =
          state is ParticipatedCoursesLoaded && event.isLoadingMore
              ? state as ParticipatedCoursesLoaded
              : null;

      if (currentState == null) {
        emit(ParticipatedCoursesLoading());
      }

      final response =
          await personalService.getParticipatedCourses(event.request);
      await response.on(
        onSuccess: (newCourses) {
          if (currentState != null) {
            final updatedCourses = Page<UserCourse>(
              number: newCourses.number,
              totalElements: newCourses.totalElements,
              totalPages: newCourses.totalPages,
              content: [...currentState.courses.content, ...newCourses.content],
            );
            emit(ParticipatedCoursesLoaded(updatedCourses));
          } else {
            emit(ParticipatedCoursesLoaded(newCourses));
          }
        },
        onError: (error) => emit(ParticipatedCoursesError(error['message'])),
      );
    });

    on<FetchUserHomeworks>((event, emit) async {
      final currentState = state is UserHomeworksLoaded && event.isLoadingMore
          ? state as UserHomeworksLoaded
          : null;

      if (currentState == null) {
        emit(UserHomeworksLoading());
      }

      final response = await personalService.getUserHomeworks(event.request);
      await response.on(
        onSuccess: (newHomeworks) {
          if (currentState != null) {
            final updatedHomeworks = Page<UserHomework>(
              number: newHomeworks.number,
              totalElements: newHomeworks.totalElements,
              totalPages: newHomeworks.totalPages,
              content: [
                ...currentState.homeworks.content,
                ...newHomeworks.content
              ],
            );
            emit(UserHomeworksLoaded(updatedHomeworks));
          } else {
            emit(UserHomeworksLoaded(newHomeworks));
          }
        },
        onError: (error) => emit(UserHomeworksError(error['message'])),
      );
    });

    on<FetchUserInterests>((event, emit) async {
      final currentState = state is UserInterestsLoaded && event.isLoadingMore
          ? state as UserInterestsLoaded
          : null;

      if (currentState == null) {
        emit(UserInterestsLoading());
      }

      final response = await personalService.getUserInterests(event.request);
      await response.on(
        onSuccess: (newInterests) {
          if (currentState != null) {
            final updatedInterests = Page<UserInterests>(
              number: newInterests.number,
              totalElements: newInterests.totalElements,
              totalPages: newInterests.totalPages,
              content: [
                ...currentState.interests.content,
                ...newInterests.content
              ],
            );
            emit(UserInterestsLoaded(updatedInterests));
          } else {
            emit(UserInterestsLoaded(newInterests));
          }
        },
        onError: (error) => emit(UserInterestsError(error['message'])),
      );
    });

    on<AddUserInterest>((event, emit) async {
      final response = await personalService.addUserInterest(event.request);
      await response.on(
        onSuccess: (interest) {
          if (state is UserInterestsLoaded) {
            final currentState = state as UserInterestsLoaded;
            final updatedInterests = [
              interest,
              ...currentState.interests.content
            ];

            emit(UserInterestsLoaded(Page(
                content: updatedInterests,
                totalElements: currentState.interests.totalElements + 1,
                totalPages: currentState.interests.totalPages,
                number: currentState.interests.number)));
          }
          emit(UserInterestAdded(event.request.userId, event.request.courseId));
        },
        onError: (error) => emit(UserInterestAddError(error)),
      );
    });

    on<RemoveUserInterest>((event, emit) async {
      final response = await personalService.removeUserInterest(event.request);
      await response.on(
        onSuccess: (_) {
          if (state is UserInterestsLoaded) {
            final currentState = state as UserInterestsLoaded;
            final updatedInterests = currentState.interests.content
                .where((interest) =>
                    interest.courseDto?.id != event.request.courseId)
                .toList();
            emit(UserInterestsLoaded(Page(
                content: updatedInterests,
                totalElements: currentState.interests.totalElements - 1,
                totalPages: currentState.interests.totalPages,
                number: currentState.interests.number)));
          }
          emit(UserInterestRemoved(
              event.request.userId, event.request.courseId));
        },
        onError: (error) => emit(UserInterestRemoveError(error)),
      );
    });
  }
}
