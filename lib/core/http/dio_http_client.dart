import 'package:dio/dio.dart';

class DioHttpClient with DioMixin implements Dio {
  DioHttpClient() {
    options = BaseOptions(baseUrl: 'https://fakeurl.com/');
    httpClientAdapter = HttpClientAdapter();
  }
}
