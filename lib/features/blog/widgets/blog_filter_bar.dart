import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';

class BlogSearchFilterBar extends StatefulWidget {
  final Function(String, List<int>, String) onFilterChanged;
  final List<String> sortOptions;
  final List<BlogCategory>? categories; // Make categories nullable
  final String initialSortOption;

  const BlogSearchFilterBar({
    Key? key,
    required this.onFilterChanged,
    required this.sortOptions,
    this.categories,
    this.initialSortOption = 'Relevance',
  }) : super(key: key);

  @override
  _BlogSearchFilterBarState createState() => _BlogSearchFilterBarState();
}

class _BlogSearchFilterBarState extends State<BlogSearchFilterBar> {
  late String _keyword;
  late List<int> _selectedCategoryIds;
  late String _sortOption;

  @override
  void initState() {
    super.initState();
    _keyword = '';
    _selectedCategoryIds = [];
    _sortOption = widget.initialSortOption;
  }

  Map<String, String> _sortOptionLabels = {
    'Relevance': 'Relevance',
    'MOST_LIKE': 'Most Like',
    'MOST_COMMENT': 'Most Commented',
    'DATE_ASC': 'Oldest',
    'DATE_DESC': 'Newest',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search Blogs',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _keyword = value;
              });
              _applyFilters();
            },
          ),
          DropdownButtonFormField<String>(
            value: _sortOption,
            decoration: const InputDecoration(
              labelText: 'Sort By',
              border: OutlineInputBorder(),
            ),
            items: widget.sortOptions.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  _sortOptionLabels[option] ?? option,
                  style: TextStyle(
                      color: Colors.black), // Set the desired text color here
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sortOption = value ?? _sortOption;
              });
              _applyFilters();
            },
            style: TextStyle(
                color: Colors.blue), // Set the desired text color here
          ),
          if (widget.categories != null) // Check if categories is not null
            Wrap(
              spacing: 8.0,
              children: widget.categories!.map((category) {
                return ChoiceChip(
                  label: Text(category.categoryName!),
                  selected: _selectedCategoryIds.contains(category.id),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategoryIds.add(category.id!);
                      } else {
                        _selectedCategoryIds.remove(category.id);
                      }
                    });
                    _applyFilters();
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _applyFilters() {
    widget.onFilterChanged(_keyword, _selectedCategoryIds, _sortOption);
  }
}
