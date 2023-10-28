import 'dart:async';

import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/chat/widgets/chat_bubble_left.dart';
import 'package:pigu/app/modules/chat/widgets/chat_bubble_person.dart';
import 'package:pigu/app/modules/chat/widgets/chat_bubble_right.dart';
import 'package:pigu/app/modules/chat/widgets/chat_invitation_host.dart';
import 'package:pigu/app/modules/chat/widgets/chat_order_status.dart';
import 'package:pigu/app/modules/chat/widgets/chat_virtual_queue.dart';
import 'package:pigu/app/modules/chat/widgets/float_menu.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/menu/widgets/slide_menu.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pigu/shared/utilities.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  // final String title;
  // final group;
  // final order;
  // final msgType;
  const ChatPage(
      {Key key,
      // this.title = "Chat",
      // this.group,
      // this.msgType,
      // this.order,
      @required this.groupId})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final homeController = Modular.get<HomeController>();
  ChatController chatController;
  ScrollController scrollController = ScrollController();

  //use 'controller' variable to access controller

  // void handleScroll() async {
  //   scrollController.addListener(() {
  //     if (scrollController.position.userScrollDirection ==
  //             ScrollDirection.reverse ||
  //         scrollController.position.userScrollDirection ==
  //             ScrollDirection.forward) {
  //       chatController.setShowAppBar(false);
  //       print('ENTROU NA IF ${chatController.showAppBar}');
  //       print(
  //           'DADOS1 ${scrollController.initialScrollOffset} ${scrollController.keepScrollOffset} ${scrollController.offset} ${scrollController.position} ${scrollController.positions.iterator.current}');
  //     } else {
  //       chatController.setShowAppBar(true);
  //       print('ENTROU NA ELSE ${chatController.showAppBar}');
  //       print(
  //           'DADOS2 ${scrollController.initialScrollOffset} ${scrollController.keepScrollOffset} ${scrollController.offset} ${scrollController.position} ');
  //     }
  //   });
  // }

  @override
  void initState() {
    // handleScroll();

    chatController = Modular.get<ChatController>();
    chatController.setGroupId(widget.groupId);
    chatController.getStatus();
    chatController.setFirstOrder();
    chatController.getAwaitingCheckout();
    chatController.reverseChat(widget.groupId);
    // homeController.setRouterMenu(null);
    // if (widget.group != widget.group.toString()) {
    //   setState(() {
    //     chatController.hash = widget.group[1];
    //   });
    // } else {
    //   setState(() {
    //     chatController.hash = widget.group;
    //   });
    // }
    // scrollController = new ScrollController();

    chatController.eventcleaner();
    // chatController.getHostinvite();
    // getLastOrder();
    // chatController.reverseChat(widget.groupId);
    super.initState();
  }

  @override
  void dispose() {
    homeController.setGroupRepeatOrder(null);
    homeController.setmMyGroupSelected(null);
    scrollController.removeListener(() {});
    // homeController.setMyGroupSelected(null);

    super.dispose();
  }

  // getLastOrder() async {
  // descomenta dps
  // QuerySnapshot _user = await Firestore.instance
  //     .collection('orders')
  //     .where('user_id', isEqualTo: homeController.user.uid)
  //     .getDocuments();
  // //print'_user ==========: ${_user.documents.isEmpty}');
  // if (_user.documents.isEmpty) {
  //   setState(() {
  //     firstOrder = true;
  //   });
  // } else {
  //   setState(() {
  //     firstOrder = false;
  //   });
  // }
  // }

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection("users")
        .document(homeController.user.uid)
        .get()
        .then((value) {
      chatController.phoneUserLogin = value.data['mobile_phone_number'];
    });
    Timer(Duration(seconds: 1), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 3), curve: Curves.ease);
    });
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/open-table');
      },
      child: StreamBuilder(
          stream: Firestore.instance
              .collection("groups")
              .document(widget.groupId)
              .snapshots(),
          builder: (context, groupSnap) {
            if (!groupSnap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                ),
              );
            } else {
              DocumentSnapshot gs = groupSnap.data;
              return Scaffold(
                backgroundColor: Color(0xffFAFAFA),
                body: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          NavTableBar(
                            goBack: () {
                              Modular.to.pushNamed('/open-table');
                            },
                            goToTableInfo: () {
                              Modular.to.pushNamed('open-table/table-info',
                                  arguments: widget.groupId);
                            },
                            title: "${gs['label']}",
                            imageURL: gs['avatar'],
                            // iconButton:
                            //     Icon(Icons.more_vert, color: Color(0xfffafafa)),
                            // iconOnTap: () {
                            //   //print"icon click");
                            //   setState(() {
                            //     showMenu = !showMenu;
                            //   });
                            // },
                          ),
                          // Container(
                          //   height: 57,
                          //   color: ColorTheme.primaryColor,
                          //   child: Row(
                          //     children: [
                          //       SizedBox(
                          //         width: 16,
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           Modular.to.pushNamed('/open-table');
                          //         },
                          //         child: Image.asset(
                          //           'assets/icon/back.png',
                          //           height: 36,
                          //           width: 36,
                          //           fit: BoxFit.contain,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 28,
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           Modular.to.pushNamed('open-table/table-info',
                          //               arguments: widget.group);
                          //         },
                          //         child: Text(
                          //           "${ds['name']}",
                          //           style: TextStyle(
                          //             fontFamily: 'Roboto',
                          //             fontSize: 16,
                          //             color: ColorTheme.white,
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //       ),
                          //       Spacer(),
                          // (iconOnTap != null)
                          //     ? (iconButton != null) ? InkWell(
                          //       onTap: iconOnTap,
                          //       child: iconButton) : Icon(
                          //         Icons.favorite_border,
                          //         color: ColorTheme.purple,v
                          //       )
                          //     : Container(),
                          //       SizedBox(
                          //         width: 30,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Expanded(
                          //   child: ListView(
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.vertical,
                          //     children: [
                          //       ChatBubblePerson(
                          //         date: Timestamp.now(),
                          //         image:
                          //             'https://spassodourado.com.br/wp-content/uploads/2015/01/default-placeholder.png',
                          //         title: "1 Coffee Jelly Frappuccino ",
                          //       ),
                          //       ChatBubblePersonSplit(
                          //         title: "1 Coffee Jelly Frappuccino ",
                          //       ),
                          //       ChatBubbleLeft(
                          //         title: "3/4 decidiram o que pedir",
                          //       ),
                          //       ChatBubbleRight(
                          //         date: Timestamp.now(),
                          //         imageUrl:
                          //             'https://spassodourado.com.br/wp-content/uploads/2015/01/default-placeholder.png',
                          //         title: "1 Coffee Jelly Frappuccino",
                          //       ),
                          //       ChatBubbleLeft(
                          //         title: "4/4 decidiram o que pedir",
                          //       ),
                          //     ],
                          //   ),
                          // )

                          StreamBuilder(
                            stream: Firestore.instance
                                .collection("chats")
                                .where('group_id',
                                    isEqualTo: chatController.groupId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                // print('Dados ${snapshot.data}');
                                QuerySnapshot ds = snapshot.data;
                                return Observer(
                                  builder: (context) {
                                    return StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('chats')
                                          .document(ds.documents[0].documentID)
                                          .collection('messages')
                                          .orderBy('created_at',
                                              descending: false)
                                          .snapshots(),
                                      builder:
                                          (BuildContext context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          if (snapshot2.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        ColorTheme.yellow),
                                              ),
                                            );
                                          } else {
                                            return Expanded(
                                              child: NotificationListener<
                                                  ScrollNotification>(
                                                onNotification: (notification) {
                                                  // if (notification
                                                  //     is ScrollStartNotification) {
                                                  //   chatController
                                                  //       .setShowAppBar(false);
                                                  // }
                                                  // if (notification
                                                  //     is ScrollEndNotification) {
                                                  //   chatController
                                                  //       .setShowAppBar(true);
                                                  // }
                                                },
                                                child: ListView.builder(
                                                  // reverse: true,
                                                  controller: scrollController,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: snapshot2
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    DocumentSnapshot dss =
                                                        snapshot2.data
                                                            .documents[index];

                                                    return dss['type'] ==
                                                            'create-table'
                                                        ? ChatBubbleLeft(
                                                            title:
                                                                "${dss['text']}",
                                                          )
                                                        : dss['type'] ==
                                                                'order-with-members'
                                                            ? ChatBubblePerson(
                                                                onTapp: () {
                                                                  Fluttertoast.showToast(
                                                                      msg: dss[
                                                                          'note'],
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .CENTER,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          ColorTheme
                                                                              .blueCyan,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          18.0);
                                                                },
                                                                haveNote: dss['note'] ==
                                                                            '' ||
                                                                        dss['note'] ==
                                                                            null
                                                                    ? false
                                                                    : true,
                                                                phoneUserLogin:
                                                                    chatController
                                                                        .phoneUserLogin,
                                                                dss: dss,
                                                                authorId: dss[
                                                                    'author_id'],
                                                                host: dss[
                                                                        'author_id'] ==
                                                                    homeController
                                                                        .user
                                                                        .uid,
                                                                orderID: dss[
                                                                    'order_id'],
                                                                date: dss[
                                                                    'created_at'],
                                                              )
                                                            : dss['type'] ==
                                                                    'create-order'
                                                                ? InkWell(
                                                                    child:
                                                                        ChatBubbleRight(
                                                                      dss: dss,
                                                                      onTapp:
                                                                          () {
                                                                        Fluttertoast.showToast(
                                                                            msg: dss[
                                                                                'note'],
                                                                            toastLength: Toast
                                                                                .LENGTH_LONG,
                                                                            gravity: ToastGravity
                                                                                .CENTER,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                            backgroundColor:
                                                                                ColorTheme.blueCyan,
                                                                            textColor: Colors.white,
                                                                            fontSize: 18.0);
                                                                      },
                                                                      haveNote: dss['note'] == '' ||
                                                                              dss['note'] == null
                                                                          ? false
                                                                          : true,
                                                                      authorId:
                                                                          dss['author_id'],
                                                                      host: homeController
                                                                              .user
                                                                              .uid ==
                                                                          dss['author_id'],
                                                                      orderID: dss[
                                                                          'order_id'],
                                                                      date: dss[
                                                                          'created_at'],
                                                                    ),
                                                                  )
                                                                : dss['type'] ==
                                                                        'user-invite-table'
                                                                    ? InkWell(
                                                                        child:
                                                                            ChatBubbleLeft(
                                                                          title:
                                                                              "${dss['text']}",
                                                                        ),
                                                                      )
                                                                    : dss['type'] ==
                                                                            'user_host_invited'
                                                                        ? ChatInvitationHost(
                                                                            answer: dss['status'] == 'awaiting'
                                                                                ? null
                                                                                : dss['status'] == 'accept',
                                                                            onSetState:
                                                                                () {
                                                                              setState(() {});
                                                                            },
                                                                            dss:
                                                                                dss,
                                                                            status:
                                                                                dss['status'],
                                                                            inviteHost:
                                                                                dss['invite_host'],
                                                                            date:
                                                                                dss['created_at'],
                                                                            authorID:
                                                                                dss['author_id'],
                                                                            groupID:
                                                                                dss['group_id'],
                                                                          )
                                                                        : dss['type'] ==
                                                                                'order_status_changed'
                                                                            ? ChatOrderStatus(
                                                                                sellerId: dss['seller_id'],
                                                                                dss: dss,
                                                                                clientNote: dss['client_note'] == null ? '' : dss['client_note'],
                                                                                haveNote: dss['client_note'] == '' || dss['client_note'] == null ? false : true,
                                                                                note: dss['seller_note'],
                                                                                text: dss['text'],
                                                                                userId: dss['author_id'],
                                                                                date: dss['created_at'],
                                                                                orderId: dss['order_id'],
                                                                                onTapp: () {
                                                                                  Fluttertoast.showToast(msg: dss['client_note'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: ColorTheme.blueCyan, textColor: Colors.white, fontSize: 18.0);
                                                                                },
                                                                              )
                                                                            : dss['type'] == 'virtual_queue_add'
                                                                                ? chatVirtualQueue(
                                                                                    uid: dss['user_id'],
                                                                                    seller: dss['author_id'],
                                                                                    date: dss['created_at'],
                                                                                    queuedUntil: dss['prev'],
                                                                                    position: dss['pos'],
                                                                                  )
                                                                                : Container();
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        } else if (snapshot.hasError) {
                                          Container();
                                        }
                                        return CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              ColorTheme.yellow),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),

                          // Container(
                          //   height: 30,
                          // )
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          child: chatController.clickItem
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      // //print"clicou");
                                      chatController.clickItem =
                                          !chatController.clickItem;
                                    });
                                  },
                                  child: SlideMenu(),
                                )
                              : Container()),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Visibility(
                            visible: chatController.showMenu,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    chatController.showMenu =
                                        !chatController.showMenu;
                                  });
                                },
                                child: FloatMenu(
                                  group: chatController.hash,
                                ))),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar: Observer(
                  builder: (context) {
                    return Visibility(
                      visible: chatController.showAppBar,
                      // child:
                      // AnimatedContainer(
                      // color: Colors.red,
                      // // width: MediaQuery.of(context).size.width,
                      // duration: Duration(seconds: 1),
                      // curve: Curves.decelerate,
                      // height:
                      //     chatController.showAppBar ? wXD(80, context) : 0,
                      child: BottomAppBar(
                          elevation: 1,
                          notchMargin: 22,
                          clipBehavior: Clip.antiAlias,
                          color: ColorTheme.white,
                          shape: AutomaticNotchedShape(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0))),
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                          child: Row(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.10),
                              InkWell(
                                onTap: () async {
                                  await chatController.getStatus();
                                  chatController.getSituation(
                                      button: 'pedirConta');

                                  Modular.to.pushNamed(
                                    'open-table/pay-the-bill',
                                    arguments: widget.groupId,
                                  );
                                },
                                child: Container(
                                  width: wXD(50, context),
                                  height: wXD(80, context),
                                  child: Column(children: [
                                    SizedBox(height: 15),
                                    Image.asset(
                                      'assets/icon/count.png',
                                      height: wXD(26, context),
                                      width: wXD(26, context),
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: wXD(8, context)),
                                    Text(
                                      "pedir conta",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: wXD(10, context),
                                        color: ColorTheme.textGrey,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                                ),
                              ),
                              Spacer(),
                              Observer(
                                builder: (context) {
                                  return Visibility(
                                    visible: true,
                                    child: AnimatedContainer(
                                      margin: EdgeInsets.only(bottom: 20),
                                      duration: Duration(seconds: 1),
                                      curve: Curves.decelerate,
                                      width: chatController.showAppBar
                                          ? wXD(75, context)
                                          : 0,
                                      height: chatController.showAppBar
                                          ? wXD(75, context)
                                          : 0,
                                      child: FloatingActionButton(
                                        backgroundColor: ColorTheme.blueCyan,
                                        onPressed: () async {
                                          chatController.getSituation(
                                              button: 'menu');

                                          DocumentSnapshot docRefSeller =
                                              await Firestore.instance
                                                  .collection('sellers')
                                                  .document(gs['seller_id'])
                                                  .get();
                                          SellerModel _seller = SellerModel(
                                            address:
                                                docRefSeller.data['address'],
                                            avatar: docRefSeller.data['avatar'],
                                            bg_image:
                                                docRefSeller.data['bg_image'],
                                            category_id: docRefSeller
                                                .data['category_id'],
                                            name: docRefSeller.data['name'],
                                            id: docRefSeller.data['id'],
                                          );
                                          homeController.setSeller(_seller);
                                          // homeController.setGroupChat(chatController.groupId);
                                          homeController
                                              .setGroupChat(widget.groupId);

                                          homeController.setMyGroupStauts(
                                              chatController.myGroupStatus);
                                          Modular.to.pushNamed('/menu',
                                              arguments: _seller);
                                        },
                                        child: Image.asset(
                                          'assets/icon/menuOpen.png',
                                          height: wXD(42, context),
                                          width: wXD(45, context),
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  await chatController.getStatus();
                                  await chatController.getSituation(
                                      button: 'repetirPedido');
                                  if (chatController.repeatOrder) {
                                    chatController.functionRepeatOrder(
                                        sellerId: gs['seller_id'],
                                        groupId: widget.groupId,
                                        repeatOrder: true);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: chatController.toastText,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            ColorTheme.primaryColor,
                                        textColor: ColorTheme.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Container(
                                  width: wXD(70, context),
                                  height: wXD(90, context),
                                  child: Column(children: [
                                    SizedBox(height: wXD(15, context)),
                                    Image.asset(
                                      'assets/icon/rep.png',
                                      height: wXD(26, context),
                                      width: wXD(26, context),
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: wXD(8, context)),
                                    Text(
                                      "Repetir pedido",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: wXD(10, context),
                                        color: ColorTheme.textGrey,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ],
                          )),
                      // ),
                    );
                  },
                ),
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.centerDocked,
                // floatingActionButton:
              );
            }
          }),
    );
  }
}

class BlankSpacer extends StatelessWidget {
  const BlankSpacer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
    );
  }
}
