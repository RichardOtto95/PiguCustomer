import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../chat_controller.dart';

class ChatBubbleRight extends StatelessWidget {
  final String authorId;
  final bool host;
  final String orderID;
  final Function onTapp;
  final bool haveNote;
  final Timestamp date;
  final dss;

  const ChatBubbleRight({
    Key key,
    this.date,
    this.haveNote,
    this.onTapp,
    this.orderID,
    this.authorId,
    this.host,
    this.dss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Modular.get<ChatController>();

    double bottomRight = 8;
    double bottomLeft = 24;
    double marLeft = 75;
    double marRight = 15;
    double height = 200;
    if (!host) {
      bottomRight = 24;
      bottomLeft = 8;
      marLeft = 15;
      marRight = 75;
      height = 230;
    }

    return Container(
      width: wXD(62, context),
      height: wXD(height, context),
      padding: EdgeInsets.symmetric(
          horizontal: wXD(14, context), vertical: wXD(9, context)),
      margin: EdgeInsets.fromLTRB(wXD(marLeft, context), wXD(8, context),
          wXD(marRight, context), wXD(8, context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(bottomRight),
          bottomLeft: Radius.circular(bottomLeft),
        ),
        color: host ? ColorTheme.textGrey : ColorTheme.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(authorId)
            .snapshots(),
        builder: (context, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return new Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
            ));
          } else {
            if (userSnap.hasError)
              return new Text('Error: ${userSnap.error}');
            else {
              if (userSnap.hasData) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('orders')
                        .document(orderID)
                        .collection('cart_item')
                        .snapshots(),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData) {
                        return Container();
                      } else if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(ColorTheme.yellow),
                          ),
                        );
                      } else {
                        var cart = snapshot2.data.documents[0].data;
                        int itemAmount = cart['ordered_amount'].toInt();
                        String title = cart['title'];
                        String listingID = cart['listing_id'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            host
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: wXD(14, context),
                                      ),
                                      Text(
                                        "Acabei de pedir",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: wXD(5, context),
                                      ),
                                      Text(
                                        '$itemAmount ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(15, context),
                                          color: ColorTheme.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: wXD(350, context),
                                            child: Text(
                                              userSnap.data['username'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: wXD(16, context),
                                                color: ColorTheme.textColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: wXD(22, context),
                                              ),
                                              Text(
                                                "Acabei de pedir",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: wXD(16, context),
                                                  color: ColorTheme.textColor,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: wXD(5, context),
                                              ),
                                              Text(
                                                '$itemAmount ',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: wXD(15, context),
                                                  color: ColorTheme.textColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          )
                                        ]),
                                  ),
                            SizedBox(
                              height: wXD(10, context),
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('listings')
                                  .document(listingID)
                                  .snapshots(),
                              builder: (context, snapshot3) {
                                if (!snapshot3.hasData) {
                                  return Container();
                                } else if (snapshot3.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          ColorTheme.yellow),
                                    ),
                                  );
                                } else {
                                  DocumentSnapshot listing = snapshot3.data;

                                  String imageURL = listing.data['image'];
                                  if (imageURL == null) {
                                    imageURL =
                                        'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg';
                                  }
                                  return Container(
                                    padding: EdgeInsets.only(
                                        right: wXD(50, context)),
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () => chatController
                                              .functionRepeatOrder(
                                            sellerId: dss['seller_id'],
                                            groupId: dss['group_id'],
                                            itemId: listing['id'],
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: wXD(100, context),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x29000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: imageURL,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          ColorTheme.yellow),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                        haveNote == false
                                            ? Container()
                                            : Positioned(
                                                top: wXD(5, context),
                                                right: wXD(5, context),
                                                child: InkWell(
                                                  onTap: onTapp,
                                                  child: Container(
                                                    width: wXD(54, context),
                                                    height: wXD(42, context),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                21.0),
                                                        topRight:
                                                            Radius.circular(
                                                                21.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                21.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                58.0),
                                                      ),
                                                      color:
                                                          ColorTheme.blueCyan,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                              0x29000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Obs.',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize:
                                                              wXD(16, context),
                                                          color:
                                                              ColorTheme.white,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: wXD(11, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Text(
                                //   '$itemAmount ',
                                //   style: TextStyle(
                                //     fontFamily: 'Roboto',
                                //     fontSize: wXD(15, context),
                                //     color: ColorTheme.white,
                                //     fontWeight: FontWeight.w700,
                                //   ),
                                //   textAlign: TextAlign.start,
                                // ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.height * .01,
                                // ),
                                Container(
                                  width: wXD(250, context),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(15, context),
                                      color: ColorTheme.textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  // "${date.toDate().hour}:${date.toDate().minute}",
                                  "${date.toDate().hour.toString().padLeft(2, '0')}:${date.toDate().minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: wXD(10, context),
                                    color: host
                                        ? ColorTheme.white
                                        : ColorTheme.primaryColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        );
                      }
                    });
              } else
                return Container();
            }
          }
        },
      ),
    );
  }
}
