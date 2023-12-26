import 'package:dio/dio.dart';
import 'package:shazy/utils/constants/app_constant.dart';

import '../../base/base_model.dart';

abstract class BaseNetworkManager {
  final Dio dio =
      Dio(BaseOptions(baseUrl: '$baseUrl/api'));

  Future<dynamic> get<T extends BaseModel>(String path, {T? model});

  Future<dynamic> post<T extends BaseModel>(String path, {T? model});
}
