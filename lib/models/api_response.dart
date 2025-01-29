class ApiResponse {
  final bool success;
  final String? error;
  final List<dynamic>? data;

  ApiResponse({required this.success, this.error, this.data});
}
