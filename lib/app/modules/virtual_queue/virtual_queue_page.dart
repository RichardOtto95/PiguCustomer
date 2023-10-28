import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/restaurant_selected/restaurant_selected_controller.dart';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'virtual_queue_controller.dart';

class VirtualQueuePage extends StatefulWidget {
  final seller;
  final String title;
  const VirtualQueuePage({Key key, this.title = "VirtualQueue", this.seller})
      : super(key: key);

  @override
  _VirtualQueuePageState createState() => _VirtualQueuePageState();
}

class _VirtualQueuePageState
    extends ModularState<VirtualQueuePage, VirtualQueueController> {
  final homeController = Modular.get<HomeController>();
  final restaurantController = Modular.get<RestaurantSelectedController>();
  //use 'controller' variable to access controller
  DocumentSnapshot queueDoc;
  QuerySnapshot queue;
  num queuelength;
  Timestamp now = Timestamp.now();
  DateTime queuetime;

  @override
  void initState() {
    // homeController.setSpn(false);
    super.initState();
  }

  @override
  void dispose() {
    homeController.setSpn(false);
    homeController.setSeller(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Modular.to.pushNamed('/');
    }, child: Observer(builder: (_) {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.primaryColor,
          toolbarHeight: wXD(100, context),
          leading: IconButton(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(wXD(20, context)),
            icon: Icon(
              Icons.arrow_back,
              size: wXD(30, context),
            ),
            onPressed: () {
              Modular.to.pushNamed('/');
              homeController.setSpn(false);
            },
          ),
          title: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ingressar na",
                  style: TextStyle(
                      fontSize: wXD(16, context),
                      color: ColorTheme.white,
                      fontWeight: FontWeight.w300),
                ),
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Fila Virtual",
                    style: TextStyle(
                        fontSize: wXD(30, context),
                        color: ColorTheme.white,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        body: SafeArea(
          child: homeController.sellerModel != null
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection('sellers')
                      .document(homeController.sellerModel.id)
                      .collection('queue')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    DocumentSnapshot queueDoc = snapshot.data.documents.first;
                    int forecast = snapshot
                        .data.documents.first.data['estimated_forecast']
                        .toInt();

                    int milliqueue = forecast.toInt() * 60000;
                    int noow = now.millisecondsSinceEpoch;
                    int totalmilli = noow + milliqueue;
                    queuetime = DateTime.fromMillisecondsSinceEpoch(totalmilli);

                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('sellers')
                            .document(homeController.sellerModel.id)
                            .collection('queue')
                            .document(queueDoc.documentID)
                            .collection('queued')
                            .snapshots(),
                        builder: (context, snapshot2) {
                          queue = snapshot2.data;
                          bool isQueued = false;
                          int position;
                          queue.documents.forEach((element) {
                            if (element.data['user_id'] ==
                                homeController.user.uid) {
                              position = element.data['pos'];
                              isQueued = true;
                            }
                            print(
                                'element >>>>>>>>>>>>>>>>>>>>>> ${element.data['user_id']}');
                          });

                          if (!snapshot2.hasData) {
                            return Container();
                          }
                          queuelength = queue.documents.length + 1;

                          if (queuelength.isNaN) {
                            queuelength = 1;
                          }
                          if (queuetime == null) {
                            queuetime = DateTime.now();
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(
                                      wXD(30, context),
                                      wXD(30, context),
                                      wXD(30, context),
                                      wXD(30, context)),
                                  child: Text(
                                    "No momento, todas as mesas do estabelecimento estão ocupadas!",
                                    style: TextStyle(
                                        fontSize: wXD(20, context),
                                        fontWeight: FontWeight.w300,
                                        color: ColorTheme.textColor),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(
                                      0, wXD(20, context), 0, wXD(20, context)),
                                  child: Text(
                                    "Quer aguardar na fila virtual?",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorTheme.textColor),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        wXD(18, context),
                                        0,
                                        wXD(18, context),
                                        0),
                                    child: Text(
                                      "Atualizado em tempo real",
                                      style: TextStyle(
                                          fontSize: wXD(18, context),
                                          fontWeight: FontWeight.w200,
                                          color: ColorTheme.textGrey),
                                    ),
                                  ),
                                  // Container(
                                  //   padding:
                                  //       EdgeInsets.fromLTRB(0, 0, 18, 10),
                                  //   child: Text(
                                  //     "tempo real",
                                  //     style: TextStyle(
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.w200,
                                  //         color: ColorTheme.textGrey),
                                  //   ),
                                  // )
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              wXD(18, context),
                                              wXD(18, context),
                                              wXD(18, context),
                                              0),
                                          child: Text(
                                            "Previsão de",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w200,
                                                color: ColorTheme.textGrey),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              wXD(18, context),
                                              0,
                                              wXD(18, context),
                                              0),
                                          child: Text(
                                            "Atendimento",
                                            style: TextStyle(
                                                fontSize: wXD(18, context),
                                                fontWeight: FontWeight.w200,
                                                color: ColorTheme.textGrey),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "${DateFormat('Hms').format(queuetime)}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.green),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0,
                                        wXD(30, context), 0, wXD(50, context)),
                                    child: Text(
                                      "Posição na fila ",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0,
                                        wXD(30, context), 0, wXD(50, context)),
                                    child: Text(
                                      '${queuelength}',
                                      style: TextStyle(
                                          fontSize: wXD(19, context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: ColorTheme.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(26.0)),
                                      child: Text(
                                        "Recusar",
                                        style: TextStyle(
                                            fontSize: wXD(20, context),
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Modular.to.pushNamed('/');
                                      },
                                      padding: EdgeInsets.fromLTRB(
                                          wXD(34, context),
                                          wXD(23, context),
                                          wXD(34, context),
                                          wXD(23, context)),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: ColorTheme.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(26.0)),
                                      child: Text(
                                        "Aceitar",
                                        style: TextStyle(
                                            fontSize: wXD(20, context),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (isQueued == true) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Você está na posição ${position.toString()} da fila",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  ColorTheme.primaryColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          setState(() {
                                            homeController.setSpn(false);
                                          });
                                          Modular.to.pop();
                                        } else {
                                          await homeController.setQRoute(true);
                                          Modular.to.pushNamed('/table-opening',
                                              arguments: widget.seller);
                                        }
                                      },
                                      padding: EdgeInsets.fromLTRB(
                                          wXD(39, context),
                                          wXD(23, context),
                                          wXD(39, context),
                                          wXD(23, context)),
                                      color: ColorTheme.primaryColor,
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        });
                  })
              : Container(),
        ),
      ));
    }));
  }
}
