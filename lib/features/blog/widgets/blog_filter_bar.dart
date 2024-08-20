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
    'MOST_LIKE': 'Most Liked',
    'MOST_COMMENT': 'Most Commented',
    'DATE_ASC': 'Oldest',
    'DATE_DESC': 'Newest',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              labelText: 'Search Blogs',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _keyword = value;
              });
              _applyFilters();
            },
          ),
          SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: _sortOption,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              labelText: 'Sort By',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
            ),
            items: widget.sortOptions.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  _sortOptionLabels[option] ?? option,
                  style: TextStyle(
                    color: Colors.black87, // Slightly darker text color
                  ),
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
              color: Colors.black87, // Consistent text color
            ),
          ),
          SizedBox(height: 8.0),
          if (widget.categories != null) // Check if categories is not null
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.categories!.map((category) {
                return ChoiceChip(
                  label: Text(category.categoryName!),
                  selected: _selectedCategoryIds.contains(category.id),
                  selectedColor: Colors.blueAccent.withOpacity(0.2),
                  backgroundColor: Colors.grey[200],
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
                  labelStyle: TextStyle(
                    color: _selectedCategoryIds.contains(category.id)
                        ? Colors.blueAccent
                        : Colors.black87,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
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
