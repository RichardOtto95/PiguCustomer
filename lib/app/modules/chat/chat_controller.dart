import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'chat_controller.g.dart';

@Injectable()
class ChatController = _ChatControllerBase with _$ChatController;

abstract class _ChatControllerBase with Store {
  final homeController = Modular.get<HomeController>();

  // final openTableController = Modular.get<OpenTableController>();

  @observable
  int value = 0;
  @observable
  bool clickItem = false;
  @observable
  String hash;
  @observable
  String host;
  @observable
  String invited_host;
  @observable
  String image_invited_host;
  @observable
  String image_host;
  @observable
  String group;
  @observable
  bool firstOrder = false;
  @observable
  bool ver = false;
  @observable
  int qntdItem = 0;
  @observable
  List arrayAccept = List();
  @observable
  List<String> list = [];
  @observable
  bool showMenu = false;
  @observable
  String phoneUserLogin = '';
  @observable
  bool reverse = false;
  @observable
  String groupId;
  @observable
  String groupStatus;
  @observable
  String myGroupStatus;
  @observable
  bool enableButtons;
  @observable
  String titleEmpty = '';
  @observable
  bool repeatOrder;
  @observable
  String toastText;
  @observable
  bool awaitingCheckout;
  @observable
  bool allOk = false;
  @observable
  ObservableMap orderIdAvatares = Map().asObservable();
  // @observable
  // Map<String, int> orderIdAmountPerson = Map();
  @observable
  bool showAppBar = true;
  @observable
  bool paymentDialog = false;

  @action
  setShowAppBar(bool show) {
    showAppBar = show;
  }

  @action
  setPaymentDialog(bool dl) => paymentDialog = dl;
  @action
  setGroupId(_group) => groupId = _group;

  @action
  functionRepeatOrder(
      {String sellerId,
      String groupId,
      bool repeatOrder = false,
      String itemId}) async {
    homeController.setGroupChat(groupId);
    String listingId = '';

    if (repeatOrder) {
      QuerySnapshot lastOrders = await Firestore.instance
          .collection("orders")
          .where('user_id', isEqualTo: homeController.user.uid)
          .where('group_id', isEqualTo: groupId)
          .orderBy('created_at', descending: true)
          .getDocuments();

      QuerySnapshot lastCartItem = await lastOrders.documents.first.reference
          .collection('cart_item')
          .getDocuments();

      listingId = await lastCartItem.documents.first.data['listing_id'];
    }

    DocumentSnapshot seller =
        await Firestore.instance.collection('sellers').document(sellerId).get();

    SellerModel sellerModel = SellerModel(
      address: seller.data['address'],
      avatar: seller.data['avatar'],
      bg_image: seller.data['bg_image'],
      category_id: seller.data['category_id'],
      name: seller.data['name'],
      id: seller.data['id'],
    );

    homeController.setSeller(sellerModel);

    Modular.to.pushNamed('/menu', arguments: sellerModel);

    MenuController menuController = Modular.get<MenuController>();

    menuController.setclickItem(true);
    menuController.setItemId(repeatOrder ? listingId : itemId);
  }

  @action
  Future<bool> getGroupPaymentStatus({String groupId}) async {
    DocumentSnapshot group =
        await Firestore.instance.collection('groups').document(groupId).get();

    QuerySnapshot groupMembers =
        await group.reference.collection('members').getDocuments();

    if (groupMembers.documents.length == 1 ||
        homeController.user.uid != group.data['user_host']) {
      return true;
    } else {
      int membersPaid = 0;
      groupMembers.documents.forEach((element) {
        if (element.data['user_id'] != group.data['user_host'] &&
            element.data['role'] == 'paid') {
          membersPaid++;
        }
      });
      var membersSemHost = groupMembers.documents.length - 1;
      if (membersPaid == membersSemHost) {
        return true;
      } else {
        return false;
      }
    }
  }

  @action
  getAvatarPayTheBill({String orderId}) async {
    List<String> list = [];
    DocumentSnapshot order =
        await Firestore.instance.collection('orders').document(orderId).get();

    DocumentSnapshot host = await Firestore.instance
        .collection('users')
        .document(order.data['user_id'])
        .get();

    if (order.data['user_id'] != homeController.user.uid) {
      list.add(host.data['avatar']);
    }

    QuerySnapshot members =
        await order.reference.collection('members').getDocuments();

    members.documents.forEach((ds) async {
      DocumentSnapshot _user = await Firestore.instance
          .collection('users')
          .document(ds.data['user_id'])
          .get();

      if (ds.data['user_id'] != homeController.user.uid) {
        list.add(_user.data['avatar']);
      }
      orderIdAvatares.putIfAbsent(orderId, () => list);
    });
  }

