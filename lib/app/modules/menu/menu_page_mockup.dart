import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/menu/widgets/bottom_action_container.dart';
import 'package:pigu/app/modules/menu/widgets/slide_menu.dart';
import 'package:pigu/app/modules/order/order_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'menu_controller.dart';

class MenuPageMockup extends StatefulWidget {
  final String title;
  final SellerModel seller;
  const MenuPageMockup({Key key, this.title = "Menu", this.seller})
      : super(key: key);

  @override
  _MenuPageMockupState createState() => _MenuPageMockupState();
}

class _MenuPageMockupState
    extends ModularState<MenuPageMockup, MenuController> {
  final homeController = Modular.get<HomeController>();

  bool click = false;
  bool clickItem = false;
  String item = null;
  double addOrder = 1;
  @override
  Widget build(BuildContext context) {
    // //print'Seller: ${SellerModel().toJson(controller.homeController.sellerModel)}');
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xffFAFAFA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavBar(
                backPage: () {
                  Modular.to.pop();
                },
                title: "${controller.homeController.sellerModel.name}",
                iconOnTap: () {},
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 22, top: 15, bottom: 9),
                          child: Text(
                            "Sugestões",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: ColorTheme.textColor,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 216,
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection("listing")
                                  .where('seller_id',
                                      isEqualTo: controller
                                          .homeController.sellerModel.id)
                                  .where('status', isEqualTo: 'highlighted')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return new ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshot.data.documents[index];
                                        return new InkWell(
                                          onTap: () {
                                            setState(() {
                                              item = ds['listing_id'];
                                              // //print'item : $item');

                                              clickItem = !clickItem;
                                            });
                                          },
                                          child: ItemMenu(
                                              image: ds['image'],
                                              name: ds['title_ptbr'],
                                              note: ds['description_ptbr'],
                                              price: ds['price'].toString()),
                                        );
                                      });
                                }
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 13, bottom: 16),
                          height: 1,
                          color: ColorTheme.textGrey,
                        ),
                        MenuHorizontal(),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection("listing")
                                .where('seller_id',
                                    isEqualTo: controller
                                        .homeController.sellerModel.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data.documents[index];

                                      return new InkWell(
                                        onTap: () {
                                          // Modular.to.pushNamed('/restaurant-selected/${ds.data}');
                                        },
                                        child: HorizontalItem(
                                          title: ds['title_ptbr'],
                                          note: ds['description_ptbr'],
                                          price: ds['price'].toString(),
                                          onTap: () {
                                            setState(() {
                                              item = ds['listing_id'];
                                              // //print'item : $item');

                                              clickItem = !clickItem;
                                            });
                                          },
                                        ),
                                      );
                                    });
                              }
                            }),
                        BlankItem()
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        child: controller.orderConfirm.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    // //print"clicou");
                                    click = !click;
                                  });
                                },
                                child: InkWell(
                                    onTap: () {
                                      // Modular.to.pushNamed('/order');
                                    },
                                    child: BottomActionContainer(
                                      items: controller.orderConfirm.length
                                          .toString(),
                                      totalPrice:
                                          controller.totalMenu.toString(),
                                      confirm: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return OrderPage(
                                              order: controller.orderConfirm);
                                        }));
                                      },
                                    )))
                            : Container()),
                    Positioned(
                        bottom: 0,
                        child: clickItem
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    // //print"clicou");
                                    clickItem = !clickItem;
                                  });
                                },
                                child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("listing")
                                        .where('seller_id',
                                            isEqualTo: controller
                                                .homeController.sellerModel.id)
                                        .where('listing_id', isEqualTo: item)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      } else {
                                        QuerySnapshot documentFields =
                                            snapshot.data;
                                        return SlideMenu(
                                          name: documentFields
                                              .documents[0].data['title_ptbr'],
                                          note: documentFields.documents[0]
                                              .data['description_ptbr'],
                                          price: documentFields
                                              .documents[0].data['price']
                                              .toDouble(),
                                          image: documentFields
                                              .documents[0].data['image'],
                                          plus: () {
                                            controller.setPlusOrder();
                                            controller
                                                .setTotalPrice(documentFields
                                                        .documents[0]
                                                        .data['price'] *
                                                    controller.qtdOrder)
                                                .toDouble;
                                            ;
                                            // //print
                                            //     'TOTAL:========  ${controller.totalPrice}');
                                          },
                                          remove: () {
                                            controller.setRemoveOrder();
                                            controller
                                                .setTotalPrice(documentFields
                                                        .documents[0]
                                                        .data['price'] *
                                                    controller.qtdOrder)
                                                .toDouble;
                                            ;
                                            // //print
                                            //     'TOTAL:========  ${controller.totalPrice}');
                                          },
                                          goToInvited: () {
                                            controller.setNameOrderShare(
                                                documentFields.documents[0]
                                                    .data['title_ptbr']);
                                            controller.setImageOrderShare(
                                                documentFields.documents[0]
                                                    .data['image']);
                                            Modular.to
                                                .pushNamed('/invite-to-share');
                                          },
                                          // addOrder: addOrder,
                                          confirmOrder: () {
                                            setState(() {
                                              clickItem = false;
                                            });

                                            controller.setSeller(controller
                                                .homeController.sellerModel);
                                          },
                                        );
                                      }
                                    }),
                                // SlideMenu(
                                //   name: ,
                                // ),
                              )
                            : Container())
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class HorizontalItem extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        height: 55,
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
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Spacer(),
                Text(
                  "R\$",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "$price",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              "$note",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ColorTheme.textGrey,
                fontWeight: FontWeight.w300,
              ),
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
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
      height: 47,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 14,
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
            width: 14,
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
            width: 14,
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
            width: 14,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 306,
      margin: EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            width: 306,
            height: 145,
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
            height: 12,
          ),
          Row(
            children: [
              Text(
                "$name",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Text(
                "R\$",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "$price",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "$note",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.textGrey,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
