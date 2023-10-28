import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  DocumentReference uid;
  String labelPtbr;
  // String labelEnus;
  String image;

  String key;

  CategoryModel({this.uid, this.labelPtbr, this.image, this.key});

  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    return CategoryModel(
      uid: doc.reference,
      labelPtbr: doc['label_ptbr'],
      image: doc['image'],
      key: doc['key'],
    );
  }

  Map<String, dynamic> toJson(CategoryModel doc) => {
        'uid': doc.uid,
        'labelPtbr': doc.labelPtbr,
        'image': doc.image,
        'key': doc.key,
      };
}
