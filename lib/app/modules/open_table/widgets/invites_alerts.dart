import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/shared/color_theme.dart';

class InviteAlerts extends StatelessWidget {
  final Function goTo;
  // final String avatar;
  final String groupHash;

  const InviteAlerts({Key key, this.goTo, this.groupHash}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
            child: Image.asset(
          'assets/img/elipse.png',
          height: wXD(70, context),
          width: wXD(70, context),
        )),
        Positioned(
          child: InkWell(
            onTap: goTo,
            child: Container(
              width: wXD(60, context),
              height: wXD(60, context),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 3.0, color: ColorTheme.textGrey),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('groups')
                      .document(groupHash)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      String avatar = snapshot.data['avatar'];
                      return CircleAvatar(
                        radius: 85,
                        backgroundColor: Color(0xfffafafa),
                        child: CircleAvatar(
                          backgroundImage: avatar != null
                              ? NetworkImage(avatar)
                              : AssetImage('assets/img/defaultUser.png'),
                          backgroundColor: Colors.white,
                          // child: ,
                          radius: 82,
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
