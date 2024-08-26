import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/core/theme/app_pallete.dart';

import '../blocs/category/category_bloc.dart';

class FilterBar extends StatefulWidget {
  final List<int> initialSelectedCategoryIds;
  final Function(String, List<int>) onApplyFilter;

  const FilterBar({
    Key? key,
    required this.initialSelectedCategoryIds,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late List<int> _selectedCategoryIds;
  String _selectedSortOption = 'title';

  void _onSortOptionSelected(String sortBy) {
    setState(() {
      _selectedSortOption = sortBy;
    });
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
      }
    });
  }

  @override
  void initState() {
    _selectedCategoryIds = List.from(widget.initialSelectedCategoryIds);
    context.read<CategoriesBloc>().add(FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppPallete.lightBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Filter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesLoaded) {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: state.categories.map((category) {
                    final isSelected =
                        _selectedCategoryIds.contains(category.id);
                    return ChoiceChip(
                      label: Text(category.categoryName!),
                      selected: isSelected,
                      onSelected: (_) => _onCategorySelected(category.id ?? 0),
                    );
                  }).toList(),
                );
              } else {
                return const Text('Failed to load categories');
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Sort',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ChoiceChip(
                label: const Text('Price'),
                selected: _selectedSortOption == 'price',
                onSelected: (_) => _onSortOptionSelected('price'),
              ),
              ChoiceChip(
                label: const Text('Title'),
                selected: _selectedSortOption == 'title',
                onSelected: (_) => _onSortOptionSelected('title'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryIds.clear();
                    _selectedSortOption = 'title';
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppPallete.lightBackgroundColor,
                  backgroundColor: AppPallete.lightErrorColor,
                ),
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onApplyFilter(
                      _selectedSortOption, _selectedCategoryIds);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppPallete.lightBackgroundColor,
                  backgroundColor: AppPallete.lightAccentColor,
                ),
                child: const Text('Apply Filter'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
