typedef ApiResponse<T> = Future<Response<T>>;

class Response<T> {
  final T? data;
  final Map<String, dynamic>? error;

  bool get isSuccess => data != null;

  void on({
    required Function(Map<String, dynamic> error) onError,
    required Function(T data) onSuccess,
  }) {
    if (isSuccess) {
      onSuccess(data as T);
    } else {
      onError(error!);
    }
  }

  Response({this.data, this.error});
}
