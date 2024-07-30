import 'package:bloc/bloc.dart';
import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/user.dart';
import 'package:educhain/features/student/models/statistics.dart';
import 'package:educhain/features/student/student_home_service.dart';

part 'student_home_event.dart';
part 'student_home_state.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvent, StudentHomeState> {
  StudentHomeService studentHomeService;

  StudentHomeBloc(this.studentHomeService) : super(StudentHomeInitial()) {
    on<FetchStudentHomeData>(_onFetchStudentHomeData);
  }

  Future<void> _onFetchStudentHomeData(
    FetchStudentHomeData event,
    Emitter<StudentHomeState> emit,
  ) async {
    emit(StudentHomeLoading());

    try {
      final categoriesResponse =
          await studentHomeService.getPopularCategories();
      final coursesResponse = await studentHomeService.getBestCourses();
      final statisticsResponse = await studentHomeService.getStatistics();
      final bestTeacherResponse = await studentHomeService.getBestTeacher();

      if (categoriesResponse.isSuccess &&
          coursesResponse.isSuccess &&
          statisticsResponse.isSuccess &&
          bestTeacherResponse.isSuccess) {
        emit(StudentHomeLoaded(
          categories: categoriesResponse.data!,
          courses: coursesResponse.data!,
          statistics: statisticsResponse.data!,
          bestTeacher: bestTeacherResponse.data!,
        ));
      } else {
        // Handle API-specific errors if available
        emit(StudentHomeError('Failed to fetch data'));
      }
    } catch (e) {
      // Handle unexpected errors
      emit(StudentHomeError('An unexpected error occurred: $e'));
    }
  }
}
