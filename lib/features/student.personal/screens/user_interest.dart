import 'package:educhain/features/student.personal/bloc/personal_bloc.dart';
import 'package:educhain/features/student.personal/models/user_interests_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInterestsPage extends StatefulWidget {
  const UserInterestsPage({Key? key}) : super(key: key);

  @override
  _UserInterestsPageState createState() => _UserInterestsPageState();
}

class _UserInterestsPageState extends State<UserInterestsPage> {
  late PersonalBloc _personalBloc;
  int _currentPage = 0;
  String? _searchTitle;

  @override
  void initState() {
    super.initState();
    _personalBloc = BlocProvider.of<PersonalBloc>(context);
    _fetchInterests();
  }

  void _fetchInterests() {
    final request = UserInterestsRequest(
      page: _currentPage,
      titleSearch: _searchTitle,
    );
    _personalBloc.add(FetchUserInterests(request));
  }

  void _deleteInterest(int courseId) {
    _personalBloc.add(RemoveUserInterest(AddOrDeleteInterestRequest(courseId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Interests'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: BlocListener<PersonalBloc, PersonalState>(
        listener: (context, state) {
          if (state is UserInterestSaved) {
            final status = state.status;
            final message = status == 'removed'
                ? 'Interest removed successfully'
                : 'Error removing interest';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            if (status == 'removed') {
              _fetchInterests();
            }
          } else if (state is UserInterestSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errors}')),
            );
          }
        },
        child: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, state) {
            if (state is UserInterestsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserInterestsLoaded) {
              return Column(
                children: [
                  _buildSearchAndFilter(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.interests.content.length,
                      itemBuilder: (context, index) {
                        final interest = state.interests.content[index];
                        final course = interest.courseDto;
                        if (course == null) {
                          return SizedBox.shrink(); // Skip if no course data
                        }
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Icon(
                                        Icons.book,
                                        size: 40,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.title ?? 'No Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        course.description ?? 'No Description',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteInterest(course.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is UserInterestsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading interests: ${state.errors}'),
                ),
              );
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
              onChanged: (value) {
                _searchTitle = value;
              },
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: _fetchInterests,
            tooltip: 'Search',
            style: IconButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
