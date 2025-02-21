import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/injection_container.dart';

Future<bool> checkIfUserIsRegistered() async {
  print("🔍 Checking if user is registered...");
  final result = await sl<GetDataFromLocalUseCase>().call(AppConstants.uid);
  return result.fold((failure) {
    print("❌ Failed to get user data: ${failure.message}");
    return false;
  }, (uid) {
    print("📱 User ID found: $uid, isEmpty: ${uid.isEmpty}");
    return uid.isNotEmpty;
  });
}
