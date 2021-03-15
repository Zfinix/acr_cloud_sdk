import 'dart:convert';

import 'package:dio/dio.dart';

mixin BaseNetwork {
  final Dio client = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
    ),
  );

  Future<Map<String, String>> get defaultHeaders async => {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8',
      };

  final String defaultBody = '{}';
  //* Helper functions

  Future<Response> getData({
    required String url,
    Map<String, String>? headers,
  }) async {
    return await client.get(
      url,
      options: Options(
        headers: headers ?? await defaultHeaders,
      ),
    );
  }

  Future<Response> postData({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return await client.post(
      url,
      data: json.encode(body ?? defaultBody),
      options: Options(
        headers: headers ?? await defaultHeaders,
      ),
    );
  }
}
