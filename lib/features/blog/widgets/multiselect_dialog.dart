import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<BlogCategory> categories;
  final List<int> selectedCategoryIds;
  final void Function(List<int>) onSelectionChanged;

  MultiSelectDialog({
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
      title: Text(
        'Select Categories',
        style: TextStyle(color: AppPallete.lightErrorColor),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.categories.map((category) {
            return CheckboxListTile(
              title: Text(category.categoryName ?? 'No Name'),
              value: _selectedIds.contains(category.id),
              onChanged: (selected) {
                setState(() {
                  if (selected ?? false) {
                    _selectedIds.add(category.id!);
                  } else {
                    _selectedIds.remove(category.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.onSelectionChanged(_selectedIds);
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
