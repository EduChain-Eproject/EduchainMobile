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
            // Optionally, refetch interests to update the list
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
                        return ListTile(
                          title: Text(course.title ?? 'No Title'),
                          subtitle:
                              Text(course.description ?? 'No Description'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteInterest(course.id!);
                            },
                          ),
                          onTap: () {
                            // Handle interest item tap
                          },
                        );
                      },
                    ),
                  ),
                  _buildPaginationControls(state.interests.totalPages),
                ],
              );
            } else if (state is UserInterestsError) {
              return Center(
                child: Text('Error loading interests: ${state.errors}'),
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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchTitle = value;
              },
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _fetchInterests,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                    _fetchInterests();
                  });
                }
              : null,
          child: Text('Previous Page'),
        ),
        Text('Page ${_currentPage + 1} / $totalPages'),
        TextButton(
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                    _fetchInterests();
                  });
                }
              : null,
          child: Text('Next Page'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
