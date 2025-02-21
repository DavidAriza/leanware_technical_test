import 'package:leanware_test/core/error_handling/exception.dart';
import 'package:leanware_test/data/data_sources/auth_remote_data_source.dart';
import 'package:leanware_test/data/models/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioHttpCliente extends Mock implements Dio {}

void main() {
  late MockDioHttpCliente mockDioHttpCliente;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDioHttpCliente = MockDioHttpCliente();
    dataSource = AuthRemoteDataSourceImpl(httpClient: mockDioHttpCliente);
  });

  group('auth remote data source', () {
    test('should return a [LoginResponseModel] when dio request is successful',
        () async {
      ///Arrange
      when(() => mockDioHttpCliente.post(
                any(),
                data: any(named: 'data'),
              ))
          .thenAnswer((_) async => Response(
              data: {'id': '1', 'email': 'email', 'token': 'token'},
              requestOptions: RequestOptions(path: ''),
              statusCode: 200));

      ///Act
      final result = await dataSource.signup('email', 'password');

      ///Assert
      expect(result, isA<LoginResponseModel>());
    });
  });

  test("should return a [DioFailure] when dio request fails", () async {
    ///Arrange
    when(() => mockDioHttpCliente.post(
              any(),
              data: any(named: 'data'),
            ))
        .thenThrow(DioFailure.decode(DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
                requestOptions: RequestOptions(path: ''), statusCode: 400))));

    ///Act
    try {
      await dataSource.signup('email', 'password');
    } catch (e) {
      ///Assert
      expect(e, isA<DioFailure>());
    }
  });
}
