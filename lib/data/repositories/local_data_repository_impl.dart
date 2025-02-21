import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/local_data_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataRepositoryImpl implements LocalDataRepository {
  final SharedPreferences _prefs;

  LocalDataRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<Either<Failure, String>> getData(String key) async {
    try {
      final result = _prefs.getString(key);
      return Right(result ?? '');
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
