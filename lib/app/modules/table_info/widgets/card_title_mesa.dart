import 'package:pigu/app/modules/table_info/widgets/card_mesa.dart';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';

class CardTitleMesa extends StatelessWidget {
  var primaryColor = Color.fromRGBO(237, 237, 237, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  final String title;
  final String background_image;
  final String avatar;

  CardTitleMesa({Key key, this.title, this.background_image, this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: wXD(265, context),
        color: primaryColor,
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    wXD(30, context), wXD(20, context), 0, wXD(8, context)),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Em",
                        style: TextStyle(fontSize: wXD(18, context)),
                      ),
                      Text("$title",
                          style: TextStyle(
                              fontSize: wXD(34, context),
                              color: primaryText,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.only(
                    left: wXD(27, context), right: wXD(17, context)),
                child: CardMesa(
                  avatar: avatar,
                  background_image: background_image,
                )),
          ],
        ));
  }
}
