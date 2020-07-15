import 'package:dio/dio.dart';
import 'package:Headlines/src/constants.dart';

class DioHttpService {
  Dio _dio;

  DioHttpService() {
    _dio = Dio(BaseOptions(connectTimeout: 10000));
  }

  Future<Response> handleGetRequestWithoutToken(String path) async {
    String completePath = Constants.apiUrl + path;
    print(completePath);
    final res = await _dio.get(completePath);
    return res;
  }
}
