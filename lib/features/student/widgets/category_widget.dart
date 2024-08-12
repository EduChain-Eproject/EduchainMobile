import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/layouts/student_layout.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;

  CategoryWidget({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Increased height for better spacing
      padding: const EdgeInsets.symmetric(vertical: 8), // Add padding
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                StudentLayout.route(
                  initialPage: 1,
                  selectedCategory: category.id,
                ),
              );
            },
            child: Container(
              width: 180, // Increased width for better content fit
              margin: const EdgeInsets.only(right: 16), // Adjusted margin
              decoration: BoxDecoration(
                color: AppPallete.accentColor,
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          category.categoryName ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightWhiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.categoryDescription ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppPallete.lightWhiteColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
