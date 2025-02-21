import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/local_data_repository.dart';
import 'package:dartz/dartz.dart';

class GetDataFromLocalUseCase {
  final LocalDataRepository repository;

  GetDataFromLocalUseCase(this.repository);

  Future<Either<Failure, String>> call(
    String key,
  ) async {
    return await repository.getData(key);
  }
}
