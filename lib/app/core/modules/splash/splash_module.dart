import 'package:pigu/app/core/modules/splash/splash_controller.dart';
import 'package:pigu/app/core/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SplashController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Modular.initialRoute,
          child: (_, args) => SplashPage(),
        ),
        // Router(Modular.initialRoute, child: (_, args) => SplashPage()),
      ];

  static Inject get to => Inject<SplashModule>.of();

  @override
  Widget get view => SplashPage();
}
