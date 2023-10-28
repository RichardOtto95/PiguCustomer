import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';

class ItemOrderWithPersons extends StatelessWidget {
  final List<String> list;
  final String name;
  final num price;
  final int amountPerson;
  final String qtdOrder;
  const ItemOrderWithPersons({
    this.amountPerson,
    this.name,
    this.qtdOrder,
    this.price,
    Key key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int photoheight;
    photoheight = list.length.toInt();
    int members = amountPerson + 1;
    num value = price * members;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
          height: wXD(63, context),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: ColorTheme.textGrey),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: wXD(8, context),
              ),
              Row(
                children: [
                  Container(
                    width: wXD(34, context),
                    child: Text(
                      qtdOrder,
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
                  //   width: MediaQuery.of(context).size.width * .02,
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
                  Container(
                    width: wXD(90, context),
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
                                text: '${formatedCurrency(price)}',
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
                  //   width: wXD(6, context),
                  // ),
                  // Text(
                  //   '${price}',
                  //   style: TextStyle(
                  //     fontFamily: 'Roboto',
                  //     fontSize: wXD(16, context),
                  //     color: ColorTheme.textColor,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: wXD(24, context),
                  // ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        height: wXD(30, context),
                        child: Row(
                          children: [
                            Text(
                              'com',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(16, context),
                                color: ColorTheme.textGrey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              width: wXD(5, context),
                            ),
                            Text(
                              '+ $amountPerson',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(16, context),
                                color: ColorTheme.orange,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: wXD(15, context),
                      ),
                      Container(
                        height: wXD(32, context),
                        width: wXD(150, context),
                        padding: photoheight == 1
                            ? EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05)
                            : photoheight == 2
                                ? EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.15)
                                : photoheight == 3
                                    ? EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.25)
                                    : photoheight == 4
                                        ? EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35)
                                        : photoheight > 4
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45)
                                            : EdgeInsets.all(0),
                        margin: EdgeInsets.only(left: wXD(50, context)),
                        alignment: Alignment.centerLeft,
                        child: ImageStack(
                          imageBorderColor: ColorTheme.darkCyanBlue,
                          backgroundColor: ColorTheme.darkCyanBlue,
                          imageList: list,
                          // showTotalCount: true,
                          imageCount:
                              4, // Maximum number of images to be shown in stack
                          totalCount: list.length,
                          imageRadius: wXD(30, context),
                          // Radius of each images
                          // imageCount: haha.length / 2,
                          //     3, // Maximum number of images to be shown in stack
                          imageBorderWidth: 3, // Border width around the images
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: wXD(30, context),
          right: wXD(21, context),
          child: Transform.rotate(
            angle: -10,
            child: Container(
              height: wXD(3, context),
              width: wXD(35, context),
              color: ColorTheme.textGrey,
            ),
          ),
        ),
        Positioned(
          top: wXD(35, context),
          right: wXD(27, context),
          child: Text(
            '${1 + amountPerson}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: wXD(16, context),
              color: ColorTheme.orange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
