import 'package:pigu/shared/color_theme.dart';
import "package:flutter/material.dart";

class NotifyContainer extends StatefulWidget {
  NotifyContainer({Key key}) : super(key: key);

  @override
  _NotifyContainerState createState() => _NotifyContainerState();
}

class _NotifyContainerState extends State<NotifyContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 42.0,
          height: 54.0,
          margin: EdgeInsets.only(top: 1, right: 10),
          padding: EdgeInsets.only(top: 2, left: 3, right: 3, bottom: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(21.0),
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(58.0),
              bottomLeft: Radius.circular(21.0),
            ),
            color: const Color(0xfffed6a5),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Image.asset(
            'assets/icon/notify.png',
            height: 20,
            width: 20,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 23,
            width: 23,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: ColorTheme.purple),
            child: Center(
              child: Text(
                '4',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        )
      ],
    );
  }
}

/* Container(
              width: 23.0,
              height: 23.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: ColorTheme.purple,
              ),
            ) */
