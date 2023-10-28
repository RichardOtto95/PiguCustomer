import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ContainerReabrir extends StatelessWidget {
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  final Function reopen;

  ContainerReabrir({Key key, this.reopen}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width,
        color: ColorTheme.darkCyanBlue,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Container(
            color: Colors.grey[300],
            height: 3,
            width: 120,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Text(
                "Conta Fechada",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Spacer(),
              FlatButton(
                shape: new RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed: reopen,
                textColor: Colors.white,
                color: ColorTheme.darkCyanBlue,
                child: Text("Reabrir", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            ],
          )
        ]));
  }
}
