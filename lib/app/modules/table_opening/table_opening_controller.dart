import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
part 'table_opening_controller.g.dart';

@Injectable()
class TableOpeningController = _TableOpeningControllerBase
    with _$TableOpeningController;

abstract class _TableOpeningControllerBase with Store {
  // final menuController = Modular.get<MenuController>();
  final homeController = Modular.get<HomeController>();
  List<Contact> _contacts;

  @observable
  List arrayInvites = [];
  int value = 0;
  @observable
  String sellerHash;
  @observable
  String tableName = '';
  @observable
  SellerModel seller;
  @observable
  File imageFile;
  @observable
  bool haveInvite = false;
  @observable
  String groupId;
  @observable
  bool showSearchButton = true;
  @observable
  num qLength;
  @observable
  Timestamp prev;

  @action
  setShowSearchButton(bool _showSearch) => showSearchButton = _showSearch;
  @action
  setHaveInvite(bool has) => haveInvite = has;
  @action
  setImage(File image) => imageFile = image;
  @action
  setArrayInvites(List invets) => arrayInvites = invets;
  @action
  setcontacts(List<Contact> inter) => _contacts = inter;
  @action
  setSellerHash(String val1) => sellerHash = val1;
  @action
  setTableName(String name) => tableName = name;
  @action
  setSeller(SellerModel sell) => seller = sell;

