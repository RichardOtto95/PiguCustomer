import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ButtonArquivarMesa extends StatelessWidget {
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  final Function archived;

  ButtonArquivarMesa({Key key, this.archived}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: wXD(25, context), vertical: wXD(10, context)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: wXD(10, context)),
          width: double.infinity,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: ColorTheme.primaryColor,
            onPressed: archived,
            child: Text("Arquivar Mesa",
                style: TextStyle(
                    fontSize: wXD(18, context),
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.white)),
            padding: EdgeInsets.all(wXD(20, context)),
          ),
          color: ColorTheme.white,
        ));
  }
}
