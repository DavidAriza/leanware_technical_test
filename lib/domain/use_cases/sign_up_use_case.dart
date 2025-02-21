import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/core/use_case/login_params.dart';
import 'package:leanware_test/core/use_case/use_case.dart';

import 'package:leanware_test/domain/entities/login_response_entity.dart';
import 'package:leanware_test/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignUpUseCase implements UseCase<LoginResponseEntity, LoginParams> {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, LoginResponseEntity>> call(LoginParams params) async {
    return await authRepository.signup(params.email, params.password);
  }
}
