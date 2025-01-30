class ApiResponse {
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;

  ApiResponse({required this.success, this.error, this.data});

  String? get username => data?['user']?['name'];
}
