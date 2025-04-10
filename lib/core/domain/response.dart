class FunctionResponse {
  final bool success;
  final String message;
  final dynamic data; // Added dynamic data property

  const FunctionResponse({
    required this.success,
    required this.message,
    this.data, // Optional parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data, // Added data in the map
    };
  }

  factory FunctionResponse.fromMap(Map<String, dynamic> map) {
    return FunctionResponse(
      success: map['success'] as bool,
      message: map['message'] as String,
      data: map['data'], // Handling dynamic data
    );
  }
}