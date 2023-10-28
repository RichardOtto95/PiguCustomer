import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SwitchNotificacoes extends StatefulWidget {
  @override
  _SwitchNotificacoesState createState() => _SwitchNotificacoesState();
}

class _SwitchNotificacoesState extends State<SwitchNotificacoes> {
  final homeController = Modular.get<HomeController>();
  var notificationActive = true;
  var primaryColor = Color.fromRGBO(254, 214, 165, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Firestore.instance
            .collection('users')
            .document(homeController.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          DocumentSnapshot ds = snapshot.data;
          notificationActive = ds['notification_enabled'];
          return Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: ColorTheme.primaryColor,
              value: notificationActive,
              onChanged: (v) async {
                ds.reference.updateData({'notification_enabled': v});
              });
        });
  }
}
