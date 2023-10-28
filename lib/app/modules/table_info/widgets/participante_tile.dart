import 'dart:ui';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParticipanteTile extends StatelessWidget {
  var participante;
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryColor = Color.fromRGBO(250, 250, 250, 1);
  var anfitriaoText = Color(0xff95A5A6);
  var personText = Color(0xffD0D2D2);
  // var todosPagaram = false;
  // var pagou = true;
  // final checkHost;
  // final group;
  final Function showMenu;
  // bool checkHost = false;
  ParticipanteTile({
    @required this.participante,
    // this.checkHost,
    // this.group,
    this.showMenu,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("groups")
          .document(participante['group_id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(),
          );
        } else {
          return InkWell(
            onTap: showMenu,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
              decoration: BoxDecoration(
                  color: snapshot.data['user_host'] != participante['user_id']
                      ? primaryColor
                      : Color(0xffDADCDC),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(participante['user_id'])
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (!snapshot2.hasData) {
                    return Container();
                  } else if (snapshot2.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                      ),
                    );
                  } else {
                    DocumentSnapshot user = snapshot2.data;
                    return ListTile(
                      leading: Container(
                        width: wXD(50, context),
                        height: wXD(50, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                              width: wXD(3, context), color: Color(0xff95A5A6)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: user['avatar'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(ColorTheme.yellow),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Container(
                            width: wXD(180, context),
                            child: Text(
                              user['username'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: participante['role'] == 'paid'
                                    ? Color(0xff3C3C3B).withOpacity(0.5)
                                    : Color(0xff3C3C3B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            snapshot.data['user_host'] ==
                                    participante['user_id']
                                ? 'Anfitrião'
                                : participante['role'] == 'paid'
                                    ? 'Quitado'
                                    : '',
                            style: TextStyle(
                              color: participante['role'] == 'paid'
                                  ? ColorTheme.primaryColor.withOpacity(0.5)
                                  : ColorTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: wXD(12, context),
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(
                          left: wXD(10, context),
                        ),
                        child: Text(
                          formatedNumber(
                            user['mobile_phone_number'],
                            user['mobile_region_code'],
                          ),
                          style: TextStyle(
                            color: participante['role'] == 'paid'
                                ? Color(0xff3C3C3B).withOpacity(0.5)
                                : Color(0xff3C3C3B),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}

String formatedNumber(String value, [String rpc]) {
  int i = 0;
  List<String> newValue = value.split('');
  List<String> newlist = List();
  newlist.add('+55 ');
  if (rpc != null) newlist.add('($rpc)');

  if (newValue.length == 8) {
    newlist.add('9');
    newValue.forEach((element) {
      i++;
      newlist.add(element);
      if (i == 4) {
        newlist.add('-');
      }
    });
  } else {
    if (newValue.length == 9) {
      newValue.forEach((element) {
        i++;
        newlist.add(element);
        if (i == 5) {
          newlist.add('-');
        }
      });
    }
  }

  return newlist.join();
}
