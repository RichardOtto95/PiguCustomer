import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/table_info/widgets/profile_view.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FloatMenu extends StatelessWidget {
  final String group;
  final String click;
  final Function tapProfileView;
  final Function tapPromoteHoster;
  final Function tapPartialCheck;
  final String userView;
  FloatMenu(
      {Key key,
      this.click,
      this.tapProfileView,
      this.tapPromoteHoster,
      this.tapPartialCheck,
      this.userView,
      this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final openTableController = Modular.get<OpenTableController>();
    final homeController = Modular.get<HomeController>();
    return StreamBuilder(
      stream:
          Firestore.instance.collection("groups").document(group).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var userDocument = snapshot.data;
          bool host = userDocument['user_host'] == homeController.user.uid;
          bool you = userView == homeController.user.uid;
          bool hostAndYou = host == you;
          return Container(
            width: wXD(200, context),
            height: !host
                ? wXD(40, context)
                : hostAndYou
                    ? wXD(85, context)
                    : wXD(125, context),
            // height: !hostAndYou
            //     ? wXD(125, context)
            //     : host
            //         ? wXD(85, context)
            //         : wXD(40, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileView(
                              userView: openTableController.userView,
                            );
                          },
                        ),
                      );
                      // }
                    },
                    child: FloatMenuButton(
                        title: "Visualizar Perfil", onTap: tapProfileView)),
                openTableController.clickLabel == 'PromoteHoster'
                    ? Container()
                    : host && !you
                        ? StreamBuilder(
                            stream: Firestore.instance
                                .collection("order_sheets")
                                .where('user_id',
                                    isEqualTo: openTableController.userView)
                                .where('group_id', isEqualTo: group)
                                .snapshots(),
                            builder: (context, snapshotValid) {
                              return InkWell(
                                  onTap: () async {
                                    if (snapshotValid.data.documents.first
                                            .data['status'] ==
                                        'awaiting_checkout') {
                                      Fluttertoast.showToast(
                                          msg: "Usuário pediu/quitou mesa",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: ColorTheme.orange,
                                          textColor: ColorTheme.white,
                                          fontSize: wXD(16, context));
                                    } else {
                                      homeController.setPromotehost(true);
                                      openTableController
                                          .setClickLabelTableInfo(
                                              'PromoteHoster');

                                      DocumentSnapshot _user = await Firestore
                                          .instance
                                          .collection('users')
                                          .document(
                                              openTableController.userView)
                                          .get();

                                      Firestore.instance
                                          .collection('groups')
                                          .document(group)
                                          .updateData({
                                        'user_host_invited': _user.documentID
                                      });
                                      QuerySnapshot ref4 = await Firestore
                                          .instance
                                          .collection("chats")
                                          .where('group_id', isEqualTo: group)
                                          .getDocuments();

                                      ref4.documents[0].reference
                                          .collection("messages")
                                          .add({
                                        'author_id': homeController.user.uid,
                                        'invite_host': _user.documentID,
                                        'group_id': group,
                                        'status': 'awaiting',
                                        'created_at': Timestamp.now(),
                                        'text':
                                            'Usuario anfitriao criada com sucesso!',
                                        'type': 'user_host_invited',
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                              "Convite de anfitrião enviado para ${_user.data['fullname'] != null ? _user.data['fullname'] : _user.data['mobile_phone_number']}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: ColorTheme.orange,
                                          textColor: ColorTheme.white,
                                          fontSize: wXD(16, context));
                                    }
                                  },
                                  child: FloatMenuButton(
                                      title: "Promover a Anfitrião",
                                      onTap: tapPromoteHoster));
                            })
                        : Container(),
                openTableController.clickLabel == 'PartialCheck'
                    ? Container()
                    : host
                        ? InkWell(
                            onTap: () {
                              openTableController
                                  .setClickLabelTableInfo('PartialCheck');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Text("PARTIALCHECKPATH???");
                                  },
                                ),
                              );
                            },
                            child: FloatMenuButton(
                                title: "Ver Comanda Parcial",
                                onTap: tapPartialCheck))
                        : Container()
              ],
            ),
          );
        }
      },
    );
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: wXD(39, context),
        padding: EdgeInsets.only(left: wXD(14, context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(16, context),
                color: ColorTheme.textGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
