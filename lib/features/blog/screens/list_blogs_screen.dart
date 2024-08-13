import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';
import 'package:educhain/features/blog/widgets/blog_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blog_bloc.dart';
import '../widgets/blog_list.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late BlogBloc _blogBloc;
  String _searchKeyword = '';
  List<int> _selectedCategories = [];
  String _sortOption = 'Relevance';
  List<String> _sortOptions = [
    'Relevance',
    'mostLike',
    'mostComment',
    'descTime',
    'ascTime'
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
      await response.on(
        onSuccess: (categories) {
          setState(() {
            _categories = categories;
          });
        },
        onError: (error) {
          print('Error fetching categories: $error');
        },
      );
    } catch (e) {
      print('Exception fetching categories: $e');
    }
  }

  void _searchBlogs() {
    final filterRequest = BlogFilterRequest(
      sortStrategy: _sortOption,
      keyword: _searchKeyword,
      categoryIdArray: _selectedCategories,
    );

    _blogBloc.add(FilterBlogs(filterRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: Column(
        children: [
          BlogSearchFilterBar(
            onFilterChanged: (keyword, selectedCategories, sortOption) {
              setState(() {
                _searchKeyword = keyword;
                _selectedCategories = selectedCategories;
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
                  return Center(child: Text('Error: ${state.errors}'));
                } else if (state is BlogsLoaded) {
                  return BlogList(blogs: state.blogs);
                } else {
                  return const Center(child: Text('No blogs available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
