import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:dartz/dartz.dart';

abstract class LocalDataRepository {
  Future<void> saveData(String key, String value);
  Future<Either<Failure, String>> getData(String key);

  Future<void> remove(String key);
}
