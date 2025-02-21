import 'package:leanware_test/domain/repositories/local_data_repository.dart';

class SaveDataToLocalUseCase {
  final LocalDataRepository repository;

  SaveDataToLocalUseCase(this.repository);

  Future<void> call(String key, String value) async {
    await repository.saveData(key, value);
  }
}
