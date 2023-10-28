import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/menu/widgets/bottom_action_container.dart';
import 'package:pigu/app/modules/menu/widgets/slide_menu.dart';
import 'package:pigu/app/modules/menu/widgets/slide_menu_mockup.dart';
import 'package:pigu/app/modules/order/order_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'menu_controller.dart';

class MenuPage extends StatefulWidget {
  final String title;
  final SellerModel seller;
  const MenuPage({
    Key key,
    this.title = "Menu",
    this.seller,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends ModularState<MenuPage, MenuController> {
  final homeController = Modular.get<HomeController>();
  final SlidableController slidableController = SlidableController();
  bool click = false;
  var fav;
  var stateButton = false;
  bool clickItem = false;
  // String item = null;
  String status;
  bool requestedMenu = false;
  String sellerCategories;
  CarouselController _controller;
  CarouselController _controller2;
  Future<dynamic> _task;
  List arrayAux = [];
  SellerModel seller;

  int highlindex;
  @override
  void dispose() {
    homeController.setRouterMenu(null);
    controller.setSlideMenu('slidy_menu_mockup');

    super.dispose();
  }

  @override
  void initState() {
    print('MENU 1 ${controller.clickItem} ${controller.itemId}');
    _controller = new CarouselController();
    _controller2 = new CarouselController();
    _task = getListing();

    setState(() {
      homeController.setmMyGroupSelected(homeController.groupChat);
      seller = homeController.sellerModel;
      click = false;
    });
    getFavs();
    super.initState();
  }

  Future<dynamic> getListing() async {
    QuerySnapshot _listing = await Firestore.instance
        .collection("listings")
        .where('seller_id', isEqualTo: controller.homeController.sellerModel.id)
        .getDocuments();

    _listing.documents.forEach((element) {
      arrayAux.add(element.data);
    });

    arrayAux.asMap().forEach((i, element) async {
      DocumentSnapshot _sellerCategory = await Firestore.instance
          .collection("sellers")
          .document(homeController.sellerModel.id)
          .collection("categories")
          .document(element['category_id'])
          .get();
      setState(() {
        element['highlindex'] = _sellerCategory.data['highlindex'];
        element['category_id'] = _sellerCategory.data['id'];
      });
    });
    await Future.delayed(Duration(seconds: 1));

    arrayAux.sort((a, b) {
      return a['highlindex'].compareTo(b['highlindex']);
    });

    return arrayAux;
  }

  getFavs() async {
    Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('favorite_sellers')
        .where('id', isEqualTo: homeController.sellerModel.id)
        .getDocuments()
        .then((value) {
      if (value.documents.isNotEmpty) {
        if (value.documents.first.data['id'] == homeController.sellerModel.id) {
          setState(() {
            stateButton = true;
          });
        }
      }
    });
  }

  bool getEnable() {
    switch (homeController.routerMenu) {
      case 'seller-profile':
        if (seller.protectedPrices == null || seller.protectedPrices == true) {
          // print('ENTROU NO IF DO CASE');

          return false;
        } else {
          // print('ENTROU NO ELSE');

          return true;
        }

        break;

      case 'invite':
        return false;
        break;

      default:
        if (homeController.awaitingCheckout == false) {
          return true;
        } else {
          return false;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        if (controller.clickItem) {
          controller.setclickItem(false);
        } else {
          homeController.setRouterMenu(null);

          Modular.to.pop();
        }
      },
      child: Observer(
        builder: (_) {
          return Scaffold(
            backgroundColor: Color(0xffFAFAFA),
            body: SafeArea(
              child: (homeController.sellerModel.id == null)
                  ? Column(
                      children: [
                        NavBar(
                          backPage: () {
                            homeController.setRouterMenu(null);
                            setState(() {
                              click = !click;
                            });
                            Modular.to.pop();
                          },
                          title: "",
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        EmptyStateList(
                          image: 'assets/img/empty_list.png',
                          title: 'Sem menu cadastrado',
                          description:
                              'O menu deste estabelecimento ainda não foi cadastrado',
                        ),
                        Spacer(
                          flex: 2,
                        )
                      ],
                    )
                  : (controller.homeController.sellerModel.id != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection('users')
                                    .document(homeController.user.uid)
                                    .collection('favorite_sellers')
                                    .where('id',
                                        isEqualTo:
                                            homeController.sellerModel.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  QuerySnapshot ds = snapshot.data;
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    return NavBar(
                                      backPage: () {
                                        homeController.setRouterMenu(null);
                                        setState(() {
                                          click = !click;
                                        });
                                        Modular.to.pop();
                                      },
                                      title:
                                          "${homeController.sellerModel.name}",
                                      iconButton: ds.documents.isEmpty
                                          ? Icon(
                                              Icons.favorite_border,
                                              color: ColorTheme.white,
                                              size: wXD(32, context),
                                            )
                                          : ds.documents.first.data['id'] ==
                                                  homeController.sellerModel.id
                                              ? Icon(Icons.favorite,
                                                  color: ColorTheme.white,
                                                  size: wXD(32, context))
                                              : Icon(
                                                  Icons.favorite_border,
                                                  color: ColorTheme.white,
                                                  size: wXD(32, context),
                                                ),
                                      iconOnTap: () async {
                                        setState(() {
                                          stateButton = !stateButton;
                                        });
                                        if (stateButton == true) {
                                          await Firestore.instance
                                              .collection('users')
                                              .document(homeController.user.uid)
                                              .collection('favorite_sellers')
                                              .add({
                                            'id': homeController.sellerModel.id
                                          });
                                        } else {
                                          var doc = await Firestore.instance
                                              .collection('users')
                                              .document(homeController.user.uid)
                                              .collection('favorite_sellers')
                                              .where('id',
                                                  isEqualTo: homeController
                                                      .sellerModel.id)
                                              .getDocuments();
                                          await doc.documents.first.reference
                                              .delete();
                                        }
                                      },
                                    );
                                  }
                                }),
                            Expanded(
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: wXD(22, context),
                                            top: wXD(8, context),
                                            bottom: wXD(8, context)),
                                        child: Text(
                                          "Sugestões",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            // fontSize: 16,
                                            fontSize: 17,
                                            color: ColorTheme.textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        width: size.width,
                                        height: wXD(215, context),
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("listings")
                                                .where('seller_id',
                                                    isEqualTo: controller
                                                        .homeController
                                                        .sellerModel
                                                        .id)
                                                .where('highlighted',
                                                    isEqualTo: true)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              } else {
                                                return new ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data.documents.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      int count = snapshot.data
                                                          .documents.length;
                                                      DocumentSnapshot ds =
                                                          snapshot.data
                                                              .documents[index];
                                                      Widget finalItem(
                                                          int lenght,
                                                          int index) {
                                                        index++;
                                                        if (index == lenght) {
                                                          return SizedBox(
                                                            width: size.width *
                                                                0.05,
                                                          );
                                                        } else {
                                                          return SizedBox();
                                                        }
                                                      }

                                                      return Row(
                                                        children: [
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.05),
                                                          new InkWell(
                                                            onTap: () async {
                                                              await controller
                                                                  .queuedAsking(
                                                                      ds['preparation_time']);
                                                              setState(() {
                                                                // controller
                                                                //         .itemId =
                                                                //     ds['id'];
                                                                controller
                                                                    .setItemId(
                                                                        ds['id']);
                                                                // //print
                                                                //     'item : $item');

                                                                controller
                                                                    .setclickItem(
                                                                        !clickItem);
                                                              });
                                                            },
                                                            child: ItemMenu(
                                                                protectedPrices:
                                                                    seller.protectedPrices ==
                                                                            null
                                                                        ? false
                                                                        : seller
                                                                            .protectedPrices,
                                                                image:
                                                                    ds['image'],
                                                                name:
                                                                    ds['label'],
                                                                note: ds[
                                                                    'description'],
                                                                price: formatedCurrency(
                                                                    ds['price'])),
                                                          ),
                                                          finalItem(
                                                              count, index)
                                                        ],
                                                      );
                                                    });
                                              }
                                            }),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: wXD(4, context)),
                                        height: 1,
                                        color: ColorTheme.textGrey,
                                      ),
                                      // comeco do menu
                                      StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("sellers")
                                              .document(controller
                                                  .homeController
                                                  .sellerModel
                                                  .id)
                                              .collection('categories')
                                              .orderBy('highlindex',
                                                  descending: false)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            } else {
                                              return new Container(
                                                  height: wXD(38, context),
                                                  child: CarouselSlider.builder(
                                                    options: CarouselOptions(
                                                        enlargeCenterPage: true,
                                                        enableInfiniteScroll:
                                                            true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        autoPlay: false,
                                                        viewportFraction: 0.4,
                                                        aspectRatio: 10.0,
                                                        initialPage: 0,
                                                        onPageChanged:
                                                            (index, reason) {
                                                          snapshot
                                                              .data.documents
                                                              .asMap()
                                                              .forEach(
                                                                  (i, element) {
                                                            if (element.data[
                                                                    'highlindex'] !=
                                                                highlindex) {
                                                            } else {
                                                              _controller2.animateToPage(
                                                                  i,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1));
                                                            }
                                                          });
                                                        }),
                                                    carouselController:
                                                        _controller2,
                                                    itemCount: snapshot
                                                        .data.documents.length,
                                                    itemBuilder: (context,
                                                        index, realIndex) {
                                                      return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              highlindex = snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  'highlindex'];
                                                            });
                                                            snapshot
                                                                .data.documents
                                                                .asMap()
                                                                .forEach((i,
                                                                    element) {
                                                              if (element.data[
                                                                      'highlindex'] ==
                                                                  highlindex) {
                                                                _controller2.animateToPage(
                                                                    i,
                                                                    // curve: Curves
                                                                    //     .easeIn,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1));
                                                                for (var i = 0;
                                                                    i <
                                                                        arrayAux
                                                                            .length;
                                                                    i++) {
                                                                  if (arrayAux[
                                                                              i]
                                                                          [
                                                                          'highlindex'] ==
                                                                      highlindex) {
                                                                    _controller.animateToPage(
                                                                        i,
                                                                        // curve: Curves
                                                                        //     .easeIn,
                                                                        duration:
                                                                            Duration(seconds: 1));
                                                                    break;
                                                                  }
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                                    // borderRadius: BorderRadius
                                                                    //     .all(Radius
                                                                    //         .circular(
                                                                    //             25.0)),
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            width:
                                                                                2.0,
                                                                            color: highlindex == snapshot.data.documents[index].data['highlindex']
                                                                                ? ColorTheme.primaryColor
                                                                                : Color(0xffFAFAFA)))),
                                                            child: Center(
                                                              child: Text(
                                                                "${snapshot.data.documents[index].data['label']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 13,
                                                                  color: ColorTheme
                                                                      .textGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ));
                                                    },
                                                  ));
                                            }
                                          }),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                wXD(373, context),
                                            child: FutureBuilder(
                                              future: _task,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                } else {
                                                  return CarouselSlider.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder: (context,
                                                        index, realIndex) {
                                                      var ds =
                                                          snapshot.data[index];
                                                      // print('ds: ${ds}');
                                                      bool confirmOrder = false;

                                                      return Slidable(
                                                        key: Key('${ds['id']}'),
                                                        controller:
                                                            slidableController,
                                                        actionPane:
                                                            SlidableScrollActionPane(),
                                                        enabled: getEnable(),
                                                        secondaryActions: [
                                                          StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .all(wXD(10,
                                                                        context)),
                                                                child: Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            confirmOrder =
                                                                                true;
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          // height:
                                                                          //     MediaQuery.of(context).size.height * 0.2,
                                                                          width: confirmOrder
                                                                              ? 0
                                                                              : wXD(70, context),
                                                                          decoration: BoxDecoration(
                                                                              color: ColorTheme.primaryColor,
                                                                              borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                'Pedir',
                                                                                style: TextStyle(color: Colors.white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            confirmOrder =
                                                                                false;
                                                                          });
                                                                          controller
                                                                              .setSeller(homeController.sellerModel);
                                                                          await controller.setQntdGroups(
                                                                              sellerId: seller.id);
                                                                          await controller.simpleOrder(
                                                                              listing: ds,
                                                                              router: homeController.routerMenu);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height: wXD(
                                                                              90,
                                                                              context),
                                                                          width: confirmOrder
                                                                              ? wXD(70, context)
                                                                              : 0,
                                                                          decoration: BoxDecoration(
                                                                              color: ColorTheme.blueCyan,
                                                                              borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                'Confirmar',
                                                                                style: TextStyle(color: Colors.white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              );
                                                            },
                                                          )
                                                        ],
                                                        child: HorizontalItem(
                                                          protectedPrices: seller
                                                                      .protectedPrices ==
                                                                  null
                                                              ? false
                                                              : seller
                                                                  .protectedPrices,
                                                          title: ds['label'],
                                                          note:
                                                              ds['description'],
                                                          price:
                                                              formatedCurrency(
                                                                  ds['price']),
                                                          onTap: () async {
                                                            await controller
                                                                .queuedAsking(ds[
                                                                    'preparation_time']);
                                                            setState(() {
                                                              // controller.itemId =
                                                              //     ds['id'];
                                                              controller
                                                                  .setItemId(
                                                                      ds['id']);
                                                              controller
                                                                  .setclickItem(
                                                                      !clickItem);
                                                            });
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    options: CarouselOptions(
                                                      pageSnapping: false,
                                                      initialPage: 3,
                                                      disableCenter: true,
                                                      enableInfiniteScroll:
                                                          true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      autoPlay: false,
                                                      viewportFraction:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height <
                                                                  600
                                                              ? 0.25
                                                              : 0.2,
                                                      autoPlayInterval:
                                                          Duration(seconds: 1),
                                                      aspectRatio: 2.0,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        var ds = snapshot
                                                            .data[index];
                                                        if (highlindex !=
                                                            ds['highlindex']) {
                                                          setState(() {
                                                            highlindex = ds[
                                                                'highlindex'];
                                                          });
                                                          _controller2
                                                              .animateToPage(
                                                            index,
                                                            duration: Duration(
                                                                seconds: 1),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    carouselController:
                                                        _controller,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Observer(builder: (context) {
                                    print(
                                        ' controller.orderConfirm.isNotEmpty ==================: ${controller.orderConfirm.isNotEmpty}');
                                    return Positioned(
                                        bottom: 0,
                                        child: controller
                                                .orderConfirm.isNotEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    // //print"clicou");
                                                    click = !click;
                                                  });
                                                },
                                                child: InkWell(
                                                    child:
                                                        BottomActionContainer(
                                                  items: controller
                                                      .totalAmountOrder
                                                      .toInt()
                                                      .toString(),
                                                  totalPrice: formatedCurrency(
                                                      controller.totalMenu),
                                                  confirm: () {
                                                    setState(() {
                                                      click = false;
                                                      //print"click: $click");
                                                    });
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return OrderPage(
                                                          order: controller
                                                              .orderConfirm);
                                                    }));
                                                  },
                                                )))
                                            : homeController.routerMenu ==
                                                    'seller-profile'
                                                ? Container()
                                                : Container());
                                  }),
                                  Observer(
                                    builder: (context) {
                                      return Visibility(
                                        visible: controller.clickItem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    controller
                                                        .setclickItem(true);
                                                    controller.setAddOrder(1);
                                                  });
                                                },
                                                child: StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection("listings")
                                                      .where('seller_id',
                                                          isEqualTo: seller.id)
                                                      .where('id',
                                                          isEqualTo:
                                                              controller.itemId)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Container();
                                                    }

                                                    DocumentSnapshot
                                                        documentFields =
                                                        snapshot.data.documents
                                                            .first;

                                                    controller.slideFunction(
                                                        awaitingCheckout:
                                                            homeController
                                                                .awaitingCheckout,
                                                        route: homeController
                                                            .routerMenu,
                                                        seller: seller,
                                                        groupId: homeController
                                                            .groupChat);

                                                    return Observer(
                                                      builder: (context) {
                                                        if (controller
                                                                .slideMenu ==
                                                            'slidy_menu_mockup') {
                                                          return SlideMenuMockup(
                                                            preparation:
                                                                documentFields
                                                                        .data[
                                                                    'preparation_time'],
                                                            clickItem:
                                                                controller
                                                                    .clickItem,
                                                            name: documentFields
                                                                .data['label'],
                                                            note: documentFields
                                                                    .data[
                                                                'description'],
                                                            price: formatedCurrency(
                                                                documentFields
                                                                        .data[
                                                                    'price']),
                                                            image:
                                                                documentFields
                                                                        .data[
                                                                    'image'],
                                                          );
                                                        } else {
                                                          return SlideMenu(
                                                            preparation:
                                                                documentFields
                                                                        .data[
                                                                    'preparation_time'],
                                                            clickItem:
                                                                controller
                                                                    .clickItem,
                                                            name: documentFields
                                                                .data['label'],
                                                            note: documentFields
                                                                    .data[
                                                                'description'],
                                                            price:
                                                                documentFields
                                                                    .data[
                                                                        'price']
                                                                    .toDouble(),
                                                            image:
                                                                documentFields
                                                                        .data[
                                                                    'image'],
                                                            plus: () {
                                                              controller
                                                                  .setPlusOrder();
                                                              controller
                                                                  .setTotalPrice(documentFields
                                                                              .data[
                                                                          'price'] *
                                                                      controller
                                                                          .qtdOrder)
                                                                  .toDouble;
                                                            },
                                                            remove: () {
                                                              controller
                                                                  .setRemoveOrder();
                                                              controller
                                                                  .setTotalPrice(documentFields
                                                                              .data[
                                                                          'price'] *
                                                                      controller
                                                                          .qtdOrder)
                                                                  .toDouble;
                                                            },
                                                            goToInvited:
                                                                () async {
                                                              await controller
                                                                  .setQntdGroups(
                                                                      sellerId:
                                                                          seller
                                                                              .id);
                                                              await controller
                                                                  .onTapOrderShared(
                                                                      documentFields:
                                                                          documentFields);
                                                            },
                                                            confirmOrder:
                                                                () async {
                                                              controller.setSeller(
                                                                  homeController
                                                                      .sellerModel);

                                                              await controller
                                                                  .setQntdGroups(
                                                                      sellerId:
                                                                          seller
                                                                              .id);
                                                              await controller.onTapConfirmOrder(
                                                                  documentFields:
                                                                      documentFields,
                                                                  routerMenu:
                                                                      homeController
                                                                          .routerMenu);
                                                            },
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(ColorTheme.yellow),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalItem extends StatelessWidget {
  final bool protectedPrices;
  final String title;
  final Function onTap;
  final String note;
  final String price;
  const HorizontalItem({
    Key key,
    this.title,
    this.note,
    this.price,
    this.onTap,
    this.protectedPrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: wXD(15, context), vertical: wXD(7, context)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xffBDAEA7)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      // fontSize: 16,
                      fontSize: 15,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                !protectedPrices
                    ? Text(
                        "R\$",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                !protectedPrices
                    ? Container(
                        child: Text(
                          "$price",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      )
                    : Container(),
              ],
            ),
            Spacer(
              flex: 3,
            ),
            Text(
              "$note",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                color: ColorTheme.textGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class BlankItem extends StatelessWidget {
  const BlankItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: wXD(15, context), vertical: wXD(8, context)),
      height: 85,
    );
  }
}

class MenuHorizontal extends StatelessWidget {
  const MenuHorizontal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(47, context),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: wXD(14, context),
          ),
          Text(
            "Mais populares",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: wXD(14, context),
          ),
          Text(
            "Cafés quentes",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: wXD(14, context),
          ),
          Text(
            "Cafés gelado",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: wXD(14, context),
          ),
          Text(
            "Outros",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  final bool protectedPrices;
  final String name;
  final String note;
  final String price;
  final String image;
  const ItemMenu({
    this.image,
    this.name,
    this.note,
    this.price,
    Key key,
    this.protectedPrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: wXD(140, context),
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
                imageUrl: image,
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            height: wXD(15, context),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  "$name",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Spacer(),
              !protectedPrices
                  ? Text(
                      "R\$",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.end,
                    )
                  : Container(),
              !protectedPrices
                  ? Text(
                      "$price",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.end,
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: wXD(2, context),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: wXD(37, context),
                  child: Text(
                    "$note",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      color: ColorTheme.textGrey,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
