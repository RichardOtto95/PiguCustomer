import 'dart:io';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/table_info/widgets/button_arquivar_mesa.dart';
import 'package:pigu/app/modules/table_info/widgets/card_title_mesa.dart';
import 'package:pigu/app/modules/table_info/widgets/container_reabrir.dart';
import 'package:pigu/app/modules/table_info/widgets/mesainfo_appbar.dart';
import 'package:pigu/app/modules/table_info/widgets/participante_tile.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './widgets/float_menu_table.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class TableInfoPage extends StatefulWidget {
  final String title;
  final group;

  const TableInfoPage({Key key, this.title = "TableInfo", this.group})
      : super(key: key);

  @override
  _TableInfoPageState createState() => _TableInfoPageState();
}

class _TableInfoPageState extends State<TableInfoPage> {
  final openTableController = Modular.get<OpenTableController>();
  final homeController = Modular.get<HomeController>();

  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var blackText = Color(0xff3C3C3B);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  bool checkMenu = false;
  var userStatus;
  double checkClickMenu = 0;
  Function kickmenu;
  // var mesaName = "Magros de Ruim";
  var status;
  String clickLabel;
  String hash = '';
  String groupStatus;

  File _imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });

    if (_imageFile != null) {
      var group = await Firestore.instance
          .collection('groups')
          .document(widget.group)
          .get();
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('groups/${group.documentID}/avatar/${_imageFile.path[0]}');

      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
        (value) async {
          await Firestore.instance
              .collection("groups")
              .document(group.documentID)
              .updateData({'avatar': value});
        },
      );
    }
  }

  Future<dynamic> futureMembersDocuments;
  List<dynamic> membersMaps = new List();

  Future<dynamic> getMembersDocuments() async {
    QuerySnapshot members = await Firestore.instance
        .collection("groups")
        .document(widget.group)
        .collection('members')
        .getDocuments();

    Map<String, dynamic> userMap = new Map();

    await members.documents.forEach((member) async {
      if (member.data['role'] == 'accepted_invite' ||
          member.data['role'] == 'created') {
        userMap = member.data;
        userMap['showMenu'] = false;
        membersMaps.add(userMap);
      }
    });

    membersMaps.sort((a, b) {
      return a['mobile_phone_number']
          .toLowerCase()
          .compareTo(b['mobile_phone_number'].toLowerCase());
    });

    await Future.delayed(Duration(seconds: 1));

    return membersMaps;
  }

  @override
  void initState() {
    futureMembersDocuments = getMembersDocuments();
    if (widget.group != widget.group.toString()) {
      setState(() {
        hash = widget.group[1];
      });
    } else {
      setState(() {
        hash = widget.group;
      });
    }
    Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('my_group')
        .where('id', isEqualTo: hash)
        .getDocuments()
        .then((value) {
      setState(() {
        status = value.documents.first.data['status'];
        // //print'statuuuuuuuuuuus $status');
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    openTableController.setUserView(null);
    openTableController.setMembersID([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var orientationn = MediaQuery.of(context).orientation.index;
    List<String> usersID = [];
    getMembers(DocumentSnapshot ds) async {
      QuerySnapshot qs =
          await ds.reference.collection('members').getDocuments();
      qs.documents.forEach((element) {
        usersID.add(element.data['user_id']);
      });
    }

    return WillPopScope(
      onWillPop: () {
        openTableController.setGroupSelected(hash);
        Modular.to.pop();
        //print" click add friend");
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("groups")
                  .document(hash)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                    ),
                  );
                } else {
                  groupStatus = snapshot.data['status'];
                  DocumentSnapshot ds = snapshot.data;
                  getMembers(ds);

                  return MesainfoAppbar(
                    newImage: () {
                      pickImage();
                    },
                    iconButton: Icon(Icons.group_add, color: Color(0xfffafafa)),
                    host: ds['user_host'],
                    title: ds['label'],
                    imageURL: ds['avatar'],
                    iconOnTap: () {
                      openTableController.setMembersID(usersID);
                      openTableController.setGroupSelected(hash);

                      Modular.to.pushNamed('/add-participant');
                    },
                  );
                }
              },
            ),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
          body: Column(
            children: [
              StreamBuilder(
                stream: Firestore.instance
                    .collection("groups")
                    .document(widget.group)
                    .snapshots(),
                builder: (context, group) {
                  if (group.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                    );
                  } else {
                    var ds = group.data;
                    return CardTitleMesa(
                      title: ds['seller_name'],
                      background_image: ds['bg_image'],
                      avatar: ds['avatar'],
                    );
                  }
                },
              ),
              status == 'paid'
                  ? ButtonArquivarMesa(
                      archived: () {
                        setState(() {
                          Future<QuerySnapshot> setStatus = Firestore.instance
                              .collection('users')
                              .document(homeController.user.uid)
                              .collection('my_group')
                              .where('id', isEqualTo: hash)
                              .getDocuments();
                          setStatus.then((value) {
                            value.documents.first.reference
                                .updateData({'status': 'filed'});
                          });
                        });
                        Modular.to.pushNamed('/open-table');
                      },
                    )
                  : Container(),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('order_sheets')
                    .where('group_id', isEqualTo: widget.group)
                    .snapshots(),
                builder: (context, sheetsSnap) {
                  if (sheetsSnap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                      ),
                    );
                  } else {
                    int paids = 0;
                    bool todosPagaram = false;

                    // if (){}
                    sheetsSnap.data.documents
                        .forEach((DocumentSnapshot member) {
                      if (member.data['status'] == 'paid') {
                        paids++;
                      }
                      if (paids == sheetsSnap.data.documents.length) {
                        todosPagaram = true;
                      }
                    });
                    return Container(
                      padding: EdgeInsets.fromLTRB(
                        wXD(20, context),
                        wXD(10, context),
                        wXD(25, context),
                        wXD(10, context),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              "${sheetsSnap.data.documents.length} participantes:",
                              style: TextStyle(
                                fontSize: wXD(18, context),
                              )),
                          todosPagaram
                              ? Text("todos pagaram",
                                  style: TextStyle(
                                      fontSize: wXD(18, context),
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold))
                              : Text(
                                  "$paids/${sheetsSnap.data.documents.length} pagaram",
                                  style: TextStyle(
                                      fontSize: wXD(16, context),
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold))
                        ],
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: futureMembersDocuments,
                  builder: (context, userSnap) {
                    if (userSnap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ),
                      );
                    } else {
                      String dropdownValue = 'One';

                      return ListView.builder(
                        itemCount: userSnap.data.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var ds = userSnap.data[index];

                          return Stack(alignment: Alignment.center, children: [
                            ParticipanteTile(
                              showMenu: () {},
                              participante: ds,
                            ),
                            Positioned(
                              right: 0,
                              child: DropdownButton(
                                onTap: () {
                                  openTableController
                                      .setUserView(ds['user_id']);
                                },
                                itemHeight: wXD(50, context),
                                elevation: 0,
                                underline: Container(),
                                iconSize: 0,
                                autofocus: false,
                                focusColor: Colors.transparent,
                                dropdownColor: Colors.transparent,
                                selectedItemBuilder: (context) {
                                  return [
                                    Container(
                                      height: wXD(50, context),
                                      width: wXD(375, context),
                                    ),
                                  ];
                                },
                                value: dropdownValue,
                                style: TextStyle(color: Colors.deepPurple),
                                onChanged: (String newValue) {},
                                items: <String>[
                                  'One'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: wXD(150, context)),
                                      child: FloatMenu(
                                        userView: ds['user_id'],
                                        tapPartialCheck: () {
                                          if (ds['status'] == 'awaiting') {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Aguarde a abertura da Conta...",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.SNACKBAR,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.white,
                                                textColor: ColorTheme.yellow,
                                                fontSize: wXD(
                                                    wXD(16, context), context));
                                          } else {
                                            Modular.to.pushNamed(
                                                'open-table/pay-the-bill',
                                                arguments: hash);
                                            // }
                                          }
                                        },
                                        group: hash,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            ds['role'] == 'paid'
                                ? Positioned(
                                    // right: wXD(289, context),
                                    left: wXD(60, context),
                                    top: wXD(12, context),
                                    child: Image.asset(
                                      "assets/icon/closed.png",
                                      fit: BoxFit.fill,
                                      width: wXD(30, context),
                                      height: wXD(30, context),
                                    ),
                                  )
                                : Container()
                          ]);
                        },
                      );
                    }
                  },
                ),
              ),
              ((status == 'filed' && groupStatus == 'open') ||
                      (status == 'paid' && groupStatus == 'open'))
                  ? ContainerReabrir(
                      reopen: () {
                        openTableController.createMessage(
                            groupId: widget.group);
                        setState(
                          () {
                            Future<QuerySnapshot> setGroup = Firestore.instance
                                .collection('groups')
                                .document(widget.group)
                                .collection('members')
                                .where('user_id',
                                    isEqualTo: homeController.user.uid)
                                .getDocuments();

                            setGroup.then((value3) {
                              value3.documents.first.reference
                                  .updateData({'role': 'accepted_invite'});
                            });

                            Future<QuerySnapshot> setMyGroup = Firestore
                                .instance
                                .collection('users')
                                .document(homeController.user.uid)
                                .collection('my_group')
                                .where('id', isEqualTo: hash)
                                .getDocuments();

                            setMyGroup.then(
                              (value) {
                                value.documents.first.reference
                                    .updateData({'status': 'open'});
                              },
                            );
                            Future<QuerySnapshot> setOrdSht = Firestore.instance
                                .collection('order_sheets')
                                .where('user_id',
                                    isEqualTo: homeController.user.uid)
                                .where('group_id', isEqualTo: hash)
                                .getDocuments();

                            setOrdSht.then(
                              (value2) {
                                value2.documents.first.reference
                                    .updateData({'status': 'opened'});

                                value2.documents.first.reference
                                    .collection('orders')
                                    .getDocuments()
                                    .then((value3) {
                                  value3.documents.forEach((element) {
                                    element.reference
                                        .updateData({'item_status': 'paid'});
                                  });
                                });
                              },
                            );
                          },
                        );
                        Modular.to.pushNamed('/open-table');
                      },
                    )
                  : Container(),
            ],
          ),
          // )
          // body: orientationn != Orientation.landscape.index
          //     ? getBody(hash, orientationn, context)
          //     : SingleChildScrollView(
          //         child: getBody(hash, orientationn, context),
          //       )
        ),
      ),
    );
  }
}
