import 'dart:io';

import 'package:acr_cloud_sdk_example/core/network_layer/base_network/base_network.dart';
import 'package:acr_cloud_sdk_example/core/network_layer/exceptions/exceptions.dart';
import 'package:acr_cloud_sdk_example/utils/log.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ApiHelper with BaseNetwork {
  Future<String> get({
    @required String url,
    Map<String, String> headers,
  }) async {
    var responseJson;
    try {
      final response = await getData(
        url: url,
        headers: headers,
      );

      Log().debug(url, response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (e is UnauthorisedException) Log().error(e.toString());
      throw e;
    }
    return responseJson;
  }

  Future<Response> getRaw({
    @required String url,
    Map<String, String> headers,
  }) async {
    Response responseJson;
    try {
      final response = await getData(
        url: url,
        headers: headers,
      );

      Log().debug(url, response.body);
      responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (e is UnauthorisedException) Log().error(e.toString());
      throw e;
    }
    return responseJson;
  }

  Future<String> post({
    @required String url,
    Map<String, String> headers,
    bool throwError = false,
    List<int> passRange,
    @required Map<String, dynamic> body,
  }) async {
    var responseJson;
    try {
      Log().debug('body', body);
      final response = await postData(
        url: url,
        headers: headers,
        body: body,
      );
      print(response.body);
      if (!throwError) {
        if (passRange != null) {
          for (int item in passRange) {
            item == response.statusCode
                ? responseJson = response.body
                : throw response.body;
          }
        } else {
          responseJson = _returnResponse(response);
        }
      } else {
        return response.body;
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e.toString());
      if (e is UnauthorisedException) Log().error(e.toString());
      if (e.toString().toLowerCase().contains('time'))
        throw 'Sever Took too long to Respond';
      else
        throw e;
    }
    return responseJson;
  }

  String _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        return (response.body.toString());
      case 422:
        return (response.body.toString());
      case 404:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
