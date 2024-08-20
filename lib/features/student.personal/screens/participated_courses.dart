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
  int _currentPage = 1;
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
      page: _currentPage - 1,
      titleSearch: _searchTitle,
      completionStatus: _selectedStatus,
    );
    _personalBloc.add(FetchParticipatedCourses(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.courseDto?.title ?? 'No Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      course.courseDto?.description ??
                                          'No Description',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    LinearProgressIndicator(
                                      value: (course.progress ?? 0) / 100,
                                      backgroundColor: Colors.grey[300],
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Enrollment Date: ${course.createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
          } else if (state is ParticipatedCoursesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Đã xảy ra lỗi khi tải khóa học: ${state.errors}',
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

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
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
          SizedBox(width: 20),
          DropdownButton<CompletionStatus>(
            value: _selectedStatus,
            hint: Text('Status'),
            items: CompletionStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status.toString().split('.').last,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
            style: TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: _fetchCourses,
            tooltip: 'Tìm kiếm',
            style: IconButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
