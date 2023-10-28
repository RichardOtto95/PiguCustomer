import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'repeat_order_controller.g.dart';

@Injectable()
class RepeatOrderController = _RepeatOrderControllerBase
    with _$RepeatOrderController;

abstract class _RepeatOrderControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  @action
  addLastUserOrder(
    Map<String, dynamic> cart,
    String groupID,
    String orderID,
  ) async {
    var user = await FirebaseAuth.instance.currentUser();

    String _listingID = cart['listing_id'];

    DocumentSnapshot _listing = await Firestore.instance
        .collection('listings')
        .document(_listingID)
        .get();

    DocumentReference order =
        await Firestore.instance.collection('orders').add({
      'created_at': Timestamp.now(),
      'note': '',
      'status': 'order_requested',
      'user_id': user.uid,
      'group_id': groupID,
      'seller_id': _listing.data['seller_id'],
    });

    order.updateData({'id': order.documentID});

    DocumentReference cartItem = await order.collection('cart_item').add({
      'ordered_amount': cart['ordered_amount'],
      'ordered_value': cart['ordered_value'],
      'status': 'created',
      'listing_id': _listingID,
      'description': cart['description'],
      'title': cart['title'],
      'seller_id': _listing.data['seller_id'],
      'user_id': user.uid,
      'note': '',
      'created_at': Timestamp.now(),
    });

    cartItem.updateData({'id': cartItem.documentID});

    QuerySnapshot chats = await Firestore.instance
        .collection("chats")
        .where('group_id', isEqualTo: groupID)
        .getDocuments();

    String chatId = chats.documents.first.documentID;

    DocumentReference message = await Firestore.instance
        .collection("chats")
        .document(chatId)
        .collection("messages")
        .add({
      'order_id': orderID,
      'author_id': user.uid,
      'created_at': Timestamp.now(),
      'seller_note': '',
      'text': '',
      'type': 'create-order'
    });

    message.updateData({'id': message.documentID});

    Modular.to.pushNamed('/reapeat-order/chat/' + groupID, arguments: groupID);
  }
}
