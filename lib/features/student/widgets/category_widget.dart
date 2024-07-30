import 'package:educhain/core/models/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;

  CategoryWidget({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories
          .map((category) => Text(category.categoryDescription ?? ""))
          .toList(),
    );
  }
}
