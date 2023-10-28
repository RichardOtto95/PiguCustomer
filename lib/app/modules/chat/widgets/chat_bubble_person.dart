import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_stack/image_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:intl/intl.dart';

class ChatBubblePerson extends StatefulWidget {
  final DocumentSnapshot dss;
  final String phoneUserLogin;
  final String authorId;
  final Function onTapp;
  final bool host;
  final Timestamp date;
  final String orderID;
  final bool haveNote;

  const ChatBubblePerson({
    Key key,
    this.date,
    this.orderID,
    this.host,
    this.authorId,
    this.dss,
    this.phoneUserLogin,
    this.haveNote,
    this.onTapp,
  }) : super(key: key);

  @override
  _ChatBubblePersonState createState() => _ChatBubblePersonState();
}

class _ChatBubblePersonState extends State<ChatBubblePerson> {
  List<String> listAvatar = [];
  String orderStatus = '';

  final homeController = Modular.get<HomeController>();
  final chatController = Modular.get<ChatController>();

  double marRight;
  double marLeft;
  double borderRight;
  double borderLeft;
  Future<dynamic> task;
  @override
  void initState() {
    task = getMembers();

    super.initState();
  }

  int membros = 0;
  Future<dynamic> getMembers() async {
    // Map<String, String> mapMembers = Map();
    DocumentSnapshot order = await Firestore.instance
        .collection('orders')
        .document(widget.orderID)
        .get();
    // print('orderStatus: ${orderStatus}');
    orderStatus = order.data['status'];
    // print('orderStatus: ${orderStatus}');

    QuerySnapshot amigos =
        await order.reference.collection('members').getDocuments();

    amigos.documents.forEach((element) async {
      DocumentSnapshot _amigo = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .get();
      await listAvatar.add(_amigo.data['avatar']);
    });

    await Future.delayed(Duration(seconds: 1));

    return listAvatar;
    // return mapMembers;
  }

