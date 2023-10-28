import 'package:pigu/app/app_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_widget.dart';
import 'core/modules/root/root_module.dart';
import 'core/services/auth/auth_controller.dart';
import 'core/services/auth/auth_service.dart';
import 'core/services/storage/local_storage_interface.dart';
import 'core/services/storage/local_storage_shared_preferences.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppController()),
        Bind<ILocalStorage>((i) => LocalStorageSharedPreferences()),
        Bind<AuthService>((i) => AuthService()),
        Bind((i) => AuthController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: RootModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
