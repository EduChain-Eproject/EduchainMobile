import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/features/student.personal/bloc/personal_bloc.dart';
import 'package:educhain/features/student.personal/models/user_homeworks_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserHomeworkPage extends StatefulWidget {
  const UserHomeworkPage({Key? key}) : super(key: key);

  @override
  _UserHomeworkPageState createState() => _UserHomeworkPageState();
}

class _UserHomeworkPageState extends State<UserHomeworkPage> {
  late PersonalBloc _personalBloc;
  bool _isSubmitted = true; // Default filter for submission status
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _personalBloc = BlocProvider.of<PersonalBloc>(context);
    _fetchHomeworks();
  }

  void _fetchHomeworks() {
    final request = UserHomeworksRequest(
      isSubmitted: _isSubmitted,
      page: _currentPage - 1,
    );
    _personalBloc.add(FetchUserHomeworks(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My homeworks'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        builder: (context, state) {
          if (state is UserHomeworksLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserHomeworksLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.homeworks.content.length,
                    itemBuilder: (context, index) {
                      UserHomework homework = state.homeworks.content[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(homework.homeworkDto?.title ?? 'No Title',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Submission Status: ${homework.isSubmitted! ? 'Submitted' : 'Not Submitted'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Due Date: ${homework.submissionDate != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(homework.submissionDate!) : 'N/A'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle homework tap
                          },
                        ),
                      );
                    },
                  ),
                ),
                _buildPaginationControls(state.homeworks.totalPages),
              ],
            );
          } else if (state is UserHomeworksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Đã xảy ra lỗi khi tải bài tập: ${state.errors}',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            );
          } else {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          }
        },
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<bool>(
              value: _isSubmitted,
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text(
                    'Submitted',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text(
                    'Not Submitted',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _isSubmitted = value!;
                  _fetchHomeworks(); // Refetch data based on the new filter
                });
              },
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                      _fetchHomeworks();
                    });
                  }
                : null,
            child: Text('Trang trước'),
          ),
          Text('Trang $_currentPage / $totalPages'),
          TextButton(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                      _fetchHomeworks();
                    });
                  }
                : null,
            child: Text('Trang sau'),
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
