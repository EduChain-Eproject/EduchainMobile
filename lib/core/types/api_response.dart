typedef ApiResponse<T> = Future<Response<T>>;

class Response<T> {
  final T? data;
  final Map<String, dynamic>? error;

  bool get isSuccess => data != null;

  Future<void> on({
    required Function(Map<String, dynamic> error) onError,
    required Function(T data) onSuccess,
  }) async {
    if (isSuccess) {
      await onSuccess(data as T);
    } else {
      await onError(error!);
    }
  }

  Response({this.data, this.error});
}