  @action
  openTable(SellerModel sellerMd) async {
    if (arrayInvites != null || arrayInvites.isEmpty) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      DocumentReference refGroup =
          await Firestore.instance.collection("groups").add({
        'created_at': Timestamp.now(),
        'avatar': sellerMd.avatar,
        'status': 'requested',
        'bg_image': sellerMd.bg_image,
        'label': tableName,
        'seller_id': sellerMd.id,
        'seller_name': sellerMd.name,
        'user_created': user.uid,
        'user_host': user.uid
      }).then((value) async {
        if (homeController.queueRoute == true) {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          QuerySnapshot queue = await Firestore.instance
              .collection('sellers')
              .document(sellerMd.id)
              .collection('queue')
              .getDocuments();

          num med = queue.documents.first.data['table_estimation'];

          QuerySnapshot queued = await queue.documents.first.reference
              .collection('queued')
              .getDocuments();

          qLength = queued.documents.length + 1;

          if (qLength.isNaN || qLength == null) {
            qLength = 1;
          }

          int qtime = (med * qLength).round();

          int forecast =
              (queue.documents.first.data['estimated_forecast'].toInt() *
                  60000);

          Timestamp now = Timestamp.now();

          int noow = now.millisecondsSinceEpoch;

          int tmillisecs = forecast + noow;

          prev = Timestamp.fromMillisecondsSinceEpoch(tmillisecs);

          await queue.documents.first.reference.collection('queued').add({
            'group_id': value.documentID,
            'queued_at': Timestamp.now(),
            'queue_prev': qtime,
            'pos': qLength,
            'user_id': user.uid
          }).then((valueQ) {
            valueQ.updateData({'id': valueQ.documentID});
          });
        }

        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        DocumentSnapshot _user = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();

        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('groups/${value.documentID}/avatar/${imageFile.path[0]}');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

        taskSnapshot.ref.getDownloadURL().then(
          (valueimage) async {
            await Firestore.instance
                .collection("groups")
                .document(value.documentID)
                .updateData({
              'avatar': valueimage,
              // 'id': value.documentID,
            });
          },
        );
        Firestore.instance.collection('order_sheets').add({
          'created_at': Timestamp.now(),
          'status': 'opened',
          'user_id': user.uid,
          'group_id': value.documentID,
          'seller_id': sellerMd.id,
        }).then((value) {
          value.updateData({'id': value.documentID});
        });
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('my_group')
            .add(
                {'id': value.documentID, 'status': 'open', 'event_counter': 1});

        //print'my_group_status 2');

        DocumentReference refUser = await Firestore.instance
            .collection("groups")
            .document(value.documentID)
            .collection('members')
            .add({
          'created_at': Timestamp.now(),
          'role': 'created',
          'username': _user['username'],
          'mobile_region_code': _user['mobile_region_code'],
          'mobile_phone_number': _user['mobile_phone_number'],
          'user_id': user.uid,
          'group_id': value.documentID,
          'selected_user': false,
          'inviter_id': user.uid
        });
        refUser.updateData({'id': refUser.documentID});

        List listUsers = [];
        arrayInvites.forEach((member) async {
          DocumentSnapshot ds = await Firestore.instance
              .collection('users')
              .document(member)
              .get();
          //print'%%%%%%%%%%%% ds.data ${ds.data} %%%%%%%%%%%%');

          //print'===========   COM MEMBRO: ${ds.data['mobile_phone_number']}');

          QuerySnapshot usersRef = await Firestore.instance
              .collection("users")
              .where('mobile_phone_number',
                  isEqualTo: ds.data['mobile_phone_number'])
              .getDocuments();

          //print
          // '%%%%%%%%%%%% usersRef ${usersRef.documents.first.data} %%%%%%%%%%%%');

          if (usersRef != null) {
            //print'%%%%%%%%%%%% entrou no iffffff %%%%%%%%%%%%');
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            DocumentReference ref = await Firestore.instance
                .collection("groups")
                .document(value.documentID)
                .collection('members')
                .add({
              'created_at': Timestamp.now(),
              'role': 'invited',
              'username': ds.data['username'],
              'mobile_region_code': ds.data['mobile_region_code'],
              'mobile_phone_number': ds.data['mobile_phone_number'],
              'user_id': usersRef.documents[0].documentID,
              'group_id': value.documentID,
              'selected_user': false,
              'inviter_id': user.uid
            });
            ref.updateData({'id': ref.documentID});

            //print'print pra esse código idiota acordar');
            DocumentReference ref3 =
                await Firestore.instance.collection("invites").add({
              'created_at': Timestamp.now(),
              'role': 'invited',
              'username': ds.data['username'],
              'mobile_region_code': ds.data['mobile_region_code'],
              'mobile_phone_number': ds.data['mobile_phone_number'],
              'seller_id': sellerMd.id,
              'user_id': usersRef.documents[0].documentID,
              'group_id': value.documentID,
              'inviter_id': user.uid
            });

            ref3.updateData({'id': ref3.documentID});
            //print'outro print:::::::::: ${ref3.documentID}');
          }
        });
        var idG = value.documentID;

        DocumentReference ref4 = await Firestore.instance
            .collection("chats")
            .add({'group_id': value.documentID}).then((valueChat) async {
          valueChat.updateData({'id': valueChat.documentID});
          Firestore.instance
              .collection("chats")
              .document(valueChat.documentID)
              .collection("messages")
              .add({
            'group_id': idG,
            'author_id': user.uid,
            'created_at': Timestamp.now(),
            'text': 'Mesa $tableName criada com sucesso!',
            'type': 'create-table',
          }).then((valueMessages) {
            valueMessages.updateData({'id': valueMessages.documentID});
          });
          if (homeController.queueRoute == true)
            await {
              Firestore.instance
                  .collection("chats")
                  .document(valueChat.documentID)
                  .collection("messages")
                  .add({
                'user_id': homeController.user.uid,
                'group_id': value.documentID,
                'author_id': sellerMd.id,
                'created_at': Timestamp.now(),
                'prev': prev,
                'type': 'virtual_queue_add',
                'pos': qLength,
              }).then((qValueMessages) {
                qValueMessages.updateData({'id': qValueMessages.documentID});
              })
            };
        });

        value.updateData({'id': value.documentID});
        //print'value value: ${value.documentID}');
        homeController.setQRoute(false);
        Modular.to.pushNamed('table-opening/chat/' + value.documentID,
            arguments: value.documentID);
        setImage(null);
      });
    } else {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      DocumentReference refGroup =
          await Firestore.instance.collection("groups").add({
        'created_at': Timestamp.now(),
        'avatar': sellerMd.avatar,
        'status': 'requested',
        'bg_image': sellerMd.bg_image,
        'label': tableName,
        'seller_id': sellerMd.id,
        'seller_name': sellerMd.name,
        'user_created': user.uid,
        'user_host': user.uid
      }).then((value) async {
        /////////////////// DONT DELETE THIS SHIIIIIIITA ////////////////////
        if (homeController.queueRoute == true) {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          QuerySnapshot queue = await Firestore.instance
              .collection('sellers')
              .document(sellerMd.id)
              .collection('queue')
              .getDocuments();

          num med = queue.documents.first.data['table_estimation'];

          QuerySnapshot queued = await queue.documents.first.reference
              .collection('queued')
              .getDocuments();

          qLength = queued.documents.length + 1;

          if (qLength.isNaN || qLength == null) {
            qLength = 1;
          }

          int qtime = (med * qLength).round();

          int forecast =
              (queue.documents.first.data['estimated_forecast'].toInt() *
                  60000);

          Timestamp now = Timestamp.now();

          int noow = now.millisecondsSinceEpoch;

          int tmillisecs = forecast + noow;

          prev = Timestamp.fromMillisecondsSinceEpoch(tmillisecs);

          await queue.documents.first.reference.collection('queued').add({
            'group_id': value.documentID,
            'queued_at': Timestamp.now(),
            'queue_prev': qtime,
            'pos': qLength,
            'user_id': user.uid
          }).then((valueQ) {
            valueQ.updateData({'id': valueQ.documentID});
          });
        }
        /////////////////// DONT DELETE THIS SHIIIIIIITA ////////////////////

        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('my_group')
            .add(
                {'id': value.documentID, 'status': 'open', 'event_counter': 1});
        Firestore.instance.collection('order_sheets').add({
          'created_at': Timestamp.now(),
          'status': 'opened',
          'user_id': user.uid,
          'group_id': value.documentID,
          'seller_id': sellerMd.id,
        }).then((value) {
          value.updateData({'id': value.documentID});
        });
        DocumentSnapshot _user = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();

        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('groups/${value.documentID}/avatar/${imageFile.path[0]}');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then(
          (value) async {
            await Firestore.instance
                .collection("groups")
                .document(value.documentID)
                .updateData({'avatar': value});
          },
        );
        DocumentReference refUser = await Firestore.instance
            .collection("groups")
            .document(value.documentID)
            .collection('members')
            .add({
          'created_at': Timestamp.now(),
          'role': 'created',
          'username': _user['fullname'],
          'mobile_region_code': _user['mobile_region_code'],
          'mobile_phone_number': _user['mobile_phone_number'],
          'user_id': user.uid,
          'group_id': value.documentID,
          'selected_user': false,
          'inviter_id ': user.uid
        }).then((valuememb) {
          value.updateData({'id': valuememb});
        });

        var idG = value.documentID;

        DocumentReference ref4 = await Firestore.instance
            .collection("chats")
            .add({'group_id': value.documentID}).then((valueChat) async {
          valueChat.updateData({'id': valueChat.documentID});

          Firestore.instance
              .collection("chats")
              .document(valueChat.documentID)
              .collection("messages")
              .add({
            'group_id': idG,
            'author_id': user.uid,
            'created_at': Timestamp.now(),
            'text': 'Mesa $tableName criada com sucesso!',
            'type': 'create-table',
          }).then((valueMessages) async {
            await valueMessages.updateData({'id': valueMessages.documentID});
          });
          if (homeController.queueRoute == true)
            await {
              Firestore.instance
                  .collection("chats")
                  .document(valueChat.documentID)
                  .collection("messages")
                  .add({
                'user_id': homeController.user.uid,
                'group_id': value.documentID,
                'author_id': sellerMd.id,
                'created_at': Timestamp.now(),
                'prev': prev,
                'type': 'virtual_queue_add',
                'pos': qLength,
              }).then((qValueMessages) {
                qValueMessages.updateData({'id': qValueMessages.documentID});
              })
            };
        });
        homeController.setQRoute(false);
        Modular.to.pushNamed('table-opening/chat/' + value.documentID,
            arguments: value.documentID);
      });
      await refGroup.updateData({'id': refGroup.documentID});
    }
    setImage(null);
  }

  @action
  void increment() {
    value++;
  }
}
