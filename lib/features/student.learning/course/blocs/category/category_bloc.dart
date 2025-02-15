// categories_bloc.dart
import 'package:educhain/core/models/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../course_service.dart';

part 'category_state.dart';
part 'category_event.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CourseService courseService;

  CategoriesBloc(this.courseService) : super(CategoriesInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoriesLoading());
      try {
        final response = await courseService.fetchCategories();
        await response.on(
          onSuccess: (categories) => emit(CategoriesLoaded(categories)),
          onError: (error) => emit(CategoriesError(error['message'])),
        );
      } catch (e) {
        emit(CategoriesError(e.toString()));
      }
    });
  }
}
