import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/features/student.learning/homework/screens/homework_detail_screen.dart';
import 'package:educhain/features/student.personal/bloc/personal_bloc.dart';
import 'package:educhain/features/student.personal/models/user_homeworks_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const Text('My Homeworks'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            8.0), // Add some padding around the body for better visuals
        child: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, state) {
            if (state is UserHomeworksLoading) {
              return const Center(
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              HomeworkDetailScreen.route(
                                  homework.homeworkDto?.id ?? 0),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    homework.homeworkDto?.title ?? 'No Title',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: homework.isSubmitted!
                                              ? Colors.green
                                              : Colors.red),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Submission Status: ${homework.isSubmitted! ? 'Submitted' : 'Not Submitted'}',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  LinearProgressIndicator(
                                    value: (homework.progress ?? 0) / 100,
                                    backgroundColor: Colors.grey[300],
                                    color: AppPallete.successColor,
                                  ),
                                  const SizedBox(height: 8.0),
                                  if (homework.grade != null &&
                                      homework.grade != 0)
                                    Row(
                                      children: [
                                        const Icon(Icons.grade,
                                            color: Colors.amber),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Mark: ${homework.grade.toString()}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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
                  child: Text(
                    'Error loading homeworks: ${state.errors}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<bool>(
              value: _isSubmitted,
              items: [
                const DropdownMenuItem(
                  value: true,
                  child: Text(
                    'Submitted',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const DropdownMenuItem(
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
              decoration: InputDecoration(
                labelText: 'Filter by Submission Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
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
          ElevatedButton.icon(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                      _fetchHomeworks();
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous Page'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent, // Set the text color
            ),
          ),
          Text('Page $_currentPage of $totalPages',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                      _fetchHomeworks();
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next Page'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
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
