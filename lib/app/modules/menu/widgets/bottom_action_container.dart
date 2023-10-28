import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class BottomActionContainer extends StatelessWidget {
  final String items;
  final String totalPrice;
  final Function confirm;
  const BottomActionContainer(
      {Key key, this.items, this.confirm, this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: confirm,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.3,
        width: MediaQuery.of(context).size.width,
        color: ColorTheme.darkCyanBlue,
        child: Column(
          children: [
            SizedBox(height: 14),
            Container(
              height: 4,
              width: 124,
              decoration: BoxDecoration(
                  color: ColorTheme.textGrey,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                SizedBox(width: 16),
                Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorTheme.white,
                  ),
                  child: Text(
                    '$items',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'item(s)',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.white,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Text(
                  'Ver pedido',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Container(
                  height: 45,
                  width: 101,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xff2C3E50),
                      border: Border.all(color: ColorTheme.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'R\$',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xffFAFAFA),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '$totalPrice',
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xffFAFAFA),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
