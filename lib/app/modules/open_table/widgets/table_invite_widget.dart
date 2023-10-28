import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TableInvite extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  const TableInvite({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();
    return Stack(children: [
      Container(
        height: wXD(50, context),
        width: MediaQuery.of(context).size.width * 0.27,
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
              return Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(
                        bottom: wXD(7, context), left: wXD(10, context)),
                    child: Text(
                      'Convites',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w700,
                          height: 0.9),
                    ),
                  ),
                  snapshot.data.documents.length == 0
                      ? Container()
                      : Positioned(
                          right: wXD(2, context),
                          top: wXD(9, context),
                          child: Container(
                            alignment: Alignment.center,
                            height: wXD(23, context),
                            width: wXD(23, context),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: ColorTheme.blue),
                            child: Text(
                              '${snapshot.data.documents.length}',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(14, context),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                ],
              );
            }
          },
        ),
      ),
    ]);
  }
}
