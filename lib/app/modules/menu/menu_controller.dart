import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'menu_controller.g.dart';

@Injectable()
class MenuController = _MenuControllerBase with _$MenuController;

abstract class _MenuControllerBase with Store {
  final homeController = Modular.get<HomeController>();
  @observable
  String userId;
  @observable
  String listingId;
  @observable
  String groupShared;
  @observable
  int value = 0;
  @observable
  int qtdgroup;
  @observable
  double qtdOrder = 1;
  @observable
  double totalPrice;
  @observable
  double totalAmountOrder = 0;
  @observable
  int price = 0;
  @observable
  bool userHaveGroup = false;
  @observable
  bool orderShared = false;
  @observable
  SellerModel sellerModel;
  @observable
  ObservableList<dynamic> orderConfirm = new List().asObservable();
  @observable
  List<dynamic> orderConfirmWthFriend = new List();
  @observable
  dynamic usersInvitedToshare;
  @observable
  dynamic totalMenu = 0;
  @observable
  String nameOrderShare;
  @observable
  String imageOrderShare;
  @observable
  dynamic orderWithInvite;
  @observable
  String noteInput = '';
  @observable
  bool clickNote = false;
  @observable
  bool clickItem = false;
  @observable
  String orderId;
  @observable
  String statusSeller;
  @observable
  String routerOrderPop;
  @observable
  String slideMenu = 'slidy_menu_mockup';
  @observable
  String textToast = '';
  @observable
  bool requestedMenu;
  @observable
  int qntdGroups = 0;
  @observable
  String routerMenuGroupId;
  @observable
  String groupStatus;
  @observable
  String myGroupStatus;
  @observable
  String itemId = '';

  @action
  setItemId(String _itemId) => itemId = _itemId;
  @action
  setSlideMenu(String slide) => slideMenu = slide;
  @action
  setTextToast(String text) => textToast = text;

  @action
  setOrderWithInvite(dynamic _orderWithInvite) =>
      orderWithInvite = _orderWithInvite;
  @action
  setNameOrderShare(String norder) => nameOrderShare = norder;
  @action
  setNameOrderPopPage(String pp) => routerOrderPop = pp;
  @action
  clearUsersInvitedToShare() {
    usersInvitedToshare = null;
  }

  @action
  setGroupShared(String groupShared) => groupShared = groupShared;
  @action
  setStatusSeller(String statusSeller_) => statusSeller = statusSeller_;
  @action
  setImageOrderShare(String iorder) => imageOrderShare = iorder;
  @action
  setTotalGroup(int totalgrup) => qtdgroup = totalgrup;
  @action
  setTotalPrice(double total) => totalPrice = total;
  @action
  setTotalMenu(dynamic ttt) => totalMenu = ttt;
  @action
  setAddOrder(double add) => qtdOrder = add;
  @action
  setNoteInput(String _note) => noteInput = _note;
  @action
  setClickNote(bool _noteinpt) => clickNote = _noteinpt;
  @action
  setclickItem(bool _iteminpt) => clickItem = _iteminpt;
  @action
  setTotalAmountOrder() {
    totalAmountOrder = orderConfirm
        .map((element) => element['order'] != null
            ? element['order']['ordered_amount']
            : element['ordered_amount'])
        .fold(0, (prev, amount) => prev + amount);
  }

  @action
  setSeller(SellerModel see) => sellerModel = see;
  @action
  setusersInvitedToshare(norder) => usersInvitedToshare = norder;

  @action
  createOrder({DocumentSnapshot listing}) async {
    DocumentSnapshot group = await Firestore.instance
        .collection('groups')
        .document(routerMenuGroupId)
        .get();

    if (group.data['status'] == 'open') {
      DocumentReference order =
          await Firestore.instance.collection('orders').add({
        'created_at': Timestamp.now(),
        'group_id': group.documentID,
        'seller_id': listing['seller_id'],
        'user_id': homeController.user.uid,
        'status': 'order_requested',
      });

      order.updateData({'id': order.documentID});

      DocumentReference cartItem = await Firestore.instance
          .collection('orders')
          .document(order.documentID)
          .collection('cart_item')
          .add({
        'ordered_amount': qtdOrder,
        'ordered_value': listing['price'],
        'status': 'created',
        'note': noteInput,
        'listing_id': listing['id'],
        'description ': listing['description'],
        'title': listing['label'],
        'created_at': Timestamp.now(),
      });

      cartItem.updateData({'id': cartItem.documentID});

      QuerySnapshot groupChat = await Firestore.instance
          .collection("chats")
          .where('group_id', isEqualTo: group.documentID)
          .getDocuments();

      DocumentReference chat = await Firestore.instance
          .collection("chats")
          .document(groupChat.documents[0].documentID)
          .collection("messages")
          .add({
        'order_id': order.documentID,
        'author_id': homeController.user.uid,
        'created_at': Timestamp.now(),
        'note': noteInput,
        'seller_id': group.data['seller_id'],
        'group_id': group.documentID,
        'type': 'create-order'
      });

      chat.updateData({'id': chat.documentID});

      Modular.to.pushNamed('/menu/chat/' + group.documentID,
          arguments: group.documentID);
    } else {
      Fluttertoast.showToast(
          msg: 'Aguarde a abertura da conta',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: ColorTheme.primaryColor,
          textColor: Colors.white,
          fontSize: 16);
    }
  }

