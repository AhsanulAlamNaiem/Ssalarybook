class FunctionResponse{
  final bool success;
  final String message;

  const FunctionResponse({
    required this.success,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': this.success,
      'message': this.message,
    };
  }

  factory FunctionResponse.fromMap(Map<String, dynamic> map) {
    return FunctionResponse(
      success: map['success'] as bool,
      message: map['message'] as String,
    );
  }
}