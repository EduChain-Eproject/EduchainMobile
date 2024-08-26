import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';

import 'multiselect_dialog.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
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
          SizedBox(height: 12.0),

          // Sort By Dropdown
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
                  style: TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sortOption = value ?? _sortOption;
              });
              _applyFilters();
            },
            style: TextStyle(color: Colors.black87),
          ),
          SizedBox(height: 12.0),

          // Categories Button
          if (widget.categories != null && widget.categories!.isNotEmpty)
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<List<int>>(
                  context: context,
                  builder: (context) => MultiSelectDialog(
                    categories: widget.categories!,
                    selectedCategoryIds: _selectedCategoryIds,
                    onSelectionChanged: (selectedIds) {
                      setState(() {
                        _selectedCategoryIds = selectedIds;
                      });
                      _applyFilters();
                    },
                  ),
                );

                if (result != null) {
                  setState(() {
                    _selectedCategoryIds = result;
                  });
                  _applyFilters();
                }
              },
              child: Text('Select Categories'),
            ),
        ],
      ),
    );
  }

  void _applyFilters() {
    widget.onFilterChanged(_keyword, _selectedCategoryIds, _sortOption);
  }
}
