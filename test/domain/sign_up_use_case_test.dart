import 'package:leanware_test/core/use_case/login_params.dart';
import 'package:leanware_test/data/repositories/auth_repository_impl.dart';
import 'package:leanware_test/domain/entities/login_response_entity.dart';
import 'package:leanware_test/domain/use_cases/sign_up_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryImpl extends Mock implements AuthRepositoryImpl {}

void main() {
  group('login use case', () {
    late SignUpUseCase signUpUseCase;
    late AuthRepositoryImpl mockAuthRepositoryImpl;

    setUp(() {
      mockAuthRepositoryImpl = MockAuthRepositoryImpl();
      signUpUseCase = SignUpUseCase(authRepository: mockAuthRepositoryImpl);
    });

    const params = LoginParams(email: 'email', password: 'password');
    const loginResponse =
        LoginResponseEntity(id: '1', email: 'email', token: 'token');

    test("should return a login response from the repository", () async {
      ///Arrange
      when(() => mockAuthRepositoryImpl.signup(any(), any())).thenAnswer(
          (_) async => const Right(
              LoginResponseEntity(id: '1', email: 'email', token: 'token')));

      ///Act
      final result = await signUpUseCase.call(params);

      ///Assert
      expect(result, const Right(loginResponse));
      verify(
          () => mockAuthRepositoryImpl.signup(params.email, params.password));
      verifyNoMoreInteractions(mockAuthRepositoryImpl);
    });
  });
}
