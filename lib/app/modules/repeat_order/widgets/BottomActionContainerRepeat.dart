import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu/shared/utilities.dart';

class BottomActionContainerRepeat extends StatelessWidget {
  final String items;
  final String totalPrice;
  final bool loadCircular;
  final Function confirm;
  const BottomActionContainerRepeat(
      {Key key, this.items, this.confirm, this.totalPrice, this.loadCircular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(20, context),
      width: MediaQuery.of(context).size.width,
      color: ColorTheme.darkCyanBlue,
      child: Column(
        children: [
          SizedBox(height: wXD(14, context)),
          Container(
            height: wXD(4, context),
            width: wXD(124, context),
            decoration: BoxDecoration(
                color: ColorTheme.textGrey,
                borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(height: wXD(2, context)),
          Row(
            children: [
              SizedBox(width: wXD(16, context)),
              Container(
                height: wXD(36, context),
                width: wXD(36, context),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorTheme.white,
                ),
                child: Text(
                  '$items',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(16, context),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: wXD(6, context)),
              Text(
                'item(s)',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(16, context),
                  color: ColorTheme.white,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                height: wXD(45, context),
                // width: wXD(101, context),
                padding: EdgeInsets.symmetric(horizontal: wXD(10, context)),
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
                        fontSize: wXD(16, context),
                        color: Color(0xffFAFAFA),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: wXD(4, context)),
                    Text(
                      '$totalPrice',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: Color(0xffFAFAFA),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(width: wXD(14, context)),
            ],
          ),
          SizedBox(height: wXD(10, context)),
          loadCircular
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorTheme.primaryColor),
                  ),
                )
              : InkWell(
                  onTap: confirm,
                  child: Container(
                    height: wXD(49, context),
                    width: wXD(283, context),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: ColorTheme.primaryColor,
                    ),
                    child: Text(
                      'Repetir Pedido',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
