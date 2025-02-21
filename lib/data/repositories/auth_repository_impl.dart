import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/data/data_sources/auth_remote_data_source.dart';
import 'package:leanware_test/domain/entities/login_response_entity.dart';
import 'package:leanware_test/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, LoginResponseEntity>> signup(
      String email, String password) async {
    try {
      final response = await authRemoteDataSource.signup(email, password);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