  @action
  orderAccepted({String orderId}) async {
    Map<String, bool> map = new Map();
    DocumentSnapshot order =
        await Firestore.instance.collection('orders').document(orderId).get();

    QuerySnapshot member = await order.reference
        .collection('members')
        .where('user_id', isEqualTo: homeController.user.uid)
        .getDocuments();

    member.documents.first.reference.updateData({'role': 'accepted_invite'});

    QuerySnapshot orderMembers =
        await order.reference.collection('members').getDocuments();

    orderMembers.documents.forEach((element) {
      map.putIfAbsent(
          element.data['user_id'], () => element.data['role'] == 'invited');
    });

    if (map.containsValue(true) == false) {
      order.reference.updateData({'status': 'order_requested'});
    }
  }

  @action
  orderRefused({String orderId}) async {
    DocumentSnapshot order =
        await Firestore.instance.collection('orders').document(orderId).get();

    order.reference.updateData({'status': 'order_refused'});

    QuerySnapshot members = await order.reference
        .collection('members')
        .where('user_id', isEqualTo: homeController.user.uid)
        .getDocuments();

    members.documents.first.reference.updateData({'role': 'refused_invite'});
  }

  // @action
  // getQueueStatus(){
  //   Firestore.instance.collection('sellers').

  // }

  @action
  createMessage() async {
    DocumentSnapshot user = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .get();
    String _username = user.data['username'];
    if (_username.length > 20) {
      _username = _username.substring(0, 20);
    }
    QuerySnapshot chats = await Firestore.instance
        .collection('chats')
        .where('group_id', isEqualTo: groupId)
        .getDocuments();

    DocumentReference chat =
        await chats.documents.first.reference.collection('messages').add({
      'author_id': homeController.user.uid,
      'created_at': Timestamp.now(),
      'group_id': groupId,
      'text': "Usuário '$_username' pediu a conta",
      'type': 'create-table',
    });
    chat.updateData({'id': chat.documentID});
  }

