import 'dart:convert';
import 'package:dio/dio.dart';
import '../../base/base_model.dart';
import 'base_network_manager.dart';

class NetworkManager extends BaseNetworkManager {
  NetworkManager._init();

  static NetworkManager instance = NetworkManager._init();

  @override
  Future get<T extends BaseModel>(String path, {T? model}) async {
    try {
      var response = await dio.get(path);
      Map<String, dynamic> data = response.data;
      print(path);
      print(data);
      if (data['success'] == 'false') {
        throw Exception(data['errorMessage']);
      } else {
        if (data['data'] is List) {
          if (model != null) {
            List list = [];
            for (var e in data['data']) {
              list.add(model.fromJson(e));
            }
            return list;
          }
        } else {
          if (model != null) {
            return model.fromJson(data['data']);
          }
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future post<T extends BaseModel>(String path,
      {T? model, Map<String, dynamic>? data}) async {
    try {
      Response<dynamic> response;

      if (model != null) {
        response = await dio.post(path, data: model.toJson());
      } else {
        response = await dio.post(path, data: jsonEncode(data));
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['success'] == 'false') {
          throw Exception(data['errorMessage']);
        } else {
          if (model != null) {
            print(path);
            print(model.toJson());
            print(data);
            return model.fromJson(data['data']);
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}