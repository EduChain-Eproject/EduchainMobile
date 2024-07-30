import 'package:educhain/core/models/category.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final Function(String, int?) onCategorySelected;

  const CategoryDropdown({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      hint: const Text('Select Category'),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('All Categories'),
        ),
        ...categories.map((category) => DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.categoryName ?? ""),
            )),
      ],
      onChanged: (selectedCategory) {
        onCategorySelected('', selectedCategory);
      },
    );
  }
}
