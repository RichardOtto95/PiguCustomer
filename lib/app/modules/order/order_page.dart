import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/app/modules/order/widgets/bottom_action_container.dart';
import 'package:pigu/app/modules/order/widgets/item_order.dart';
import 'package:pigu/app/modules/order/widgets/item_order_commission.dart';
import 'package:pigu/app/modules/order/widgets/item_order_with_person.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  final String title;
  final List order;
  const OrderPage({Key key, this.title = "Order", this.order})
      : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final menuController = Modular.get<MenuController>();
  bool loadCircular = false;
  num value;
  String _seller;
  @override
  void dispose() {
    menuController.clearUsersInvitedToShare();
    menuController.setNameOrderPopPage(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double qntddItens = 0;
    List<String> listAvatar = [];
    widget.order.forEach((element) {
      // print('%%%%%%%%%%%% element ${element['ordered_amount']} %%%%%%%%%%%%');
      qntddItens += element['ordered_amount'];
      _seller = element['seller_id'];
    });
    return WillPopScope(
      onWillPop: () {
        menuController.setAddOrder(1);
        menuController.clearUsersInvitedToShare();
        if (menuController.routerOrderPop == 'invite') {
          Modular.to.pop();
          Modular.to.pop();
        } else {
          Modular.to.pop();
        }
      },
      child: Observer(builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavBar(
                  title: 'Pedido',
                  iconOnTap: null,
                  backPage: () {
                    menuController.setAddOrder(1);
                    menuController.clearUsersInvitedToShare();
                    if (menuController.routerOrderPop == 'invite') {
                      Modular.to.pop();
                      Modular.to.pop();
                    } else {
                      Modular.to.pop();
                    }
                  },
                ),
                SizedBox(
                  height: wXD(14, context),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3),
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
                  padding: EdgeInsets.only(left: wXD(52, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confira',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(36, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'o pedido',
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
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.order.length,
                      itemBuilder: (context, index) {
                        var ds = widget.order[index];
                        List<String> listAvatarr = [];
                        if (ds['order_shared_friends'] != null) {
                          for (int i = 0;
                              i < ds['order_shared_friends'].length;
                              ++i) {
                            listAvatarr
                                .add(ds['order_shared_friends'][i]['avatar']);
                          }
                        }

                        return ds['order_shared_friends'] != null
                            ? ItemOrderWithPersons(
                                list: listAvatarr,
                                qtdOrder: ds['ordered_amount'] == null ||
                                        ds['ordered_amount'] == 0
                                    ? 1.toString()
                                    : ds['ordered_amount'].toInt().toString(),
                                amountPerson:
                                    ds['order_shared_friends'].length.toInt(),
                                name: ds['label'],
                                price: ds['ordered_amount'] == null ||
                                        ds['ordered_amount'] == 0
                                    ? ds['price']
                                    : ds['ordered_amount'] * ds['price'],
                              )
                            : ItemOrder(
                                name: ds['label'],
                                price: ds['ordered_amount'] == null ||
                                        ds['ordered_amount'] == 0
                                    ? formatedCurrency(ds['price'])
                                    : formatedCurrency(
                                        ds['price'] * ds['ordered_amount']),
                                qtdOrder: ds['ordered_amount'] == null ||
                                        ds['ordered_amount'] == 0
                                    ? 1.toString()
                                    : ds['ordered_amount'].toInt().toString(),
                              );
                      }),
                ),
                // ItemOrderCommission(),
                loadCircular == true
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        color: ColorTheme.darkCyanBlue,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(ColorTheme.yellow),
                          ),
                        ),
                      )
                    : BottomActionContainer(
                        confirm: () {
                          setState(() {
                            loadCircular = true;
                          });
                          // //print'widget.orderwidget.order    :${widget.order}');
                          menuController.confirmOrder(widget.order);
                          menuController.eventCountIncrement();
                          menuController.clearUsersInvitedToShare();
                        },
                        items: qntddItens.toInt().toString(),
                        // menuController.totalAmountOrder.toInt().toString(),
                        totalPrice: formatedCurrency(menuController.totalMenu),
                      )
              ],
            ),
          ),
        );
      }),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
