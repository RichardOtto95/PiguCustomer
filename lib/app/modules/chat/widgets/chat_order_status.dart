import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu/shared/utilities.dart';

import '../chat_controller.dart';

class ChatOrderStatus extends StatelessWidget {
  final String sellerId;
  final String orderId;
  final String userId;
  final String text;
  final String note;
  final String clientNote;
  final bool haveNote;
  final Function onTapp;
  final Timestamp date;
  final dss;

  ChatOrderStatus({
    Key key,
    this.userId,
    this.date,
    this.text,
    this.orderId,
    this.note,
    this.clientNote,
    this.haveNote,
    this.onTapp,
    this.sellerId,
    this.dss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Modular.get<ChatController>();

    return Container(
      height: wXD(320, context),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('orders')
            .document(orderId)
            .collection('cart_item')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
              ),
            );
          } else {
            var cart = snapshot.data.documents[0].data;

            return Container(
              width: wXD(62, context),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              margin: EdgeInsets.fromLTRB(
                wXD(15, context),
                wXD(8, context),
                wXD(60, context),
                wXD(8, context),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                  bottomLeft: Radius.circular(8.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: wXD(274, context),
                    height: wXD(26, context),
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('sellers')
                            .document(sellerId)
                            .snapshots(),
                        builder: (context, sellerSnap) {
                          if (!sellerSnap.hasData) return Container();
                          DocumentSnapshot ss = sellerSnap.data;
                          if (sellerSnap.hasData) {
                            return Text(
                              ss.data['name'],
                              // 'TESTE',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  Row(
                    children: [
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .document(userId)
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
                            String _userName = snapshot2.data['username'];
                            ;
                            if (_userName.length > 25) {
                              _userName.substring(0, 25);
                            }
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 15,
                                    color: ColorTheme.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: _userName,
                                    ),
                                    TextSpan(
                                        text: ', seu \npedido de ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    TextSpan(
                                        text:
                                            '${cart['ordered_amount'].toInt()}',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ]),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: wXD(10, context),
                  ),
                  Stack(children: [
                    Container(
                      width: wXD(204, context),
                      height: wXD(100, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
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
                            .collection('listings')
                            .document(cart['listing_id'])
                            .snapshots(),
                        builder: (context, snapshot3) {
                          if (!snapshot3.hasData) {
                            return Container();
                          } else if (snapshot3.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorTheme.yellow),
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () => chatController.functionRepeatOrder(
                                sellerId: dss['seller_id'],
                                groupId: dss['group_id'],
                                itemId: snapshot3.data['id'],
                              ),
                              child: Container(
                                width: 204,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot3.data['image'],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          ColorTheme.yellow),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    haveNote == false
                        ? Container()
                        : Positioned(
                            top: 5,
                            right: 5,
                            child: InkWell(
                              onTap: onTapp,
                              child: Container(
                                width: wXD(54, context),
                                height: wXD(42, context),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(21.0),
                                    topRight: Radius.circular(21.0),
                                    bottomRight: Radius.circular(21.0),
                                    bottomLeft: Radius.circular(58.0),
                                  ),
                                  color: ColorTheme.blueCyan,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
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
                                      fontSize: 16,
                                      color: ColorTheme.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                  ]),
                  SizedBox(height: wXD(15, context)),
                  Container(
                    width: wXD(274, context),
                    child: Text(
                      cart['title'],
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: wXD(8, context)),
                  Center(
                    child: Container(
                      width: wXD(300, context),
                      height: wXD(1, context),
                      color: ColorTheme.textGrey.withOpacity(.3),
                    ),
                  ),
                  SizedBox(height: wXD(8, context)),
                  Row(
                    children: [
                      Text(
                        "${text}",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: wXD(8, context)),
                  note != null && note != ''
                      ? InkWell(
                          onTap: () {
                            return Fluttertoast.showToast(
                                msg: "$note",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: ColorTheme.blueCyan,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: wXD(260, context),
                            child: Text(
                              "${note}",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      : Text(
                          "Sem observação!",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${date.toDate().hour.toString().padLeft(2, '0')}:${date.toDate().minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          color: ColorTheme.orange,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// class ChatOrderStatus extends StatefulWidget {
//   final String orderId;
//   final String userId;
//   final String text;
//   final String note;
//   final String clientNote;
//   final bool haveNote;
//   final Function onTapp;
//   final Timestamp date;

//   const ChatOrderStatus({
//     Key key,
//     this.userId,
//     this.date,
//     this.text,
//     this.orderId,
//     this.note,
//     this.clientNote,
//     this.haveNote,
//     this.onTapp,
//   }) : super(key: key);

//   @override
//   _ChatOrderStatusState createState() => _ChatOrderStatusState();
// }

// class _ChatOrderStatusState extends State<ChatOrderStatus> {
//   Future<dynamic> task;
//   List<String> listAvatar = [];

//   // @override
//   // void initState() {
//   //   task = getMembers();

//   //   super.initState();
//   // }

//   Future<dynamic> getMembers() async {
//     QuerySnapshot amigos = await Firestore.instance
//         .collection('orders')
//         .document(widget.orderId)
//         .collection('members')
//         .getDocuments();

//     amigos.documents.forEach((element) async {
//       DocumentSnapshot _amigo = await Firestore.instance
//           .collection('users')
//           .document(element.data['user_id'])
//           .get();
//       await listAvatar.add(_amigo.data['avatar']);
//     });

//     await Future.delayed(Duration(seconds: 1));

//     return listAvatar;
//   }

//   // @override
//   // void dispose() {
//   //   // homeController.setStatusOrder('');
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Firestore.instance
//           .collection('orders')
//           .document(widget.orderId)
//           .collection('cart_item')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
//             ),
//           );
//         } else {
//           var cart = snapshot.data.documents[0].data;

//           return Container(
//             width: 62.0,
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//             margin: EdgeInsets.fromLTRB(15, 8, 42, 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24.0),
//                 topRight: Radius.circular(24.0),
//                 bottomRight: Radius.circular(24.0),
//                 bottomLeft: Radius.circular(8.0),
//               ),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0x29000000),
//                   offset: Offset(0, 3),
//                   blurRadius: 6,
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     StreamBuilder(
//                       stream: Firestore.instance
//                           .collection('users')
//                           .document(widget.userId)
//                           .snapshots(),
//                       builder: (context, snapshot2) {
//                         if (!snapshot2.hasData) {
//                           return Container();
//                         } else if (snapshot2.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(
//                               valueColor:
//                                   AlwaysStoppedAnimation(ColorTheme.yellow),
//                             ),
//                           );
//                         } else {
//                           String userName;

//                           userName = snapshot2.data['username'];

//                           return Container(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             child: Text(
//                               userName,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: TextStyle(
//                                 fontFamily: 'Roboto',
//                                 fontSize: 16,
//                                 color: ColorTheme.textColor,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       "${widget.text}",
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 16,
//                         color: ColorTheme.textGrey,
//                         fontWeight: FontWeight.w300,
//                       ),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//                 widget.note != null && widget.note != ''
//                     ? Row(
//                         children: [
//                           SizedBox(
//                             width: 14,
//                           ),
//                           Container(
//                             alignment: Alignment.centerLeft,
//                             width: MediaQuery.of(context).size.width * .7,
//                             child: Text(
//                               "${widget.note}",
//                               style: TextStyle(
//                                 fontFamily: 'Roboto',
//                                 fontSize: 16,
//                                 color: ColorTheme.textGrey,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                               textAlign: TextAlign.start,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ],
//                       )
//                     : SizedBox(),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     Stack(children: [
//                       Container(
//                         width: 204,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0x29000000),
//                               offset: Offset(0, 3),
//                               blurRadius: 6,
//                             ),
//                           ],
//                         ),
//                         child: StreamBuilder(
//                           stream: Firestore.instance
//                               .collection('listings')
//                               .document(cart['listing_id'])
//                               .snapshots(),
//                           builder: (context, snapshot3) {
//                             if (!snapshot3.hasData) {
//                               return Container();
//                             } else if (snapshot3.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   valueColor:
//                                       AlwaysStoppedAnimation(ColorTheme.yellow),
//                                 ),
//                               );
//                             } else {
//                               return ClipRRect(
//                                 borderRadius: BorderRadius.circular(14),
//                                 child: CachedNetworkImage(
//                                   fit: BoxFit.cover,
//                                   imageUrl: snapshot3.data['image'],
//                                   placeholder: (context, url) =>
//                                       CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation(
//                                         ColorTheme.yellow),
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       Icon(Icons.error),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       widget.haveNote == false
//                           ? Container()
//                           : Positioned(
//                               top: 5,
//                               right: 5,
//                               child: InkWell(
//                                 onTap: widget.onTapp,
//                                 child: Container(
//                                   width: 54,
//                                   height: 42,
//                                   padding: EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(21.0),
//                                       topRight: Radius.circular(21.0),
//                                       bottomRight: Radius.circular(21.0),
//                                       bottomLeft: Radius.circular(58.0),
//                                     ),
//                                     color: ColorTheme.blueCyan,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(0x29000000),
//                                         offset: Offset(0, 3),
//                                         blurRadius: 6,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Obs.',
//                                       style: TextStyle(
//                                         fontFamily: 'Roboto',
//                                         fontSize: 16,
//                                         color: ColorTheme.white,
//                                         fontWeight: FontWeight.w300,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                     ]),
//                   ],
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.02,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       '${cart['ordered_amount'].toInt()} ',
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 15,
//                         color: ColorTheme.textColor,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.start,
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.height * .01,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * .65,
//                       child: Text(
//                         cart['title'],
//                         style: TextStyle(
//                           fontFamily: 'Roboto',
//                           fontSize: 15,
//                           color: ColorTheme.textColor,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 6,
//                 ),
//                 // StreamBuilder(
//                 //     stream: Firestore.instance
//                 //         .collection('orders')
//                 //         .document(widget.orderId)
//                 //         .collection('members')
//                 //         .snapshots(),
//                 //     builder: (context, snapshotOrder) {
//                 //       if (snapshotOrder.hasData) {
//                 //         if (snapshotOrder.connectionState ==
//                 //             ConnectionState.waiting) {
//                 //           return Center(
//                 //             child: CircularProgressIndicator(
//                 //               valueColor:
//                 //                   AlwaysStoppedAnimation(ColorTheme.yellow),
//                 //             ),
//                 //           );
//                 //         } else {
//                 //           List<String> listAvatar = [];

//                 //           if (!snapshotOrder.data.documents.isEmpty) {
//                 //             QuerySnapshot qs = snapshotOrder.data;

//                 //             qs.documents.forEach((userID) async {
//                 //               DocumentSnapshot user = await Firestore.instance
//                 //                   .collection('users')
//                 //                   .document(userID.data['user_id'])
//                 //                   .get();
//                 //               listAvatar.add(user.data['avatar']);
//                 //             });

//                 //             int photoheight = listAvatar.length;

//                 //             return Row(children: [
//                 //               SizedBox(
//                 //                 width: 15,
//                 //               ),
//                 //               Container(
//                 //                 width: 180,
//                 //                 height: 36,
//                 //                 child: Row(
//                 //                   children: [
//                 //                     Container(
//                 //                       padding: EdgeInsets.only(right: 10),
//                 //                       child: Text(
//                 //                         'com',
//                 //                         style: TextStyle(
//                 //                           fontFamily: 'Roboto',
//                 //                           fontSize: 16,
//                 //                           color: ColorTheme.textGrey,
//                 //                           fontWeight: FontWeight.w300,
//                 //                         ),
//                 //                       ),
//                 //                     ),
//                 //                     SizedBox(
//                 //                       width: 5,
//                 //                     ),
//                 //                     // FutureBuilder(
//                 //                     //     future: task,
//                 //                     //     builder: (context, snapshot) {
//                 //                     //       if (snapshot.connectionState ==
//                 //                     //           ConnectionState.waiting) {
//                 //                     //         return new Center(
//                 //                     //             child:
//                 //                     //                 CircularProgressIndicator(
//                 //                     //           valueColor:
//                 //                     //               AlwaysStoppedAnimation(
//                 //                     //                   ColorTheme.yellow),
//                 //                     //         ));
//                 //                     //       } else {
//                 //                     //         if (snapshot.hasError)
//                 //                     //           return new Text(
//                 //                     //               'Error: ${snapshot.error}');
//                 //                     //         else {
//                 //                     //           if (snapshot.hasData) {
//                 //                     //             double leftPadding = 0;
//                 //                     //             if (listAvatar.length < 5) {
//                 //                     //               leftPadding = (18 *
//                 //                     //                       listAvatar.length
//                 //                     //                           .toDouble()) -
//                 //                     //                   13;
//                 //                     //             } else {
//                 //                     //               leftPadding = 85;
//                 //                     //             }
//                 //                     //             return Container(
//                 //                     //                 padding: EdgeInsets.only(
//                 //                     //                     left: wXD(leftPadding,
//                 //                     //                         context)),
//                 //                     //                 alignment:
//                 //                     //                     Alignment.centerLeft,
//                 //                     //                 child: ImageStack(
//                 //                     //                   imageList: listAvatar,
//                 //                     //                   imageCount: 4,
//                 //                     //                   totalCount:
//                 //                     //                       listAvatar.length,
//                 //                     //                   imageRadius:
//                 //                     //                       wXD(30, context),
//                 //                     //                   imageBorderWidth: 1,
//                 //                     //                 ));
//                 //                     //           } else
//                 //                     //             return Container();
//                 //                     //         }
//                 //                     //       }
//                 //                     //     }),
//                 //                     // Container(
//                 //                     //   padding: photoheight == 1
//                 //                     //       ? EdgeInsets.only(left: 0)
//                 //                     //       : photoheight == 2
//                 //                     //           ? EdgeInsets.only(left: 25)
//                 //                     //           : photoheight == 3
//                 //                     //               ? EdgeInsets.only(left: 55)
//                 //                     //               : photoheight == 4
//                 //                     //                   ? EdgeInsets.only(
//                 //                     //                       left: 85)
//                 //                     //                   : photoheight > 4
//                 //                     //                       ? EdgeInsets.only(
//                 //                     //                           left: 90)
//                 //                     //                       : EdgeInsets.all(0),
//                 //                     //   alignment: Alignment.centerLeft,
//                 //                     //   child: ImageStack(
//                 //                     //     imageList: listAvatar,
//                 //                     //     imageCount: 4,
//                 //                     //     totalCount: listAvatar.length,
//                 //                     //     imageRadius: 40,
//                 //                     //     imageBorderWidth: 1,
//                 //                     //   ),
//                 //                     // ),
//                 //                     Text(
//                 //                       '?',
//                 //                       style: TextStyle(
//                 //                         fontFamily: 'Roboto',
//                 //                         fontSize: 16,
//                 //                         color: ColorTheme.textGrey,
//                 //                         fontWeight: FontWeight.w300,
//                 //                       ),
//                 //                     ),
//                 //                   ],
//                 //                 ),
//                 //               ),
//                 //             ]);
//                 //           } else
//                 //             return Container();
//                 //         }
//                 //       } else
//                 //         return Container();
//                 //     }),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       "${widget.date.toDate().hour.toString().padLeft(2, '0')}:${widget.date.toDate().minute.toString().padLeft(2, '0')}",
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 10,
//                         color: ColorTheme.orange,
//                         fontWeight: FontWeight.w300,
//                       ),
//                       textAlign: TextAlign.center,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }
