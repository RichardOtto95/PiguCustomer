import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/order/widgets/item_order.dart';
import 'package:pigu/app/modules/order/widgets/item_order_commission.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/app/modules/repeat_order/widgets/BottomActionContainerRepeat.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repeat_order_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class RepeatOrderPage extends StatefulWidget {
  final String title;
  final order;

  const RepeatOrderPage({Key key, this.title = "RepeatOrder", this.order})
      : super(key: key);

  @override
  _RepeatOrderPageState createState() => _RepeatOrderPageState();
}

class _RepeatOrderPageState
    extends ModularState<RepeatOrderPage, RepeatOrderController> {
  final homeController = Modular.get<HomeController>();

  //use 'controller' variable to access controller
  bool loadCircular = false;
  Map<String, dynamic> cart;
  Map<String, dynamic> order;
  String lastGroupId;
  String orderID;
  var itens;
  var value;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Modular.to.pop();
      },
      child: Observer(
        builder: (_) {
          return Scaffold(
            body: SafeArea(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("orders")
                    .where('user_id', isEqualTo: homeController.user.uid)
                    .where('group_id',
                        isEqualTo: homeController.groupRepeatOrder)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  QuerySnapshot qq = snapshot.data;
                  lastGroupId = qq.documents.first.data['group_id'];
                  orderID = qq.documents.first.documentID;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavBar(
                        title: 'Pedido',
                        backPage: () {
                          Modular.to.pop();
                        },
                      ),
                      !snapshot.hasData
                          ? Expanded(
                              child: Column(
                              children: [
                                Spacer(),
                                EmptyStateList(
                                  image: 'assets/img/empty_list.png',
                                  title: 'Sem pedidos anteriores para repetir',
                                  description:
                                      'Não existem pedidos para serem listados!',
                                ),
                                Spacer()
                              ],
                            ))
                          : Expanded(
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: wXD(14, context),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                3),
                                    height: wXD(4, context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorTheme.textGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: wXD(28, context),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: wXD(52, context)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Repetir',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: wXD(36, context),
                                            color: ColorTheme.textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'pedido',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: wXD(36, context),
                                            color: ColorTheme.textColor,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: wXD(25, context),
                                  ),
                                  StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("orders")
                                          .document(
                                              qq.documents.first.documentID)
                                          .collection('cart_item')
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                          // return Center(
                                          //   child: CircularProgressIndicator(
                                          //     valueColor:
                                          //         AlwaysStoppedAnimation(
                                          //             ColorTheme.yellow),
                                          //   ),
                                          // );
                                        }
                                        if (snapshot2.hasError) {
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (snapshot.hasData) {
                                          QuerySnapshot qqq = snapshot2.data;
                                          cart = qqq.documents.first.data;

                                          return new ItemOrder(
                                              name: qqq.documents.first
                                                  .data['title'],
                                              price: formatedCurrency(qqq
                                                  .documents
                                                  .first
                                                  .data['ordered_value']),
                                              qtdOrder: qqq.documents.first
                                                  .data['ordered_amount']
                                                  .toInt()
                                                  .toString());
                                        } else if (snapshot.hasError) {
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        return Center(
                                            child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              ColorTheme.yellow),
                                        ));
                                      }),
                                ],
                              ),
                            ),
                      // ItemOrderCommission(),
                      // loadCircular
                      //     ? Center(
                      //         child: CircularProgressIndicator(
                      //           valueColor: AlwaysStoppedAnimation(
                      //               ColorTheme.primaryColor),
                      //         ),
                      //       )
                      //     :
                      Container(
                        height: wXD(140, context),
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("orders")
                              .document(qq.documents.first.documentID)
                              .collection('cart_item')
                              .snapshots(),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(ColorTheme.yellow),
                                ),
                              );
                            }
                            if (snapshot2.hasError) {
                              return new Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              QuerySnapshot qqq = snapshot2.data;
                              // print(
                              //     'snapshot.data 2: ${qqq.documents.first.data}');
                              cart = qqq.documents.first.data;

                              return new BottomActionContainerRepeat(
                                loadCircular: loadCircular,
                                items: qqq
                                    .documents.first.data['ordered_amount']
                                    .toInt()
                                    .toString(),
                                totalPrice: formatedCurrency(
                                    qqq.documents.first.data['ordered_value']),
                                confirm: () {
                                  setState(() {
                                    loadCircular = true;
                                  });
                                  controller.addLastUserOrder(
                                    cart,
                                    lastGroupId,
                                    orderID,
                                    // order,
                                  );
                                },
                              );
                            }

                            return new Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorTheme.yellow),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String formatedCurrency(var value) {
    var newValue = new NumberFormat("#,##0.00", "pt_BR");
    return newValue.format(value);
  }
}
