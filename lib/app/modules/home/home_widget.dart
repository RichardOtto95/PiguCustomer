import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/home/searchservice.dart';
import 'package:pigu/app/modules/home/widgets/company_container.dart';
import 'package:pigu/app/modules/home/widgets/fabButtom.dart';
import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pigu/shared/utilities.dart';

class HomeWidget extends StatefulWidget {
  final String title;
  const HomeWidget({Key key, this.title = "Menu"}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ModularState<HomeWidget, HomeController> {
  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;
  final authController = Modular.get<AuthController>();
  String uid;
  String search;
  var queryResultSet = [];
  var tempSearchStore = [];
  String categoryID;
  List arrayAux = [];
  List<String> strList = [];
  CarouselController _carouselController;
  final homeController = Modular.get<HomeController>();
  FocusNode myFocusNode;
  var favAux;
  // Future task;
  FocusNode openTableFocus;

  @override
  void initState() {
    // task = homeController.getPosition();
    controller.getUserAuth();
    _carouselController = new CarouselController();
    scrollController = new ScrollController();
    super.initState();
    openTableFocus = FocusNode();
    myFocusNode = FocusNode();
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        uid = value.uid;
      });
    });

    handleScroll();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    setState(() {
      search = null;
      queryResultSet = [];
      tempSearchStore = [];
    });
    super.dispose();
  }

  void showFloationButton() {
    controller.setShooow(true);
  }

  void hideFloationButton() {
    controller.setShooow(false);
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideFloationButton();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showFloationButton();
        }
      }
    });
  }

  getUserFavs() async {
    favAux = await Firestore.instance
        .collection('users')
        .document(controller.user.uid)
        .collection('favorite_sellers')
        .getDocuments();
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        // //print'value.length: ${value.length}');

        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          if (docs.documents[i].data['name'].startsWith(capitalizedValue)) {
            setState(() {
              tempSearchStore.add(docs.documents[i].data);
            });
          }
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: wXD(25, context),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: wXD(38, context),
                        bottom: wXD(25, context),
                      ),
                      height: wXD(60, context),
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        focusNode: myFocusNode,
                        onChanged: (val) {
                          setState(() {
                            search = val;
                          });
                          initiateSearch(val);
                        },
                        decoration: InputDecoration(
                            labelText: search != null && search != ""
                                ? ''
                                : "Encontre aqui a loja que procura...",
                            labelStyle: TextStyle(
                              fontSize: wXD(15, context),
                              fontWeight: FontWeight.w200,
                            ),
                            prefixIcon: Image.asset(
                              'assets/icon/fab.png',
                              height: wXD(15, context),
                              width: wXD(15, context),
                            )),
                      )),
                  uid != null
                      ? StreamBuilder(
                          stream: Firestore.instance
                              .collection("users")
                              .document(uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return InkWell(
                                  onTap: () {
                                    Modular.to.pushNamed('/user-profile');
                                  },
                                  child: PersonPhoto(
                                      image: snapshot.data['avatar']));
                            }
                          })
                      : Container(),
                  SizedBox(
                    width: wXD(15, context),
                  ),
                ],
              ),
              Observer(builder: (_) {
                return controller.user != null &&
                        authController.position != null
                    ? StreamBuilder(
                        stream: Firestore.instance
                            .collection("users")
                            .document(controller.user.uid)
                            .collection('favorite_sellers')
                            .snapshots(),
                        builder: (context, snapshotUser) {
                          if (!snapshotUser.hasData) {
                            return Container();
                          } else {
                            return Expanded(
                              child: Listener(
                                onPointerMove: (event) {
                                  if (event.delta.direction < 0) {
                                    // print('maior');
                                    controller.setShowOpenTableButton(false);
                                  } else {
                                    // print('menor');

                                    controller.setShowOpenTableButton(true);
                                  }
                                },
                                child: CustomScrollView(
                                  controller: scrollController,
                                  slivers: <Widget>[
                                    SliverPersistentHeader(
                                        delegate: DynamicHeader()),
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          SizedBox(
                                            height: wXD(34, context),
                                          ),
                                          Container(
                                            color: Color(0xffFAFAFA),
                                            height: wXD(100, context),
                                            child: Container(
                                                color: Color(0xffFAFAFA),
                                                child:
                                                    futureCategories(maxWidth)),
                                          ),
                                          SizedBox(
                                            height: wXD(15, context),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: wXD(15, context)),
                                            width: double.infinity,
                                            height: wXD(1, context),
                                            color: ColorTheme.darkCyanBlue,
                                          ),
                                          SizedBox(
                                            height: wXD(15, context),
                                          ),
                                          Observer(builder: (_) {
                                            return search == null ||
                                                    search == ''
                                                ? controller.categoryID ==
                                                        'xHA7JSFDddplyk9i3R1H'
                                                    ? StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection("users")
                                                            .document(
                                                                homeController
                                                                    .user.uid)
                                                            .collection(
                                                                'favorite_sellers')
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
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
                                                            var lss = snapshot
                                                                .data
                                                                .documents
                                                                .length;
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Container();
                                                            } else {
                                                              if (lss == 0 ||
                                                                  lss == null) {
                                                                return EmptyStateList(
                                                                  image:
                                                                      'assets/img/empty_list.png',
                                                                  title:
                                                                      'Sem Estabelecimentos',
                                                                  description:
                                                                      'Não existem Estabelecimentos para serem listados!',
                                                                );
                                                              } else {
                                                                return ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: snapshot
                                                                      .data
                                                                      .documents
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    DocumentSnapshot
                                                                        ds =
                                                                        snapshot
                                                                            .data
                                                                            .documents[index];
                                                                    // print(
                                                                    // 'snapshotSellers.data: ${ds.data}');

                                                                    return ds
                                                                            .exists
                                                                        ? StreamBuilder(
                                                                            stream:
                                                                                Firestore.instance.collection("sellers").document(ds.data['id']).snapshots(),
                                                                            builder: (context, snapshotSellers) {
                                                                              if (snapshotSellers.data != null) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  double distance = Geolocator.distanceBetween(authController.position.latitude, authController.position.longitude, snapshotSellers.data['location'].latitude, snapshotSellers.data['location'].longitude);
                                                                                  // print('snapshotSellers.data: ${snapshotSellers.data}');

                                                                                  return new InkWell(
                                                                                    onTap: () {
                                                                                      SellerModel _seller = SellerModel(
                                                                                        protectedPrices: snapshotSellers.data['protected_prices'],
                                                                                        hasVirtualQueue: snapshotSellers.data['has_virtual_queue'],
                                                                                        address: snapshotSellers.data['adress'],
                                                                                        avatar: snapshotSellers.data['avatar'],
                                                                                        bg_image: snapshotSellers.data['bg_image'],
                                                                                        category_id: snapshotSellers.data['category_id'],
                                                                                        name: snapshotSellers.data['name'],
                                                                                        location: ds['location'],
                                                                                        id: snapshotSellers.data['id'],
                                                                                      );

                                                                                      controller.sellerModel = _seller;

                                                                                      Modular.to.pushNamed(
                                                                                        'home/restaurant-selected',
                                                                                        arguments: _seller,
                                                                                      );
                                                                                    },
                                                                                    child: StatefulBuilder(builder: (context, setState) {
                                                                                      return CompanyContainer(
                                                                                        address: snapshotSellers.data["address"],
                                                                                        seller_id: snapshotSellers.data.documentID,
                                                                                        name: snapshotSellers.data['name'],
                                                                                        mainImg: snapshotSellers.data["bg_image"],
                                                                                        iconImg: snapshotSellers.data["avatar"],
                                                                                        local: (distance / 1000),
                                                                                      );
                                                                                    }),
                                                                                  );
                                                                                }
                                                                              } else {
                                                                                return Container();
                                                                              }
                                                                            })
                                                                        : Container();
                                                                  },
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                      )
                                                    : Observer(builder: (_) {
                                                        return StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  "sellers")
                                                              .where(
                                                                  'category_id',
                                                                  isEqualTo:
                                                                      controller
                                                                          .categoryID)
                                                              .orderBy(
                                                                  'location',
                                                                  descending:
                                                                      true)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation(
                                                                      ColorTheme
                                                                          .yellow),
                                                                ),
                                                              );
                                                            } else {
                                                              var lss = snapshot
                                                                  .data
                                                                  .documents
                                                                  .length;
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Container();
                                                              } else {
                                                                if (lss == 0 ||
                                                                    lss ==
                                                                        null) {
                                                                  return EmptyStateList(
                                                                    image:
                                                                        'assets/img/empty_list.png',
                                                                    title:
                                                                        'Sem Estabelecimentos',
                                                                    description:
                                                                        'Não existem Estabelecimentos para serem listados!',
                                                                  );
                                                                } else {
                                                                  return ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: snapshot
                                                                        .data
                                                                        .documents
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      DocumentSnapshot
                                                                          ds =
                                                                          snapshot
                                                                              .data
                                                                              .documents[index];

                                                                      double distance = Geolocator.distanceBetween(
                                                                          authController
                                                                              .position
                                                                              .latitude,
                                                                          authController
                                                                              .position
                                                                              .longitude,
                                                                          ds.data['location']
                                                                              .latitude,
                                                                          ds.data['location'].longitude);
                                                                      // print(
                                                                      // 'ds: ${ds.data}');
                                                                      return new InkWell(
                                                                        onTap:
                                                                            () {
                                                                          SellerModel _seller = SellerModel(
                                                                              protectedPrices: ds['protected_prices'],
                                                                              hasVirtualQueue: ds['has_virtual_queue'],
                                                                              address: ds['address'],
                                                                              avatar: ds['avatar'],
                                                                              bg_image: ds['bg_image'],
                                                                              category_id: ds['category_id'],
                                                                              name: ds['name'],
                                                                              location: ds['location'],
                                                                              id: ds['id']);
                                                                          controller.sellerModel =
                                                                              _seller;
                                                                          Modular
                                                                              .to
                                                                              .pushNamed(
                                                                            'home/restaurant-selected',
                                                                            arguments:
                                                                                _seller,
                                                                          );
                                                                        },
                                                                        child: StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return CompanyContainer(
                                                                            // restaurantFav: favAux.,
                                                                            address:
                                                                                ds["address"],
                                                                            seller_id:
                                                                                ds.documentID,
                                                                            name:
                                                                                ds['name'],
                                                                            mainImg:
                                                                                ds["bg_image"],
                                                                            iconImg:
                                                                                ds["avatar"],
                                                                            local:
                                                                                (distance / 1000),
                                                                          );
                                                                        }),
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                            }
                                                          },
                                                        );
                                                      })
                                                : tempSearchStore.isNotEmpty
                                                    ? ListView(
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        children:
                                                            tempSearchStore
                                                                .map((element) {
                                                          double distance = Geolocator
                                                              .distanceBetween(
                                                                  authController
                                                                      .position
                                                                      .latitude,
                                                                  authController
                                                                      .position
                                                                      .longitude,
                                                                  element['location']
                                                                      .latitude,
                                                                  element['location']
                                                                      .longitude);

                                                          return InkWell(
                                                            onTap: () {
                                                              SellerModel _seller = SellerModel(
                                                                  address: element[
                                                                      'address'],
                                                                  avatar: element[
                                                                      'avatar'],
                                                                  bg_image: element[
                                                                      'bg_image'],
                                                                  category_id:
                                                                      element[
                                                                          'category_id'],
                                                                  name: element[
                                                                      'name'],
                                                                  location: element[
                                                                      'location'],
                                                                  id: element[
                                                                      'id']);
                                                              controller
                                                                      .sellerModel =
                                                                  _seller;

                                                              Modular.to
                                                                  .pushNamed(
                                                                'home/restaurant-selected',
                                                                arguments:
                                                                    _seller,
                                                              );
                                                            },
                                                            child:
                                                                CompanyContainer(
                                                              address: element[
                                                                  "address"],
                                                              seller_id:
                                                                  element['id'],
                                                              name: element[
                                                                  'name'],
                                                              mainImg: element[
                                                                  "bg_image"],
                                                              iconImg: element[
                                                                  "avatar"],
                                                              local: (distance /
                                                                  1000),
                                                            ),
                                                          );
                                                        }).toList())
                                                    : EmptyStateList(
                                                        image:
                                                            'assets/img/empty_list.png',
                                                        title:
                                                            'Sem Estabelecimentos',
                                                        description:
                                                            'Não existem Estabelecimentos para serem listados!',
                                                      );
                                          })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyStateList(
                            image: 'assets/img/empty_list.png',
                            title: 'Localização desativada',
                            description:
                                'Ative a sua localização para que possamos listar os estabelecimentos próximos',
                          ),
                          SizedBox(
                            height: wXD(20, context),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                loadCircular = true;
                                homeController.determinePosition();
                              });
                            },
                            child: loadCircular
                                ? CircularProgressIndicator(
                                    backgroundColor: ColorTheme.primaryColor,
                                  )
                                : Container(
                                    height: wXD(61, context),
                                    width: wXD(283, context),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(21),
                                        color: ColorTheme.primaryColor),
                                    child: Text(
                                      'Ativar localização',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: wXD(16, context),
                                        color: ColorTheme.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ],
                      );
              })
              // : CircularProgressIndicator(
              //     valueColor:
              //         AlwaysStoppedAnimation(ColorTheme.yellow),
              //   ),
            ],
          ),
          // }),
        ),
        floatingActionButton: Observer(builder: (_) {
          return Visibility(
            visible: controller.showOpenButton,
            child: InkWell(
                onTap: () {
                  Modular.to.pushNamed('/open-table');
                },
                child: FabButton()),
          );
        }));
    // });
  }

  futureCategories(double maxWidth) {
    return FutureBuilder(
        future: Firestore.instance.collection("categories").getDocuments(),
        builder: (context, categoriasSnap) {
          if (categoriasSnap != null) {
            if (categoriasSnap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
              );
            } else {
              var lds = categoriasSnap.data.documents.length;
              if (categoriasSnap.data == null) {
                return Container();
              } else {
                if (lds == 0 || lds == null) {
                  return Center(
                    child: Container(
                      width: maxWidth * .8,
                      child: Text(
                        'Não há categorias cadastradas no banco!!!',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: MediaQuery.of(context).size.width * .035,
                          color: ColorTheme.darkCyanBlue,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return CarouselSlider.builder(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          autoPlay: false,
                          viewportFraction: 0.3,
                          // aspectRatio: 10.0,
                          // initialPage: 1,
                          onScrolled: (adsa) {
                            // //print'entrou: $adsa ');
                          },
                          onPageChanged: (index, reason) {
                            DocumentSnapshot ds =
                                categoriasSnap.data.documents[index];
                            categoriasSnap.data.documents.forEach((element) {
                              if (element.data['id'] == ds.data['id']) {
                                categoryID = element.data['id'];
                                controller.setCategoryID(element.data['id']);

                                // print(
                                // 'index ================================: ${controller.categoryID}');
                              }
                            });
                          }),
                      itemCount: categoriasSnap.data.documents.length,
                      itemBuilder: (context, index, realIndex) {
                        DocumentSnapshot ds =
                            categoriasSnap.data.documents[index];
                        return InkWell(
                          onTap: () {
                            // categoriasSnap.data.documents
                            // //print'ds.documentID: menu ${ds.documentID}');

                            //print
                            // 'controller.categoryID ${controller.categoryID}');
                            if (controller.categoryID == ds.documentID) {
                              // //print'igaul');
                              controller.setCategoryID(null);
                            } else {
                              controller.setCategoryID(ds.documentID);

                              // //print' n igaul');
                            }
                          },
                          child: Observer(builder: (_) {
                            return new TabIcon(
                                category: controller.categoryID == ds.documentID
                                    ? true
                                    : false,
                                title: ds["label"],
                                icon: ds["image"]);
                          }),
                        );
                      });
                  // });
                }
              }
            }
          } else {
            return Container();
          }
        });
  }
}

