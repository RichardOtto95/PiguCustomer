// import 'package:pigu/app/core/models/contact_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/table_opening/widgets/person_contact.dart';
import 'package:pigu/app/modules/table_opening/widgets/person_photo_selected_create.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/widgets/fabButtom.dart';
// import 'package:pigu/app/modules/table_opening/widgets/person_container.dart';
// import 'package:pigu/app/modules/table_opening/widgets/person_photo_selected.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';
import 'table_opening_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TableOpeningPage extends StatefulWidget {
  final String title;
  final SellerModel seller;

  const TableOpeningPage({Key key, this.title = "TableOpening", this.seller})
      : super(key: key);

  @override
  _TableOpeningPageState createState() => _TableOpeningPageState();
}

class _TableOpeningPageState
    extends ModularState<TableOpeningPage, TableOpeningController> {
  int qntMesa = 0;
  // List<ContactModel> _contacts = List<ContactModel>();
  List arrayAux = [];
  List<String> strList = [];
  Future<dynamic> _friendsArray;

  List arrayInvites = [];
  List arrayInvitesFinal = [];

  List searchedContact = [];
  bool invited = false;
  bool loadCircular = false;
  bool search = false;
  bool searching = false;
  bool sincr = false;
  bool click = false;
  // String _searchText = "";
  // bool _IsSearching;
  ImagePicker picker = ImagePicker();

  FocusNode searchFocus;
  TextEditingController searchController = TextEditingController();
  Map<String, bool> participantCheck = Map();
  final homeController = Modular.get<HomeController>();
  get list => null;

  bool hasFocus = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    textEditingController = TextEditingController();
    arrayInvites = [];
    searchFocus = FocusNode();

    _friendsArray = getContacts();

    super.initState();
  }

  void dispose() {
    sincr = false;
    homeController.setQRoute(false);
    controller.setHaveInvite(false);
    setInviteToFalse();
    controller.setSeller(null);
    searchFocus.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        controller.setImage(File(pickedFile.path));
      } else {}
    });
  }

  Future<dynamic> getContactsInvited(arrayInvites) async {
    return await arrayInvites;
  }

  setInviteToFalse() {
    Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('contacts')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        if (element.data['invited'] == true) {
          element.reference.updateData({'invited': false});
        }
      });
    });
  }

  Future<void> askPermissions() async {
    var user = await FirebaseAuth.instance.currentUser;
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getContacts();
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<dynamic> getContacts() async {
    QuerySnapshot _friends = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('contacts')
        .getDocuments();
    _friends.documents.forEach((element) async {
      DocumentSnapshot _friend = await Firestore.instance
          .collection('users')
          .document(element.data['id'])
          .get();
      if (_friend.data != null) {
        await arrayAux.add(_friend.data);
        if (_friend.data['username'] != null) {
          await strList.add(_friend.data['username']);
        }
      }
    });

    await Future.delayed(
        Duration(milliseconds: 500 * _friends.documents.length));
    arrayAux.sort((a, b) {
      return a['username'].compareTo(b['username']);
    });

    strList.sort((a, b) {
      return a.compareTo(b);
    });

    return strList;
  }

  // _SearchListState() {
  //   searchController.addListener(() {
  //     if (searchController.text.isEmpty) {
  //       setState(() {
  //         _IsSearching = false;
  //         _searchText = "";
  //       });
  //     } else {
  //       setState(() {
  //         _IsSearching = true;
  //         _searchText = searchController.text;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    // double headerHeight = 0;
    // double alphabeticHeight = 0;
    // Size size = MediaQuery.of(context).size;
    String fav;
    // String name = '';

    return WillPopScope(
      onWillPop: () {
        homeController.setSpn(false);
        Modular.to.pop();
      },
      child: Observer(
        builder: (_) {
          controller.seller = widget.seller;
          controller.setSeller(widget.seller);
          return Scaffold(
              resizeToAvoidBottomPadding: true,
              resizeToAvoidBottomInset: true,
              body: Listener(
                onPointerDown: (covariant) {
                  hasFocus = false;
                  searchFocus.unfocus();
                },
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavBar(
                        backPage: () {
                          homeController.setSpn(false);
                          Modular.to.pop();
                        },
                        title: "Criar mesa",
                        iconButton: Icon(
                          Icons.refresh,
                          color: Color(0xfffafafa),
                        ),
                        iconOnTap: sincr == false
                            ? () async {
                                // Fluttertoast.showToast(
                                //     msg: 'Sincronizando contatos',
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.SNACKBAR,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: ColorTheme.yellow,
                                //     textColor: ColorTheme.white,
                                //     fontSize: 16.0);
                                DocumentSnapshot userDs = await Firestore
                                    .instance
                                    .collection('users')
                                    .document(homeController.user.uid)
                                    .get();

                                userDs.reference
                                    .updateData({'contactlist_sync': false});
                                print(
                                    'contactsync antes+++:==========================:${userDs.data['contactlist_sync']}');
                                await homeController.askPermissions();
                                bool contactsync =
                                    await userDs.data['contactlist_sync'];
                                print(
                                    'contactsync depoos da funcao+++:==========================:${userDs.data['contactlist_sync']}');
                                await Modular.to
                                    .pushReplacementNamed('/table-opening');

                                if (contactsync == true) {
                                  Fluttertoast.showToast(
                                      msg: 'Contatos sincronizados com sucesso',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorTheme.yellow,
                                      textColor: ColorTheme.white,
                                      fontSize: 16.0);

                                  setState(() {
                                    sincr = true;
                                  });
                                }
                              }
                            : () {
                                // Fluttertoast.showToast(
                                //     msg: 'Contatos sincronizados com sucesso',
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.SNACKBAR,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: ColorTheme.yellow,
                                //     textColor: ColorTheme.white,
                                //     fontSize: 16.0);
                              },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: wXD(14),
                              ),
                              Container(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        left: 0,
                                        top: 5,
                                        child: Container(
                                          height: wXD(100),
                                          width: wXD(55),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      ColorTheme.primaryColor),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(90),
                                                  topRight:
                                                      Radius.circular(90))),
                                          child: Image.asset(
                                              "assets/icon/addPeople.png"),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: wXD(64)),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  getImage();
                                                },
                                                child: controller.imageFile ==
                                                        null
                                                    ? Container(
                                                        width: wXD(62),
                                                        height: wXD(62),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                          border: Border.all(
                                                              width: 3.0,
                                                              color: ColorTheme
                                                                  .textGrey),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: const Color(
                                                                  0x29000000),
                                                              offset:
                                                                  Offset(0, 3),
                                                              blurRadius: 6,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                            Icons.add_a_photo))
                                                    : Container(
                                                        width: wXD(62),
                                                        height: wXD(62),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                          border: Border.all(
                                                              width: 3.0,
                                                              color: ColorTheme
                                                                  .textGrey),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: const Color(
                                                                  0x29000000),
                                                              offset:
                                                                  Offset(0, 3),
                                                              blurRadius: 6,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                          child: Image.file(
                                                              controller
                                                                  .imageFile),
                                                        ),
                                                      ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: wXD(21),
                                                    left: wXD(15)),
                                                child: TextField(
                                                  onChanged: (val) {
                                                    setState(() {
                                                      controller
                                                          .setTableName(val);
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Minha mesa",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            ColorTheme.textGrey,
                                                        fontSize: wXD(16),
                                                        fontWeight:
                                                            FontWeight.w300),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: ColorTheme
                                                              .textGrey),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: ColorTheme
                                                              .textGrey),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        FutureBuilder(
                                            future: _friendsArray,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Container();
                                              }
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Container();
                                              }

                                              if (!snapshot.hasData) {
                                                return EmptyStateList(
                                                  image:
                                                      'assets/img/empty_list.png',
                                                  title:
                                                      'Sem participantes nos seus contatos',
                                                  description:
                                                      'Não existem contatos para serem listados!',
                                                );
                                              } else {
                                                return Container(
                                                  // height: addParticipant
                                                  height: arrayInvites.length !=
                                                          0
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.13
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.05,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Visibility(
                                                              visible:
                                                                  // addParticipant,
                                                                  arrayInvites
                                                                          .length !=
                                                                      0,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width: wXD(
                                                                          74)),
                                                                  Text(
                                                                    'participantes',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          wXD(14),
                                                                      color: ColorTheme
                                                                          .textColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: wXD(
                                                                          8)),
                                                                  Text(
                                                                    '${arrayInvites.length}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          wXD(14),
                                                                      color: ColorTheme
                                                                          .blueCyan,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                            width: wXD(300),
                                                            // height: 60,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  arrayInvites
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                var username =
                                                                    arrayInvites[
                                                                        index];

                                                                // print(
                                                                //     'ds cima: ${snapshot.data}');
                                                                return arrayInvites
                                                                        .contains(
                                                                            username)
                                                                    ? PersonPhotoSelectedCreate(
                                                                        username:
                                                                            username,
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            arrayInvites.remove(username);

                                                                            controller.setHaveInvite(arrayInvites.length !=
                                                                                0);
                                                                          });
                                                                        })
                                                                    : Container();
                                                              },
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        Observer(
                                          builder: (context) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    left: wXD(53)),
                                                child: Container(
                                                  height: !controller.haveInvite
                                                      // height: arrayInvites.length == 0
                                                      ? 100
                                                      : 0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Adicione',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          // fontSize: 36,
                                                          fontSize: wXD(34),
                                                          color: ColorTheme
                                                              .darkCyanBlue,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'participantes',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: wXD(34),
                                                          color: ColorTheme
                                                              .darkCyanBlue,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                // ),
                                                );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: wXD(5)),
                                alignment: Alignment.center,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                  height: searchFocus.hasFocus ? wXD(48) : 0,
                                  width: searchFocus.hasFocus
                                      ? MediaQuery.of(context).size.width * .85
                                      : 0,
                                  child: Focus(
                                    child: TextFormField(
                                      controller: textEditingController,
                                      onChanged: (val) {
                                        fav = val;
                                        val = val.toLowerCase();
                                        searchContacts(val);
                                      },
                                      focusNode: searchFocus,
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
                                          width: wXD(20),
                                          height: wXD(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 1,
                                color: ColorTheme.textGrey,
                              ),
                              Listener(
                                onPointerMove: (event) {
                                  if (event.delta.direction < 0) {
                                    controller.setShowSearchButton(false);
                                  } else {
                                    controller.setShowSearchButton(true);
                                  }
                                },
                                child: FutureBuilder<dynamic>(
                                    future: _friendsArray,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: hXD(120, context)),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      ColorTheme.yellow),
                                            ),
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return EmptyStateList(
                                          image: 'assets/img/empty_list.png',
                                          title:
                                              'Sem participantes nos seus contatos',
                                          description:
                                              'Não existem contatos para serem listados!',
                                        );
                                      }
                                      if (snapshot.hasData) {
                                        print(
                                            'USER NAME: ==========================${snapshot.data}');
                                        return searchedContact.length == 0
                                            ? snapshot.data.isEmpty
                                                ? EmptyStateList(
                                                    image:
                                                        'assets/img/empty_list.png',
                                                    title:
                                                        'Sem participantes nos seus contatos',
                                                    description:
                                                        'Não existem contatos para serem listados!',
                                                  )
                                                : Container(
                                                    height: controller
                                                            .haveInvite
                                                        ? searchFocus.hasFocus
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                wXD(350)
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                wXD(300)
                                                        : searchFocus.hasFocus
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                wXD(420)
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                wXD(360),
                                                    child: AlphabetScrollView(
                                                      list: snapshot.data
                                                          .map<AlphaModel>(
                                                              (user) =>
                                                                  AlphaModel(
                                                                      user))
                                                          .toList(),
                                                      itemExtent: wXD(80),
                                                      waterMark: (value) =>
                                                          Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: ColorTheme
                                                              .yellow
                                                              .withOpacity(0.8),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '$value'
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      alignment:
                                                          LetterAlignment.left,
                                                      isAlphabetsFiltered:
                                                          false,
                                                      itemBuilder: (context,
                                                          index, username) {
                                                        print(
                                                            'USER NAME: ==========================${username}');
                                                        return PersonContact(
                                                          username: username,
                                                          onTap: () {
                                                            setState(() {
                                                              if (arrayInvites
                                                                  .contains(
                                                                      username)) {
                                                                arrayInvites
                                                                    .remove(
                                                                        username);
                                                              } else {
                                                                arrayInvites.add(
                                                                    username);
                                                              }
                                                              controller.setHaveInvite(
                                                                  arrayInvites
                                                                          .length !=
                                                                      0);
                                                            });
                                                          },
                                                          selected: arrayInvites
                                                              .contains(
                                                                  username),
                                                        );
                                                      },
                                                    ),
                                                  )
                                            : Container(
                                                height: controller.haveInvite
                                                    ? searchFocus.hasFocus
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            wXD(340)
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            wXD(290)
                                                    : searchFocus.hasFocus
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            wXD(410)
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            wXD(360),
                                                child: ListView.builder(
                                                  itemCount:
                                                      searchedContact.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var ds =
                                                        searchedContact[index];

                                                    return PersonContact(
                                                      username: ds,
                                                      onTap: () {
                                                        setState(() {
                                                          if (arrayInvites
                                                              .contains(ds)) {
                                                            arrayInvites
                                                                .remove(ds);
                                                          } else {
                                                            arrayInvites
                                                                .add(ds);
                                                          }
                                                          controller.setHaveInvite(
                                                              arrayInvites
                                                                      .length !=
                                                                  0);
                                                        });
                                                      },
                                                      selected: arrayInvites
                                                          .contains(ds),
                                                    );
                                                  },
                                                ));
                                      }
                                      return Container();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<Object>(
                          stream: Firestore.instance
                              .collection('users')
                              .document(homeController.user.uid)
                              .snapshots(),
                          builder: (context, snapshotUser) {
                            if (!snapshotUser.hasData) {
                              return Container();
                            } else {
                              DocumentSnapshot _user = snapshotUser.data;
                              return _user['contactlist_sync']
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 12.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: ColorTheme.primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                                "Aguarde a sincronização dos contatos",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: ColorTheme.white)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                            }
                          }),
                      loadCircular
                          ? Center(
                              heightFactor: 2,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorTheme.yellow),
                              ),
                            )
                          :
                          // Observer(
                          //     builder: (context) {
                          //       return
                          InkWell(
                              onTap: () {
                                if (controller.tableName.isNotEmpty &&
                                    controller.imageFile != null) {
                                  arrayInvites.forEach((element) async {
                                    QuerySnapshot userId = await Firestore
                                        .instance
                                        .collection('users')
                                        .where('username', isEqualTo: element)
                                        .getDocuments();
                                    arrayInvitesFinal
                                        .add(userId.documents.first.documentID);
                                  });
                                  setState(() {
                                    controller
                                        .setArrayInvites(arrayInvitesFinal);

                                    loadCircular = true;
                                  });
                                  controller
                                      .openTable(homeController.sellerModel);
                                  setInviteToFalse();
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Digite o nome da mesa e coloque uma foto!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: ColorTheme.yellow,
                                      fontSize: 16.0);
                                }
                              },
                              child: Container(
                                height: wXD(60),
                                color: ColorTheme.primaryColor,
                                alignment: Alignment.center,
                                child: Text(
                                  'Criar mesa',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: wXD(16),
                                    color: ColorTheme.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                      //   },
                      // )
                    ],
                  ),
                ),
              ),
              floatingActionButton: Visibility(
                visible: controller.showSearchButton,
                child: InkWell(
                    onTap: () {
                      print('hasfocus $hasFocus');
                      if (hasFocus) {
                        searchFocus.unfocus();
                        textEditingController.clear();
                        fav = '';
                        searchContacts(fav);
                        hasFocus = false;
                      } else {
                        searchFocus.requestFocus();
                        hasFocus = true;
                      }
                    },
                    child: FabButton(
                      image: 'assets/icon/fab.png',
                      size: 45,
                    )),
              ));
        },
      ),
    );
  }

  searchContacts(String text) {
    searchedContact = [];
    if (text != '' || text != null) {
      arrayAux.forEach((element) {
        if (element['username'].toLowerCase().contains(text)) {
          searchedContact.add(element['username']);
        }
      });
    }
    setState(() {});
  }
}
