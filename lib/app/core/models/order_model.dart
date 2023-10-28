import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  DocumentReference uid;
  String userId;

  String
      mainImg; //TODO Refactory to change this field to point to Firebase Storage URI
  String category;
  String description;
  double maxPrice;
  double minPrice;
  double value;

  String name;
  String note;
  //TODO add LatLng after adding maps plugin
  //LatLng orderedAt;
  DateTime quotationAccepted;
  DateTime finished;
  DateTime updated;
  DateTime created;

  String status;
  int views;

  OrderModel({
    this.uid,
    this.userId,
    this.mainImg,
    this.category,
    this.created,
    this.description,
    this.maxPrice,
    this.minPrice,
    this.value,
    this.name,
    this.finished,
    this.note,
    //LatLng orderedAt,
    this.quotationAccepted,
    this.status,
    this.updated,
    this.views,
  });

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    //print'ORDER MODELO : ${doc.data}');
    return OrderModel(
      uid: doc.reference,
      userId: doc['userId'],

      name: doc['name'],
      mainImg: doc['mainImg'],
      maxPrice: double.parse(doc['maxPrice'].toStringAsFixed(2)),
      minPrice: double.parse(doc['minPrice'].toStringAsFixed(2)),
      category: doc['category'],
      created: doc['created'].toDate(),
      description: doc['description'],
      // value: double.parse(doc['value'].toStringAsFixed(2)),
      note: doc['note'],
      // quotationAccepted: doc['quotationAccepted'].toDate(),
      // finished: doc['finished'].toDate(),
      status: doc['status'],
      updated: doc['updated'].toDate(),
      views: doc['views'],
    );
  }
  //  Map<String, dynamic> _convertOrderModelToMap(OrderModel model)
  Map<String, dynamic> toJson(OrderModel model) => {
        'uid': model.uid,
        'userId': model.userId,
        'name': model.name,
        'mainImg': model.mainImg,
        'maxPrice': model.maxPrice,
        'minPrice': model.minPrice,
        'category': model.category,
        'created': model.created,
        'description': model.description,
        'value': model.value,
        'note': model.note,
        'quotationAccepted': model.quotationAccepted,
        'finished': model.finished,
        'status': model.status,
        'updated': model.updated,
        'views': model.views,
      };
  save(String statusParam, DateTime finished) {
    uid.updateData({'status': statusParam, 'finished': finished});
  }
}
