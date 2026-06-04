class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  const ApiResponse({
    this.data,
    this.error,
    this.isLoading = false,
  });

  const ApiResponse.loading() : this(isLoading: true);
  const ApiResponse.success(T data) : this(data: data);
  const ApiResponse.error(String error) : this(error: error);

  bool get hasData => data != null;
  bool get hasError => error != null;

  @override
  String toString() =>
      'ApiResponse(data: $data, error: $error, isLoading: $isLoading)';
}
