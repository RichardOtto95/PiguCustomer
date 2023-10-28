import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ItemOrder extends StatelessWidget {
  final String price;
  final String qtdOrder;
  final String name;
  const ItemOrder({
    this.price,
    this.qtdOrder,
    this.name,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xffBDAEA7)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: wXD(34, context),
            child: Text(
              '${qtdOrder}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(15, context),
                color: ColorTheme.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // SizedBox(
          //   width: 11,
          // ),
          Container(
            width: wXD(200, context),
            child: Text(
              '$name',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(15, context),
                color: ColorTheme.textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Spacer(),
          Container(
            width: wXD(100, context),
            child: RichText(
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: wXD(15, context),
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'R\$ ',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(15, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: '$price',
                      )
                    ])),
          ),
          // Text(
          //   'R\$',
          //   style: TextStyle(
          //     fontFamily: 'Roboto',
          //     fontSize: wXD(15, context),
          //     color: ColorTheme.textColor,
          //     fontWeight: FontWeight.w300,
          //   ),
          // ),
          // SizedBox(
          //   width: 6,
          // ),
          // Text(
          //   '${price}',
          //   style: TextStyle(
          //     fontFamily: 'Roboto',
          //     fontSize: wXD(15, context),
          //     color: ColorTheme.textColor,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
          // SizedBox(
          //   width: wXD(5, context),
          // ),
        ],
      ),
    );
  }
}
