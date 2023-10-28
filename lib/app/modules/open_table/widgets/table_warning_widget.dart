import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TableWarning extends StatelessWidget {
  const TableWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();
    return Stack(children: [
      Container(
        height: 34,
        width: 95,
      ),
      Positioned(
        top: 0,
        right: 0,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('invites')
              .where('user_id', isEqualTo: homeController.user.uid)
              .where('role', isEqualTo: 'invited')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return Row(children: [
                Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 16, right: 16),
                          child: Text(
                            'Alertas de',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                color: ColorTheme.textColor,
                                height: 0.9),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16, right: 16),
                          child: Text(
                            'Contas',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.bold,
                                height: 0.9),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                snapshot.data.documents.length == 0
                    ? Container()
                    : Positioned(
                        top: 1,
                        right: 1,
                        child: Container(
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: ColorTheme.blue),
                          child: Center(
                            child: Text(
                              '${snapshot.data.documents.length}',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
              ]);
            }
          },
        ),
      )
    ]);
  }
}
