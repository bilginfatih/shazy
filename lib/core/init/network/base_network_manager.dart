import 'package:dio/dio.dart';

import '../../base/base_model.dart';

abstract class BaseNetworkManager {
  Dio dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5858', ));

  Future<dynamic> get<T extends BaseModel>(String path, {T? model});

  Future<dynamic> post<T extends BaseModel>(String path, {T? model});
}