import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_profile_edit_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserProfileEditPage extends StatefulWidget {
  final String title;
  const UserProfileEditPage({Key key, this.title = "UserProfileEdit"})
      : super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

double wXD(double size, BuildContext context) {
  double finalSize = MediaQuery.of(context).size.width * size / 375;
  return finalSize;
}

class _UserProfileEditPageState
    extends ModularState<UserProfileEditPage, UserProfileEditController> {
  final homeController = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;

    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    var maskFormatter = new MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

    return homeController.user != null
        ? StreamBuilder(
            stream: Firestore.instance
                .collection("users")
                .document(homeController.user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                var userDocument = snapshot.data;
                return Scaffold(
                  // resizeToAvoidBottomPadding: true,
                  resizeToAvoidBottomInset: true,
                  body: Column(
                    children: <Widget>[
                      Expanded(
                          child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height),
                          child: Container(
                            height: wXD(500, context),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      top: wXD(26, context),
                                      left: wXD(10, context)),
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: wXD(170, context),
                                      top: wXD(
                                        40,
                                        context,
                                      ),
                                      bottom: wXD(12, context)),
                                  child: Text('Editar perfil',
                                      style: TextStyle(
                                          fontSize: wXD(29, context))),
                                ),
                                Container(
                                    width: wXD(300, context),
                                    child: TextFormField(
                                      initialValue: userDocument['fullname'],
                                      onChanged: (val) {
                                        controller.setName(val);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Nome Completo',
                                          labelStyle: TextStyle(
                                            color: ColorTheme.textGrey,
                                            fontSize: wXD(19, context),
                                          )),
                                    )),
                                Container(
                                    width: wXD(300, context),
                                    child: TextFormField(
                                      initialValue: userDocument['username'],
                                      onChanged: (val) {
                                        controller.setUserName(val);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Nome de usuário',
                                          labelStyle: TextStyle(
                                            color: ColorTheme.textGrey,
                                            fontSize: wXD(19, context),
                                          )),
                                    )),
                                Container(
                                    width: wXD(300, context),
                                    child: TextFormField(
                                      initialValue: userDocument['email'],
                                      onChanged: (val) {
                                        controller.setEmail(val);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            color: ColorTheme.textGrey,
                                            fontSize: wXD(19, context),
                                          )),
                                    )),
                                Container(
                                    width: wXD(300, context),
                                    child: TextFormField(
                                      inputFormatters: [maskFormatter],
                                      onChanged: (val) {
                                        val = maskFormatter.getUnmaskedText();
                                        controller.setCpf(val);
                                      },
                                      initialValue: userDocument['cpf'],
                                      decoration: InputDecoration(
                                          labelText: 'CPF',
                                          labelStyle: TextStyle(
                                            color: ColorTheme.textGrey,
                                            fontSize: wXD(19, context),
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      )),
                      Container(
                          // margin: EdgeInsets.only(bottom: wXD(70, context)),
                          width: wXD(280, context),
                          height: wXD(60, context),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.transparent)),
                            child: loadCircular
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: ColorTheme.primaryColor,
                                    ),
                                  )
                                : Text(
                                    'Salvar',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                            color: ColorTheme.primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                loadCircular = true;
                              });
                              controller.updateProfile();
                            },
                          )),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              }
            })
        : Container();
  }
}