  @action
  onTapOrderShared({DocumentSnapshot documentFields}) {
    switch (homeController.routerMenu) {
      case 'seller-profile':
        Fluttertoast.showToast(
            msg:
                'Não há como efetuar um pedido compartilhado, faça-o a partir de uma conta',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: ColorTheme.primaryColor,
            textColor: Colors.white,
            fontSize: 16);

        break;

      default:
        setNameOrderShare(documentFields.data['label']);

        setImageOrderShare(documentFields.data['image']);

        setOrderWithInvite(documentFields.data);

        Modular.to.pushNamed('/invite-to-share');
        break;
    }
  }

  @action
  onTapConfirmOrder(
      {DocumentSnapshot documentFields, String routerMenu}) async {
    switch (routerMenu) {
      case 'seller-profile':
        switch (qntdGroups) {
          case 0:
            Fluttertoast.showToast(
                msg: 'Para efetuar um pedido, primeiro abra uma conta',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: ColorTheme.primaryColor,
                textColor: Colors.white,
                fontSize: 16);
            // homeController.setRouterMenu(null);

            await homeController.getTables(sellerModel);

            await homeController.getTableOpening(seller: sellerModel);
            // Modular.to.pushNamed('/table-opening', arguments: sellerModel.id);

            break;

          case 1:
            Fluttertoast.showToast(
                msg: 'Pedido efetuado',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: ColorTheme.primaryColor,
                textColor: Colors.white,
                fontSize: 16);

            await createOrder(listing: documentFields);
            setAddOrder(1);
            setTotalAmountOrder();
            setClickNote(false);
            setclickItem(false);
            setNoteInput('');
            // homeController.setRouterMenu(null);

            break;

          default:
            Fluttertoast.showToast(
                msg:
                    'Você possui mais de uma conta aberta. Realize o pedido dentro da conta desejada!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: ColorTheme.primaryColor,
                textColor: Colors.white,
                fontSize: 16);
            break;
        }
        break;

      default:
        setConfirmOrder(documentFields.data);

        setAddOrder(1);
        setTotalAmountOrder();
        setClickNote(false);
        setclickItem(false);

        setNoteInput('');
        break;
    }
  }

  @action
  slideFunction({
    bool awaitingCheckout,
    String route,
    SellerModel seller,
    String groupId,
  }) async {
    switch (route) {
      case 'seller-profile':
        if (!seller.protectedPrices) {
          setSlideMenu('slide_menu');
        }
        break;

      case 'invite':
        break;

      default:
        if (awaitingCheckout == false) {
          await getStatus(groupId);

          if (groupStatus == 'requested' && requestedMenu == true) {
            setSlideMenu('slide_menu');
          }

          if (groupStatus == 'open' && myGroupStatus == 'open') {
            setSlideMenu('slide_menu');
          }
        } else {
          setSlideMenu('slidy_menu_mockup');
        }
        break;
    }
  }

  @action
  getStatus(groupId) async {
    DocumentSnapshot group =
        await Firestore.instance.collection('groups').document(groupId).get();
    groupStatus = group.data['status'];
    QuerySnapshot myGroups = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('my_group')
        .where('id', isEqualTo: groupId)
        .getDocuments();
    myGroupStatus = myGroups.documents.first.data['status'];
  }

  @action
  queuedAsking(num preparation) async {
    QuerySnapshot queue = await Firestore.instance
        .collection('sellers')
        .document(homeController.sellerModel.id)
        .collection('queue')
        .getDocuments();
    if (queue.documents.length != 0) {
      QuerySnapshot queued = await queue.documents.first.reference
          .collection('queued')
          .getDocuments();

      if (queued.documents.length == 0) {
        requestedMenu = false;
      }

      for (var i = 0; i < queued.documents.length; i++) {
        if (queued.documents[i].data['group_id'] == homeController.groupChat) {
          num queuePrev = await queued.documents[i].data['queue_prev'];

          if (queuePrev < preparation) {
            requestedMenu = true;
          }

          if (queuePrev > preparation) {
            requestedMenu = false;
          }
        }
        if (i == queued.documents.length - 1 && requestedMenu == null) {
          requestedMenu = false;
        }
      }
    } else {
      requestedMenu = false;
    }
  }

