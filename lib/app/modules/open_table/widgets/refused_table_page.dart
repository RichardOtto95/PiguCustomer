import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_detail.dart';
import 'package:pigu/app/modules/open_table/widgets/float_menu.dart';
import 'package:pigu/app/modules/open_table/widgets/person_container.dart';
import 'package:pigu/app/modules/open_table/widgets/invites_alerts.dart';

import 'package:pigu/app/modules/open_table/widgets/table_invite_widget.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';

class RefusedTablePage extends StatefulWidget {
  RefusedTablePage({Key key}) : super(key: key);

  @override
  _RefusedTablePageState createState() => _RefusedTablePageState();
}

class _RefusedTablePageState extends State<RefusedTablePage> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  bool click = false;
  bool showMenu = false;
  final authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();
  final refusedController = Modular.get<OpenTableController>();
  String clickLabel;
  Future<dynamic> _refusedTablesFuture;
  bool eventVerifier;
  List<dynamic> refusedTables = new List();

  @override
  void initState() {
    refusedController.setClickLabel('onRefused');

    setState(() {
      // refusedController.groupEventCounter(homeController.categoryID);
      _refusedTablesFuture = getRefusedGroup();
      // eventVerifier = refusedController.eventVerifier;
      super.initState();
    });
  }

  // setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;

  // groupEventCounter(String group) {
  //   print('=====================groupSelected =====================  ${group}');

  //   FirebaseAuth.instance.currentUser().then((value) {
  //     Firestore.instance
  //         .collection('users')
  //         .document(value.uid)
  //         .get()
  //         .then((value) {
  //       value.data['my_group'].forEach((element) {
  //         if (element == group) {
  //           int index = value.data['my_group'].indexOf(element);
  //           print('MY GROUP INDEX &&&&&&&&&&&&&&&&&             : $index');
  //           int counter = value.data['event_counter'][index];
  //           print('GROUP EVENT COUNTER &&&&&&&&&&&&&&&&&&&      : $counter');
  //           print('counter: $counter');
  //           if (counter > 0) {
  //             return setEventVerifier(true);
  //           } else {
  //             return setEventVerifier(false);
  //           }
  //         }
  //       });
  //     });
  //   });
  // }

  Future<dynamic> getRefusedGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot _user = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'refused')
        .getDocuments();

    var mygroup = await _user.documents;
    // //print'HASHS :$mygroup');

    mygroup.forEach((element) async {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(element.data['id'])
          .get();
      _mygroup.reference.updateData({'id': _mygroup.documentID});

      // //print'_mygroup: ${_mygroup.data}');
      await refusedTables.add(_mygroup.data);
    });

    // await Future.delayed(Duration(seconds: mygroup.length ~/ 2));
    await Future.delayed(Duration(milliseconds: 500 * mygroup.length));

    refusedTables.sort((b, a) {
      return a['created_at'].compareTo(b['created_at']);
    });
    return refusedTables;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/');
      },
      child: Scaffold(
          body: SafeArea(
              child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NavBar(
                title: "",
                backPage: () {
                  Modular.to.pushNamed('/');
                },
                iconButton: Icon(Icons.more_vert, color: Color(0xfffafafa)),
                iconOnTap: () {
                  // //print"icon click");
                  setState(() {
                    showMenu = !showMenu;
                  });
                },
              ),
              SizedBox(
                height: wXD(5, context),
              ),
              Container(
                height: wXD(90, context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: wXD(90, context),
                        height: wXD(60, context),
                        child: TableInvite()),
                    Expanded(
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("invites")
                              .where('user_id',
                                  isEqualTo: homeController.user.uid)
                              .where('role', isEqualTo: 'invited')
                              .orderBy('created_at', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  alignment: Alignment.center,
                                  child: Text('Você não possui nenhum Convite!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorTheme.darkCyanBlue,
                                          fontSize: wXD(15, context))),
                                ),
                              );
                            } else {
                              if (snapshot.data.documents.length == 0 ||
                                  snapshot.data.documents.length == null) {
                                return Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Você não possui nenhum Convite!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ColorTheme.darkCyanBlue,
                                            fontSize: wXD(15, context))),
                                  ),
                                );
                              } else {
                                return new ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data.documents[index];
                                      return new InviteAlerts(
                                        // width: wXD(64, context),
                                        // height: wXD(64, context),
                                        // marTop: wXD(14, context),
                                        // marRight: wXD(12, context),
                                        // marLeft: wXD(0, context),
                                        // marBottom: wXD(8, context),
                                        goTo: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return OpenTableDetailPage(
                                              invite: ds,
                                            );
                                          }));
                                        },
                                        groupHash: ds['group_id'],
                                      );
                                    });
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
              AdicionarPessoasTitle(),
              SizedBox(
                height: wXD(5, context),
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: _refusedTablesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ),
                      );
                    else
                      return snapshot.data != null
                          ? snapshot.data.isEmpty
                              ? EmptyStateList(
                                  image: 'assets/img/empty_list.png',
                                  title: 'Sem contas recusadas no momento',
                                  description:
                                      'Não existem contas recusadas para serem listadas',
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var ds = snapshot.data[index];
                                    List<String> list = [];

                                    Firestore.instance
                                        .collection('groups')
                                        .document(ds['id'])
                                        .collection('members')
                                        .getDocuments()
                                        .then((value) {
                                      value.documents.forEach((element) {
                                        // //print
                                        //     'element: ${element.data['avatar']}');
                                        if (element.data['avatar'] != null) {
                                          list.add(element.data['avatar']);
                                        } else {
                                          list.add(
                                              'https://firebasestorage.googleapis.com/v0/b/ayou-4d78d.appspot.com/o/defaut%2FdefaultUser.png?alt=media&token=33daa153-d1f8-4d92-9afe-30e3f646a8fd');
                                        }
                                      });
                                    });
                                    return PersonContainer(
                                      listMembers: list,
                                      // eventVerifier: eventVerifier,
                                      group: ds['id'],
                                      onTap: () {
                                        // //print'ds: $ds');
                                        // refusedController
                                        //     .setSellerGroupSelected(
                                        //         ds['seller_id']);

                                        homeController
                                            .setmMyGroupSelected(ds['id']);

                                        Modular.to.pushNamed(
                                            'open-table/chat/' + ds['id'],
                                            arguments: ds['id']);

                                        Firestore.instance
                                            .collection('users')
                                            .document(homeController.user.uid)
                                            .collection('my_group')
                                            .where('id', isEqualTo: ds['id'])
                                            .snapshots()
                                            .first
                                            .then((value) => value
                                                .documents.first.reference
                                                .updateData(
                                                    {'event_counter': 0}));
                                      },
                                      name: ds['label'],
                                      createAt: ds['created_at'],
                                      avatar: ds['avatar'],
                                      sellerId: ds['seller_id'],
                                    );
                                  })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: wXD(100, context),
                                ),
                                Text("Você não está em uma mesa.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(16, context),
                                      color: ColorTheme.textColor,
                                      fontWeight: FontWeight.w300,
                                    )),
                                SizedBox(
                                  height: 70,
                                ),
                                InkWell(
                                  onTap: () {
                                    Modular.to.pushNamed('/');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Criar ",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "mesa",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(
                                        width: wXD(8, context),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: wXD(15, context)),
                                        height: wXD(100, context),
                                        width: wXD(55, context),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: ColorTheme.primaryColor),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(90),
                                                topLeft: Radius.circular(90))),
                                        child: Center(
                                            child: Image.asset(
                                                "assets/icon/addPeople.png")),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                  },
                ),
              ),
              click
                  ? InkWell(
                      onTap: () {
                        Modular.to.pushNamed('/chat');
                      },
                      child: Container(
                        height: wXD(80, context),
                        color: ColorTheme.yellow,
                        alignment: Alignment.center,
                        child: Text(
                          'Criar mesa',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(16, context),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ]),
          ),
          Visibility(
              visible: showMenu,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      showMenu = !showMenu;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      right: wXD(6, context),
                      top: wXD(6, context),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0x30000000),
                    alignment: Alignment.topRight,
                    child: FloatMenu(
                      click: clickLabel,
                      onTapRefused: () {
                        clickLabel = 'onRefused';
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RefusedTablePage();
                        }));
                      },
                    ),
                  ))),
          // Positioned(
          //   top: 6,
          //   right: 6,
          //   child: Visibility(
          //     visible: showMenu,
          //     child: InkWell(
          //       onTap: () {
          //         setState(() {
          //           showMenu = !showMenu;
          //         });
          //       },
          //       child: FloatMenu(
          //         click: clickLabel,
          //         onTapRefused: () {
          //           clickLabel = 'onRefused';
          //           Navigator.push(context, MaterialPageRoute(builder: (context) {
          //             return RefusedTablePage();
          //           }));
          //         },
          //       ),
          //     ),
          //   ),
          // ),
        ]),
      ))),
    );
  }
}

class AdicionarPessoasTitle extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  const AdicionarPessoasTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(100, context),
      padding: EdgeInsets.only(left: wXD(30, context)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: wXD(9, context),
          ),
          Text(
            'Contas',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(36, context),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w700,
                height: 0.9),
          ),
          Text(
            'recusadas',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(28, context),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w300,
                height: 1),
          ),
          SizedBox(
            height: wXD(13, context),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: wXD(5, context),
              width: wXD(170, context),
              color: Color(0xFFFF3D00),
            ),
          )
        ],
      ),
    );
  }
}

class LetterDivision extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final String letter;
  const LetterDivision({
    Key key,
    this.letter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(34, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: wXD(36, context),
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
