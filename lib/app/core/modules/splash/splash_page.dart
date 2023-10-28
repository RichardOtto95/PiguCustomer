import 'package:pigu/app/core/modules/root/root_controller.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/core/utils/auth_status_enum.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key key, this.title = "Splash"}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashController> {
  final rootController = Modular.get<RootController>();

  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    disposer = autorun((_) {
      final auth = Modular.get<AuthController>();
      if (auth.status == AuthStatus.signed_in) {
        // Modular.to.pushReplacementNamed('/master');
        rootController.setSelectedTrunk(2); //Trunk 2 = master (tab)
      } else if (auth.status == AuthStatus.signed_out) {
        rootController.setSelectedTrunk(1);

        //Trunk 1 = signin-email
        // Modular.to.pushReplacementNamed('/signin-email');
      } // otherwise, simply ignore (keeps on loading)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        "assets/pigu_splash.png",
      ),
    ));

    // Container(
    //   child: Center(
    //     child: Image.asset(
    //       "assets/pigu_splash.png",
    //     ),
    //   ),
    // );
    // appBar: AppBar(
    //  title: Text(widget.title),
    //  ),
    // body: Center(
    //  child: CircularProgressIndicator(),
    //  ));
    //}

    //@override
    //void dispose() {
    super.dispose();
    disposer();
  }
}