  @action
  setConfirmOrder(dynamic confirm) {
    if (qtdOrder > 1) {
      confirm['note'] = noteInput;

      if (confirm['order'] != null) {
        totalMenu = totalMenu + (qtdOrder * confirm['order']['price']);
      } else {
        totalMenu = totalMenu + (qtdOrder * confirm['price']);
      }
    } else {
      confirm['ordered_amount'] = qtdOrder;
      confirm['note'] = noteInput;
      totalMenu = totalMenu + confirm['price'];
    }

    if (usersInvitedToshare != null) {
      confirm['order_shared'] = true;
      confirm['order_shared_friends'] = usersInvitedToshare;
      confirm['ordered_amount'] = qtdOrder;
      orderConfirm.add(confirm);

      usersInvitedToshare = null;
      Modular.to.pop();
    } else {
      confirm['ordered_amount'] = qtdOrder;
      orderConfirm.add(confirm);
    }
  }

  @action
  setQntdGroups({String sellerId}) async {
    List groupsId = [];
    QuerySnapshot groupSeller = await Firestore.instance
        .collection('groups')
        .where('seller_id', isEqualTo: sellerId)
        .where('status', isEqualTo: 'open')
        .getDocuments();

    QuerySnapshot myGroups = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'open')
        .getDocuments();

