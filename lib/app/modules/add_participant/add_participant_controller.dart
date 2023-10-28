import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'add_participant_controller.g.dart';

@Injectable()
class AddParticipantController = _AddParticipantControllerBase
    with _$AddParticipantController;

abstract class _AddParticipantControllerBase with Store {
  final homeController = Modular.get<HomeController>();
  final openTableController = Modular.get<OpenTableController>();

  List<Contact> _contacts;
  @observable
  ObservableList arrayInvites = [].asObservable();
  @observable
  int value = 0;
  @observable
  String tableName;
  @observable
  SellerModel seller;
  @observable
  bool unsearch = true;
  @observable
  bool showSearchButton = true;

  @action
  setShowSearchButton(bool _showSearch) => showSearchButton = _showSearch;
  @action
  setTableName(String name) => tableName = name;
  @action
  setUnsearch(bool _unsearch) => unsearch = _unsearch;

  @action
  setArrayInvites(List invets) => arrayInvites = invets;
  @action
  void increment() {
    value++;
  }

  @action
  updateTable(String tableID) async {
    // //print'tableID ===: $tableID');
    if (tableName != null) {
      Firestore.instance
          .collection("groups")
          .document(tableID)
          .updateData({'label': tableName});
    }
    // //print'arrayInvites ===: $arrayInvites');

    if (arrayInvites != null || arrayInvites.isNotEmpty) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // //print
      //     'openTableController.sellerGroupSelected ====: ${openTableController.sellerGroupSelected}');

      DocumentSnapshot grouppp =
          await Firestore.instance.collection('groups').document(tableID).get();
      String sellerID = grouppp.data['seller_id'];
      //print'sellerIDd ===: $sellerID');

      var _seller = await Firestore.instance
          .collection('sellers')
          .document(sellerID)
          .get();

      // SellerModel();

      // arrayInvites.forEach((element) async {
      arrayInvites.forEach((member) async {
        DocumentSnapshot ds =
            await Firestore.instance.collection('users').document(member).get();
        // //print'=========== COM MEMBRO: ${element['full_name']}');

        QuerySnapshot usersRef = await Firestore.instance
            .collection("groups")
            .document(tableID)
            .collection('members')
            .where('mobile_phone_number',
                isEqualTo: ds.data['mobile_phone_number'])
            .getDocuments();
        if (usersRef != null) {
          // //print'*****************************usersRef: ${usersRef}');
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          // DocumentReference refUser = await Firestore.instance
          //                 .collection("group")
          //                 .document(value.documentID)
          //                 .collection('members')
          //                 .add({
          String userTable;

          if (usersRef.documents.isEmpty) {
            // //print'if ');
            userTable;
          } else {
            // //print'else ');
            userTable = usersRef.documents[0].data['mobile_phone_number'];
          }

          // //print'userTable ${userTable}');

          // //print
          //     'element[mobile_phone_number] ${ds.data['mobile_phone_number']}');
          if (userTable != ds.data['mobile_phone_number']) {
            // //print'USER CONVIDADO : ${ds.data['reference']} ');

            DocumentReference ref = await Firestore.instance
                .collection("groups")
                .document(tableID)
                .collection('members')
                .add({
              'created_at': Timestamp.now(),
              'role': 'invited',
              'username': ds.data['username'],
              'mobile_region_code': ds.data['mobile_region_code'],
              'mobile_phone_number': ds.data['mobile_phone_number'],
              'user_id': ds.data['id'],
              'group_id': tableID,
              'selected_user': false,
              'inviter_id': user.uid
            }).then((value2) async {
              value2.updateData({'id': value2.documentID});
              FirebaseUser user = await FirebaseAuth.instance.currentUser();

              DocumentReference ref3 =
                  await Firestore.instance.collection("invites").add({
                'created_at': Timestamp.now(),
                'role': 'invited',
                'username': ds.data['username'],
                'mobile_region_code': ds.data['mobile_region_code'],
                'mobile_phone_number': ds.data['mobile_phone_number'],
                'seller_id': _seller.documentID,
                'user_id': ds.data['id'],
                'group_id': tableID,
                'inviter_id': user.uid
              });
              ref3.updateData({'id': ref3.documentID});
              // //printref3);
            });

            // //printref);
          }
        }
        arrayInvites = [].asObservable();
      });

      // QuerySnapshot ref5 = await Firestore.instance
      //     .collection("chats")
      //     .where('group_id', isEqualTo: tableID)
      //     .getDocuments();

      // ref5.documents.first.reference.collection("messages").add({
      //   'author_id': user.uid,
      //   'created_at': Timestamp.now(),
      //   'text': tableName != null
      //       ? 'Mesa $tableName Alterada com sucesso!'
      //       : 'Mesa Alterada com sucesso!',
      //   'type': 'create-table',
      // });
      // });

      //print'value value: $value');
      // Modular.to.pushNamed('open-table/chat/' + ds['id'], arguments: ds['id']);
      Modular.to
          .pushNamed('add-participant/chat/' + tableID, arguments: tableID);
    }
  }
}
