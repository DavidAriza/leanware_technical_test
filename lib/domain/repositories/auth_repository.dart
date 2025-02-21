import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/entities/login_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> signup(
      String email, String password);
}
