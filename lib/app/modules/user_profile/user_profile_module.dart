import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/user_profile_edit/user_profile_edit_module.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'user_profile_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'user_profile_page.dart';

class UserProfileModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => UserProfileController()),
        Bind((i) => AuthController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => UserProfilePage()),
        ModularRouter('/user-profile-edit', module: UserProfileEditModule()),
      ];

  static Inject get to => Inject<UserProfileModule>.of();

  @override
  // TODO: implement view
  Widget get view => UserProfilePage();
}
