import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';
import 'package:educhain/features/blog/screens/create_blog_screen.dart';
import 'package:educhain/features/blog/widgets/blog_card.dart'; // Import BlogCard
import 'package:educhain/features/blog/widgets/blog_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blog_bloc.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late BlogBloc _blogBloc;
  String _searchKeyword = '';
  List<int>? _selectedCategories = [];
  String _sortOption = 'Relevance';
  List<String> _sortOptions = [
    'Relevance',
    'MOST_LIKE',
    'MOST_COMMENT',
    'DATE_ASC',
    'DATE_DESC'
  ];
  List<BlogCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _blogBloc = BlocProvider.of<BlogBloc>(context);
    _fetchCategories();
    _searchBlogs();
  }

  void _fetchCategories() async {
    try {
      final response = await _blogBloc.blogService.fetchBlogCategories();
      if (response.isSuccess) {
        setState(() {
          _categories = response.data!;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching categories: ${response.error}'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching categories: $error'),
        ),
      );
    }
  }

  void _searchBlogs() {
    final filterRequest = BlogFilterRequest(
      page: 0,
      sortStrategy: _sortOption,
      keyword: _searchKeyword,
      categoryIds: _selectedCategories ?? [],
    );

    _blogBloc.add(FilterBlogs(filterRequest));
  }

  void _createNewBlog() {
    // Navigate to the blog creation screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateBlogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        backgroundColor: Colors.blueAccent, // Match the UserInterestsPage color
        elevation: 4, // Add elevation for a subtle shadow
      ),
      body: Column(
        children: [
          BlogSearchFilterBar(
            onFilterChanged: (keyword, selectedCategories, sortOption) {
              setState(() {
                _searchKeyword = keyword;
                _selectedCategories =
                    selectedCategories.isEmpty ? null : selectedCategories;
                _sortOption = sortOption;
              });
              _searchBlogs();
            },
            sortOptions: _sortOptions,
            categories: _categories,
            initialSortOption: _sortOption,
          ),
          Expanded(
            child: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                if (state is BlogsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BlogsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error: ${state.errors}',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else if (state is BlogsLoaded) {
                  return ListView.builder(
                    itemCount: state.blogs.content.length,
                    itemBuilder: (context, index) {
                      return BlogCard(blog: state.blogs.content[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('No blogs available'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBlog,
        child: const Icon(Icons.add),
        tooltip: 'Create New Blog',
        backgroundColor: Colors.blueAccent, // Match the AppBar color
      ),
    );
  }
}
