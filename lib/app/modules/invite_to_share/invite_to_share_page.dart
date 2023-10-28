import 'package:pigu/app/modules/open_table/open_table_page.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/table_opening/widgets/person_photo_selected.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/app/modules/home/widgets/fabButtom.dart';
import 'package:pigu/app/modules/invite_to_share/widgets/person_container.dart';
import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';

import 'invite_to_share_controller.dart';

class InviteToSharePage extends StatefulWidget {
  final String title;
  final order;
  final bool search;

  const InviteToSharePage(
      {Key key, this.title = "InviteToShare", this.order, this.search = false})
      : super(key: key);

  @override
  _InviteToSharePageState createState() => _InviteToSharePageState();
}

class _InviteToSharePageState
    extends ModularState<InviteToSharePage, InviteToShareController> {
  //use 'controller' variable to access controller
  Map<String, bool> participantCheck = Map();
  bool click = false;
  bool search = false;
  bool unsearch = false;
  dynamic qntMesa = true;
  String name = '';
  final authController = Modular.get<AuthController>();
  final menuController = Modular.get<MenuController>();
  List arrayInvites = [];
  final homeController = Modular.get<HomeController>();
  FocusNode myFocusNode;
  Future<dynamic> _task2;
  Future<dynamic> _task;
  List arrayAux = [];
  String image;
  String person = '';
  List searchResult = [];

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController = TextEditingController();
    _task = getMemembers();
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    cleanInvited();
    myFocusNode.dispose();

    super.dispose();
  }

  Future<dynamic> getMemembers() async {
    QuerySnapshot orderSheetMembers = await Firestore.instance
        .collection('order_sheets')
        .where('group_id', isEqualTo: homeController.groupChat)
        .where('status', isEqualTo: 'opened')
        .getDocuments();

    QuerySnapshot _friends = await Firestore.instance
        .collection("groups")
        .document(homeController.groupChat)
        .collection('members')
        .getDocuments();

    orderSheetMembers.documents.forEach((orderSheet) async {
      _friends.documents.forEach((element) {
        if (homeController.user.uid != element.data['user_id'] &&
            element.data['user_id'] == orderSheet.data['user_id']) {
          arrayAux.add(element.data);
        }
      });
    });

    return arrayAux;
  }

  cleanInvited() {
    Firestore.instance
        .collection("groups")
        // .document(homeController.groupCode)
        .document(homeController.groupChat)
        .collection('members')
        .getDocuments()
        .then((group) {
      group.documents.forEach((element) {
        element.reference.updateData({'selected_user': false});
      });
    });
  }

  Future<dynamic> getContactsInvited(arrayInvites) async {
    return await arrayInvites;
  }

  @override
  Widget build(BuildContext context) {
    String fav;
    // print(' Pedido ----- ${widget.order}');

    return StreamBuilder(
        stream: Firestore.instance
            .collection("groups")
            // .document(homeController.groupCode)
            .document(homeController.groupChat)
            // .where('role',isEqualTo:'invited')
            .snapshots(),
        builder: (context, snapshotGroup) {
          if (!snapshotGroup.hasData) {
            return LinearProgressIndicator();
          } else {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      myFocusNode.unfocus();
                      // });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavBar(
                          backPage: () {
                            Modular.to.pop();
                          },
                          title: "${snapshotGroup.data['label']}",
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  height: 100,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: ColorTheme.primaryColor),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(90),
                                          topRight: Radius.circular(90))),
                                  child: Center(
                                      child: Image.asset(
                                          "assets/icon/addPeople.png")),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 42),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: 134,
                                                height: 65,
                                                // margin: EdgeInsets.only(left: 85),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
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
                                                      BorderRadius.circular(14),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: menuController
                                                                .imageOrderShare !=
                                                            null
                                                        ? menuController
                                                            .imageOrderShare
                                                        : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQwAAAC8CAMAAAC672BgAAABGlBMVEX///9YrjnF1vPr6+vk5OSdnZ3D1POvsLHI2fTt9P7l6O/k7fzu7u7n7/rV4vd6eXx+h3tul2DKzNBgpUjc6PvS4fn5+fmWlpfR3vOJiYqgoKH1+P3CytewsrbV2d+RkZLV1dXA1Oxcr0Hy+fDExMW3t7i70uSyztabxq55unKoycaorbW8xNN8v2P6/fmqq6vKz9nI0uO7vsPV3u2zzdmnycOaxqyiyLqOv5mBuoN8uXmHvYxhrUtqs1pztWi30dKRxI611rnb6eeMxXu4267R6Mmo1Jjh8NzG47tzu1nF39HO4eiGxHCjz5yo0LGrvLuVo5mataKNn4yMr4qDo359rnV2r2rG1sCEl4GTvIWrtKeTqYt6nG69x7rFCBnUAAAEX0lEQVR4nO3a61/aVhzHcTUgsFy6UUjC1QAJNy1RRFAuYgdIrdZZq1u7dv//v7HfOQmFeNserPpazvf9pC8hD5LP63eSE+3aGgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAf0OPPE1S9Jc+xeejGNEnxZKSLkwOJZp13dgjXDcbswUaDooRaycf0Y5FXce2IqLUoBhO8qdHJJ0oDY4jzEqhGO2imniQWqQYbkyc2WAxdlVVle+hD4sFNjdW0k5akgg1eAxZTj1AlncLUdeWJMuh26gIs6EYFIOuXGNYABZG837apxixpKJHbLZSBHiosBh5uvw0k5L5rcL7SUtp+YLBYigRy7IpR+hvoxSjkNdS6XScrl9OsI9yspdGM/PbhsseJbpiOa5tKcpLn+0P9j0GGwU1xz7KqawGxWExso5Fm3LLjtH2y7JCPhpeDM1bIzkeQ8/l1NQihpH19qJRgzYcTshHg95N/BjeWHhyqraIYfCXF/5PNiq93Ik+By8Ge5Am7sfY2yksuTQdYsRQ/SXiYzHiadPc390tLiSdrBgxaCz0FeyBEo/HTTPFN6KEnrjFtiAxUv41L8h0A2U1/G2YtzcXJcY9vAUtFL4t5VtzeVeAGFve0yT+IHrImKa/U6cYW+GPsZ03H4vhB+E7srwQMQp5M/1EDL8IvagIEMPY5jE2nsJi7LVjbth3oF6M+D/EiKe1/WIyGfZ3k38Vg0ZDk9Xwv7X6MVavvMQFYqS1wHY9pFiMHRZjc4FiVJlSaXP5WVoO7tfD6U4MPhadGulUSxubi0TxVOKlT/Q5BGKUStXO+KDXq3e79XrvoFnzxoPdMMI/FmvLGHwAqp1m7/Co32+Q/tHgsN7sUI0NU1YFWCNEWolR6jTrg+Nh2TMcHR9RjWopnvJLhP4XwlJmEaNarfW6g/6ovO5hNQbd3njf/9WoLkUiIa8hZba8GKUajUV/NFy0WPeG4+Ttr/4zNWI5Yd+Bfo9RbdYPl2OxGI7hZDr3DtQjdjTs7yZeDJPWSHfQGA0DLdbPLibTWYUdlsslim0jI0aMWrNHt87hncF4czqbV1rssJwq5wuCxDgf9w4bo+BYlMtnk3d8LFqtVkLWdrbFiLE35vfOYIuzyel0zsaiNZ+9fX/O/ogiQoz2+Xuai7tr5GJKa4QdUpl9OLkcm2JMhvvb+PJoVC4H54LuF3wsKpXZtHE86J2LMRlXHy9PGsG5KL+ZnL7ja4RSnE5Go/5h7+BqS4AY15+OGnc2GHTr9B8j8+nFGW3QR/0Pn64FiJH5fHP7+/HrFaMzf6ulK9IfX/hXx7cDMWL8/Pnm5tsvS7dfTv2tlmTZf37lX327+Xp9lQl9jFcZyhFw9de8wteIHnGM5Xd0XPhj3GPY/vuYbrmZ1S8yryIve7I/mi7ds/xffXTPCAr5KzwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwP/a38wtqoLPT/bDAAAAAElFTkSuQmCC',
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              ColorTheme
                                                                  .yellow),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: Container(
                                                  width: 36.0,
                                                  height: 28.0,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(21.0),
                                                      topRight:
                                                          Radius.circular(21.0),
                                                      bottomRight:
                                                          Radius.circular(21.0),
                                                      bottomLeft:
                                                          Radius.circular(58.0),
                                                    ),
                                                    color: ColorTheme.blueCyan,
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
                                                        fontSize: 9,
                                                        color: ColorTheme.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 4),
                                                Text(
                                                  '${menuController.qtdOrder.toInt()}',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: wXD(16, context),
                                                    color: ColorTheme.textColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Container(
                                                  width: wXD(225, context),
                                                  child: Text(
                                                    '${menuController.nameOrderShare}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          wXD(16, context),
                                                      color:
                                                          ColorTheme.textColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // SizedBox(
                                              //   height: 28,
                                              // ),
                                              Text(
                                                'Dividir',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 36,
                                                  color:
                                                      ColorTheme.darkCyanBlue,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                'com',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 36,
                                                  color:
                                                      ColorTheme.darkCyanBlue,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 30),
                                            width: 180,
                                            height: 70,
                                            child: new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: arrayInvites.length,
                                                itemBuilder: (context, index) {
                                                  var ds = arrayInvites[index];
                                                  return ds['selected_user'] ==
                                                          true
                                                      ? new PersonPhotoSelected(
                                                          avatar: image,
                                                          onTap: () {
                                                            setState(() {
                                                              ds['selected_user'] =
                                                                  false;
                                                              arrayInvites
                                                                  .remove(ds);
                                                            });
                                                          },
                                                        )
                                                      : SizedBox(width: 0);
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Center(
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                                // duration: Duration(milliseconds: 300),
                                // curve: Curves.easeIn,
                                height: myFocusNode.hasFocus ? 50 : 0,
                                width: myFocusNode.hasFocus
                                    ? MediaQuery.of(context).size.width * .85
                                    : 0,
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                      height: myFocusNode.hasFocus ? 50 : 0,
                                      width: myFocusNode.hasFocus
                                          ? wXD(295, context)
                                          : 0,
                                      child: TextFormField(
                                        controller: textEditingController,
                                        onChanged: getSearchResult,
                                        focusNode: myFocusNode,
                                        decoration: InputDecoration(
                                          labelText: fav != null && fav != ""
                                              ? ''
                                              : "Pesquisar usuario...",
                                          labelStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200,
                                          ),
                                          prefixIcon: Image.asset(
                                            'assets/icon/fab.png',
                                            fit: BoxFit.fill,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        textEditingController.clear();
                                        search = false;
                                        myFocusNode.unfocus();
                                        fav = '';
                                        getSearchResult(fav);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: myFocusNode.hasFocus
                                            ? wXD(20, context)
                                            : 0,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: wXD(10, context)),
                              height: 0.5,
                              color: ColorTheme.textColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 14),
                              child: Text(
                                'participantes:',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: searchResult.isNotEmpty
                              ? searching()
                              : FutureBuilder<dynamic>(
                                  future: _task,
                                  builder: (context, snapshot2) {
                                    if (!snapshot2.hasData) {
                                      return Container();
                                    } else {
                                      if (snapshot2.data.length == 0) {
                                        return EmptyStateList(
                                          image: 'assets/img/empty_list.png',
                                          title: 'Sem contatos',
                                          description:
                                              'Essa mesa ainda não tem contatos',
                                        );
                                      }

                                      // bool selected = false;
                                      return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot2.data.length,
                                        itemBuilder: (context, index) {
                                          var ds = snapshot2.data[index];
                                          // print('snapshot2.data:  ${ds}');

                                          // print('mesa com membros: ${ds.data}');
                                          return ds['user_id'] !=
                                                      homeController.user.uid &&
                                                  ds['role'] != 'invited'
                                              ? StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection('users')
                                                      .document(ds['user_id'])
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshot3) {
                                                    if (snapshot3.hasData) {
                                                      if (snapshot3
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    ColorTheme
                                                                        .yellow),
                                                          ),
                                                        );
                                                      } else {
                                                        DocumentSnapshot user =
                                                            snapshot3.data;
                                                        return PersonContainer(
                                                          avatar: user
                                                              .data['avatar'],
                                                          name: user
                                                              .data['username'],
                                                          tel: user.data[
                                                              'mobile_phone_number'],
                                                          onTap: () {
                                                            setState(() {
                                                              image = user.data[
                                                                  'avatar'];
                                                              if (ds['selected_user'] ==
                                                                  null) {
                                                                ds['selected_user'] =
                                                                    false;
                                                                ds['selected_user'] =
                                                                    !ds['selected_user'];
                                                              } else {
                                                                ds['selected_user'] =
                                                                    !ds['selected_user'];
                                                              }
                                                              if (arrayInvites.every(
                                                                  (element) =>
                                                                      element[
                                                                          'mobile_phone_number'] !=
                                                                      user.data[
                                                                          'mobile_phone_number'])) {
                                                                arrayInvites
                                                                    .add(user
                                                                        .data);
                                                              }

                                                              if (ds['selected_user'] ==
                                                                  false) {
                                                                print(
                                                                    'ds[selected_user] ===========: ${ds['selected_user']}');
                                                                arrayInvites.removeWhere((item) =>
                                                                    item[
                                                                        'id'] ==
                                                                    user.data[
                                                                        'id']);

                                                                // arrayInvites
                                                                //     .remove(user
                                                                //         .data);
                                                              }
                                                              print(
                                                                  'arrayInvites ===========: ${arrayInvites}');
                                                              _task2 =
                                                                  getContactsInvited(
                                                                      arrayInvites);
                                                            });
                                                          },
                                                          selected:
                                                              ds['selected_user'] ==
                                                                  true,
                                                        );
                                                      }
                                                    } else
                                                      return Container();
                                                  },
                                                )
                                              : Container();
                                        },
                                      );
                                    }
                                  },
                                ),
                        ),
                        Visibility(
                          visible: arrayInvites.length != 0,
                          child: InkWell(
                            onTap: () {
                              menuController
                                  .setusersInvitedToshare(arrayInvites);
                              menuController.setConfirmOrder(
                                  menuController.orderWithInvite);
                              menuController.setTotalAmountOrder();
                              menuController.setclickItem(false);
                              menuController.setAddOrder(1);

                              // menuController.setConfirmOrder();
                              // Modular.to.pop();
                            },
                            child: Container(
                              height: 65,
                              color: ColorTheme.primaryColor,
                              alignment: Alignment.center,
                              child: Text(
                                'Chamar para dividir',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: ColorTheme.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                floatingActionButton: InkWell(
                    onTap: () {
                      if (search) {
                        textEditingController.clear();
                        search = false;
                        myFocusNode.unfocus();
                        fav = '';
                        getSearchResult(fav);
                      } else {
                        myFocusNode.requestFocus();
                        textEditingController.clear();
                        search = true;
                      }
                    },
                    child: FabButton(
                      image: 'assets/icon/fab.png',
                      size: 45,
                    )));
          }
        });
  }

  getSearchResult(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    arrayAux.forEach((element) {
      if (element['username'].contains(text)) {
        searchResult.add(element);
      }

      setState(() {});
    });
  }

  Widget searching() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        var ds = searchResult[index];
        // print('snapshot2.data:  ${ds}');

        // print('mesa com membros: ${ds.data}');
        if (ds['username'].contains(person)) {
          return ds['user_id'] != homeController.user.uid &&
                  ds['role'] != 'invited'
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(ds['user_id'])
                      .snapshots(),
                  builder: (context, snapshot3) {
                    if (snapshot3.hasData) {
                      if (snapshot3.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(ColorTheme.yellow),
                          ),
                        );
                      } else {
                        DocumentSnapshot user = snapshot3.data;
                        return PersonContainer(
                          avatar: user.data['avatar'],
                          name: user.data['username'],
                          tel: user.data['mobile_phone_number'],
                          onTap: () {
                            setState(() {
                              image = user.data['avatar'];
                              if (ds['selected_user'] == null) {
                                ds['selected_user'] = false;
                                ds['selected_user'] = !ds['selected_user'];
                              } else {
                                ds['selected_user'] = !ds['selected_user'];
                              }
                              if (arrayInvites.every((element) =>
                                  element['mobile_phone_number'] !=
                                  user.data['mobile_phone_number'])) {
                                arrayInvites.add(user.data);
                              }
                              if (ds['selected_user'] == false) {
                                arrayInvites.removeWhere(
                                    (item) => item['id'] == user.data['id']);
                              }
                              _task2 = getContactsInvited(arrayInvites);
                            });
                          },
                          selected: ds['selected_user'] == true,
                        );
                      }
                    } else
                      return Container();
                  },
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}
