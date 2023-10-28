import 'package:pigu/app/core/models/seller_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/open_table/widgets/float_menu.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_stack/image_stack.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:intl/intl.dart';
// import 'package:pigu/shared/utilities.dart';

class OpenTableDetailPage extends StatefulWidget {
  final DocumentSnapshot invite;
  final group;
  // final list;
  OpenTableDetailPage({
    Key key,
    this.invite,
    this.group,
    // this.list
  }) : super(key: key);

  @override
  _OpenTableDetailPageState createState() => _OpenTableDetailPageState();
}

class _OpenTableDetailPageState
    extends ModularState<OpenTableDetailPage, OpenTableController> {
  Future<dynamic> task;

  final homeController = Modular.get<HomeController>();
  bool click = false;
  bool showMenu = false;
  int photoheight;
  bool spin = false;
  bool spin2 = false;
  SellerModel _seller;
  DocumentSnapshot sellerDocRef;

  @override
  void initState() {
    task = getMembersAvatar();
    sellerModel();

    super.initState();
  }

  Future<dynamic> getMembersAvatar() async {
    List<String> _listMembers = [];
    QuerySnapshot _getGroupMembers = await Firestore.instance
        .collection('groups')
        .document(widget.invite.data['group_id'])
        .collection('members')
        .getDocuments();

    _getGroupMembers.documents.forEach((element) async {
      DocumentSnapshot _getMemberDataFromUser = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .get();
      await _listMembers.add(_getMemberDataFromUser.data['avatar']);
    });

    await Future.delayed(Duration(seconds: 1));
    // //print'membersmembersmembersmembersmembers  :$_listMembers');

    return _listMembers;
  }

  sellerModel() async {
    sellerDocRef = await Firestore.instance
        .collection('sellers')
        .document(widget.invite.data['seller_id'])
        .get();

    _seller = SellerModel(
      address: sellerDocRef.data['address'],
      avatar: sellerDocRef.data['avatar'],
      bg_image: sellerDocRef.data['bg_image'],
      category_id: sellerDocRef.data['category_id'],
      name: sellerDocRef.data['name'],
      id: sellerDocRef.data['id'],
    );
    // print('_seller: ${_seller}');
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Color(0xFFEDEDED),
            child: Stack(
              children: [
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("sellers")
                        .where('id', isEqualTo: widget.invite['seller_id'])
                        .snapshots(),
                    builder: (context, snapshotSeller) {
                      if (snapshotSeller.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshotSeller.hasError) {
                        return Center(
                          child: Text('Erro: ${snapshotSeller.error}'),
                        );
                      }

                      if (!snapshotSeller.hasData) {
                        return Container();
                      }
                      // if (!snapshotSeller.hasData) {
                      //   return Container();
                      // } else {
                      DocumentSnapshot sellerDS =
                          snapshotSeller.data.documents.first;
                      return Column(
                        children: [
                          NavBar(
                            title: "",
                            // iconButton:
                            //     Icon(Icons.more_vert, color: ColorTheme.white),
                            // iconOnTap: () {
                            //   setState(() {
                            //     showMenu = !showMenu;
                            //   });
                            // },
                            backPage: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: InkWell(
                                onTap: () {
                                  // setState(() {
                                  //   showMenu = false;
                                  // });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        color: ColorTheme.white,
                                        height: wXD(106, context),
                                        padding: EdgeInsets.fromLTRB(
                                            wXD(22, context),
                                            wXD(30, context),
                                            0,
                                            0),
                                        // padding: EdgeInsets.only(top: 30),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: wXD(350, context),
                                              alignment: Alignment.centerLeft,
                                              child: StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection('groups')
                                                    .document(widget
                                                        .invite['group_id'])
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(
                                                          'Erro: ${snapshot.error}'),
                                                    );
                                                  }

                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  }
                                                  return Text(
                                                    '${snapshot.data['label']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          wXD(16, context),
                                                      color:
                                                          ColorTheme.textColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  );
                                                },
                                              ),
                                            ),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'convidados:',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          wXD(16, context),
                                                      color:
                                                          ColorTheme.textColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  FutureBuilder(
                                                      future: task,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Container();
                                                        } else {
                                                          double leftPadding =
                                                              0;
                                                          if (snapshot.data
                                                                  .length <=
                                                              5) {
                                                            print('menor');

                                                            leftPadding = (26 *
                                                                    snapshot
                                                                        .data
                                                                        .length
                                                                        .toDouble()) -
                                                                13;
                                                          } else {
                                                            print('maior');

                                                            leftPadding = 115;
                                                          }
                                                          return InkWell(
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            splashColor: Colors
                                                                .transparent,
                                                            onTap: () {
                                                              setState(() {
                                                                click = !click;
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  left: wXD(
                                                                      leftPadding,
                                                                      context)),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: ImageStack(
                                                                imageList:
                                                                    snapshot
                                                                        .data,
                                                                // showTotalCount: true,
                                                                imageCount:
                                                                    5, // Maximum number of images to be shown in stack
                                                                totalCount:
                                                                    snapshot
                                                                        .data
                                                                        .length,
                                                                imageRadius: wXD(
                                                                    35,
                                                                    context),
                                                                // Radius of each images
                                                                // imageCount: haha.length / 2,
                                                                //     3, // Maximum number of images to be shown in stack
                                                                imageBorderColor:
                                                                    Color(
                                                                        0xff95a5a6),
                                                                imageBorderWidth:
                                                                    2, // Border width around the images
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }),
                                                ])
                                          ],
                                        )),
                                    StreamBuilder(
                                        stream: Firestore.instance
                                            .collection("groups")
                                            .document(
                                              widget.invite['group_id'],
                                            )
                                            .collection('members')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'Erro: ${snapshot.error}'),
                                            );
                                          }

                                          if (!snapshot.hasData) {
                                            return Container();
                                          }
                                          // if (!snapshot.hasData) {
                                          //   return Container();
                                          // } else {
                                          double length = snapshot
                                              .data.documents.length
                                              .toDouble();
                                          return AnimatedContainer(
                                            color: ColorTheme.white,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                            height:
                                                click ? (wXD(220, context)) : 0,
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data.documents.length,
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot ds = snapshot
                                                      .data.documents[index];

                                                  controller
                                                      .getAvatar(ds['user_id']);
                                                  return new Participant(
                                                    hash: ds['user_id'],
                                                    name: ds['username'],
                                                    number: ds[
                                                        'mobile_phone_number'],
                                                    group: ds['group_id'],
                                                    host:
                                                        ds['role'] == 'created',
                                                  );
                                                }),
                                          );
                                          // }
                                        }),
                                    AdicionarPessoasTitle(
                                      name: sellerDS['name'],
                                      dia: widget.invite['created_at'],
                                    ),

                                    // AdicionarPessoasTitle(name: widget.invite['nickname'],),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    Container(
                                      // color: Color(0xFFEDEDED),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Stack(
                                              alignment: AlignmentDirectional
                                                  .topCenter,
                                              children: [
                                                Container(
                                                  //color: Colors.grey,
                                                  // margin: EdgeInsets.only(
                                                  //     left: 27,
                                                  //     right: 27,
                                                  //     bottom: 16),
                                                  height: wXD(230, context),
                                                  width: wXD(355, context),
                                                ),
                                                Positioned(
                                                  top: wXD(78, context),
                                                  // left: 00,
                                                  child: Container(
                                                    height: wXD(105, context),
                                                    width: wXD(306, context),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      color: const Color(
                                                          0xFFEDEDED),
                                                    ),
                                                    child: Image.asset(
                                                      'assets/img/map.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  // left: 27,
                                                  child: Container(
                                                    height: wXD(125, context),
                                                    width: wXD(355, context),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                              0x29000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: sellerDS[
                                                            'bg_image'],
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  ColorTheme
                                                                      .yellow),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  left: 4,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    height: wXD(48, context),
                                                    width: wXD(48, context),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0xffF9995E)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Container(
                                                        color: Colors.white,
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: sellerDS[
                                                              'avatar'],
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    ColorTheme
                                                                        .yellow),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: wXD(110, context),
                                                  // left: 158,
                                                  child: Container(
                                                    height: wXD(44, context),
                                                    width: wXD(44, context),
                                                    child: Image.asset(
                                                      'assets/icon/mapMarker.png',
                                                      height: wXD(16, context),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: wXD(145, context),
                                                  right: 0,
                                                  child: Container(
                                                    width: wXD(55, context),
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
                                                      child: Image.asset(
                                                        'assets/icon/sender.png',
                                                        height: 18,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: wXD(11, context),
                                                  left: wXD(5, context),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/icon/marker.png',
                                                        height:
                                                            wXD(18, context),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  child: Container(
                                                    width: wXD(320, context),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        '  ${sellerDS['address']}',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          wXD(15, context),
                                          2,
                                          wXD(15, context),
                                          wXD(15, context)),
                                      height: 1,
                                      color: Color(0xffBDAEA7),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        homeController.setRouterMenu('invite');
                                        homeController.setSeller(_seller);
                                        Modular.to.pushNamed('/menu',
                                            arguments: _seller);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icon/menuOpen.png',
                                            height: wXD(40, context),
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            width: wXD(4, context),
                                          ),
                                          Text(
                                            'Ver',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: wXD(16, context),
                                              color: ColorTheme.textColor,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: wXD(4, context),
                                          ),
                                          Text(
                                            'menu',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: wXD(16, context),
                                              color: ColorTheme.textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: wXD(21, context),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: wXD(14, context)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          spin2 == false
                                              ? InkWell(
                                                  onTap: () {
                                                    controller.refuseTable(
                                                        widget.invite
                                                            .data['group_id']);

                                                    setState(() {
                                                      spin2 = true;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Convite recusado com sucesso.",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            ColorTheme.yellow,
                                                        textColor: Colors.white,
                                                        fontSize:
                                                            wXD(16, context));
                                                    Modular.to.pushNamed(
                                                        '/open-table');
                                                  },
                                                  child: Container(
                                                      height: wXD(61, context),
                                                      width: wXD(142, context),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorTheme
                                                                  .primaryColor),
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      21)),
                                                      child: Center(
                                                        child: Text(
                                                          'Fica pra próxima',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: wXD(
                                                                16, context),
                                                            color: ColorTheme
                                                                .textColor,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                )
                                              : Container(
                                                  height: wXD(61, context),
                                                  width: wXD(142, context),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: ColorTheme
                                                              .primaryColor),
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21)),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              ColorTheme
                                                                  .yellow),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: wXD(48, context),
                                          ),
                                          spin == false
                                              ? InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      spin = true;
                                                    });
                                                    FirebaseUser user =
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser();
                                                    await Firestore.instance
                                                        .collection("invites")
                                                        .document(widget
                                                            .invite.documentID)
                                                        .updateData({
                                                      'role': 'accepted_invite'
                                                    });

                                                    DocumentSnapshot geoup =
                                                        await Firestore.instance
                                                            .collection(
                                                                "groups")
                                                            .document(widget
                                                                    .invite
                                                                    .data[
                                                                'group_id'])
                                                            .get();
                                                    if (geoup.data['status'] !=
                                                        'refused') {
                                                      QuerySnapshot ref2 =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  "groups")
                                                              .document(widget
                                                                      .invite
                                                                      .data[
                                                                  'group_id'])
                                                              .collection(
                                                                  'members')
                                                              .where('user_id',
                                                                  isEqualTo:
                                                                      user.uid)
                                                              .getDocuments();

                                                      await ref2.documents.first
                                                          .reference
                                                          .updateData({
                                                        'role':
                                                            'accepted_invite'
                                                      });

                                                      Firestore.instance
                                                          .collection('users')
                                                          .document(user.uid)
                                                          .collection(
                                                              'my_group')
                                                          .add({
                                                        'id': widget.invite
                                                            .data['group_id']
                                                            .toString(),
                                                        'status': 'open',
                                                        'event_counter': 1
                                                      });
                                                      Firestore.instance
                                                          .collection(
                                                              'order_sheets')
                                                          .add({
                                                        'created_at':
                                                            Timestamp.now(),
                                                        'status': 'opened',
                                                        'user_id': user.uid,
                                                        'group_id': widget
                                                            .invite
                                                            .data['group_id'],
                                                        'seller_id': widget
                                                            .invite
                                                            .data['seller_id'],
                                                        // 'seller_id': seller.seller_id,
                                                      }).then((value) {
                                                        value.updateData({
                                                          'id': value.documentID
                                                        });
                                                      });

                                                      QuerySnapshot ref4 =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  "chats")
                                                              .where('group_id',
                                                                  isEqualTo: widget
                                                                          .invite[
                                                                      'group_id'])
                                                              .getDocuments();

                                                      DocumentSnapshot userLog =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  "chats")
                                                              .document(
                                                                  user.uid)
                                                              .get();

                                                      DocumentReference ref5 =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  "chats")
                                                              .document(ref4
                                                                  .documents[0]
                                                                  .documentID)
                                                              .collection(
                                                                  "messages")
                                                              .add({
                                                        'group_id': widget
                                                            .invite['group_id'],
                                                        'author_id': user.uid,
                                                        'created_at':
                                                            Timestamp.now(),
                                                        'text':
                                                            'Usuário "${userLog.data['username']}" entrou na mesa',
                                                        'type':
                                                            'user-invite-table',
                                                      });
                                                      ref5.updateData({
                                                        'id': ref5.documentID
                                                      });
                                                      // await Modular.to.pushNamed(
                                                      //     '/open-table/chat',
                                                      //     arguments:
                                                      //         widget.invite[
                                                      //             'group_id']);
                                                      Modular.to.pushNamed(
                                                          '/open-table/chat/' +
                                                              widget.invite[
                                                                  'group_id'],
                                                          arguments:
                                                              widget.invite[
                                                                  'group_id']);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Mesa recusada pelo estabelecimento",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              ColorTheme.yellow,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize:
                                                              wXD(16, context));
                                                      Modular.to.pop();
                                                    }
                                                  },
                                                  child: Container(
                                                      height: 61,
                                                      width: 142,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: const Color(
                                                                  0x29000000),
                                                              offset:
                                                                  Offset(0, 3),
                                                              blurRadius: 6,
                                                            ),
                                                          ],
                                                          color: ColorTheme
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      21)),
                                                      child: Center(
                                                        child: Text(
                                                          'Vou!',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            color: ColorTheme
                                                                .white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                )
                                              : Container(
                                                  height: wXD(61, context),
                                                  width: wXD(142, context),
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                              0x29000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                        ),
                                                      ],
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21)),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              ColorTheme
                                                                  .yellow),
                                                    ),
                                                  ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: wXD(24, context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                      // }
                    }),
                Positioned(
                  top: wXD(6, context),
                  right: wXD(6, context),
                  child: Visibility(
                      visible: showMenu,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              showMenu = !showMenu;
                            });
                          },
                          child: FloatMenu())),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Participant extends StatelessWidget {
  final bool host;
  final String group;
  final String name;
  final String hash;
  final String number;
  const Participant({
    this.hash,
    this.name,
    this.number,
    Key key,
    this.host,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String avatar;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: wXD(20, context), vertical: wXD(5, context)),
      height: wXD(69, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: host ? Color(0xffdadcdc) : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(hash)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Container();
                    }
                    avatar = snapshot.data['avatar'];
                    return Container(
                      width: wXD(64, context),
                      height: wXD(64, context),
                      margin: EdgeInsets.only(
                          left: wXD(10, context), top: 3, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        border:
                            Border.all(width: 3.0, color: ColorTheme.textGrey),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.network(avatar, fit: BoxFit.cover)),
                    );
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: wXD(15, context)),
                        width: wXD(170, context),
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(16, context),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('groups')
                              .document(group)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData) {
                              return Container();
                            }
                            // if (!snapshot.hasData) {
                            //   return Container();
                            // } else {
                            return host
                                ? Text(
                                    'anfitrião',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(16, context),
                                      color: ColorTheme.primaryColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.right,
                                  )
                                : Container();
                            // }
                          }),
                      SizedBox(
                        width: wXD(12, context),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: wXD(34, context),
                      ),
                      Text(
                        '$number',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(16, context),
                          color: ColorTheme.textGrey,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: wXD(10, context),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdicionarPessoasTitle extends StatelessWidget {
  final String name;
  final Timestamp dia;
  const AdicionarPessoasTitle({
    this.name,
    this.dia,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: EdgeInsets.only(left: wXD(30, context), bottom: wXD(7, context)),
      width: double.infinity,
      color: Color(0XFFEDEDED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: wXD(5, context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Em',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(16, context),
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Text(
                      '${DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, 'pt_Br').format(dia.toDate())}',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(12, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: wXD(5, context),
                    ),
                    Text(
                      '${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(dia.toDate())}',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(12, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: wXD(10, context),
                    ),
                  ],
                ),
                SizedBox(
                  height: wXD(7, context),
                ),
                Text(
                  '$name',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: wXD(36, context),
                      color: ColorTheme.darkCyanBlue,
                      fontWeight: FontWeight.w700,
                      height: 0.9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
