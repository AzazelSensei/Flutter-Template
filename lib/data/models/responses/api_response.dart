/*
 * Generic API Response Wrapper
 *
 * Backend response format: { "response": {...}, "data": {...} }
 *
 * dataParser parametresi sayede farklı tip'lerdeki data'yı parse edebiliriz:
 * - ApiResponse<List<Movie>>.fromJson(json, (data) => parseMovieList(data))
 * - ApiResponse<User>.fromJson(json, (data) => User.fromJson(data))
 */
class ApiResponse<T> {
  final ResponseMeta response;
  final T data;

  const ApiResponse({
    required this.response,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataParser,
  ) {
    return ApiResponse(
      response: ResponseMeta.fromJson(json['response'] ?? {}),
      data: dataParser(json['data']),
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T) dataSerializer) {
    return {
      'response': response.toJson(),
      'data': dataSerializer(data),
    };
  }
}

class ResponseMeta {
  final int code;
  final String message;

  const ResponseMeta({
    required this.code,
    required this.message,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) {
    return ResponseMeta(
      code: json['code'] ?? 200,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  bool get isSuccess => code >= 200 && code < 300;
}
