import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/domain/use_cases/clear_room_use_case.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/is_user_host_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/set_room_host_use_case.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetDataFromLocalUseCase extends Mock
    implements GetDataFromLocalUseCase {}

class MockSaveDataToLocalUseCase extends Mock
    implements SaveDataToLocalUseCase {}

class MockSetRoomHostUseCase extends Mock implements SetRoomHostUseCase {}

class MockIsUserHostUseCase extends Mock implements IsUserHostUseCase {}

class MockClearRoomUseCase extends Mock implements ClearRoomUseCase {}

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
  late CallCubit callCubit;
  late MockGetDataFromLocalUseCase mockGetDataFromLocalUseCase;
  late MockSaveDataToLocalUseCase mockSaveDataToLocalUseCase;
  late MockSetRoomHostUseCase mockSetRoomHostUseCase;
  late MockIsUserHostUseCase mockIsUserHostUseCase;
  late MockClearRoomUseCase mockClearRoomUseCase;

  setUp(() {
    mockGetDataFromLocalUseCase = MockGetDataFromLocalUseCase();
    mockSaveDataToLocalUseCase = MockSaveDataToLocalUseCase();
    mockSetRoomHostUseCase = MockSetRoomHostUseCase();
    mockIsUserHostUseCase = MockIsUserHostUseCase();
    mockClearRoomUseCase = MockClearRoomUseCase();

    callCubit = CallCubit(
      mockGetDataFromLocalUseCase,
      mockSaveDataToLocalUseCase,
      mockSetRoomHostUseCase,
      mockIsUserHostUseCase,
      mockClearRoomUseCase,
    );
  });

  tearDown(() {
    callCubit.close();
  });

  test('initial state should be CallInitial', () {
    expect(callCubit.state, equals(CallInitial()));
  });

  group('State transitions', () {
    blocTest<CallCubit, CallState>(
      'setToJoiningCallState emits JoiningCall',
      build: () => callCubit,
      act: (cubit) => cubit.setToJoiningCallState(),
      expect: () => [JoiningCall()],
    );

    blocTest<CallCubit, CallState>(
      'setWaitingRoom emits CallWaiting',
      build: () => callCubit,
      act: (cubit) => cubit.setWaitingRoom(),
      expect: () => [CallWaiting()],
    );

    blocTest<CallCubit, CallState>(
      'setToInitial emits CallInitial',
      build: () => callCubit,
      act: (cubit) => cubit.setToInitial(),
      expect: () => [CallInitial()],
    );

    blocTest<CallCubit, CallState>(
      'startCall emits StartCall',
      build: () => callCubit,
      act: (cubit) => cubit.startCall(),
      expect: () => [StartCall()],
    );
  });

  group('saveUserName', () {
    const testUserName = 'TestUser';

    blocTest<CallCubit, CallState>(
      'emits UserNameLoaded when successfully saves username',
      build: () {
        when(() => mockSaveDataToLocalUseCase.call(
                AppConstants.userName, testUserName))
            .thenAnswer((_) async => const Right(unit));
        return callCubit;
      },
      act: (cubit) => cubit.saveUserName(testUserName),
      expect: () => [UserNameLoaded(testUserName)],
      verify: (_) {
        verify(() => mockSaveDataToLocalUseCase.call(
            AppConstants.userName, testUserName)).called(1);
      },
    );
  });

  group('getUserName', () {
    blocTest<CallCubit, CallState>(
      'emits [AskForUserName] when getUserName fails',
      build: () {
        when(() => mockGetDataFromLocalUseCase.call(AppConstants.userName))
            .thenAnswer((_) async => Left(
                MockRepositoryFailure('Error when getting data from local')));
        return callCubit;
      },
      act: (cubit) => cubit.getUserName(AppConstants.userName),
      expect: () => [AskForUserName()],
    );

    blocTest<CallCubit, CallState>(
      'emits [AskForUserName] when userName is empty',
      build: () {
        when(() => mockGetDataFromLocalUseCase.call(AppConstants.userName))
            .thenAnswer((_) async => const Right(''));
        return callCubit;
      },
      act: (cubit) => cubit.getUserName(AppConstants.userName),
      expect: () => [AskForUserName()],
    );

    blocTest<CallCubit, CallState>(
      'emits [UserNameLoaded] when userName exists',
      build: () {
        when(() => mockGetDataFromLocalUseCase.call(AppConstants.userName))
            .thenAnswer((_) async => const Right('TestUser'));
        return callCubit;
      },
      act: (cubit) => cubit.getUserName(AppConstants.userName),
      expect: () => [const UserNameLoaded('TestUser')],
    );
  });

  group('getUserId', () {
    test('returns empty string when getting user id fails', () async {
      when(() => mockGetDataFromLocalUseCase.call(AppConstants.uid)).thenAnswer(
          (_) async =>
              Left(MockRepositoryFailure('Error when getting the user id')));

      final result = await callCubit.getUserId();
      expect(result, equals(''));
    });

    test('returns userId when successful', () async {
      const testUid = 'test-uid-123';
      when(() => mockGetDataFromLocalUseCase.call(AppConstants.uid))
          .thenAnswer((_) async => const Right(testUid));

      final result = await callCubit.getUserId();
      expect(result, equals(testUid));
    });
  });

  group('setAndCheckIfItsHost', () {
    const testUid = 'test-uid-123';

    test('returns correct map with isHost true', () async {
      when(() => mockGetDataFromLocalUseCase.call(AppConstants.uid))
          .thenAnswer((_) async => const Right(testUid));
      when(() => mockSetRoomHostUseCase.call(testUid))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockIsUserHostUseCase.call(testUid))
          .thenAnswer((_) async => const Right(true));

      final result = await callCubit.setAndCheckIfItsHost();
      expect(result, equals({"isHost": true, "uid": testUid}));
    });

    test('returns correct map with isHost false', () async {
      when(() => mockGetDataFromLocalUseCase.call(AppConstants.uid))
          .thenAnswer((_) async => const Right(testUid));
      when(() => mockSetRoomHostUseCase.call(testUid))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockIsUserHostUseCase.call(testUid))
          .thenAnswer((_) async => const Right(false));

      final result = await callCubit.setAndCheckIfItsHost();
      expect(result, equals({"isHost": false, "uid": testUid}));
    });
  });

  group('clearRoom', () {
    test('calls clearRoomUseCase', () async {
      when(() => mockClearRoomUseCase.call())
          .thenAnswer((_) async => const Right(unit));

      await callCubit.clearRoom();
      verify(() => mockClearRoomUseCase.call()).called(1);
    });
  });
}
