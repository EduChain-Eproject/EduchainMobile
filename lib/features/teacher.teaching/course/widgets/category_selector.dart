import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category/teacher_category_bloc.dart';

class CategorySelector extends StatefulWidget {
  final List<int> selectedCategoryIds;
  final void Function(List<int>) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.selectedCategoryIds,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  void initState() {
    super.initState();
    // Dispatch an event when the widget is initialized
    context.read<TeacherCategoryBloc>().add(FetchTeacherCategory());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCategoryBloc, TeacherCategoryState>(
      builder: (context, state) {
        if (state is TeacherCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherCategoryLoaded) {
          final teacherCategories = state.categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Teacher Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...teacherCategories.map((category) {
                final isSelected =
                    widget.selectedCategoryIds.contains(category.id);

                return CheckboxListTile(
                  title: Text(category.categoryName ?? ""),
                  value: isSelected,
                  onChanged: (isChecked) {
                    final updatedCategoryIds =
                        List<int>.from(widget.selectedCategoryIds);

                    if (isChecked == true) {
                      if (!updatedCategoryIds.contains(category.id)) {
                        updatedCategoryIds.add(category.id ?? 0);
                      }
                    } else {
                      updatedCategoryIds.remove(category.id);
                    }

                    widget.onCategorySelected(updatedCategoryIds);
                  },
                );
              }).toList(),
            ],
          );
        } else {
          return const Center(
              child: Text('Failed to load Teacher Categories.'));
        }
      },
    );
  }
}
