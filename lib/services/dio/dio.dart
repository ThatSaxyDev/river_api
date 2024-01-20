import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/shared/app_urls.dart';
import 'package:river_api/shared/extensions.dart';

final Provider<DioClient> dioClientProvider =
    Provider((ref) => DioClient.instance);

//!
//! SINGLE CLASS FOR ALL DIO METHODS AND HELPER FUNCTIONS
class DioClient {
  DioClient._();

  static final instance = DioClient._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 90),
      responseType: ResponseType.json,
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    ),
  );

  Options header({required String? sessionToken}) => Options(
        headers: {"Authorization": "Token $sessionToken"},
      );

  //!
  //! GET
  Future<Map<String, dynamic>> get({
    required String path,
    Map<String, dynamic>? payload,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        data: payload ?? data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.data["success"]) {
        return response.data;
      }

      throw "Something went wrong: ${response.data.toString()}";
    } catch (error) {
      "DIO Error $error".log();
      rethrow;
    }
  }

  //!
  //! POST
  Future<Map<String, dynamic>> post({
    required String path,
    Map<String, dynamic>? payload,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: payload ?? data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      throw "Something went wrong";
    } catch (error) {
      "DIO ERROR: $error".log();
      rethrow;
    }
  }

  //!
  //! PUT
  Future<Map<String, dynamic>> put({
    required String path,
    Map<String, dynamic>? payload,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        path,
        data: payload ?? data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      throw "Something went wrong";
    } catch (error) {
      "DIO ERROR: $error".log();
      rethrow;
    }
  }

  //!
  //! PUT
  Future<Map<String, dynamic>> patch({
    required String path,
    Map<String, dynamic>? payload,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        path,
        data: payload ?? data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.data["success"]) {
        return response.data;
      }

      throw "Something went wrong";
    } catch (error) {
      "DIO ERROR: $error".log();
      rethrow;
    }
  }

  //!
  //! DELETE
  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? payload,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        data: payload ?? data,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 204 || response.data["success"]) {
        return response.data;
      }

      throw "Something went wrong";
    } catch (error) {
      "DIO ERROR: $error".log();
      rethrow;
    }
  }
}
