import 'package:educhain/core/models/award.dart';
import 'package:flutter/material.dart';

class AwardTile extends StatelessWidget {
  final Award award;

  const AwardTile({Key? key, required this.award}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Award Status: ${award.status}'),
      subtitle: Text('Comments: ${award.comments ?? 'No comments'}'),
    );
  }
}
