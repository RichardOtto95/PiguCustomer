import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ChatBubbleLeft extends StatelessWidget {
  final String title;
  const ChatBubbleLeft({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 82.0,
      width: wXD(82, context),
      // height: 80.0,
      height: wXD(70, context),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(15, 8, 42, 8),
      decoration: BoxDecoration(
        // border: Border.all(color: Color(0xff95A5A6)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: ColorTheme.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            children: [
              SizedBox(
                width: wXD(24, context),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * .7,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(14, context),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Spacer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       height: 37,
          //       width: 170,
          //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), color: ColorTheme.orange),
          //       child: Center(
          //         child: Text(
          //           "Enviar para a cozinha",
          //           style: TextStyle(
          //             fontFamily: 'Roboto',
          //             fontSize: 12,
          //             color: ColorTheme.textColor,
          //             fontWeight: FontWeight.w700,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