class DynamicHeader extends SliverPersistentHeaderDelegate {
  DynamicHeader({
    this.searching = false,
  });

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  int index = 0;
  final bool searching;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      height: searching ? minExtent : maxExtent,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: wXD(52, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecione',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: MediaQuery.of(context).size.width * .1,
                  color: ColorTheme.darkCyanBlue,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'o restaurante',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: MediaQuery.of(context).size.width * .1,
                  color: ColorTheme.darkCyanBlue,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 0.0;
}

class DynamicMenu extends SliverPersistentHeaderDelegate {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  int index = 0;

  final homeController = Modular.get<HomeController>();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xffFAFAFA),
      height: maxExtent,
      child: Container(
          color: Color(0xffFAFAFA),
          height: wXD(150, context),
          child: StreamBuilder(
              stream: Firestore.instance.collection("categories").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return InkWell(
                            onTap: () {
                              // print('categoryID: menu ${ds.documentID}');
                              homeController.setCategoryID(ds.documentID);
                            },
                            child: new TabIcon(
                                marLeft: snapshot.data.documents.length == 1
                                    ? wXD(8, context)
                                    : wXD(4, context),
                                title: ds["label_ptbr"],
                                icon: ds["image"]));
                      });
                }
              })),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 100.0;

  void setState(Null Function() param0) {}
}

