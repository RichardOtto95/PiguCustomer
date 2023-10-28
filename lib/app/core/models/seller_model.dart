import 'package:cloud_firestore/cloud_firestore.dart';

class SellerModel {
  bool protectedPrices;
  bool hasVirtualQueue;
  String address;
  String avatar;
  String bg_image;
  // String category_id;
  String category_id;
  GeoPoint location;
  String name;
  String search_key;
  String id;
  Timestamp created_at;

  SellerModel(
      {this.protectedPrices,
      this.hasVirtualQueue,
      this.address,
      this.avatar,
      this.category_id,
      this.location,
      this.name,
      this.bg_image,
      this.id,
      this.search_key,
      this.created_at});

  factory SellerModel.fromDocument(DocumentSnapshot doc) {
    return SellerModel(
        protectedPrices: doc['protected_prices'],
        hasVirtualQueue: doc['has_virtual_queue'],
        avatar: doc['avatar'],
        address: doc['address'],
        bg_image: doc['backGroud_image'],
        category_id: doc['category_id'],
        location: doc['location'],
        name: doc['name'],
        search_key: doc['search_key'],
        created_at: doc['created_at'],
        id: doc['id']);
  }
  // Map<String, dynamic> convertUser(UserModel user) {
  //   Map<String, dynamic> map = {};
  //   map['reference'] = user.reference;
  //   map['avatar'] = user.avatar;
  //   map['birthdate'] = user.birthdate;
  //   map['country'] = user.country;
  //   map['countryPhoneCode'] = user.countryPhoneCode;
  //   map['createdAt'] = user.createdAt;
  //   map['email'] = user.email;
  //   map['firstName'] = user.firstName;
  //   map['mobilePhoneNumber'] = user.mobilePhoneNumber;
  //   map['regionPhoneCode'] = user.regionPhoneCode;
  //   map['sellerId'] = user.sellerId;
  //   map['status'] = user.status;
  //   map['surname'] = user.surname;

  //   return map;
  // }

  Map<String, dynamic> toJson(SellerModel user) => {
        'protected_prices': user.protectedPrices,
        'has_virtual_queue': user.hasVirtualQueue,
        'avatar': user.avatar,
        'address': user.address,
        'bg_image': user.bg_image,
        'category_id': user.category_id,
        'location': user.location,
        'name': user.name,
        'search_key': user.search_key,
        'created_at': user.created_at,
        'id': user.id
      };

  // userPhotoUpdate(String userPhoto) {
  //   reference.updateData({'avatar': userPhoto});
  // }
}
