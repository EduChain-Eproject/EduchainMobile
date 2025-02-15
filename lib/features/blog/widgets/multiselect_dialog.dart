import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<BlogCategory> categories;
  final List<int> selectedCategoryIds;
  final void Function(List<int>) onSelectionChanged;

  const MultiSelectDialog({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedCategoryIds);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Categories'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCategoryList(),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  Widget _buildCategoryList() {
    return ListBody(
      children: widget.categories.map((category) {
        return CheckboxListTile(
          title: Text(category.categoryName ?? 'No Name'),
          value: _selectedIds.contains(category.id),
          onChanged: (selected) {
            _onCategorySelectionChanged(category.id!, selected ?? false);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          _clearSelections();
        },
        child: const Text('Clear All'),
      ),
      TextButton(
        onPressed: () {
          widget.onSelectionChanged(_selectedIds);
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
    ];
  }

  void _onCategorySelectionChanged(int categoryId, bool isSelected) {
    setState(() {
      isSelected
          ? _selectedIds.add(categoryId)
          : _selectedIds.remove(categoryId);
    });
  }

  void _clearSelections() {
    setState(() {
      _selectedIds.clear();
    });
  }
}
