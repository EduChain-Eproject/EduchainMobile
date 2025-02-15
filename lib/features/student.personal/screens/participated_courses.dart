import 'package:educhain/core/models/user_course.dart';
import 'package:educhain/features/student.learning/course/screens/course_detail_screen.dart';
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
        title: const Text('My Courses'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        builder: (context, state) {
          if (state is ParticipatedCoursesLoading) {
            return const Center(
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
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          CourseDetailScreen.route(course.courseDto?.id ?? 0),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: Image.network(
                                      '${course.courseDto?.avatarPath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseDto?.title ?? 'No Title',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        course.courseDto?.description ??
                                            'No Description',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      LinearProgressIndicator(
                                        value: (course.progress ?? 0) / 100,
                                        backgroundColor: Colors.grey[300],
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            course.completionStatus
                                                .toString()
                                                .substring(17),
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
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            );
          } else {
            return const Center(
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
                suffixIcon: const Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
              onChanged: (value) {
                _searchTitle = value;
              },
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 20),
          DropdownButton<CompletionStatus>(
            value: _selectedStatus,
            hint: const Text('Status'),
            items: CompletionStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status.toString().split('.').last,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: _fetchCourses,
            tooltip: 'Tìm kiếm',
            style: IconButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.all(8.0),
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
