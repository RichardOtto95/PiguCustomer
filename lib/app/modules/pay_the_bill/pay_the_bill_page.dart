import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/pay_the_bill/widgets/item_payTheBill_with_person.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'botton_action_container.dart';
import 'package:pigu/app/modules/order/widgets/item_order.dart';
import 'package:pigu/app/modules/order/widgets/item_order_commission.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/widgets/navbar.dart';
import 'package:pigu/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class PayTheBillPage extends StatefulWidget {
  // final bool enableButtons;
  // final String description;
  // final String title;
  final group;
  const PayTheBillPage({
    Key key,
    this.group,
  }) : super(key: key);

  @override
  _PayTheBillPageState createState() => _PayTheBillPageState();
}

class _PayTheBillPageState extends State<PayTheBillPage> {
  final homeController = Modular.get<HomeController>();
  final openTableController = Modular.get<OpenTableController>();
  final chatController = Modular.get<ChatController>();

  Future<dynamic> _future;
  double total = 0;
  bool haveOrders;
  double lengthOrder = 0;
  List orders = [];
  String hash;
  bool loading = false;

  @override
  void initState() {
    loading = false;
    if (widget.group != widget.group.toString()) {
      setState(() {
        hash = widget.group[1];
      });
    } else {
      setState(() {
        hash = widget.group;
      });
    }
    _future = getPayTheBill();
    super.initState();
  }

