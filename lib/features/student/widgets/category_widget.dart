import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/layouts/student_layout.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoryWidget({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Increased height for better spacing
      padding:
          const EdgeInsets.symmetric(vertical: 16), // More vertical padding
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
              width: 200, // Increased width for better content fit
              margin:
                  const EdgeInsets.symmetric(horizontal: 8), // Balanced margin
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppPallete.accentColor,
                    AppPallete.darkAccentColor
                  ], // Gradient for visual appeal
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          category.categoryName ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightWhiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category.categoryDescription ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppPallete.lightWhiteColor,
                        fontWeight:
                            FontWeight.w300, // Lighter text for description
                      ),
                      maxLines: 2, // Limit the text to 2 lines for a neat look
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
