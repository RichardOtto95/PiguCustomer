import 'package:pigu/app/modules/restaurant_selected/restaurant_selected_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/restaurant_selected/widgets/card_seller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantSelectedPage extends StatefulWidget {
  final String title;
  final SellerModel seller;
  const RestaurantSelectedPage(
      {Key key, this.title = "RestaurantSelected", this.seller})
      : super(key: key);

  @override
  _RestaurantSelectedPageState createState() => _RestaurantSelectedPageState();
}

class _RestaurantSelectedPageState
    extends ModularState<RestaurantSelectedPage, RestaurantSelectedController> {
  final homeController = Modular.get<HomeController>();
  final authController = Modular.get<AuthController>();

  //use 'controller' variable to access controller
  var primaryColor = Color.fromRGBO(254, 214, 165, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  int lastOrientation = -1;
  var stateButton = false;
  var fav;
  // num _tables;
  // num _usedTables;

  @override
  initState() {
    homeController.setSpn(false);
    getFavs();
    super.initState();
  }

  @override
  void dispose() {
    homeController.setShowSpnSync(false);
    // _tables = 0;
    // _usedTables = 0;
    super.dispose();
  }

  //  Future<void>
  getFavs() async {
    Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('favorite_sellers')
        .where('id', isEqualTo: widget.seller.id)
        .getDocuments()
        .then((value) {
      // print('KAKAKAKAK SELLLER ID${value.documents.first.data['id']}');
      // print('KAKAKAKAK WIDGETSELLLER ID${value.documents}');
      if (value.documents.isNotEmpty) {
        if (value.documents.first.data['id'] == widget.seller.id) {
          setState(() {
            stateButton = true;
          });
        }
      }
    });
  }

  // getTables() async {
  //   QuerySnapshot _tab = await Firestore.instance
  //       .collection('tables')
  //       .where('seller_id', isEqualTo: widget.seller.id)
  //       .getDocuments();

  //   QuerySnapshot _usdTab = await Firestore.instance
  //       .collection('tables')
  //       .where('seller_id', isEqualTo: widget.seller.id)
  //       .where('status', isEqualTo: 'used')
  //       .getDocuments();

  //   _tables = await _tab.documents.length;
  //   if (_tables < 1 || _tables == null) {
  //     _tables = 2;
  //   }
  //   _usedTables = await _usdTab.documents.length;
  //   if (_usedTables < 1 || _usedTables == null) {
  //     _usedTables = 1;
  //   }
  // }

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    var orientationn = MediaQuery.of(context).orientation.index;
    AppBar appBar = AppBar(
      leading: InkWell(
        onTap: () {
          Modular.to.pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: ColorTheme.primaryColor,
        ),
      ),
      backgroundColor: ColorTheme.white,
      elevation: 0,
    );

    return WillPopScope(
      onWillPop: () {
        Modular.to.pop();
      },
      // onWillPop: () => Future.value(false),
      child: SafeArea(
          child: Scaffold(
        appBar: appBar,
        backgroundColor: ColorTheme.white,
        body: SingleChildScrollView(
            child: orientationn == Orientation.landscape.index
                ? Container(
                    // height: MediaQuery.of(context).size.height * .1,
                    child: body(orientationn, context),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: body(orientationn, context))),
      )),
    );
  }

  Widget body(int orientation, context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          child: CardSeller(orientation, widget.seller),
          width: double.infinity,
          color: ColorTheme.white,
          height: size.height * .57,
        ),
        StreamBuilder(
            stream: Firestore.instance
                .collection("users")
                .document(homeController.user.uid)
                .collection('favorite_sellers')
                .where('id', isEqualTo: widget.seller.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                QuerySnapshot ds = snapshot.data;

                return Positioned(
                  child: GestureDetector(
                    onTap: () async {
                      //  stateButton = true;
                      setState(() {
                        stateButton = !stateButton;
                        // homeController.setrestfav(stateButton);
                      });
                      //  stateButton = false;

                      if (stateButton == true) {
                        await Firestore.instance
                            .collection('users')
                            .document(homeController.user.uid)
                            .collection('favorite_sellers')
                            .add({'id': widget.seller.id});
                      } else {
                        var doc = await Firestore.instance
                            .collection('users')
                            .document(homeController.user.uid)
                            .collection('favorite_sellers')
                            .where('id', isEqualTo: widget.seller.id)
                            .getDocuments();
                        await doc.documents.first.reference.delete();

                        // ds.documents[0].reference.delete();
                      }
                    },
                    child: ds.documents.isEmpty
                        ? Icon(
                            Icons.favorite_border,
                            color: ColorTheme.white,
                            size: wXD(32, context),
                          )
                        : ds.documents[0].data['id'] == widget.seller.id
                            ? Icon(Icons.favorite,
                                color: ColorTheme.white, size: wXD(32, context))
                            : Icon(
                                Icons.favorite_border,
                                color: ColorTheme.white,
                                size: wXD(32, context),
                              ),
                  ),
                  top: wXD(15, context),
                  right: wXD(15, context),
                );
              }
            }),
        // orientation == Orientation.landscape.index
        //     ? Positioned(
        //         top: 100,
        //         left: 100,
        //         child: Text("${widget.seller.name}",
        //             style:
        //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 46)),
        //       )
        //     : Positioned(
        //         top: 80,
        //         left: 40,
        //         child: Text("${widget.seller.name}",
        //             style:
        //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 38)),
        //       ),
        // CardSeller(orientation, widget.seller),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              // margin: EdgeInsets.only(bottom: 50),
              child: Observer(
            builder: (context) {
              return homeController.spin == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            homeController.setRouterMenu('seller-profile');
                            homeController.setSeller(widget.seller);
                            Modular.to
                                .pushNamed('/menu', arguments: widget.seller);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: wXD(14, context),
                              ),
                              Container(
                                child: Image.asset("assets/icon/menuOpen.png"),
                                width: wXD(50, context),
                                height: wXD(50, context),
                              ),
                              SizedBox(
                                width: wXD(10, context),
                              ),
                              Text("Ver",
                                  style: TextStyle(
                                      color: ColorTheme.textColor,
                                      fontSize: maxValue(
                                          value: size.height * .036, max: 17),
                                      // fontSize: 17,
                                      fontWeight: FontWeight.w300)),
                              SizedBox(
                                width: wXD(10, context),
                              ),
                              Text("menu",
                                  style: TextStyle(
                                      color: ColorTheme.textColor,
                                      // fontSize: size.height * .036,
                                      fontSize: maxValue(
                                          value: size.height * .036, max: 17),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Spacer(),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        Container(
                          height: wXD(70, context),
                          width: wXD(2, context),
                          color: ColorTheme.textGrey,
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                homeController.setSpn(true);
                              });

                              controller.setSeller(widget.seller);
                              homeController.setSeller(widget.seller);

                              await homeController.getTables(widget.seller);
                              print(
                                  'Spin ToasFy ===========:${homeController.showToastSync}');

                              await homeController.getTableOpening(
                                  seller: widget.seller);
                              print('quarto:');

                              // setState(() {
                              //   homeController.setSpn(false);
                              // });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Abrir",
                                    style: TextStyle(
                                        color: ColorTheme.textColor,
                                        fontSize: maxValue(
                                            value: size.height * .036, max: 17),
                                        fontWeight: FontWeight.w300)),
                                SizedBox(
                                  width: wXD(10, context),
                                ),
                                Text("Conta",
                                    style: TextStyle(
                                        color: ColorTheme.textColor,
                                        fontSize: maxValue(
                                            value: size.height * .036, max: 17),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: wXD(4, context),
                                ),
                                Container(
                                  height: wXD(100, context),
                                  width: wXD(50, context),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: ColorTheme.primaryColor),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(90),
                                          topLeft: Radius.circular(90))),
                                  child:
                                      Image.asset("assets/icon/addPeople.png"),
                                ),
                              ],
                            ))
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        homeController.showToastSync == true
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: ColorTheme.primaryColor,
                                ),
                                child: Text(
                                    "Aguarde a sincronização dos contatos",
                                    style: TextStyle(
                                        fontSize: 16, color: ColorTheme.white)),
                              )
                            : Container(),
                        SizedBox(
                          height: wXD(60, context),
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        )
                      ],
                    );
            },
          )),
        )
      ],
    );
  }

  double maxValue({double value, double max}) {
    if (value > max) {
      return max;
    } else
      return value;
  }
}
