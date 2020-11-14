import 'dart:convert';

import 'package:http/http.dart' as http;

mixin BaseNetwork {
  final http.Client client = http.Client();

  Future<Map<String, String>> get defaultHeaders async => {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8',
      };

  final String defaultBody = '{}';
  //* Helper functions

  Future<http.Response> getData(
      {String url, Map<String, String> headers}) async {
    return await client.get(
      url,
      headers: headers ?? await defaultHeaders,
    );
  }

  Future<http.Response> postData({
    String url,
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return await client.post(
      url,
      headers: headers ?? await defaultHeaders,
      body: json.encode(body ?? defaultBody),
    );
  }
}
