import 'package:leanware_test/core/error_handling/error.dart';
import 'package:leanware_test/core/error_handling/exception.dart';
import 'package:leanware_test/core/utils/generators.dart';
import 'package:leanware_test/data/models/login_response_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> signup(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio httpClient;

  AuthRemoteDataSourceImpl({required this.httpClient});
  @override
  Future<LoginResponseModel> signup(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return LoginResponseModel(
        id: generateUid(),
        email: email,
        token: 'token',
      );
    } on DioException catch (error) {
      throw DioFailure.decode(error);
    } on Error catch (error) {
      throw ErrorFailure.decode(error);
    } on Exception catch (error) {
      throw ExceptionFailure.decode(error);
    }
  }
}
