class Page<T> {
  final int page;
  final int limit;
  final int total;
  final List<T> data;

  Page({
    required this.page,
    required this.limit,
    required this.total,
    required this.data,
  });

  factory Page.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final data =
        (json['data'] as List<dynamic>).map((item) => fromJson(item)).toList();
    return Page<T>(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      data: data,
    );
  }
}
