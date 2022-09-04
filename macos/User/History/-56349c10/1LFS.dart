import 'package:get_it/get_it.dart';
import 'package:zanalys/app/app_services_provider.dart';
import 'package:zanalys/data/storage/storage_service.dart';

class AppServices {
  const AppServices._();

  static Future<void> register(AppServicesProvider provider) {
    GetIt.instance.registerSingletonAsync<StorageService>(() async {
      StorageService storage = provider.storage;
      await storage.init();
      return storage;
    });

    return GetIt.instance.allReady();
  }

  static StorageService get storage => GetIt.instance.get<StorageService>();
}