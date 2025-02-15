import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';

import 'multiselect_dialog.dart';

class BlogSearchFilterBar extends StatefulWidget {
  final Function(String, List<int>, String) onFilterChanged;
  final List<String> sortOptions;
  final List<BlogCategory>? categories;
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
  String _keyword = '';
  List<int> _selectedCategoryIds = [];
  late String _sortOption;

  final Map<String, String> _sortOptionLabels = {
    'Relevance': 'Relevance',
    'MOST_LIKE': 'Most Liked',
    'MOST_COMMENT': 'Most Commented',
    'DATE_ASC': 'Oldest',
    'DATE_DESC': 'Newest',
  };

  @override
  void initState() {
    super.initState();
    _sortOption = widget.initialSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(),
          const SizedBox(height: 12.0),
          _buildSortDropdown(),
          const SizedBox(height: 12.0),
          if (widget.categories != null && widget.categories!.isNotEmpty)
            _buildCategoryButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        labelText: 'Search Blogs',
        hintText: 'Enter keywords',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      onChanged: (value) {
        _keyword = value;
        _applyFilters();
      },
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
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
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      items: widget.sortOptions.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(_sortOptionLabels[option] ?? option),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortOption = value;
          });
          _applyFilters();
        }
      },
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildCategoryButton() {
    return ElevatedButton(
      onPressed: _openCategoryDialog,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Select Categories'),
    );
  }

  Future<void> _openCategoryDialog() async {
    final result = await showDialog<List<int>>(
      context: context,
      builder: (context) => MultiSelectDialog(
        categories: widget.categories!,
        selectedCategoryIds: _selectedCategoryIds,
        onSelectionChanged: (selectedIds) {
          setState(() {
            _selectedCategoryIds = selectedIds;
          });
        },
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCategoryIds = result;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    widget.onFilterChanged(_keyword, _selectedCategoryIds, _sortOption);
  }
}
