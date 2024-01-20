import "package:dio/dio.dart";

class AppDioException implements Exception {
  late String errorMessage;

  AppDioException.fromDIOException({
    required DioException dioException,
  }) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        errorMessage = "Request to the server was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = "Could not establish connection, check your internet.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Could not log you in.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage =
            "Your connection seems slow, kindly check your internet.";
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(
            statusCode: dioException.response?.statusCode,
            message: dioException.response?.data["message"]);
        break;
      case DioExceptionType.unknown:
        if (dioException.message!.contains("SocketException")) {
          errorMessage = "No Internet.";
          break;
        }

        if (dioException.response?.statusCode != null) {
          errorMessage = _handleStatusCode(
            statusCode: dioException.response?.statusCode,
            message: dioException.response?.data["message"],
          );
          break;
        }

        errorMessage = "An unexpected error occurred.";
        break;

      default:
        errorMessage = "Something went wrong";
        break;
    }
  }

  //!
  //! STATUS CODES
  String _handleStatusCode({
    required int? statusCode,
    required String? message,
  }) {
    switch (statusCode) {
      case 400:
        return "$message";
      case 401:
        return "Unauthorized: $message";
      case 403:
        return "$message";
      case 404:
        return "$message";
      case 500:
        return "It's not you, it's us. Kindly login again";
      default:
        return "Oops something went wrong! We're fixing it, try again later";
    }
  }

  @override
  String toString() => errorMessage;
}
