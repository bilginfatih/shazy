import 'package:dio/dio.dart';

import '../../base/base_model.dart';

abstract class BaseNetworkManager {
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://test.shazyinc.com/public/api'));

  Future<dynamic> get<T extends BaseModel>(String path, {T? model});

  Future<dynamic> post<T extends BaseModel>(String path, {T? model});
}
