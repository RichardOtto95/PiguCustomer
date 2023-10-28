import 'user_profile_edit_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'user_profile_edit_page.dart';

class UserProfileEditModule extends ChildModule {
  @override
  List<Bind> get binds => [
        
        Bind((i) => UserProfileEditController()),

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => UserProfileEditPage()),
      ];

  static Inject get to => Inject<UserProfileEditModule>.of();
}
