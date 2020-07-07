import 'package:dio/dio.dart';
import 'package:news_app/src/constants.dart';

class DioHttpService {
  Dio _dio;

  DioHttpService.internal() {
    _dio = Dio(BaseOptions(connectTimeout: 10000))
      ..options.baseUrl = Constants.apiUrl
      ..interceptors.add(LogInterceptor(responseBody: true))
      ..interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
        switch (e.type) {
          case DioErrorType.RESPONSE:
            return e.response;
            break;
          default:
            print('DioErrorType => ${e.type}');
            break;
        }
        if (e.response != null) {
          print('path => ' + e.response.request.path);
          print('dioError log => $e');
          return e.response;
        }
        return e;
      }));
  }

  Future<Response> handleGetRequestWithoutToken(String path) async {
    final res = await _dio.get(path);
    return res;
  }
}
