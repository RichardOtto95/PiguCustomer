import 'package:pigu/app/modules/home/home_widget.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/utilities.dart';
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
    return Container(
      height: wXD(148, context),
      width: MediaQuery.of(context).size.width,
      color: ColorTheme.darkCyanBlue,
      child: Column(
        children: [
          SizedBox(height: wXD(21, context)),
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
                    color: ColorTheme.brown,
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
                padding: EdgeInsets.symmetric(horizontal: wXD(15, context)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorTheme.darkCyanBlue,
                  border: Border.all(color: Color(0xff95989A)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R\$',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.white,
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
                        color: ColorTheme.white,
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
          InkWell(
            onTap: confirm,
            child: Container(
              height: wXD(61, context),
              width: wXD(283, context),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: ColorTheme.primaryColor,
              ),
              child: Text(
                'Fazer pedido',
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
