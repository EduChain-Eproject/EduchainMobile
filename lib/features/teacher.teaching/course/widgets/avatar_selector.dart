import 'dart:io';

import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSelector extends StatelessWidget {
  final XFile? selectedAvatar;
  final Function() onSelectAvatar;
  final String? courseAvatarPath;
  final String? errors;

  const AvatarSelector({
    Key? key,
    required this.selectedAvatar,
    required this.onSelectAvatar,
    this.courseAvatarPath,
    this.errors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onSelectAvatar,
          child: const Text('Select Avatar'),
        ),
        if (selectedAvatar != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.file(
              File(selectedAvatar!.path),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        if (selectedAvatar == null && courseAvatarPath != null)
          CircleAvatar(
            backgroundImage: NetworkImage(courseAvatarPath!),
          ),
        if (errors != null)
          Text(
            errors!,
            style: const TextStyle(color: AppPallete.lightErrorColor),
          ),
      ],
    );
  }
}