class TabIcon extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final String icon;
  final double marLeft;
  final String title;
  final bool category;
  const TabIcon({
    Key key,
    this.icon,
    this.title,
    this.category,
    this.marLeft = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // //print'category:$category $title');
    return Container(
      width: MediaQuery.of(context).size.width * .29,
      height: MediaQuery.of(context).size.height,
      // decoration: category ?BoxDecoration(
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.black54,
      //           blurRadius: 15.0,
      //           offset: Offset(0.0, 0.75)
      //       )
      //     ],
      // ): BoxDecoration(
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.black54,
      //           blurRadius: 15.0,
      //           offset: Offset(0.0, 0.75)
      //       )
      //     ],
      // ),
      margin: EdgeInsets.only(
        right: wXD(4, context),
        left: wXD(marLeft, context),
      ),
      child: Stack(
        children: <Widget>[
          // Container(
          // color: Colors.blue,
          // width: 104.0,
          // height: 95.0,
          // child:
          Column(
            children: [
              Spacer(),
              Container(
                width: wXD(104, context),
                height: wXD(46, context),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorTheme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(21.0),
                  color: category ? ColorTheme.primaryColor : Colors.white,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.width * .03,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: wXD(9, context))
                  ],
                ),
              ),
            ],
          ),
          // ),
          Positioned(
            top: 0,
            child: Container(
              height: wXD(70, context),
              width: wXD(104, context),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(icon),
                  fit: BoxFit.contain,
                ),
                /* boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ], */
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonPhoto extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final Function onTap;
  final String image;
  const PersonPhoto({
    Key key,
    this.onTap,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: wXD(10, context),
        ),
        Stack(
          children: [
            Container(
              height: wXD(68, context),
              width: wXD(57, context),
              margin: EdgeInsets.only(right: wXD(6, context)),
            ),
            Positioned(
              top: wXD(5, context),
              right: wXD(3, context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: wXD(54, context)),
                  Container(
                    width: wXD(50, context),
                    height: wXD(50, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                          width: 3.0, color: ColorTheme.primaryColor),
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
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: image,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: InkWell(
            //     onTap: onTap,
            //     child: Container(
            //         height: 21,
            //         width: 21,
            //         decoration: BoxDecoration(
            //             color: Color(0xff1233B3), shape: BoxShape.circle),
            //         child: Padding(
            //             padding: EdgeInsets.only(top: 1),
            //             child: Text("5",
            //                 style: TextStyle(
            //                     fontSize: 14, color: Color(0xfffafafa)),
            //                 textAlign: TextAlign.center))),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
