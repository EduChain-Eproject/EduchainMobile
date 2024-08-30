import 'package:flutter/material.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/features/blog/bloc/blog_bloc.dart';
import 'package:educhain/features/blog/models/blogComment/create_comment_request.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  final List<BlogComment> comments;
  final int blogId;

  const CommentSection({Key? key, required this.comments, required this.blogId})
      : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  int? _parentCommentId;
  late List<BlogComment> _parentComments;
  late Map<int?, List<BlogComment>> _repliesMap;

  @override
  void initState() {
    super.initState();
    _initializeComments();
  }

  void _initializeComments() {
    _parentComments =
        widget.comments.where((c) => c.parentCommentId == null).toList();
    _repliesMap = {
      for (var c in widget.comments) c.parentCommentId: <BlogComment>[]
    };
    for (var comment in widget.comments) {
      if (comment.parentCommentId != null) {
        _repliesMap[comment.parentCommentId]?.add(comment);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogCommentSaved) {
          final newBlogCmt = state.blogComment;
          setState(() {
            if (newBlogCmt.parentCommentId == null) {
              _parentComments.insert(0, newBlogCmt);
            } else {
              _repliesMap[newBlogCmt.parentCommentId]?.insert(0, newBlogCmt);
            }
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 400.0,
              child: ListView.builder(
                itemCount: _parentComments.length,
                itemBuilder: (context, index) {
                  return _buildComment(
                      _parentComments[index], _repliesMap, context, 0);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            _buildCommentInputSection(context),
          ],
        );
      },
    );
  }

  Widget _buildComment(
      BlogComment comment,
      Map<int?, List<BlogComment>> repliesMap,
      BuildContext context,
      int indentLevel) {
    return Padding(
      padding: EdgeInsets.only(left: indentLevel * 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                child: Text(
                  comment.user?.firstName?.substring(0, 1) ?? 'U',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user?.firstName ?? 'Unknown User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    Text(
                      DateFormat('MM/dd/yyyy hh:mm a')
                          .format(comment.createdAt ?? DateTime.now()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      comment.text ?? 'No Content',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    if (repliesMap.containsKey(comment.id))
                      Column(
                        children: repliesMap[comment.id]!
                            .map((reply) => _buildComment(
                                reply, repliesMap, context, indentLevel + 1))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          maxLines: null,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitComment(context),
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => _submitComment(context),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Post Comment'),
          ),
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
