import 'dart:async';

import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/home/widgets/fabButtom.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_participant_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/table_opening/widgets/person_container.dart';
import 'package:pigu/app/modules/table_opening/widgets/person_photo_selected.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class AddParticipantPage extends StatefulWidget {
  final String title;
  final SellerModel seller;
  final String groupID;
  const AddParticipantPage(
      {Key key, this.title = "AddParticipant", this.seller, this.groupID})
      : super(key: key);

  @override
  _AddParticipantPageState createState() => _AddParticipantPageState();
}

class _AddParticipantPageState
    extends ModularState<AddParticipantPage, AddParticipantController> {
  final openTableController = Modular.get<OpenTableController>();
  Map<String, bool> participantCheck = Map();

  List<Contact> _contacts;
  List arrayAux = [];
  List searchedContact = [];
  List<String> strList = [];
  // List arrayInvites = [];
  bool invited = false;
  bool loadCircular = false;
  bool hasFocus = false;
  FocusNode searchFocus;

  bool addParticipant = false;
  TextEditingController searchController = TextEditingController();
  final homeController = Modular.get<HomeController>();

  Future<dynamic> _task;
  Future<dynamic> _task2;

  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    searchFocus = FocusNode();
    _task = getContacts();
    super.initState();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    getListener();
  }

  bool isScrollingDown = false;

  getListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          controller.setUnsearch(false);
          isScrollingDown = true;
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          controller.setUnsearch(true);
        }
      }
    });
  }

  void dispose() {
    setInviteToFalse();
    searchFocus.dispose();
    openTableController.setGroupSelected(null);
    super.dispose();
  }

  Future<dynamic> getContactsInvited(arrayInvites) async {
    return await arrayInvites;
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
      arrayAux.add(_friend.data);
      if (element.data['fullname'] != null) {
        strList.add(_friend.data['fullname']);
      } else {
        strList.add(_friend.data['mobile_phone_number']);
      }
    });
    await Future.delayed(
        Duration(milliseconds: 500 * _friends.documents.length));
    arrayAux.sort((a, b) {
      return a['username'].compareTo(b['username']);
    });
    return arrayAux;
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

  bool click = false;
  String name = '';

  @override
  Widget build(BuildContext context) {
    // //print'%%%%%%%%%%%%%%% groupID ${widget.groupID} %%%%%%%%%%%%%%%');
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    String fav = '';
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavBar(
              backPage: () {
                Modular.to.pop();
              },
              title: "Adicione Participantes",
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // SizedBox(height: 14),
                Container(
                  // color: Colors.red,
                  // height: 119,
                  height: wXD(119),
                ),
                Positioned(
                    left: 0,
                    top: 19,
                    child: Container(
                      // height: 100,
                      // width: 55,
                      height: wXD(100),
                      width: wXD(55),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorTheme.primaryColor),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(90),
                              topRight: Radius.circular(90))),
                      child: Image.asset("assets/icon/addPeople.png"),
                    )),
                Container(
                  // padding: EdgeInsets.only(left: 70, top: 14),
                  padding: EdgeInsets.only(left: wXD(70), top: wXD(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: 92,
                        height: wXD(92),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Adicione',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  // fontSize: 36,
                                  fontSize: 36,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              child: Text(
                                'participantes',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  // fontSize: 36,
                                  fontSize: 36,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                  height: wXD(65),
                                  child: Observer(builder: (context) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.arrayInvites.length,
                                      itemBuilder: (context, index) {
                                        var ds = controller.arrayInvites[index];

                                        return StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('users')
                                                .document(ds)
                                                .snapshots(),
                                            builder: (context, snapshot2) {
                                              if (!snapshot2.hasData) {
                                                return Container();
                                              }
                                              DocumentSnapshot member =
                                                  snapshot2.data;
                                              return controller.arrayInvites
                                                      .contains(
                                                          member.documentID)
                                                  ? PersonPhotoSelected(
                                                      avatar: snapshot2
                                                          .data['avatar'],
                                                      onTap: () {
                                                        setState(() {
                                                          controller
                                                              .arrayInvites
                                                              .remove(member
                                                                  .documentID);
                                                        });
                                                      })
                                                  : Container();
                                            });
                                      },
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Observer(
                        builder: (context) {
                          return Row(
                            children: [
                              Text(
                                'participantes',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  // fontSize: 16,
                                  fontSize: 15,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${controller.arrayInvites.length}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  color: ColorTheme.blueCyan,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: wXD(128),
                              )
                            ],
                          );
                        },
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: searchFocus.hasFocus ? wXD(50) : 0,
                        width: searchFocus.hasFocus
                            ? MediaQuery.of(context).size.width * .85
                            : 0,
                        child: TextFormField(
                          controller: textEditingController,
                          onChanged: (val) {
                            searchContacts(val);
                            fav = val;
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
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: wXD(8),
            ),
            Container(
              height: wXD(1),
              color: ColorTheme.textGrey,
            ),
            Expanded(
              child: searchedContact.length == 0
                  ? new FutureBuilder(
                      future: _task, // a Future<String> or null
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return new Text('Press button to start');
                          case ConnectionState.waiting:
                            return Container(
                              padding: EdgeInsets.only(top: wXD(120)),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(ColorTheme.yellow),
                                ),
                              ),
                            );

                          default:
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            else {
                              return
                                  // searchedContact.length == 0
                                  //     ?
                                  ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  var ds = snapshot.data[index];
                                  if (openTableController.membersID
                                      .contains(ds['id'])) {
                                    return Container();
                                  }
                                  return FutureBuilder(
                                      future: Firestore.instance
                                          .collection('users')
                                          .document(ds['id'])
                                          .get(),
                                      builder: (context, snapshot2) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        if (snapshot.hasError) {
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (snapshot2.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        }
                                        {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              DocumentSnapshot member =
                                                  snapshot2.data;
                                              return PersonContainer(
                                                avatar: member['avatar'],
                                                name: member['username'],
                                                tel: member[
                                                    'mobile_phone_number'],
                                                code: member[
                                                    'mobile_region_code'],
                                                onTap: () {
                                                  setState(() {
                                                    if (controller.arrayInvites
                                                        .contains(member
                                                            .documentID)) {
                                                      controller.arrayInvites
                                                          .remove(member
                                                              .documentID);
                                                      // ds.reference.updateData(
                                                      //     {'invited': false});
                                                    } else {
                                                      controller.arrayInvites
                                                          .add(member
                                                              .documentID);
                                                      // ds.reference.updateData(
                                                      //     {'invited': true});
                                                    }

                                                    _task2 = getContactsInvited(
                                                        controller
                                                            .arrayInvites);
                                                  });
                                                },
                                                selected: controller
                                                    .arrayInvites
                                                    .contains(
                                                        member.documentID),
                                                // ds.data['invited'] == true,
                                              );
                                            },
                                          );
                                        }
                                      });
                                },
                              );
                            }
                        }
                      })
                  : ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: searchedContact.length,
                      itemBuilder: (context, index) {
                        var ds = searchedContact[index];
                        if (openTableController.membersID.contains(ds['id'])) {
                          return Container();
                        }
                        return StatefulBuilder(
                          builder: (context, setState) {
                            var member = ds;
                            return PersonContainer(
                              avatar: member['avatar'],
                              name: member['username'],
                              tel: member['mobile_phone_number'],
                              code: member['mobile_region_code'],
                              onTap: () {
                                setState(() {
                                  if (controller.arrayInvites
                                      .contains(member['id'])) {
                                    controller.arrayInvites
                                        .remove(member['id']);
                                  } else {
                                    controller.arrayInvites.add(member['id']);
                                  }

                                  _task2 = getContactsInvited(
                                      controller.arrayInvites);
                                });
                              },
                              selected: controller.arrayInvites
                                  .contains(member['id']),
                              // ds.data['invited'] == true,
                            );
                          },
                        );
                      },
                    ),
            ),
            loadCircular
                ? Center(
                    heightFactor: 2,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                    ))
                : Observer(
                    builder: (context) {
                      return Visibility(
                        visible: controller.arrayInvites.length != 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // controller.setArrayInvites(arrayInvites);
                              // controller.arrayInvites = arrayInvites;
                              loadCircular = true;
                            });

                            controller.arrayInvites.length == 1
                                ? Fluttertoast.showToast(
                                    msg: "Convite enviado com sucesso.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorTheme.primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Fluttertoast.showToast(
                                    msg: "Convites enviados com sucesso.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorTheme.primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                            controller.updateTable(
                              openTableController.groupSelected,
                            );

                            Modular.to.pushNamed('/chat/' + widget.groupID,
                                arguments: widget.groupID);
                          },
                          child: Center(
                            child: Container(
                              // height: 60,
                              height: wXD(60),
                              color: ColorTheme.primaryColor,
                              alignment: Alignment.center,
                              child: Text(
                                'Convidar',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  // fontSize: 16,
                                  fontSize: wXD(15),
                                  color: ColorTheme.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
      floatingActionButton: Observer(
        builder: (context) {
          return Visibility(
            visible: controller.showSearchButton,
            child: InkWell(
              onTap: () {
                if (hasFocus) {
                  hasFocus = false;
                  searchFocus.unfocus();
                  textEditingController.clear();
                  fav = '';
                  searchContacts(fav);
                } else {
                  textEditingController.clear();
                  hasFocus = true;
                  searchFocus.requestFocus();
                }
              },
              child: FabButton(
                image: 'assets/icon/fab.png',
                size: wXD(45),
              ),
            ),
          );
        },
      ),
    );
  }

  searchContacts(String text) async {
    searchedContact = [];
    // print('############# teeeeeext $text');
    // print('############# teeeeeext ${arrayAux.first}');
    var user = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('contacts')
        .getDocuments()
        .then((contacts) {
      contacts.documents.forEach((contact) {
        // print('contaaaaaaaaact ${contact.data}');
        Firestore.instance
            .collection('users')
            .document(contact.data['id'])
            .get()
            .then((user) {
          // print('useeeeeeeeer ${user.data}');
          if (user.data['username']
              .toLowerCase()
              .contains(text.toLowerCase())) {
            searchedContact.add(user.data);
          }
          setState(() {});
        });
      });
    });
  }
}
