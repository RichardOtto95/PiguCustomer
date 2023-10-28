import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String avatar;
  Timestamp created_at;
  String email;
  String fullname;
  String mobile_phone_number;
  String mobile_region_code;
  String mobile_full_number;
  String status;
  String username;
  bool contactlist_sync;

  bool notification_enabled;

  UserModel(
      {this.id,
      this.avatar,
      this.created_at,
      this.email,
      this.fullname,
      this.mobile_phone_number,
      this.mobile_region_code,
      this.mobile_full_number,
      this.status,
      this.username,
      this.notification_enabled,
      this.contactlist_sync});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc['id'],
        avatar: doc['avatar'],
        created_at: doc['created_at'],
        email: doc['email'],
        fullname: doc['fullname'],
        mobile_phone_number: doc['mobile_phone_number'],
        mobile_region_code: doc['mobile_region_code'],
        mobile_full_number: doc['mobile_full_number'],
        status: doc['status'],
        username: doc['username'],
        notification_enabled: doc['notification_enabled'],
        contactlist_sync: doc['contactlist_sync']);
  }
  Map<String, dynamic> convertUser(UserModel user) {
    Map<String, dynamic> map = {};
    map['id'] = user.id;
    map['avatar'] = user.avatar;
    map['created_at'] = user.created_at;
    map['email'] = user.email;
    map['fullname'] = user.fullname;
    map['mobile_phone_number'] = user.mobile_phone_number;
    map['mobile_region_code'] = user.mobile_region_code;
    map['mobile_full_number'] = user.mobile_full_number;
    map['status'] = user.status;
    map['username'] = user.username;
    map['notification_enabled'] = user.notification_enabled;
    map['contactlist_sync'] = user.contactlist_sync;

    return map;
  }

  Map<String, dynamic> toJson(UserModel user) => {
        'id': user.id,
        'avatar': user.avatar,
        'created_at': user.created_at,
        'email': user.email,
        'fullname': user.fullname,
        'mobile_phone_number': user.mobile_phone_number,
        'mobile_region_code': user.mobile_region_code,
        'mobile_full_number': user.mobile_full_number,
        'status': user.status,
        'username': user.username,
        'notification_enabled': user.notification_enabled,
        'contactlist_sync': user.contactlist_sync
      };

  // userPhotoUpdate(String userPhoto) {
  //   reference.updateData({'avatar': userPhoto});
  // }
}