  @action
  getAwaitingCheckout() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('order_sheets')
        .where('user_id', isEqualTo: homeController.user.uid)
        .where('group_id', isEqualTo: groupId)
        .getDocuments();
    DocumentSnapshot orderSheet = await qs.documents.first;
    if (orderSheet.data['status'] == 'awaiting_checkout') {
      awaitingCheckout = true;
      homeController.setAwaitingCheckout(awaitingCheckout);
    } else {
      awaitingCheckout = false;
      homeController.setAwaitingCheckout(awaitingCheckout);
    }
  }

  @action
  setFirstOrder() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('orders')
        .where('user_id', isEqualTo: homeController.user.uid)
        .where('group_id', isEqualTo: groupId)
        .getDocuments();
    if (qs.documents.length == 0) {
      firstOrder = true;
    } else {
      firstOrder = false;
    }
  }

  @action
  getSituation({String button}) {
    switch (button) {
      case 'pedirConta':
        if (!awaitingCheckout) {
          if (groupStatus == 'refused') {
            titleEmpty = 'Conta recusada';
            enableButtons = false;
          } else {
            if (myGroupStatus == 'paid' || myGroupStatus == 'filed') {
              titleEmpty = 'Comanda já quitada';
            }
            if (myGroupStatus == 'open') {
              titleEmpty = 'Comanda vazia';
              enableButtons = true;
            }
            if (myGroupStatus == 'refused') {
              titleEmpty = 'Convite recusado';
            }
          }
        } else {
          enableButtons = false;
          titleEmpty = 'Aguardando a conta chegar';
        }
        break;

      case 'repetirPedido':
        switch (groupStatus) {
          case 'open':
            if (!awaitingCheckout) {
              if (firstOrder) {
                toastText = 'Não há primeiro pedido';
                repeatOrder = false;
              } else if (myGroupStatus == 'open') {
                repeatOrder = true;
              } else if (myGroupStatus == 'refused') {
                toastText = 'Convite para está mesa foi recusado';
                repeatOrder = false;
              } else {
                toastText = 'Impossível, conta já quitada!';
                repeatOrder = false;
              }
            } else {
              toastText = 'Você já pediu a conta';
              repeatOrder = false;
            }
            break;

          case 'requested':
            if (myGroupStatus == 'refused') {
              toastText = 'Convite para está mesa foi recusado';
              repeatOrder = false;
            } else {
              toastText = 'Aguarde, já vamos lhe atender';
              repeatOrder = false;
            }
            break;

          case 'queue':
            if (myGroupStatus == 'refused') {
              toastText = 'Convite para está mesa foi recusado';
              repeatOrder = false;
            } else {
              toastText = 'Aguarde, já vamos lhe atender';
              repeatOrder = false;
            }
            break;

          case 'paid':
            toastText = 'Impossível, conta já quitada!';
            repeatOrder = false;
            break;

          case 'refused':
            toastText = 'Impossível, conta recusada pelo estabelecimento';
            repeatOrder = false;
            break;

          default:
            toastText = 'Aguarde a abertura da conta';
            repeatOrder = false;
            break;
        }
        break;

      case 'menu':
        switch (groupStatus) {
          case 'requested':
            toastText =
                "Abertura de mesa solicitada. Aguarde, já vamos lhe atender";
            break;
          case 'queue':
            toastText =
                "Você está em uma fila virtual. Aguarde, já vamos lhe atender";
            break;
          case 'refused':
            toastText = "Esta mesa foi recusada pelo restaurante";
            break;
          default:
            switch (myGroupStatus) {
              case 'open':
                allOk = true;
                break;
              case 'filed':
                toastText = "Esta conta está arquivada";
                break;
              case 'paid':
                toastText = "Esta conta está encerrada";
                break;
              case 'refused':
                toastText = "Esta conta foi recusada";
                break;
            }
            break;
        }
        break;
    }
  }

  @action
  getStatus() async {
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
  eventcleaner() async {
    //print'eventcleaner ===============================');
    Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .collection('my_group')
        .getDocuments()
        .then((value) {
      value.documents.forEach((group) async {
        if (group.data['id'] == hash) {
          group.reference.updateData({'event_counter': 0});
        }
      });
    });
  }

  @action
  Future<List<dynamic>> getMessages(String documentID) async {
    var docRef = await Firestore.instance
        .collection('chats')
        .document(documentID)
        .collection('messages')
        .getDocuments();

    return docRef.documents.map((snap) => snap.data).toList();
  }

  @action
  reverseChat(String groupId) async {
    QuerySnapshot chats = await Firestore.instance
        .collection('chats')
        .where('group_id', isEqualTo: groupId)
        .getDocuments();

    QuerySnapshot messages = await chats.documents.first.reference
        .collection('messages')
        .getDocuments();
    int qntd = messages.documents.length;

    if (qntd >= 5) {
      reverse = true;
    } else {
      reverse = false;
    }
  }

  Future<dynamic> getMembers(orderID) async {
    QuerySnapshot amigos = await Firestore.instance
        .collection('orders')
        .document(orderID)
        .collection('members')
        .getDocuments();

    List<dynamic> listAvatar = List();

    amigos.documents.forEach((element) async {
      DocumentSnapshot _amigo = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .get();
      await listAvatar.add(_amigo.data['avatar']);
    });

    await Future.delayed(Duration(seconds: 1));

    return listAvatar;
  }

  // @action
  // getHostinvite() {
  //   //print'MESA : ${hash}');
  //   Firestore.instance
  //       .collection('groups')
  //       .document(hash)
  //       .get()
  //       .then((value) async {
  //     DocumentSnapshot _in = await Firestore.instance
  //         .collection('users')
  //         .document(value.data['user_host_invited'])
  //         .get();
  //     DocumentSnapshot _hs = await Firestore.instance
  //         .collection('users')
  //         .document(value.data['user_host'])
  //         .get();
  //     // setState(() {
  //     if (_hs.data['avatar'] == null)
  //       image_host =
  //           "https://firebasestorage.googleapis.com/v0/b/pigu-project.appspot.com/o/users%2FdefaultUser.png?alt=media&token=74675535-a15f-4177-a4b3-282d77118c85";
  //     else {
  //       image_host = _hs.data['avatar'];
  //     }
  //     if (_in.exists) {
  //       if (_in.data['avatar'] == null) {
  //         image_invited_host =
  //             "https://firebasestorage.googleapis.com/v0/b/pigu-project.appspot.com/o/users%2FdefaultUser.png?alt=media&token=74675535-a15f-4177-a4b3-282d77118c85";
  //       } else {
  //         image_invited_host = _in.data['avatar'];
  //       }
  //       if (_in.data['fullname'] == null) {
  //         invited_host = _in.data['mobile_phone_number'];
  //       } else {
  //         invited_host = _in.data['fullname'];
  //       }
  //     }

  //     host = _hs.data['fullname'];
  //     // });
  //   });
  // }

  @action
  void increment() {
    value++;
  }
}
