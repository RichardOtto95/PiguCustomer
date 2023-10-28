import 'package:cloud_firestore/cloud_firestore.dart';

class UserInvite {
  // final DocumentReference reference;
  dynamic order;
  dynamic user;

  UserInvite({
    this.order,
    this.user,
  });

  // factory UserInvite.fromDocument(DocumentSnapshot doc) {
  //   return UserInvite(
  //       order: doc.reference,
  //       user: doc['avatar'],

  // }

  Map<String, dynamic> toJson(UserInvite user) => {
        'order': user.order,
        'user': user.user,
      };
}