    groupSeller.documents.forEach((elementGroupSeller) {
      if (myGroups.documents.isNotEmpty) {
        myGroups.documents.forEach((elementMyGroup) {
          if (elementMyGroup.data['id'] == elementGroupSeller.data['id']) {
            groupsId.add(elementGroupSeller.data['id']);
            qntdGroups = groupsId.length;
          }
        });
      }
    });
    if (qntdGroups == 1) {
      routerMenuGroupId = groupsId.first.toString();
    }
  }

  @action
  setPlusOrder() {
    qtdOrder++;
    //print'addOrder +: ${qtdOrder}');
  }

  @action
  setRemoveOrder() {
    if (qtdOrder > 1) {
      qtdOrder--;
      // //print'addOrder -: ${qtdOrder}');
    }
  }

  @action
  eventCountIncrement() async {
    QuerySnapshot membs = await Firestore.instance
        .collection("groups")
        .document(homeController.myGroupSelected)
        .collection('members')
        .getDocuments();

    membs.documents.forEach((element) async {
      QuerySnapshot myGroup = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .collection('my_group')
          .where('id', isEqualTo: element.data['group_id'])
          .getDocuments();

      myGroup.documents.forEach((element) async {
        num eventCounter = await element.data['event_counter'];
        eventCounter++;

        element.reference.updateData({'event_counter': eventCounter});
      });
    });
  }

  @action
  simpleOrder({Map<String, dynamic> listing, String router}) async {
    functionSimpleOrder(String groupId) async {
      DocumentSnapshot group =
          await Firestore.instance.collection('groups').document(groupId).get();

      if (group.data['status'] == 'open') {
        Fluttertoast.showToast(
            msg: 'Pedido efetuado',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: ColorTheme.primaryColor,
            textColor: Colors.white,
            fontSize: 16);

        DocumentReference order =
            await Firestore.instance.collection('orders').add({
          'created_at': Timestamp.now(),
          'group_id': group.documentID,
          'seller_id': listing['seller_id'],
          'user_id': homeController.user.uid,
          'status': 'order_requested'
        });

        order.updateData({'id': order.documentID});

        DocumentReference cartItem = await order.collection('cart_item').add({
          'ordered_amount': 1,
          'ordered_value': listing['price'],
          'status': 'created',
          'listing_id': listing['id'],
          'description': listing['description'],
          'title': listing['label'],
          'created_at': Timestamp.now(),
        });

        cartItem.updateData({'id': cartItem.documentID});

        QuerySnapshot groupChat = await Firestore.instance
            .collection("chats")
            .where('group_id', isEqualTo: group.documentID)
            .getDocuments();

        DocumentReference messages = await Firestore.instance
            .collection("chats")
            .document(groupChat.documents[0].documentID)
            .collection("messages")
            .add({
          'order_id': order.documentID,
          'author_id': homeController.user.uid,
          'note': noteInput,
          'created_at': Timestamp.now(),
          'seller_id': group.data['seller_id'],
          'group_id': group.documentID,
          'type': 'create-order'
        });

        messages.updateData({'id': messages.documentID});

        Modular.to.pushNamed('/menu/chat/' + group.documentID,
            arguments: group.documentID);
      } else {
        Fluttertoast.showToast(
            msg: 'Aguarde a abertura da conta',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: ColorTheme.primaryColor,
            textColor: Colors.white,
            fontSize: 16);
      }
    }

    switch (router) {
      case 'seller-profile':
        switch (qntdGroups) {
          case 0:
            Fluttertoast.showToast(
                msg: 'Para efetuar um pedido, primeiro abra uma conta',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: ColorTheme.primaryColor,
                textColor: Colors.white,
                fontSize: 16);

            await homeController.getTables(sellerModel);

            await homeController.getTableOpening(seller: sellerModel);
            // Modular.to.pushNamed('/table-opening', arguments: sellerModel.id);

            break;

          case 1:
            functionSimpleOrder(routerMenuGroupId);
            break;

          default:
            Fluttertoast.showToast(
                msg:
                    'Você possui mais de uma conta aberta. Realize o pedido dentro da conta desejada!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: ColorTheme.primaryColor,
                textColor: Colors.white,
                fontSize: 16);
            break;
        }
        break;

      default:
        functionSimpleOrder(homeController.myGroupSelected);

        break;
    }
  }

  @action
  confirmOrder(List<dynamic> order) async {
    var user = await FirebaseAuth.instance.currentUser();

    // //print'order[note]order[note]order[note]order[note]${order}');

    order.forEach((element) async {
      Firestore.instance
          .collection("groups")
          .document(homeController.myGroupSelected)
          .get()
          .then((_group) async {
        // //print'mesa: ${_group.documentID}');
        await _group.reference.updateData({"id": _group.documentID});
        await Future.delayed(Duration(milliseconds: 100));
        // //print
        //     'User ja te mesa 888888888888888888888888888888888888 :${element['order']}');
        if (element['order'] != null) {
          // //print'documentID if: ${_group.documentID}');
          await Firestore.instance.collection("orders").add({
            'id': user.uid,
            'created_at': Timestamp.now(),
            'group_id': _group.documentID,
            'seller_id': element['order']['seller_id'],
            'user_id': user.uid,
          }).then((value2) async {
            // //print'element ${element['order']}');

            await Firestore.instance
                .collection("orders")
                .document(value2.documentID)
                .collection('cart_item')
                .add({
              'ordered_amount': element['order']['ordered_amount'],
              'ordered_value': element['order']['ordered_amount'] == 1
                  ? element['order']['price']
                  : (element['order']['price'] *
                      element['order']['ordered_amount']),
              'status': 'created',
              'note': element['note'],
              'listing_id': element['order']['id'],
              'description ': element['order']['description'],
              'title': element['order']['label'],
              'user_id': user.uid,
              'created_at': Timestamp.now()
            }).then((valueOrder) {
              valueOrder.updateData({'id': valueOrder});
            });
            orderId = await value2.documentID;

            if (element['user'] != null) {
              element['user'].forEach((element) async {
                DocumentSnapshot ref3 = await Firestore.instance
                    .collection("users")
                    .document(element)
                    .get();
                // //print'ref3 : $ref3');

                DocumentReference ref4 = await Firestore.instance
                    .collection("orders")
                    .document(value2.documentID)
                    .collection('members')
                    .add({
                  'user_id': ref3.documentID,
                  'username': ref3.data['username'],
                  'inviter_id': user.uid,
                  'group_id': _group.documentID,
                  'created_at': Timestamp.now(),
                  'role': 'invited',
                  'mobile_region_code': ref3.data['mobile_region_code'],
                  'mobile_phone_number ': ref3.data['mobile_phone_number'],
                });

                // //print'ref3 : $ref4');
              });
            }
          });
          userId = user.uid;
          QuerySnapshot documentReference = await Firestore.instance
              .collection("chats")
              .where('group_id', isEqualTo: _group.documentID)
              .getDocuments();

          // //print
          //     'document id ==================== : ${documentReference.documents[0].documentID}');

          DocumentReference ref4 = await Firestore.instance
              .collection("chats")
              .document(documentReference.documents[0].documentID)
              .collection("messages")
              .add({
            'order_id': orderId,
            'author_id': user.uid,
            'created_at': Timestamp.now(),
            'note': element['note'],
            'seller_id': _group.data['seller_id'],
            'group_id': _group.documentID,
            'type': usersInvitedToshare.isNotEmpty
                ? 'order-with-members'
                : 'create-order'
          });
          await ref4.updateData({'id': ref4.documentID});
          // //print'ref4.documentID================ :${ref4.documentID} ');
          // //print
          //     'value.documents[0].documentID================ :${_group.documentID} ');
          orderId = null;
          // Modular.to.pushNamed('/menu/chat',
          //     arguments: [ref4.documentID, _group.documentID]);
          // Modular.to.pushNamed('/chat', arguments: _group.documentID);
          Modular.to.pushNamed('/menu/chat/' + _group.documentID,
              arguments: _group.documentID);
        } else {
          // //print'documentID else: ${_group.documentID}');
          await Firestore.instance.collection("orders").add({
            'created_at': Timestamp.now(),
            'status': element['order_shared_friends'] != null
                ? 'awaiting_order'
                : 'order_requested',
            'group_id': _group.documentID,
            'seller_id': element['seller_id'],
            'user_id': user.uid,
          }).then((value2) async {
            await value2.updateData({'id': value2.documentID});
            // //print
            //     'element %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%${element['note']}');

            DocumentReference ref2 = await Firestore.instance
                .collection("orders")
                .document(value2.documentID)
                .collection('cart_item')
                .add({
              'note': element['note'],
              'ordered_amount': element['ordered_amount'],
              'ordered_value': element['ordered_amount'] == 1
                  ? element['price']
                  : (element['price'] * element['ordered_amount']),
              'status': 'created',
              'description': element['description'],
              'title': element['label'],
              'created_at': Timestamp.now(),
              'listing_id': element['id'],
            });
            await ref2.updateData({'id': ref2.documentID});
            orderId = await value2.documentID;

            if (element['order_shared_friends'] != null) {
              // //print
              //     ' %%%%%%%%%%%%%%%%%%%% PEDIDO DIVIDIDO %%%%%%%%%%%%%%%%%%%%  : $element');
              element['order_shared_friends'].forEach((element2) {
                // //print
                //     ' %%%%%%%%%%%%%%%%%%%% PEDIDO DIVIDIDO dfdfs %%%%%%%%%%%%%%%%%%%%  : $element2');
                Firestore.instance
                    .collection("orders")
                    .document(value2.documentID)
                    .collection('members')
                    .add({
                  'user_id': element2['id'],
                  'username': element2['username'],
                  'inviter_id': user.uid,
                  'group_id': _group.documentID,
                  'created_at': Timestamp.now(),
                  'role': 'invited',
                  'mobile_region_code': element2['mobile_region_code'],
                  'mobile_phone_number': element2['mobile_phone_number'],
                }).then((value) {
                  value.updateData({'id': value.documentID});
                });
              });
            }

            userId = user.uid;

            QuerySnapshot documentReference = await Firestore.instance
                .collection("chats")
                .where('group_id', isEqualTo: _group.documentID)
                .getDocuments();
            // //print
            //     '_group.documentID  ==================== : ${_group.documentID}');
            // //print
            //     'documentReference  ==================== : ${documentReference.documents.first.documentID}');
            // //print
            //     'usersInvitedToshare  ==================== : ${usersInvitedToshare}');

            DocumentReference ref4 = await Firestore.instance
                .collection("chats")
                .document(documentReference.documents.first.documentID)
                .collection("messages")
                .add({
              'order_id': value2.documentID,
              'author_id': user.uid,
              'created_at': Timestamp.now(),
              'group_id': _group.documentID,
              'seller_id': _group.data['seller_id'],
              'note': element['note'],
              'type': element['order_shared_friends'] != null
                  ? 'order-with-members'
                  : 'create-order'
            });
            // .then((element) {
            //   element.updateData({'id': element});
            //   orderId = null;
            //   Modular.to.pushNamed('/chat', arguments: _group.documentID);
            //   // arguments: [element.documentID, _group.documentID]);
            // });

            await ref4.updateData({'id': ref4.documentID});
            Modular.to.pushNamed('/menu/chat/' + _group.documentID,
                arguments: _group.documentID);
          });

          // Modular.to.pop();
        }
      });
    });
    orderConfirm = new List();
    totalMenu = 0;
    totalAmountOrder = 0;
  }

  @action
  void increment() {
    value++;
  }

  @action
  setFavs() async {
    QuerySnapshot fav = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('favorite_sellers')
        .where('id', isEqualTo: homeController.sellerModel.id)
        .getDocuments();

    if (fav.documents[0].data['id'] == homeController.sellerModel.id) {
      //delete
      fav.documents[0].reference.delete();

      // //print'0position : ${fav.documents[0].data['id']}');
    }
  }
}
