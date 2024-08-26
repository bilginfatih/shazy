import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../base/base_model.dart';
import 'base_network_manager.dart';

class NetworkManager extends BaseNetworkManager {
  NetworkManager._init();

  static NetworkManager instance = NetworkManager._init();

  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  @override
  Future get<T extends BaseModel>(String path, {T? model}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        debugPrint('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      debugPrint(_headers.toString());
      debugPrint(dio.options.baseUrl + path);
      var response = await dio.get(
        path,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            return status is int && status < 500;
          },
        ),
      );
      debugPrint(response.toString());
      if (model != null) {
        return model.fromJson(response.data);
      }
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future post<T extends BaseModel>(String path,
      {T? model, Map<String, dynamic>? data}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        debugPrint('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      var request =
          model != null ? jsonEncode(model.toJson()) : jsonEncode(data);
      debugPrint(path);
      debugPrint('${dio.options.baseUrl}$path');
      log(request);
      print('---');
      debugPrint(request, wrapWidth: 1024);
      debugPrint(_headers.toString());
      Response<dynamic> response = await dio.post(
        path,
        data: request,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            debugPrint(status.toString());
            return status is int && status < 500;
          },
        ),
      );
      debugPrint(response.toString(), wrapWidth: 1024);
      print('*****');
      if (response.data == '') {
        return '';
      }
      return jsonDecode(response.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future put<T extends BaseModel>(String path,
      {T? model, Map<String, dynamic>? data}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        debugPrint('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      var request =
          model != null ? jsonEncode(model.toJson()) : jsonEncode(data);
      debugPrint(path);
      debugPrint('${dio.options.baseUrl}$path');
      log(request);
      print('---');
      debugPrint(_headers.toString());
      Response<dynamic> response = await dio.put(
        path,
        data: request,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            debugPrint(status.toString());
            return status is int && status < 500;
          },
        ),
      );
      debugPrint(response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future delete<T extends BaseModel>(String path,
      {T? model, Map<String, dynamic>? data}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        debugPrint('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      var request =
          model != null ? jsonEncode(model.toJson()) : jsonEncode(data);
      debugPrint(path);
      debugPrint('${dio.options.baseUrl}$path');
      debugPrint(request);
      debugPrint(_headers.toString());
      Response<dynamic> response = await dio.delete(
        path,
        data: request,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            debugPrint(status.toString());
            return status is int && status < 500;
          },
        ),
      );
      debugPrint(response.toString());
      return jsonDecode(response.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<Response<T>> put2<T>(String path, Map<String, dynamic> json,
      {dynamic data}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        debugPrint('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      var request = jsonEncode(data);
      log(request);
      final response = await dio.post<T>(
        path,
        data: request,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            debugPrint(status.toString());
            return status is int && status < 500;
          },
        ),
      );
      log(response.toString());
      return response;
    } on DioException catch (e) {
      print(e.message);
      if (e.response != null) {
        print(e.response?.data.toString());
      }
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /*@override
  Future post<T extends BaseModel>(String path, {T? model}) async {
    Map<String, dynamic> data = {};
    try {
      Response<dynamic> response = await dio.post('',
          data: jsonEncode(model),
          options: Options(
            headers: {},
            validateStatus: (status) => status is int && status < 500,
          ));
      data = jsonDecode(response.toString());
    } catch (e) {
      data['error'] = '';
    }
    return data;
  }*/
}
