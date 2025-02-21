import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:leanware_test/domain/use_cases/clear_room_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements RoomRepository {}

class MockRepositoryFailure extends Failure {
  final String message;

  MockRepositoryFailure(this.message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockRepositoryFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

void main() {
  // Genera el mock del repositorio

  group('ClearRoomUseCase', () {
    late MockRepository mockRepository;
    late ClearRoomUseCase clearRoomUseCase;
    setUp(
      () {
        mockRepository = MockRepository();
        clearRoomUseCase = ClearRoomUseCase(mockRepository);
      },
    );
    test('should call the repository and return a Right(Unit) on success',
        () async {
      // Arrange
      when(() => mockRepository.clearRoom())
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await clearRoomUseCase.call();

      // Assert
      verify(mockRepository.clearRoom).called(1);
      expect(result, const Right(unit));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return RepositoryFailure when clearing room fails', () async {
      // Arrange
      final failure = MockRepositoryFailure('Something went wrong');
      when(() => mockRepository.clearRoom())
          .thenAnswer((_) async => Left(failure));
      // Act
      final result = await clearRoomUseCase.call();

      // Assert
      expect(result, equals(Left<Failure, void>(failure)));
      verify(mockRepository.clearRoom).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
