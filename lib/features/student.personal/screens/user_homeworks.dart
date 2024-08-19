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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _personalBloc = BlocProvider.of<PersonalBloc>(context);
    _fetchHomeworks();
  }

  void _fetchHomeworks() {
    final request = UserHomeworksRequest(
      isSubmitted: _isSubmitted,
      page: _currentPage,
    );
    _personalBloc.add(FetchUserHomeworks(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bài tập của người dùng'),
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        builder: (context, state) {
          if (state is UserHomeworksLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserHomeworksLoaded) {
            return Column(
              children: [
                _buildFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.homeworks.content.length,
                    itemBuilder: (context, index) {
                      UserHomework homework = state.homeworks.content[index];
                      return ListTile(
                        title: Text(homework.homeworkDto!.title ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Submission Status: ${homework.isSubmitted! ? 'Submitted' : 'Not Submitted'}',
                            ),
                            Text(
                              'Due Date: ${homework.submissionDate != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(homework.submissionDate!) : 'N/A'}',
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle homework tap
                        },
                      );
                    },
                  ),
                ),
                _buildPaginationControls(state.homeworks.totalPages),
              ],
            );
          } else if (state is UserHomeworksError) {
            return Center(
              child: Text('Đã xảy ra lỗi khi tải bài tập: ${state.errors}'),
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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DropdownButton<bool>(
            value: _isSubmitted,
            items: [
              DropdownMenuItem(
                value: true,
                child: Text(
                  'Submitted',
                  style:
                      TextStyle(color: Colors.black), // Set text color to black
                ),
              ),
              DropdownMenuItem(
                value: false,
                child: Text(
                  'Not Submitted',
                  style:
                      TextStyle(color: Colors.black), // Set text color to black
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _isSubmitted = value!;
                _fetchHomeworks(); // Refetch data based on the new filter
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _fetchHomeworks,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
