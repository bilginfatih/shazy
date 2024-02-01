import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
        print('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      print(_headers);
      print(dio.options.baseUrl + path);
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
      print(response);
      if (model != null) {
        return model.fromJson(response.data);
      }
      return response.data;
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

  @override
  Future post<T extends BaseModel>(String path,
      {T? model, Map<String, dynamic>? data}) async {
    try {
      var token = await SessionManager().get('token');
      if (token != null) {
        print('token: $token');
        _headers['Authorization'] = 'Bearer $token';
      }
      var request =
          model != null ? jsonEncode(model.toJson()) : jsonEncode(data);
      print(path);
      print('${dio.options.baseUrl}$path');
      print(request);
      print(_headers.toString());
      Response<dynamic> response = await dio.post(
        path,
        data: request,
        options: Options(
          followRedirects: false,
          headers: _headers,
          validateStatus: (status) {
            return status is int && status < 500;
          },
        ),
      );
      print(response);
      return jsonDecode(response.toString());
      // TODO: delete
      /*if (model != null) {
        response = await dio.post(path, data: model.toJson());
      } else {
        response = await dio.post(path, data: jsonEncode(data));
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['success'] == 'false') {
          throw Exception(data['errorMessage']);
        } else {
          print(data);
          return data['data'];
        }
      }*/
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
}
