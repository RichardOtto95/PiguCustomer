import 'package:pigu/app/core/models/user_model.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/home/home_module.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'sign_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'sign_page.dart';

class SignModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SignController(i.get())),
        Bind((i) => AuthController()),
        Bind<UserModel>((i) => UserModel()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => SignPage()),
        ModularRouter('/home', module: HomeModule()),
        // ModularRouter('/signup', module: SignupModule()),
        // ModularRouter('/recovery-password',
        //     module: SigninEmailRecoveryModule(),
        //     transition: TransitionType.noTransition),
      ];

  @override
  Widget get view => SignPage();
}