  Future<dynamic> getPayTheBill() async {
    QuerySnapshot docs;
    if (openTableController.userView != null) {
      docs = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: hash)
          .where('user_id', isEqualTo: openTableController.userView)
          .getDocuments();
    } else {
      docs = await Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: hash)
          .where('user_id', isEqualTo: homeController.user.uid)
          .getDocuments();
    }

    QuerySnapshot _orders = await docs.documents.first.reference
        .collection('orders')
        .getDocuments();

    _orders.documents.forEach((element) {
      if (_orders.documents.isNotEmpty) {
        if (element.data['item_status'] == 'created' ||
            element.data['item_status'] == 'created_shared') {
          haveOrders = true;
          setState(() {
            lengthOrder += element['ordered_amount'];
            // lengthOrder++;
            total += (element["ordered_value"]);
          });

          orders.add(element.data);
        }
      } else {
        haveOrders = false;
        orders.clear();
      }
    });

    await Future.delayed(Duration(seconds: 1));
    return orders;
  }

  @override
  void dispose() {
    total = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Modular.to.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavBar(
                    title: 'Pedido',
                    backPage: () {
                      Modular.to.pop();
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 3),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorTheme.textGrey,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comanda',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 36,
                                  color: ColorTheme.darkCyanBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'parcial',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 36,
                                  color: ColorTheme.darkCyanBlue,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<dynamic>(
                            future: _future,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return new Text('Press button to start');
                                case ConnectionState.waiting:
                                  return new Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          ColorTheme.yellow),
                                    ),
                                  );

                                default:
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  else if (orders.isEmpty)
                                    return Expanded(
                                      child: SingleChildScrollView(
                                        child: EmptyStateList(
                                          image: 'assets/img/empty_list.png',
                                          title: chatController.titleEmpty,
                                          description:
                                              'Não existem pedidos para serem listados',
                                        ),
                                      ),
                                    );

                                  return Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          var ds = snapshot.data[index];

                                          // double totalPrice =
                                          //     ((ds['ordered_amount'].toInt()) *
                                          //         ds['ordered_value'].toDouble());

                                          if (ds['item_status'] != 'created') {
                                            chatController.getAvatarPayTheBill(
                                                orderId: ds['order_id']);
                                            return ItemPayTheBillWithPerson(
                                              orderId: ds['order_id'],
                                              qtdOrder: ds['ordered_amount']
                                                  .toInt()
                                                  .toString(),
                                              name: ds['title'],
                                              price: ds['ordered_value'],
                                              // ds['item_price'].toInt().toString(),
                                            );
                                          } else {
                                            return ItemOrder(
                                              name: ds['title'],
                                              price: ds['ordered_value'] ==
                                                          null ||
                                                      ds['ordered_value'] == 0
                                                  ? formatedCurrency(
                                                      ds['ordered_value'])
                                                  : formatedCurrency(
                                                      ds['ordered_value']),
                                              qtdOrder: ds['ordered_amount'] ==
                                                          null ||
                                                      ds['ordered_amount'] == 0
                                                  ? 1
                                                  : ds['ordered_amount']
                                                      .toInt()
                                                      .toString(),
                                            );
                                          }
                                        }),
                                  );
                              }
                            }),
                      ],
                    ),
                  ),
                  openTableController.userView == null &&
                          chatController.enableButtons != null
                      ? BottomActionContainer(
                          enableButton: chatController.enableButtons,
                          items: lengthOrder.toInt().toString(),
                          totalPrice: formatedCurrency(total),
                          confirm: () async {
                            if (await chatController.getGroupPaymentStatus(
                                groupId: hash)) {
                              setState(() {
                                chatController.setPaymentDialog(true);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'Promova alguém a anfitrião ou aguarde que todos paguem',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: ColorTheme.primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 18.0);
                            }
                          },
                        )
                      : Container(),
                ],
              ),
              Visibility(
                visible: chatController.paymentDialog,
                child: AnimatedContainer(
                  height: maxHeight,
                  width: maxWidth,
                  color: !chatController.paymentDialog
                      ? Colors.transparent
                      : Color(0x50000000),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: wXD(5, context)),
                      height: wXD(153, context),
                      width: wXD(324, context),
                      decoration: BoxDecoration(
                          color: Color(0xfffafafa),
                          borderRadius: BorderRadius.all(Radius.circular(33))),
                      child: Column(
                        children: [
                          Container(
                            width: wXD(240, context),
                            margin: EdgeInsets.only(top: wXD(15, context)),
                            child: Text(
                              '''Tem certeza que deseja fechar a comanda?''',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xfa707070),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorTheme.yellow),
                                ))
                              : Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        chatController.setPaymentDialog(false);
                                        setState(() {
                                          loading = true;
                                        });
                                        loading = false;
                                      },
                                      child: Container(
                                        height: wXD(47, context),
                                        width: wXD(98, context),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 3),
                                                  blurRadius: 3,
                                                  color: Color(0x28000000))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
                                            color: Color(0xfffafafa)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Não',
                                          style: TextStyle(
                                              color: ColorTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: wXD(16, context)),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        loading = true;
                                        setState(() {});

                                        chatController.setPaymentDialog(false);

                                        FirebaseUser user = await FirebaseAuth
                                            .instance
                                            .currentUser();

                                        QuerySnapshot group = await Firestore
                                            .instance
                                            .collection('order_sheets')
                                            .where('group_id', isEqualTo: hash)
                                            .where('user_id',
                                                isEqualTo: user.uid)
                                            .getDocuments();

                                        group.documents.first.reference
                                            .updateData({
                                          'status': 'awaiting_checkout'
                                        });

                                        QuerySnapshot ord = await group
                                            .documents.first.reference
                                            .collection('orders')
                                            .getDocuments();

                                        if (ord.documents.length == 0 ||
                                            ord.documents.length == null) {
                                          group.documents.first.reference
                                              .collection('orders')
                                              .add({
                                            'user_id': user.uid,
                                            'created_at': Timestamp.now(),
                                            'description': 'Pedido cancelado',
                                            'item_status': 'canceled',
                                            'ordered_amount': 0,
                                            'ordered_value': 0,
                                            'seller_id': hash,
                                            'title': 'Pedido cancelado',
                                          }).then((value) {
                                            homeController
                                                .setmMyGroupSelected(null);
                                            value.updateData(
                                                {'id': value.documentID});
                                          });
                                        }

                                        chatController.createMessage();

                                        Fluttertoast.showToast(
                                            msg:
                                                "Conta fechada. Aguarde atendimento.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                ColorTheme.primaryColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);

                                        chatController.getAwaitingCheckout();

                                        chatController.setPaymentDialog(false);

                                        Modular.to.pop();

                                        loading = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: wXD(47, context),
                                        width: wXD(98, context),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 3),
                                                  blurRadius: 3,
                                                  color: Color(0x28000000))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
                                            color: Color(0xfffafafa)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sim',
                                          style: TextStyle(
                                              color: ColorTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
