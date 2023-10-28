import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/modules/root/root_controller.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/user_profile/widgets/button_alterar_senha.dart';
import 'package:pigu/app/modules/user_profile/widgets/card_profile.dart';
import 'package:pigu/app/modules/user_profile/widgets/switch_notificacoes.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_alert/rich_alert.dart';
import 'user_profile_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class UserProfilePage extends StatefulWidget {
  final String title;
  const UserProfilePage({Key key, this.title = "UserProfile"})
      : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

double wXD(double size, BuildContext context) {
  double finalSize = MediaQuery.of(context).size.width * size / 375;
  return finalSize;
}

class _UserProfilePageState
    extends ModularState<UserProfilePage, UserProfileController> {
  //use 'controller' variable to access controller
  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  // final Firestore _db = Firestore.instance;
  final rootController = Modular.get<RootController>();
  var authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();
  var notificationActive = true;

  File _imageFile;

  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });

    if (_imageFile != null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/avatar/${_imageFile.path[0]}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
        (value) {
          Firestore.instance
              .collection("users")
              .document(user.uid)
              .updateData({'avatar': value});

          homeController.getuserDB(user);
        },
      );
    }
  }

  logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new RichAlertDialog(
        alertTitle: richTitle("Deseja deslogar?"),
        alertSubtitle: richSubtitle("Sua conta será deslogada!"),
        alertType: RichAlertType.WARNING,
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text('Não'),
          ),
          new FlatButton(
            onPressed: () {
              authController.setCodeSent(false);
              rootController.setSelectedTrunk(1);
              authController.signout();
              Modular.to.pushNamed('/');
            },
            child: new Text('Sim'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: Container(
                padding: EdgeInsets.only(
                    top: wXD(12, context), left: wXD(12, context)),
                child: InkWell(
                  onTap: () {
                    Modular.to.pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: ColorTheme.primaryColor,
                    size: wXD(35, context),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(top: 10, left: 40, right: 0, bottom: 20),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(homeController.user.uid)
                      .snapshots(),
                  builder: (context, snapshotUser) {
                    if (!snapshotUser.hasData) {
                      return Container();
                    } else {
                      DocumentSnapshot user = snapshotUser.data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: InkWell(
                                  onTap: () async {
                                    await pickImage();
                                  },
                                  child: CardProfile(
                                      id: user.data['id'],
                                      username: user.data['username'],
                                      photo: user.data['avatar']),
                                ),
                                padding: EdgeInsets.only(right: 40),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá!",
                                style: TextStyle(
                                    color: ColorTheme.darkCyanBlue,
                                    fontSize:
                                        MediaQuery.of(context).size.width * .09,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user.data['username'],
                                style: TextStyle(
                                    color: ColorTheme.textColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width * .09,
                                    fontWeight: FontWeight.w300),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 45),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: wXD(230, context),
                                        child: Visibility(
                                          visible: user.data['email'] != null,
                                          child: Text(
                                            '${user.data['email']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                color: ColorTheme.textGrey),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 54,
                                          height: 42,
                                          child: FlatButton(
                                              color: ColorTheme.blueCyan,
                                              padding: EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(30),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                              ),
                                              onPressed: () {
                                                Modular.to.pushNamed(
                                                    '/user-profile-edit');
                                              },
                                              child: Icon(Icons.edit,
                                                  color: Color(0xfffafafa)))),
                                    ],
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 2,
                                margin: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * .4),
                                color: ColorTheme.primaryColor,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text("Notificações",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .05,
                                                    color:
                                                        ColorTheme.textGrey))),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            logout(context);

                                            // Modular.to.pushNamed('/');
                                          },
                                          child: Text("Sair",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .05,
                                                  color: ColorTheme.textGrey,
                                                  fontWeight: FontWeight.w400)),
                                        ),

                                        // ButtonAlterarSenha()
                                      ]),
                                  StreamBuilder<Object>(
                                      stream: Firestore.instance
                                          .collection('users')
                                          .document(homeController.user.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'ERRO: ${snapshot.error}'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  ColorTheme.primaryColor,
                                            ),
                                          );
                                        }
                                        DocumentSnapshot ds = snapshot.data;
                                        notificationActive =
                                            ds['notification_enabled'];
                                        return Switch(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            activeColor:
                                                ColorTheme.primaryColor,
                                            value: notificationActive,
                                            onChanged: (v) async {
                                              ds.reference.updateData(
                                                  {'notification_enabled': v});
                                            });
                                      })
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            ))),
      );
    });
  }
}

// )
// : Container();
//   }
// }
