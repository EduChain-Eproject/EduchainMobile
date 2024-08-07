import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find Course',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Choice your course',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightWhiteColor),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            _showFilter = !_showFilter;
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('All'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Poular'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('New'),
                        ),
                      ],
                    ),
                  ),
                  CourseCard(
                    title: 'Product Design v1.0',
                    author: 'Robertson Connie',
                    progress: 0.6,
                    lessons: 24,
                  ),
                  CourseCard(
                    title: 'Product Design',
                    author: 'Webb Landon',
                    progress: 0.25,
                    lessons: 24,
                  ),
                  CourseCard(
                    title: 'Product Design',
                    progress: 0.25,
                    author: 'Webb Kyle',
                    price: '\$250',
                    hours: '14 hours',
                    lessons: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_showFilter)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.lightBorderColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilterButton(text: 'Design'),
                        FilterButton(text: 'Painting'),
                        FilterButton(text: 'Coding'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilterButton(text: 'Music'),
                        FilterButton(text: 'Visual identiy'),
                        FilterButton(text: 'Mathmatics'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    RangeSlider(
                      values: RangeValues(90, 200),
                      min: 0,
                      max: 300,
                      divisions: 10,
                      labels: RangeLabels(
                        '\$90',
                        '\$200',
                      ),
                      onChanged: (RangeValues newRange) {},
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilterButton(text: 'Date'),
                        FilterButton(text: 'Title'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showFilter = false;
                            });
                          },
                          child: Text('Apply Filter'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showFilter = false;
                            });
                          },
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String author;
  final double progress;
  final int lessons;
  final String? price;
  final String? hours;

  const CourseCard({
    required this.title,
    required this.author,
    required this.progress,
    required this.lessons,
    this.price,
    this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              color: Colors.grey[200],
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text(author),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed ${progress * 100}%',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '$lessons Lessons',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (price != null) SizedBox(height: 8),
            if (price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hours != null)
                    Text(
                      hours!,
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;

  FilterButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}
