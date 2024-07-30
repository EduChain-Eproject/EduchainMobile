class Page<T> {
  final int number;
  final int size;
  final int totalElements;
  final int totalPages;
  final List<T> content;

  Page({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
  });

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final content = (json['content'] as List<dynamic>)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();

    return Page<T>(
      number: json['number'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      content: content,
    );
  }
}