  @override
  void dispose() {
    // homeController.setStatusOrder('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('%%%%%%%%%% status $orderStatus %%%%%%%%%%');
    if (widget.host) {
      marRight = 15;
      marLeft = 42;
      borderRight = 8.0;
      borderLeft = 24.0;
    } else {
      marRight = 42;
      marLeft = 15;
      borderRight = 24.0;
      borderLeft = 8.0;
    }
    return Container(
      width: wXD(61, context),
      height: wXD(410, context),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      margin: EdgeInsets.fromLTRB(marLeft, 8, marRight, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(borderRight),
          bottomLeft: Radius.circular(borderLeft),
        ),
        color: widget.host ? ColorTheme.textGrey : ColorTheme.white,
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
            .collection('orders')
            .document(widget.orderID)
            .collection('cart_item')
            .snapshots(),
        builder: (context, snapshotCart) {
          if (snapshotCart.connectionState == ConnectionState.waiting) {
            return new Center(
                child: Container(
              width: wXD(30, context),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
              ),
            ));
          } else {
            if (snapshotCart.hasError)
              return new Text('Error: ${snapshotCart.error}');
            else {
              if (snapshotCart.hasData) {
                DocumentSnapshot cart = snapshotCart.data.documents[0];

                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('listings')
                      .document(cart.data['listing_id'])
                      .snapshots(),
                  builder: (context, snapshotListing) {
                    if (snapshotListing.connectionState ==
                        ConnectionState.waiting) {
                      return new Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                      ));
                    } else {
                      if (snapshotListing.hasError)
                        return new Text('Error: ${snapshotListing.error}');
                      else {
                        if (snapshotListing.hasData) {
                          DocumentSnapshot listing = snapshotListing.data;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  FutureBuilder(
                                    future: Firestore.instance
                                        .collection('users')
                                        .document(widget.authorId)
                                        .get(),
                                    builder: (context, snapshotUser) {
                                      if (snapshotUser.connectionState ==
                                          ConnectionState.waiting) {
                                        return new Center(
                                            child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              ColorTheme.yellow),
                                        ));
                                      } else {
                                        if (snapshotUser.hasError)
                                          return new Text(
                                              'Error: ${snapshotUser.error}');
                                        else {
                                          if (snapshotUser.hasData) {
                                            return Container(
                                              width: wXD(280, context),
                                              child: Text(
                                                snapshotUser.data['username'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: ColorTheme.textColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          } else
                                            return Container();
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: wXD(10, context),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: wXD(14, context),
                                  ),
                                  Text(
                                    "Quer dividir",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: widget.host
                                          ? ColorTheme.white
                                          : ColorTheme.textGrey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    ' ${cart.data['ordered_amount'].toInt()}  ',
                                    // '0',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: widget.host
                                          ? ColorTheme.white
                                          : ColorTheme.textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(height: wXD(10, context)),
                              Stack(children: [
                                InkWell(
                                  onTap: () =>
                                      chatController.functionRepeatOrder(
                                    sellerId: widget.dss['seller_id'],
                                    groupId: widget.dss['group_id'],
                                    itemId: listing['id'],
                                  ),
                                  child: Container(
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: listing.data['image'],
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
                                ),
                                widget.haveNote == false
                                    ? Container()
                                    : Positioned(
                                        top: 5,
                                        right: 5,
                                        child: InkWell(
                                          onTap: widget.onTapp,
                                          child: Container(
                                            width: wXD(54, context),
                                            height: wXD(42, context),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(21.0),
                                                topRight: Radius.circular(21.0),
                                                bottomRight:
                                                    Radius.circular(21.0),
                                                bottomLeft:
                                                    Radius.circular(58.0),
                                              ),
                                              color: ColorTheme.blueCyan,
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x29000000),
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
                              SizedBox(height: wXD(13, context)),
                              Container(
                                width: wXD(300, context),
                                child: Text(
                                  '${listing.data['label']}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 15,
                                    color: widget.host
                                        ? ColorTheme.white
                                        : ColorTheme.textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: wXD(10, context)),
                              Row(
                                children: [
                                  SizedBox(height: wXD(15, context)),
                                  Stack(
                                    children: [
                                      Container(
                                        height: wXD(36, context),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  right: wXD(10, context)),
                                              child: Text(
                                                'com',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: widget.host
                                                      ? ColorTheme.white
                                                      : ColorTheme.textGrey,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: wXD(5, context),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: FutureBuilder(
                                                  future: task,
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return new Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                ColorTheme
                                                                    .yellow),
                                                      ));
                                                    } else {
                                                      if (snapshot.hasError)
                                                        return new Text(
                                                            'Error: ${snapshot.error}');
                                                      else {
                                                        if (snapshot.hasData) {
                                                          double leftPadding =
                                                              0;
                                                          if (listAvatar
                                                                  .length <
                                                              5) {
                                                            leftPadding = (18 *
                                                                    listAvatar
                                                                        .length
                                                                        .toDouble()) -
                                                                13;
                                                          } else {
                                                            leftPadding = 85;
                                                          }
                                                          return Container(
                                                              padding: EdgeInsets.only(
                                                                  left: wXD(
                                                                      leftPadding,
                                                                      context)),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: ImageStack(
                                                                imageBorderColor: widget
                                                                        .host
                                                                    ? ColorTheme
                                                                        .white
                                                                    : ColorTheme
                                                                        .textGrey,
                                                                imageList:
                                                                    listAvatar,
                                                                imageCount: 5,
                                                                totalCount:
                                                                    listAvatar
                                                                        .length,
                                                                imageRadius: wXD(
                                                                    30,
                                                                    context),
                                                                imageBorderWidth:
                                                                    2,
                                                              ));
                                                        } else
                                                          return Container();
                                                      }
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('orders')
                                      .document(widget.orderID)
                                      .snapshots(),
                                  builder: (context, snapshotER) {
                                    if (!snapshotER.hasData) {
                                      return Container();
                                    } else {
                                      return StreamBuilder(
                                          stream: Firestore.instance
                                              .collection('orders')
                                              .document(widget.orderID)
                                              .collection('members')
                                              .where('user_id',
                                                  isEqualTo:
                                                      homeController.user.uid)
                                              .snapshots(),
                                          builder: (context, snapshot2) {
                                            if (!snapshot2.hasData) {
                                              return Container();
                                            } else {
                                              bool verific = false;
                                              if (snapshotER.data['status'] ==
                                                  'awaiting_order') {
                                                // //print'entrou 1');
                                                if (!snapshot2
                                                    .data.documents.isEmpty) {
                                                  // //print'entrou 2');

                                                  if (snapshot2
                                                          .data
                                                          .documents[0]
                                                          .data['role'] ==
                                                      'invited') {
                                                    verific = true;
                                                  }
                                                }
                                              }
                                              // //print'verificcccccccc $verific');
                                              return verific
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            chatController.orderRefused(
                                                                orderId: widget
                                                                        .dss[
                                                                    'order_id']);
                                                          },
                                                          child: Container(
                                                              height: 37,
                                                              width: 96,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 30),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xfffafafa),
                                                                border: Border.all(
                                                                    color: ColorTheme
                                                                        .primaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            21),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(
                                                                        0x29000000),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                    blurRadius:
                                                                        6,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Não',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    color: ColorTheme
                                                                        .textColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            chatController
                                                                .orderAccepted(
                                                                    orderId: widget
                                                                            .dss[
                                                                        'order_id']);
                                                          },
                                                          child: Container(
                                                              height: 37,
                                                              width: 96,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          30),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorTheme
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            21),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(
                                                                        0x29000000),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                    blurRadius:
                                                                        6,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Sim!',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xfffafafa),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshotER.data[
                                                                      'status'] ==
                                                                  'awaiting_order'
                                                              ? 'Aguardando convidado(s) aceitar(em)'
                                                              : snapshotER.data[
                                                                          'status'] ==
                                                                      'order_requested'
                                                                  ? 'Todos aceitaram!'
                                                                  : snapshotER.data[
                                                                              'status'] ==
                                                                          'order_accepted'
                                                                      ? 'Pedido aceito!'
                                                                      : snapshotER.data['status'] ==
                                                                              'order_delivered'
                                                                          ? 'Pedido pronto!'
                                                                          : 'Alguém recusou!',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            color: widget.host
                                                                ? Color(
                                                                    0xff000000)
                                                                : ColorTheme
                                                                    .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            }
                                          });
                                    }
                                  }),
                              Spacer(),
                              Container(
                                width: wXD(300, context),
                                height: 1,
                                color: widget.host
                                    ? ColorTheme.white.withOpacity(.5)
                                    : ColorTheme.textGrey.withOpacity(.4),
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection('orders')
                                    .document(widget.orderID)
                                    .collection('members')
                                    .snapshots(),
                                builder: (context, membrosSnap) {
                                  if (!membrosSnap.hasData) {
                                    return Container();
                                  } else {
                                    DocumentSnapshot sc =
                                        snapshotCart.data.documents.first;
                                    double precoUnitario =
                                        (sc['ordered_value'] /
                                            sc['ordered_amount']);
                                    double precoTotal = (sc['ordered_value']);
                                    double minhaParte = (sc['ordered_value'] /
                                        (membrosSnap.data.documents.length +
                                            1));
                                    return Column(
                                      children: [
                                        SizedBox(height: wXD(5, context)),
                                        Price(
                                          title: 'Preço unitário',
                                          price: precoUnitario,
                                        ),
                                        Price(
                                          title: 'Preço total',
                                          price: precoTotal,
                                        ),
                                        Price(
                                          title: 'Minha parte',
                                          price: minhaParte,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.date.toDate().hour.toString().padLeft(2, '0')}:${widget.date.toDate().minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10,
                                      color: widget.host
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
                        } else
                          return Container();
                      }
                    }
                  },
                );
              } else
                return Container();
            }
          }
        },
      ),
    );
  }
}

class Price extends StatelessWidget {
  final String title;
  final double price;

  const Price({
    Key key,
    this.title,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: wXD(9, context), right: wXD(4, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'R\$ ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '${formatedCurrency(price)}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatedCurrency(var value) {
    var numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    var newValue = numberFormat;
    return newValue.format(value);
  }
}
