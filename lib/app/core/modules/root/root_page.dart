import 'dart:io';

import 'package:pigu/app/core/modules/splash/splash_module.dart';
import 'package:pigu/app/modules/home/home_module.dart';
import 'package:pigu/app/modules/sign/sign_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'root_controller.dart';
import 'package:rich_alert/rich_alert.dart';

// import 'package:rflutter_alert/rflutter_alert.dart';

class RootPage extends StatefulWidget {
  final String title;
  const RootPage({Key key, this.title = "Root"}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends ModularState<RootPage, RootController> {
  //use 'controller' variable to access controller
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new RichAlertDialog(
            alertTitle: richTitle("Deseja sair?"),
            alertSubtitle: richSubtitle("O aplicativo será fechado"),
            alertType: RichAlertType.WARNING,
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('Não'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Sim'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _trunk_module = [
      SplashModule(),
      SignModule(),
      HomeModule(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(child: Scaffold(
          // backgroundColor: ThemeConecta().backgroundColor,
          body: Observer(builder: (_) {
        return _trunk_module[controller.selectedTrunk];
      }))),
    );
  }
}
