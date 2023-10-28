import 'dart:async';

import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'open_table_controller.g.dart';

@Injectable()
class OpenTableController = _OpenTableControllerBase with _$OpenTableController;

abstract class _OpenTableControllerBase with Store {
  final homeController = Modular.get<HomeController>();
  @observable
  int value = 0;
  @observable
  String clickLabel = 'onGoing';
  @observable
  String clickLabelTableInfo = 'ProfileView';
  @observable
  String userView;
  @observable
  String groupSelected;
  @observable
  String eventIndex;
  // @observable
  // String sellerGroupSelected;
  @observable
  List<dynamic> openTables = new List();
  @observable
  List<dynamic> filedTables = new List();
  @observable
  List<dynamic> refusedTables = new List();
  @observable
  List<dynamic> paidTables = new List();
  @observable
  List<dynamic> allTables = new List();
  @observable
  // bool eventVerifier = true;
  @observable
  int eventcVerifier;
  @observable
  List<String> list = [];
  @observable
  List<String> membersID = [];
  @observable
  bool showMenu = false;

  @action
  setShowMenu(bool show) => showMenu = show;

  // @observable
  // List arrayInvites = [];

  @observable
  List<String> lll = [];
  String avatar;

  @action
  void increment() {
    value++;
  }

  @action
  addll(haha) async {
    // //print'TESTE hhaha =====: ${haha}');
    if (haha != null) {
// snapshot.data.documents
      await haha.forEach((element) async {
        // //print'haha element =====: ${element}');
        if (element.data['avatar'] != null) {
          // //print'avatar =====: ${element.data['avatar']}');
          await lll.add(element.data['avatar']);
        }
      });
    }
  }

  @action
  clearll() {
    lll = [];
  }

  @action
  setclearll(_clll) => lll = _clll;

  @action
  setEventcVerifier(int _eventcVerifier) => eventcVerifier = _eventcVerifier;
  @action
  // setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;
  @action
  setClearTable(List<dynamic> _clearTable) => openTables = _clearTable;
  @action
  setClearFiledTables(List<dynamic> _filedTables) => filedTables = _filedTables;
  @action
  setClearRefusedTables(List<dynamic> _refusedTables) =>
      refusedTables = _refusedTables;
  @action
  setClearPaidTables(List<dynamic> _paidTables) => paidTables = _paidTables;
  @action
  setUserView(String _clickuser) => userView = _clickuser;
  @action
  setGroupSelected(String _group) => groupSelected = _group;
  // @action
  // setSellerGroupSelected(String _groupse) => sellerGroupSelected = _groupse;
  @action
  setClickLabel(String _click) => clickLabel = _click;
  @action
  setClickLabelTableInfo(String _clickinfo) => clickLabelTableInfo = _clickinfo;
  @action
  setMembersID(List<String> _members) => membersID = _members;
  @action
  acceptInvite() async {}
  @action
  List listMembers(dynamic amigo) {
    list.add(amigo);
  }

  @action
  createMessage({String groupId}) async {
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
      'text': "Usuário '$_username' reabriu a conta",
      'type': 'create-table',
    });
    chat.updateData({'id': chat.documentID});
  }

  @action
  Future<dynamic> getOpenGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot _user = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'open')
        .getDocuments();

    var mygroup = await _user.documents;
    // //print'HASHS :$mygroup');

    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i]['id'])
          .get();
      mygroup.forEach((element) {
        // //print'entrou : ======= ${element.data}');

        if (element.data['status'] == 'open') {
          _mygroup.reference.updateData({'id': _mygroup.documentID});

          var contain = openTables
              .where((element) => element['id'] == _mygroup.documentID);
          if (contain.isEmpty) {
            openTables.add(_mygroup.data);
          }
        }
      });
    }
    return openTables;
  }

  @action
  Future<dynamic> getFiledGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot _user = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'filed')
        .getDocuments();

    var mygroup = await _user.documents;
    // //print'HASHS :$mygroup');

    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i]['id'])
          .get();
      mygroup.forEach((element) {
        if (element.data['status'] == 'filed') {
          _mygroup.reference.updateData({'id': _mygroup.documentID});

          var contain = filedTables
              .where((element) => element['id'] == _mygroup.documentID);
          if (contain.isEmpty) {
            filedTables.add(_mygroup.data);
          }
        }
      });
    }
    return filedTables;
  }

  @action
  Future<dynamic> getRefusedGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot _user = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'refused')
        .getDocuments();

    var mygroup = await _user.documents;
    // //print'HASHS :$mygroup');

    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i]['id'])
          .get();

      mygroup.forEach((element) {
        if (element.data['status'] == 'refused') {
          _mygroup.reference.updateData({'id': _mygroup.documentID});

          var contain = refusedTables
              .where((element) => element['id'] == _mygroup.documentID);
          if (contain.isEmpty) {
            refusedTables.add(_mygroup.data);
          }
        }
      });
    }
    return refusedTables;
  }

  @action
  Future<dynamic> getPaidGroup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot _user = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group')
        .where('status', isEqualTo: 'paid')
        .getDocuments();

    var mygroup = await _user.documents;
    // //print'HASHS :$mygroup');

    for (var i = 0; i < mygroup.length; i++) {
      DocumentSnapshot _mygroup = await Firestore.instance
          .collection('groups')
          .document(mygroup[i]['id'])
          .get();

      mygroup.forEach((element) {
        if (element.data['status'] == 'paid') {
          _mygroup.reference.updateData({'id': _mygroup.documentID});

          var contain = paidTables
              .where((element) => element['id'] == _mygroup.documentID);
          if (contain.isEmpty) {
            paidTables.add(_mygroup.data);
          }
        }
      });
    }
    return paidTables;
  }

  // @action
  // groupEventCounter(String group) {
  //   print('groupSelected  ${group}');

  //   FirebaseAuth.instance.currentUser().then((value) {
  //     Firestore.instance
  //         .collection('users')
  //         .document(value.uid)
  //         .get()
  //         .then((value) {
  //       value.data['my_group'].forEach((element) {
  //         if (element == group) {
  //           int index = value.data['my_group'].indexOf(element);
  //           print('MY GROUP INDEX: $index');
  //           int counter = value.data['my_group_event_counter'][index];
  //           print('GROUP EVENT COUNTER: $counter');
  //           print('counter: $counter');
  //           if (counter > 0) {
  //             return setEventVerifier(true);
  //           } else {
  //             return setEventVerifier(false);
  //           }
  //         }
  //       });
  //     });
  //   });
  // }

  @action
  refuseTable(String docgroup) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    QuerySnapshot _groupMembers = await Firestore.instance
        .collection('groups')
        .document(docgroup)
        .collection('members')
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();

    _groupMembers.documents.first.reference.delete();

    QuerySnapshot _invitations = await Firestore.instance
        .collection('invites')
        .where('group_id', isEqualTo: docgroup)
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();

    _invitations.documents.first.reference.updateData({'role': 'refused'});

    CollectionReference _myGroup = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('my_group');

    _myGroup.add({'event_counter': 1, 'id': docgroup, 'status': 'refused'});
  }

  @action
  getAvatar(hash) async {
    DocumentSnapshot userDS =
        await Firestore.instance.collection('users').document(hash).get();
    if (userDS.documentID == hash) {
      avatar = userDS.data['avatar'];
    }
    return avatar;
  }
}
