import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/modules/user_profile/widgets/card_profile.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileView extends StatelessWidget {
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryColor = Color.fromRGBO(250, 250, 250, 1);
  var anfitriaoText = Color(0xff95A5A6);
  var personText = Color(0xffD0D2D2);
  var todosPagaram = false;
  var pagou = true;
  final checkHost;
  final group;
  final String userView;
  final Function showMenu;
  // bool checkHost = false;
  ProfileView({
    this.checkHost,
    this.group,
    this.showMenu,
    @required this.userView,
  });

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('users').document(userView).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var userDocument = snapshot.data;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Modular.to.pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: ColorTheme.primaryColor,
                    size: wXD(40, context),
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(),
                      child: CardProfile(
                        id: userDocument['id'],
                        username: userDocument['username'],
                        avatar: userDocument['avatar'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: wXD(15, context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: wXD(10, context),
                      left: wXD(40, context),
                      right: 0,
                      bottom: wXD(20, context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Olá!",
                          style: TextStyle(
                              color: ColorTheme.darkCyanBlue,
                              fontSize: wXD(36, context),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${userDocument['username']}',
                          style: TextStyle(
                              color: ColorTheme.textColor,
                              fontSize: wXD(36, context),
                              fontWeight: FontWeight.w300),
                          maxLines: 2,
                        ),
                        userDocument['email'] != null
                            ? Container(
                                width: wXD(200, context),
                                child: Text(
                                  '${userDocument['email']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: wXD(16, context),
                                    fontWeight: FontWeight.w300,
                                    color: ColorTheme.textGrey,
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: wXD(25, context),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: wXD(200, context),
                      height: wXD(2, context),
                      color: ColorTheme.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: wXD(25, context),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
