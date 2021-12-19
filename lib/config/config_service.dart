import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  var dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        final prefs = await SharedPreferences.getInstance();
        final _myToken = prefs.getString('access_token');
        options.headers.addAll({
          'authorization': 'Bearer $_myToken',
          'content-type': 'application/json',
        });
        options.baseUrl = 'https://test.com';
        options.receiveTimeout = 15000;
        options.connectTimeout = 15000;
        options.followRedirects = false;
        options.validateStatus = (status) {
          return status! < 500;
        };
        return handler.next(options);
      }),
    );
  var dio2 = Dio()
    ..interceptors.add(
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers.addAll({'content-type': 'application/json'});
        options.baseUrl = 'https://test.com';
        options.receiveTimeout = 15000;
        options.connectTimeout = 15000;
        options.followRedirects = false;
        options.validateStatus = (status) {
          return status! < 500;
        };
        return handler.next(options);
      }),
    );
  var dio3 = Dio()
    ..interceptors.add(
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.followRedirects = true;
        options.validateStatus = (status) {
          return status! < 500;
        };
        return handler.next(options);
      }),
    );
  late Response response;
}
