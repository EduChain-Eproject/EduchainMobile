import 'package:flutter/material.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/features/blog/bloc/blog_bloc.dart';
import 'package:educhain/features/blog/models/blogComment/create_comment_request.dart';

class CommentSection extends StatefulWidget {
  final List<BlogComment> comments;
  final int blogId; // Add this line to define the blogId parameter

  const CommentSection({Key? key, required this.comments, required this.blogId})
      : super(key: key); // Update the constructor

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  int? _parentCommentId;

  @override
  Widget build(BuildContext context) {
    final parentComments = <BlogComment>[];
    final repliesMap = <int, List<BlogComment>>{};

    // Separate comments into parent comments and replies
    for (var comment in widget.comments) {
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
        Container(
          height: 400.0,
          child: ListView(
            children: parentComments.map((comment) {
              return _buildComment(comment, repliesMap, context, 0);
            }).toList(),
          ),
        ),
        SizedBox(height: 16.0),
        _buildCommentInputSection(context),
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
          Text(
            comment.user?.firstName ?? 'Unknown User',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.0),
          Text(
            comment.text ?? 'No Content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4.0),
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
          SizedBox(height: 8.0),
          _buildReplyButton(comment.id!),
        ],
      ),
    );
  }

  Widget _buildReplyButton(int commentId) {
    return TextButton(
      onPressed: () {
        setState(() {
          _parentCommentId = commentId;
        });
      },
      child: Text('Reply'),
    );
  }

  Widget _buildCommentInputSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: 'Add a comment...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            _submitComment(context);
          },
          child: Text('Post Comment'),
        ),
      ],
    );
  }

  void _submitComment(BuildContext context) {
    if (_commentController.text.isNotEmpty) {
      final request = CreateBlogCommentRequest(
        text: _commentController.text,
        parentCommentId: _parentCommentId?.toString(),
        blogId: widget.blogId,
      );

      context.read<BlogBloc>().add(CreateBlogComment(request));

      _commentController.clear();
      setState(() {
        _parentCommentId = null;
      });
    }
  }
}
