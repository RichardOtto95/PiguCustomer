// import 'package:pigu/app/modules/order/widgets/person_photo.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_stack/image_stack.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:intl/intl.dart';

class ItemPayTheBillWithPerson extends StatelessWidget {
  final String orderId;
  final String name;
  final num price;
  // final int amountPerson;
  final String qtdOrder;
  const ItemPayTheBillWithPerson({
    // this.amountPerson,
    this.name,
    this.qtdOrder,
    this.price,
    Key key,
    this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Modular.get<ChatController>();
    return FutureBuilder(
      future: Firestore.instance
          .collection('orders')
          .document(orderId)
          .collection('members')
          .getDocuments(),
      builder: (context, snapshotOrder) {
        if (snapshotOrder.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshotOrder.hasError) {
          return Center(
            child: Text('Erro ${snapshotOrder.error}'),
          );
        }
        if (!snapshotOrder.hasData) {
          return Container();
        }
        int qntddMembers = snapshotOrder.data.documents.length;
        int members = snapshotOrder.data.documents.length + 1;
        num value = price * members;
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
              height: wXD(80, context),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: ColorTheme.textGrey),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: wXD(12, context),
                  ),
                  Row(
                    children: [
                      Text(
                        qtdOrder,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(16, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: wXD(11, context),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.54,
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(16, context),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(right: wXD(19, context)),
                        width: wXD(120, context),
                        child: RichText(
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(16, context),
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'R\$ ',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(16, context),
                                      color: ColorTheme.textColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${formatedCurrency(value)}',
                                  )
                                ])),
                      ),
                      // Text(
                      //   'R\$',
                      //   style: TextStyle(
                      //     fontFamily: 'Roboto',
                      //     fontSize: wXD(16, context),
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
                      //   textAlign: TextAlign.end,
                      // ),
                      // SizedBox(
                      //   width: wXD(24, context),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: wXD(21, context),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: wXD(180, context),
                            height: wXD(36, context),
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
                                  '${qntddMembers}',
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
                            width: wXD(30, context),
                          ),
                          Observer(
                            builder: (context) {
                              List<String> newList =
                                  chatController.orderIdAvatares[orderId] ==
                                          null
                                      ? []
                                      : chatController.orderIdAvatares[orderId];
                              int photoHeight = newList.length;

                              return Container(
                                height: wXD(35, context),
                                width: wXD(150, context),
                                padding: photoHeight == 1
                                    ? EdgeInsets.only(left: 0)
                                    : photoHeight == 2
                                        ? EdgeInsets.only(
                                            left: wXD(25, context))
                                        : photoHeight == 3
                                            ? EdgeInsets.only(
                                                left: wXD(55, context))
                                            : photoHeight == 4
                                                ? EdgeInsets.only(
                                                    left: wXD(85, context))
                                                : photoHeight > 4
                                                    ? EdgeInsets.only(
                                                        left: wXD(90, context))
                                                    : EdgeInsets.all(0),
                                margin: EdgeInsets.only(left: wXD(60, context)),
                                alignment: Alignment.centerLeft,
                                child: ImageStack(
                                  imageBorderColor: ColorTheme.darkCyanBlue,
                                  backgroundColor: ColorTheme.darkCyanBlue,
                                  imageList: newList,
                                  imageCount: 4,
                                  totalCount: photoHeight,
                                  imageRadius: wXD(30, context),
                                  imageBorderWidth: 3,
                                ),
                              );
                            },
                          )
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
                '${1 + qntddMembers}',
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
      },
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
