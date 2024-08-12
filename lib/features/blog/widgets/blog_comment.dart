import 'package:flutter/material.dart';
import 'package:educhain/core/models/blog_comment.dart';

class CommentSection extends StatelessWidget {
  final List<BlogComment> comments;

  const CommentSection({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentComments = <BlogComment>[];
    final repliesMap = <int, List<BlogComment>>{};

    // Separate comments into parent comments and replies
    for (var comment in comments) {
      if (comment.parentCommentId == null) {
        parentComments.add(comment);
      } else {
        if (!repliesMap.containsKey(comment.parentCommentId)) {
          repliesMap[comment.parentCommentId!] = [];
        }
        repliesMap[comment.parentCommentId!]!.add(comment);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.0),
        // Use a Container with a fixed height to constrain the ListView
        Container(
          height: 400.0, // Adjust the height as needed
          child: ListView(
            children: parentComments.map((comment) {
              return _buildComment(comment, repliesMap, context, 0);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildComment(
      BlogComment comment,
      Map<int, List<BlogComment>> repliesMap,
      BuildContext context,
      int indentLevel) {
    return Padding(
      padding: EdgeInsets.only(left: indentLevel * 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment user info
          Text(
            comment.user?.firstName ?? 'Unknown User',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.0),

          // Comment text
          Text(
            comment.text ?? 'No Content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4.0),

          // Display replies if they exist
          if (repliesMap.containsKey(comment.id)) ...[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Column(
                children: repliesMap[comment.id]!
                    .map((reply) => _buildComment(
                        reply, repliesMap, context, indentLevel + 1))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
