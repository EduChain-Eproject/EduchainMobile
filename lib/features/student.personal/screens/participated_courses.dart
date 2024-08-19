import 'package:educhain/core/models/user_course.dart';
import 'package:educhain/features/student.personal/bloc/personal_bloc.dart';
import 'package:educhain/features/student.personal/models/participated_courses_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchParticipatedCoursesPage extends StatefulWidget {
  const FetchParticipatedCoursesPage({Key? key}) : super(key: key);

  @override
  _FetchParticipatedCoursesPageState createState() =>
      _FetchParticipatedCoursesPageState();
}

class _FetchParticipatedCoursesPageState
    extends State<FetchParticipatedCoursesPage> {
  late PersonalBloc _personalBloc;
  int _currentPage = 0;
  String? _searchTitle;
  CompletionStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _personalBloc = BlocProvider.of<PersonalBloc>(context);
    _fetchCourses();
  }

  void _fetchCourses() {
    final request = ParticipatedCoursesRequest(
      page: _currentPage,
      titleSearch: _searchTitle,
      completionStatus: _selectedStatus,
    );
    _personalBloc.add(FetchParticipatedCourses(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách khóa học đã tham gia'),
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        builder: (context, state) {
          if (state is ParticipatedCoursesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ParticipatedCoursesLoaded) {
            return Column(
              children: [
                _buildSearchAndFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.courses.content.length,
                    itemBuilder: (context, index) {
                      UserCourse course = state.courses.content[index];
                      return ListTile(
                        title: Text(course.courseDto?.title ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.courseDto?.description ??
                                'No Description'),
                            Text('Progress: ${course.progress ?? 0}%'),
                            Text(
                                'Enrollment Date: ${course.createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                            Text(
                                'Status: ${course.completionStatus?.toString().split('.').last ?? 'N/A'}'),
                          ],
                        ),
                        onTap: () {
                          // Handle course tap
                        },
                      );
                    },
                  ),
                ),
                _buildPaginationControls(state.courses.totalPages),
              ],
            );
          } else if (state is ParticipatedCoursesError) {
            return Center(
              child: Text('Đã xảy ra lỗi khi tải khóa học: ${state.errors}'),
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

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo tiêu đề',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchTitle = value;
              },
            ),
          ),
          SizedBox(width: 8),
          DropdownButton<CompletionStatus>(
            value: _selectedStatus,
            hint: Text('Lọc theo trạng thái'),
            items: CompletionStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _fetchCourses,
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
                    _fetchCourses();
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
                    _fetchCourses();
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
