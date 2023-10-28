import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/chat/widgets/person_photo.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';
import '../../user_profile/user_profile_page.dart';

class ChatInvitationHost extends StatelessWidget {
  final Function onSetState;
  final String status;
  final String inviteHost;
  final DocumentSnapshot dss;
  final Timestamp date;
  final String authorID;
  final String groupID;
  final bool answer;

  const ChatInvitationHost({
    Key key,
    this.groupID,
    this.authorID,
    this.date,
    this.dss,
    this.inviteHost,
    this.status,
    this.answer,
    this.onSetState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();

    double marRight = 50;
    double marLeft = 15;
    double bottomRight = 24;
    double bottomLeft = 8;

    bool verificTwo = inviteHost == homeController.user.uid;
    bool verific = authorID == homeController.user.uid;
    if (verific) {
      marRight = 15;
      marLeft = 50;
      bottomRight = 8;
      bottomLeft = 24;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(
          wXD(16, context), wXD(9, context), wXD(3, context), wXD(9, context)),
      margin: EdgeInsets.fromLTRB(wXD(marLeft, context), wXD(8, context),
          wXD(marRight, context), wXD(8, context)),
      decoration: BoxDecoration(
        // border: Border.all(color: Color(0xff95A5A6)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(bottomRight),
          bottomLeft: Radius.circular(bottomLeft),
        ),
        color: Color(0xfffafafa),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(authorID)
                .snapshots(),
            builder: (context, snapshotHost) {
              if (snapshotHost.connectionState == ConnectionState.waiting) {
                return new Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                ));
              } else {
                if (snapshotHost.hasError)
                  return new Text('Error: ${snapshotHost.error}');
                else {
                  if (snapshotHost.hasData) {
                    DocumentSnapshot ds = snapshotHost.data;
                    String userhost = ds.data['username'];
                    if (ds.data['username'].length > 15) {
                      userhost = '${ds.data['username'].substring(0, 15)}...';
                    }
                    return Row(
                      children: [
                        PersonPhoto(
                          urlImage: ds.data['avatar'],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          userhost,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          answer == null
                              ? " quer promover"
                              : answer == true
                                  ? ' promoveu'
                                  : ' quis promover',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: ColorTheme.textGrey,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              }
            },
          ),
          SizedBox(height: wXD(10, context)),
          StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(inviteHost)
                .snapshots(),
            builder: (context, snapshotUser) {
              if (snapshotUser.connectionState == ConnectionState.waiting) {
                return new Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                  ),
                );
              } else {
                if (snapshotUser.hasError)
                  return new Text('Error: ${snapshotUser.error}');
                else {
                  if (snapshotUser.hasData) {
                    DocumentSnapshot ds = snapshotUser.data;
                    String username = ds.data['username'];
                    if (ds.data['username'].length > 15) {
                      username = '${ds.data['username'].substring(0, 15)}...';
                    }
                    return Row(
                      children: [
                        PersonPhoto(
                          urlImage: ds.data['avatar'],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          // "como anfitrião",
                          answer == null
                              ? " como anfitrião"
                              : answer == true
                                  ? ' a anfitrião'
                                  : ' a anfitrião',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: ColorTheme.textGrey,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    );
                  } else
                    return Container();
                }
              }
            },
          ),
          Visibility(
            visible: verificTwo && status == 'awaiting',
            child: Column(children: [
              SizedBox(height: wXD(30, context)),
              Text(
                "Você aceita?",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textGrey,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: wXD(30, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // onTapNo();
                      Firestore.instance
                          .collection('groups')
                          .document(groupID)
                          .get()
                          .then((group) {
                        group.reference.updateData({'user_host_invited': null});
                        dss.reference.updateData({'status': 'refused'});
                      });
                    },
                    child: Container(
                        height: wXD(37, context),
                        width: wXD(96, context),
                        margin: EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          color: Color(0xfffafafa),
                          border: Border.all(color: ColorTheme.primaryColor),
                          borderRadius: BorderRadius.circular(21),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Não',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: ColorTheme.textColor,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      // onTapYes();
                      Firestore.instance
                          .collection('groups')
                          .document(groupID)
                          .get()
                          .then((group) {
                        group.reference.updateData(
                            {'user_host': group.data['user_host_invited']});
                        group.reference.updateData({'user_host_invited': null});
                        dss.reference.updateData({'status': 'accept'});
                      });
                    },
                    child: Container(
                        height: wXD(37, context),
                        width: wXD(96, context),
                        margin: EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                          color: ColorTheme.primaryColor,
                          borderRadius: BorderRadius.circular(21),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Sim!',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Color(0xfffafafa),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: wXD(30, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${date.toDate().hour.toString().padLeft(2, '0')}:${date.toDate().minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: ColorTheme.primaryColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: wXD(13, context))
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
